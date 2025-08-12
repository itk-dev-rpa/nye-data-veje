"""This is the main file for executing the process of ingesting ODE data.
This should be set up to be controlled by the OpenOrchestrator variables."""

from os import path
import shutil

from sqlalchemy import create_engine
from OpenOrchestrator.orchestrator_connection.connection import OrchestratorConnection

from robot_framework.ode_ingest import ode_ingest as ode
from robot_framework import config
from robot_framework.ode_ingest.table_columns import table_date_columns, table_used_columns, table_keys
from robot_framework.ode_ingest.csv_cleaner import DateColumn
from robot_framework.ode_ingest import file_sorting as sort


def create_table(name):
    """Create a new table with a name."""
    columns = set()
    for table_dict in [table_used_columns, table_date_columns, table_keys]:
        if name in table_dict and table_dict[name]:
            columns.update(table_dict[name])
    ode.create_table(name, columns)


def insert_total_data(table: str, oc: OrchestratorConnection, from_file: int = 0, max_files: int = None, from_to_date: tuple[str, str] | None = None):
    """Insert all data from the original Total-files, for the table."""

    files = ode.find_files(config.FILE_DIRECTORY, [f"{table}_Total"])
    oc.log_trace(f"Found {len(files)} files")
    i = from_file
    engine = create_engine(config.CONNECTION_STRING.replace("{DB_NAME}", config.DB_NAME), fast_executemany=True)

    date_column = None
    if from_to_date:
        date_column = DateColumn(table_date_columns.get(table), from_to_date[0], from_to_date[1])
    for file_path in files[from_file:max_files]:
        i += 1
        oc.log_trace(f"Inserting data from file {i}/{len(files)}")
        df = ode.create_dataframe_from_file(file_path, table, oc, date_column)
        ode.insert_data(df, table, engine)
        directory, filename = path.split(file_path)
        shutil.move(file_path, path.join(directory, "processed_total_files", filename))


def insert_delta_data(delta_table, oc: OrchestratorConnection, from_file = 0):
    '''Add data from new delta files and move them to a folder of processed files.
    '''
    files = ode.find_files(config.FILE_DIRECTORY, [f"{delta_table}_Delta"])
    files = sort.sort_files(files)
    i = from_file  # Should this be based on file name?
    engine = create_engine(config.CONNECTION_STRING.replace("{DB_NAME}", config.DB_NAME), fast_executemany=True)

    for file_path in files[from_file:]:
        i += 1
        oc.log_trace(f"Inserting data from file {i}/{len(files)}")
        df = ode.create_dataframe_from_file(file_path, delta_table, oc)
        if len(df) > 0:
            ode.merge_table_from_dataframe(df, delta_table, engine)
        else:
            oc.log_trace("No lines found in file")
        directory, filename = path.split(file_path)
        shutil.move(file_path, path.join(directory, "processed_delta_files", filename))
