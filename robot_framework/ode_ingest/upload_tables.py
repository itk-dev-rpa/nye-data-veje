"""This is the main file for executing the process of ingesting ODE data.
This should be set up to be controlled by the OpenOrchestrator variables."""

from os import path
import shutil

from sqlalchemy import create_engine
from OpenOrchestrator.orchestrator_connection.connection import OrchestratorConnection

from robot_framework.ode_ingest import ode_ingest as ode
from robot_framework.ode_ingest.table_columns import table_date_columns, table_used_columns, table_keys
from robot_framework.ode_ingest.csv_cleaner import DateRangeColumn
from robot_framework.ode_ingest import file_sorting as sort
from robot_framework import config


def create_table(name: str, oc: OrchestratorConnection):
    """Create a new table with a name.

    Args:
        name: Name of table.
    """

    connection_string = oc.get_constant(config.DB_CONNECTION).value
    columns = set()
    for table_dict in [table_used_columns, table_date_columns, table_keys]:
        if name in table_dict and table_dict[name]:
            columns.update(table_dict[name])
    ode.create_table(name, columns, connection_string)


def insert_total_data(table: str, oc: OrchestratorConnection, from_to_date: tuple[str, str] | None = None):
    """Insert all data from the original Total-files, for the table.

    Args:
        table: Table name in database, to insert data into.
        oc: OrchestratorConnection used by Open Orchestrator.
        from_to_date: Dates to and from, to read data from as a tuple. Used to insert a reduced dataset. Defaults to None.
    """
    oc.log_trace(f"Starting insert of table {table}")
    file_directory = oc.get_constant(config.DATA_DIRECTORY).value
    connection_string = oc.get_constant(config.DB_CONNECTION).value

    files = ode.find_files(file_directory, f"{table}_Total")
    engine = create_engine(connection_string, fast_executemany=True)

    date_column = None
    if from_to_date:
        date_column = DateRangeColumn(table_date_columns.get(table), from_to_date[0], from_to_date[1])
    for i, file_path in enumerate(files):
        oc.log_trace(f"Inserting data from file {i+1}/{len(files)}: {file_path}")
        df = ode.create_dataframe_from_file(file_path, table, oc, date_column)
        ode.insert_data(df, table, engine)
        directory, filename = path.split(file_path)
        shutil.move(file_path, path.join(directory, "processed_total_files", filename))


def insert_delta_data(delta_table: str, oc: OrchestratorConnection):
    """Add data from new delta files and move them to a folder of processed files.

    Args:
        delta_table: Table name in database.
        oc: OrchestratorConnection used for getting constants.
        from_file: Which file to start from. Defaults to 0.
    """
    oc.log_trace(f"Starting insert of table {delta_table}")
    file_directory = oc.get_constant(config.DATA_DIRECTORY).value
    connection_string = oc.get_constant(config.DB_CONNECTION).value

    files = ode.find_files(file_directory, f"{delta_table}_Delta")
    files = sort.sort_files(files)
    engine = create_engine(connection_string, fast_executemany=True)

    for i, file_path in enumerate(files):
        oc.log_trace(f"Inserting data from file {i+1}/{len(files)}: {file_path}")
        df = ode.create_dataframe_from_file(file_path, delta_table, oc)
        if len(df) > 0:
            ode.merge_table_from_dataframe(df, delta_table, engine)
        else:
            oc.log_trace("No lines found in file")
        directory, filename = path.split(file_path)
        shutil.move(file_path, path.join(directory, "processed_delta_files", filename))
