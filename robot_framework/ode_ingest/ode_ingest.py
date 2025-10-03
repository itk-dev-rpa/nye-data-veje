"""
ode_import.py

Main workflow for importing ODE data files, transforming them to DataFrames,
and loading them into a SQL database.

This script demonstrates usage of the utility modules:
- file_utils for finding files,
- dataframe_utils for loading and cleaning data,
- db_utils for inserting/merging into the database.

This can be extended with CLI or job scheduling as needed.
"""

from typing import Optional
from sqlalchemy import create_engine

from OpenOrchestrator.orchestrator_connection.connection import OrchestratorConnection

from robot_framework.ode_ingest.utils.file_utils import find_files
from robot_framework.ode_ingest.utils.dataframe_utils import create_dataframe_from_file
from robot_framework.ode_ingest.utils.db_utils import merge_table_from_dataframe
from robot_framework import config


def import_ode_files(
    source_dir: str,
    partial_name: str,
    table_name: str,
    oc: OrchestratorConnection,
    date_filter: Optional[dict] = None
) -> None:
    """
    Orchestrate finding, loading, and importing ODE data files.

    Args:
        source_dir: Directory to search for files.
        partial_name: Pattern to match files (e.g., 'BO-aaben').
        table_name: Destination table name.
        oc: OrchestratorConnection for logging and DB connection.
        date_filter: Optional date range filter.
    """
    # Find relevant files
    files = find_files(source_dir, partial_name)
    if not files:
        print(f"No files found in {source_dir} with pattern '{partial_name}'")
        return

    # Prepare database engine
    connection_string = oc.get_constant(config.DB_CONNECTION).value
    engine = create_engine(connection_string)

    # Loop through and import each file
    for file_path in files:
        print(f"Processing {file_path}...")

        df = create_dataframe_from_file(
            file_path=file_path,
            table_name=table_name,
            oc=oc,
            date_filter=date_filter
        )

        if df is None or df.empty:
            print(f"Skipped {file_path}: No data loaded.")
            continue

        try:
            merge_table_from_dataframe(df, table_name, engine)
            print(f"Imported {file_path} to {table_name}.")
        except Exception as exc:
            print(f"Error importing {file_path}: {exc}")
            oc.log_error(f"Error importing {file_path}: {exc}")
