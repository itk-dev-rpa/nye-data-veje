import os
from pathlib import Path
import time
from datetime import datetime
import tomllib

import pandas as pd
from sqlalchemy import create_engine, text
from OpenOrchestrator.orchestrator_connection.connection import OrchestratorConnection

from robot_framework.ode_ingest import table_definitions as table_columns
from robot_framework.ode_ingest.utils import file_utils, dataframe_utils, data_cleaning
from robot_framework import config


tables = [  # List of tables to work on
    "Aftaleindhold",
    "BO-aftale-haendelse",
    "BO-aftale",
    "Bilag-aaben",
    "Bilag-master",
    "FP-aftale",
    "Bilag-lukket",
    "Forretningspartner",
    "Indbetalinger",
    "Opsaetning-Aftalekontotype",
    "Opsaetning-Rykkerniveau",
    "RIM-aftale-rater",
    "RIM-aftale-renter",
    "RIM-aftale",
    "Rykker",
    "UU-aftale-haefter",
    "UU-aftale",
]


def main(oc: OrchestratorConnection):
    file_directory = oc.get_constant(config.DATA_DIRECTORY).value
    connection_string = oc.get_constant(config.DB_CONNECTION).value

    for table in tables:
        upload_files(file_directory, table, "Total", connection_string, oc, include_date=False)
        upload_files(file_directory, table, "Delta", connection_string, oc, include_date=True)


def process_file(filepath: Path, table_name: str) -> tuple[pd.DataFrame, dict]:
    """Process single file: load, clean, filter columns, optionally add date."""
    df = dataframe_utils.load_raw_df(filepath)

    # Basic cleaning is necessary, SQL column names should not contain spaces.
    df = data_cleaning.clean_basic_data(df)

    if table_name in table_columns.table_column_alias:
        # Some columns have changed names, which we fix here
        df.rename(columns=table_columns.table_column_alias[table_name], inplace=True)

    # --- LOGGING LOGIC START ---
    # Calculate stats before any filtering
    initial_row_count = len(df)
    raw_columns = set(df.columns)

    # Determine which columns will be kept based on config
    expected_columns = set(table_columns.table_used_columns[table_name])

    # Find columns present in file but NOT in our config (Silent Drops)
    dropped_columns_list = list(raw_columns - expected_columns)
    dropped_columns_str = ", ".join(sorted(dropped_columns_list))
    # --- LOGGING LOGIC END ---

    # Not all columns are needed and some contain sensitive information.
    df = df[table_columns.table_used_columns[table_name]]
    # Add data origin information
    date, _, _ = file_utils.get_file_sort_key(filepath)
    df["export_date"] = str(date)
    df["file_origin"] = filepath.name
    df['row_number'] = range(len(df))
    df['etl_version'] = file_utils.get_project_version()

    stats = {
        "source_rows": initial_row_count,
        "final_rows": len(df),
        "dropped_cols": dropped_columns_str
    }

    return df, stats


def log_ingest_stats(engine, table_name: str, filename: str, stats: dict, status: str, error: str = None):
    """Helper to write stats to SQL log table."""
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
    except Exception as e:
        print(f"Warning: Could not write to log table: {e}")


def upload_files(directory: str, table_name: str, subset: str, connection_string: str, oc: OrchestratorConnection,
                 include_date: bool = False) -> None:
    """Upload multiple files to SQL table."""
    engine = create_engine(connection_string, fast_executemany=True)
    files = file_utils.find_files(directory, f"{table_name}_{subset}")
    for filepath in files:
        filepath = Path(filepath)
        try:
            start = time.time()
            print(f"{datetime.now().strftime("%H:%M:%S")}: Processing file {filepath}...")
            df, stats = process_file(filepath, table_name)
            df.to_sql(f"{table_name}_{subset}", engine, schema=config.DB_SCHEMA, if_exists='append', index=False)

            # Log Failure
            log_ingest_stats(engine, f"{table_name}_{subset}", filepath.name, stats, "Success")

            file_utils.move_processed_files(filepath)
            print(f"Completed in {time.time()-start} seconds.")
        # Sometimes, a column has changed name and does not match the expected schema. This catches this error.
        except KeyError as e:
            oc.log_error(f"{filepath} error: {e}")
            print(f"ERROR: {e.with_traceback()}")
            log_ingest_stats(engine, f"{table_name}_{subset}", filepath.name, stats, "Failed", str(e))
            file_utils.move_processed_files(filepath, 'KeyError')


if __name__ == "__main__":
    conn_string = os.getenv("OpenOrchestratorConnString")
    crypto_key = os.getenv("OpenOrchestratorKey")
    oc = OrchestratorConnection("ODE test", conn_string, crypto_key, "")
    main(oc)
