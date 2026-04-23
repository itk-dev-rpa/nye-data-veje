"""Utility functions for data ingestion and logging."""
from pathlib import Path
import pandas as pd
from sqlalchemy import text

from robot_framework.ode_ingest import table_definitions
from robot_framework.ode_ingest.utils import file_utils, dataframe_utils, data_cleaning


def process_file(filepath: Path, table_name: str) -> tuple[pd.DataFrame, dict]:
    """Process single file: load, clean, filter columns, add metadata.

    Args:
        filepath: Path to the file to process
        table_name: Name of the table (without _Total/_Delta suffix)

    Returns:
        Tuple of (processed DataFrame, statistics dictionary)
    """
    df = dataframe_utils.load_raw_df(filepath)

    # Basic cleaning is necessary, SQL column names should not contain spaces.
    df = data_cleaning.clean_basic_data(df)

    if table_definitions.all_tables[table_name].column_aliases:
        # Some columns have changed names, which we fix here
        df.rename(columns=table_definitions.all_tables[table_name].column_aliases, inplace=True)

    # Apply Forretningspartner normalization early (before column filtering)
    if 'Forretningspartner' in df.columns:
        errors: list[str] = []
        normalized_values = {}
        for idx, val in df['Forretningspartner'].items():
            try:
                normalized_values[idx] = data_cleaning.normalize_forretningspartner_value(val)
            except ValueError as ex:  # Collect and raise combined error with context
                errors.append(f"index={idx}, value='{val}', error={ex}")
        if errors:
            sample = " ; ".join(errors[:10])
            raise ValueError(
                "Ugyldige Forretningspartner-værdier fundet under normalisering (max 8 cifre, kun ledende 0'er fjernes). "
                f"Første eksempler: {sample}. Fil: {filepath.name}"
            )
        # Assign normalized column preserving index
        df['Forretningspartner'] = pd.Series(normalized_values)

    # --- LOGGING LOGIC START ---
    # Calculate stats before any filtering
    initial_row_count = len(df)
    raw_columns = set(df.columns)

    # Determine which columns will be kept based on config
    expected_columns = set(table_definitions.all_tables[table_name].used_columns)

    # Find columns present in file but NOT in our config (Silent Drops)
    dropped_columns_list = list(raw_columns - expected_columns)
    dropped_columns_str = ", ".join(sorted(dropped_columns_list))
    # --- LOGGING LOGIC END ---

    # Add data origin information
    date, _, _ = file_utils.get_file_sort_key(filepath)
    df["export_date"] = str(date)
    df["file_origin"] = filepath.name
    df['row_number'] = range(len(df))
    df['etl_version'] = file_utils.get_project_version()

    # Not all columns are needed and some contain sensitive information.
    df = df[table_definitions.all_tables[table_name].used_columns]

    stats = {
        "source_rows": initial_row_count,
        "final_rows": len(df),
        "dropped_cols": dropped_columns_str
    }

    return df, stats


def log_ingest_stats(*, engine, table_name: str, filename: str, stats: dict, status: str, error: str = None):
    """Write ingestion statistics to SQL log table.

    Args:
        engine: SQLAlchemy engine
        table_name: Name of the table being processed
        filename: Name of the source file
        stats: Dictionary with statistics (source_rows, final_rows, dropped_cols)
        status: Status string (e.g. "Success", "Fail")
        error: Optional error message if status is "Fail"
    """
    try:
        with engine.connect() as conn:
            query = text("""
                INSERT INTO [ode].[Data_Ingest_Log]
                (TableName, FileName, SourceRowCount, LoadedRowCount, DroppedColumns, Status, ErrorMessage)
                VALUES (:table, :file, :src_rows, :load_rows, :drops, :status, :err)
            """)
            conn.execute(query, {
                "table": table_name,
                "file": filename,
                "src_rows": stats.get("source_rows", 0),
                "load_rows": stats.get("final_rows", 0),
                "drops": stats.get("dropped_cols", ""),
                "status": status,
                "err": error
            })
            conn.commit()
    except Exception as e:  # pylint: disable=broad-exception-caught
        print(f"Warning: Could not write to log table: {e}")
