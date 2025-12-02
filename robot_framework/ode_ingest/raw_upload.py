import os
from pathlib import Path
import time
from datetime import datetime
import tomllib

import pandas as pd
from sqlalchemy import create_engine
from OpenOrchestrator.orchestrator_connection.connection import OrchestratorConnection

from robot_framework.ode_ingest import table_columns
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


def process_file(filepath: Path, table_name: str) -> pd.DataFrame:
    """Process single file: load, clean, filter columns, optionally add date."""
    df = dataframe_utils.load_raw_df(filepath)
    # Not all columns are needed and some contain sensitive information.
    df = df[table_columns.table_used_columns[table_name]]
    # Basic cleaning is necessary, SQL column names should not contain spaces.
    df = data_cleaning.clean_basic_data(df)
    if table_name in table_columns.table_column_alias:
        # Some columns have changed names, which we fix here
        df.rename(columns=table_columns.table_column_alias[table_name], inplace=True)
    # Add data origin information
    date, _, _ = file_utils.get_file_sort_key(filepath)
    df["export_date"] = date
    df["file_origin"] = filepath.name
    df['row_number'] = range(len(df))
    with open("pyproject.toml", "rb") as f:
        toml_data = tomllib.load(f)
        version = toml_data.get("project", {}).get("version", "N/A")
        df['etl_version'] = version

    return df


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
            df = process_file(filepath, table_name, include_date)
            df.to_sql(f"{table_name}_{subset}", engine, schema=config.DB_SCHEMA, if_exists='append', index=False)
            file_utils.move_processed_files(filepath)
            print(f"Completed in {time.time()-start} seconds.")
        # Sometimes, a column has changed name and does not match the expected schema. This catches this error.
        except KeyError as e:
            oc.log_error(f"{filepath} error: {e}")
            print(f"ERROR: {e.with_traceback()}")
            file_utils.move_processed_files(filepath, 'KeyError')


if __name__ == "__main__":
    conn_string = os.getenv("OpenOrchestratorConnString")
    crypto_key = os.getenv("OpenOrchestratorKey")
    oc = OrchestratorConnection("ODE test", conn_string, crypto_key, "")
    main(oc)
