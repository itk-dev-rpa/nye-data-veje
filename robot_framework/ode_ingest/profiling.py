"""This script is used for generating profiling reports, analyzing data uploaded for nulls, types and column mismatch.
This is meant to provide an overview and sanity check before committing to data cleaning, as well as identifying potential issues with the data.
Not part of the running pipeline."""
import json
from pathlib import Path
from datetime import datetime

from sqlalchemy import create_engine, Integer, String, Date, Numeric
from sqlalchemy.types import TypeEngine
import pandas as pd

from OpenOrchestrator.orchestrator_connection.connection import OrchestratorConnection

from robot_framework import config
from robot_framework.ode_ingest.utils import date_utils, number_utils, dataframe_utils
from robot_framework.ode_ingest.table_definitions import table_keys


def sqlalchemy_to_display_type(sa_type: TypeEngine) -> str:
    """Convert SQLAlchemy type to readable string."""
    if sa_type is Integer:
        return 'integer'
    elif sa_type is Date:
        return 'date'
    elif isinstance(sa_type, Numeric):
        return f'decimal({sa_type.precision},{sa_type.scale})'
    elif sa_type is String:
        return f'string({sa_type.length})' if sa_type.length else 'string'
    else:
        return str(type(sa_type).__name__)


def infer_pattern(series: pd.Series) -> dict:
    """Detect patterns in string data."""
    sample = series.dropna().astype(str).head(1000)

    patterns = {
        'date_iso': r'^\d{4}-\d{2}-\d{2}',
        'date_eu': r'^\d{2}[./]\d{2}[./]\d{4}',
        'datetime_iso': r'^\d{4}-\d{2}-\d{2}[T ]\d{2}:\d{2}',
        'decimal_comma': r'^\-?\d+,\d+$',
        'decimal_dot': r'^\-?\d+\.\d+$',
        'integer': r'^\-?\d+$',
        'empty_string': r'^$',
    }

    matches = {}
    for name, pattern in patterns.items():
        match_pct = sample.str.match(pattern).mean() * 100
        if match_pct > 1:  # Show if >1% matches
            matches[name] = round(match_pct, 1)

    return matches


def attempt_conversion(series: pd.Series, expected_type: TypeEngine) -> tuple[str, float]:
    """Try converting to expected type, return success rate."""
    non_null_count = series.notna().sum()
    if non_null_count == 0:
        return 'object', 0.0

    if expected_type is Date:
        converted = date_utils.convert_date_series(series)
        success_count = (converted.notna() & series.notna()).sum()
        success_rate = (success_count / non_null_count) * 100
        return 'datetime', round(success_rate, 1)

    if expected_type is Integer:
        converted = number_utils.convert_number_series(series)
        # Check if convertible values are actually integers
        is_int = converted.dropna().apply(lambda x: x == int(x))
        success_count = (converted.notna() & series.notna() & is_int).sum()
        success_rate = (success_count / non_null_count) * 100
        return 'integer', round(success_rate, 1)

    if isinstance(expected_type, Numeric):
        # Handle both comma and dot decimals
        converted = number_utils.convert_number_series(series)
        success_count = (converted.notna() & series.notna()).sum()
        success_rate = (success_count / non_null_count) * 100
        return 'numeric', round(success_rate, 1)

    return 'object', 100.0


def profile_column(series: pd.Series, expected_type: TypeEngine = None) -> dict:
    """Profile single column with pattern detection."""

    # Sample values handling
    sample_values = series.dropna().head(5)
    if pd.api.types.is_datetime64_any_dtype(sample_values):
        sample_values = sample_values.dt.strftime('%Y-%m-%d %H:%M:%S').tolist()
    else:
        sample_values = sample_values.tolist()

    result = {
        'actual_dtype': str(series.dtype),
        'expected_type': sqlalchemy_to_display_type(expected_type) if expected_type else None,
        'row_count': len(series),
        'null_count': int(series.isna().sum()),
        'null_pct': round(series.isna().mean() * 100, 2),
        'unique_count': int(series.nunique()),
        'sample_values': sample_values
    }

    # Attempt conversion if expected type specified
    if expected_type and not series.dropna().empty:
        inferred_type, conversion_success = attempt_conversion(series, expected_type)
        result['conversion_test'] = {
            'can_convert_to': inferred_type,
            'success_rate_pct': conversion_success
        }

    # Pattern detection for string columns
    if series.dtype == 'object' and not series.dropna().empty:
        result['patterns'] = infer_pattern(series)

        if expected_type is String:
            lengths = series.dropna().astype(str).str.len()
            result['string_stats'] = {
                'max_length': int(lengths.max()),
                'mean_length': round(lengths.mean(), 1),
                'expected_max': expected_type.length
            }

    return result


def profile_table(table_name: str, engine, expected_schema: dict = None, 
                  sample_size: int = 50000) -> dict:
    """Profile SQL table with random sampling."""

    query = f"SELECT * FROM [{config.DB_SCHEMA}].[{table_name}] TABLESAMPLE ({sample_size} ROWS)"
    df = pd.read_sql(query, engine)
    df = dataframe_utils.convert_null(df)

    profile = {
        'table': table_name,
        'profiled_at': datetime.now().isoformat(),
        'sample_size': len(df),
        'total_columns': len(df.columns),
        'columns': {}
    }

    for col in df.columns:
        expected_type = expected_schema.get(col) if expected_schema else None
        profile['columns'][col] = profile_column(df[col], expected_type)
    # Summary statistics
    profile['summary'] = {
        'columns_with_nulls': sum(1 for c in profile['columns'].values() if c['null_pct'] > 0),
        'keys_with_nulls': sum(1 for c in profile['columns'] if profile['columns'][c]['null_pct'] > 0 and table_keys[table_name.rsplit("_", 1)[0]] and c in table_keys[table_name.rsplit("_", 1)[0]]),
        'high_null_columns': [k for k, v in profile['columns'].items() if v['null_pct'] > 50],
        'missing_from_schema': [col for col in df.columns if col not in (expected_schema or {})],
        'missing_from_data': [col for col in (expected_schema or {}) if col not in df.columns],
    }

    return profile


def profile_all_tables(tables: list[str], engine, data_types: dict, 
                       output_dir: Path) -> None:
    """Profile multiple tables and save reports."""
    output_dir.mkdir(exist_ok=True)

    all_results = {}

    for table in tables:
        print(f"Profiling {table}...")
        schema = data_types.get(table, {})

        for suffix in ['Total', 'Delta']:
            full_name = f"{table}_{suffix}"
            try:
                profile = profile_table(full_name, engine, schema, sample_size=50000)

                # Save individual report
                output_file = output_dir / f"{full_name}_profile.json"
                with open(output_file, 'w', encoding='utf-8') as f:
                    json.dump(profile, f, indent=2, ensure_ascii=False)

                all_results[full_name] = profile['summary']
                print(f"  ✓ {full_name}")

            except Exception as e:
                print(f"  ✗ {full_name}: {e}")
                all_results[full_name] = {'error': str(e)}

    # Save summary report
    summary_file = output_dir / "_profile_summary.json"
    with open(summary_file, 'w', encoding='utf-8') as f:
        json.dump(all_results, f, indent=2, ensure_ascii=False)

    print(f"\n✓ Summary saved to {summary_file}")


# Usage
if __name__ == "__main__":
    from robot_framework.ode_ingest import table_definitions as table_columns
    import os

    conn_string = os.getenv("OpenOrchestratorConnString")
    crypto_key = os.getenv("OpenOrchestratorKey")
    oc = OrchestratorConnection("ODE test", conn_string, crypto_key, "")

    file_directory = oc.get_constant(config.DATA_DIRECTORY).value
    connection_string = oc.get_constant(config.DB_CONNECTION).value

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

    # Profile all
    profile_all_tables(tables, create_engine(connection_string), table_columns.data_types, Path('data_profiles'))

    # Or single table for test
    # profile = profile_table('Bilag-master_Total', engine, data_types['Bilag-master'])
    # print(json.dumps(profile, indent=2))
