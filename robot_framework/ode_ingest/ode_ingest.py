'''
This is the main functions for reading and loading files.
ODE files are exported from Opus Debitor and with these functions, read and imported to an SQL database.
'''
import time
from pathlib import Path
from typing import Optional

import pandas as pd
from sqlalchemy import create_engine, text, Engine, Table, Column, String, MetaData, PrimaryKeyConstraint, Date, Numeric
from sqlalchemy.exc import SQLAlchemyError
from OpenOrchestrator.orchestrator_connection.connection import OrchestratorConnection

from robot_framework import config
from robot_framework.ode_ingest.csv_cleaner import CSVCleaner, DateRangeColumn
from robot_framework.ode_ingest.table_columns import table_keys, table_used_columns, data_types

type_mapping = {
    'text': String(255),
    'number': Numeric(precision=15, scale=2),
    'date': Date
}


def find_files(directory: str, partial_name: str):
    """Return files containing partial name.

    Args:
        directory: Directory of files to look for.
        partial_name: Partial filename, eg "BO-aaben", "Bilag-master_Total

    Returns:
        List of files from directory matching partial name.
    """
    files = []
    for filename in Path(directory).iterdir():
        if partial_name in filename.name:
            files.append(str(filename))
    return files


def insert_data(df: pd.DataFrame, table_name: str, engine: Engine):
    """Add data to SQL.

    Args:
        df: Dataframe to add data from.
        table_name: SQL table to add data to.
        engine: SQL Engine to use.
    """
    metadata = MetaData()
    table = Table(table_name, metadata, autoload_with=engine, schema=config.DB_SCHEMA)

    with engine.begin() as conn:
        conn.execute(table.insert(), df.to_dict('records'))


def create_dataframe_from_file(file_path: str, table_name: str, oc: OrchestratorConnection, date_filter: Optional[DateRangeColumn] = None) -> pd.DataFrame:
    """Create a dataframe from a file.

    Args:
        file_path: Path of file.
        table_name: Name of table.
        date_filter: Optional date filter. Defaults to None.

    Returns:
        A pandas dataframe containing formatted data from file.
    """
    csv_file = Path(file_path)

    if not csv_file.exists():
        return None

    date_cols = [col for col, type_ in data_types[table_name].items() if type_ == 'date']
    num_cols = [col for col, type_ in data_types[table_name].items() if type_ == 'number']

    cleaner = CSVCleaner()
    df = cleaner.read_csv_with_types(
            csv_file,
            oc,
            table_keys=table_keys[table_name],
            date_columns=date_cols,
            number_columns=num_cols,
            date_filter=date_filter  # Optional
        )

    # Make sure we only use the required columns
    columns = set()
    for table_dict in [table_used_columns, table_keys]:
        if table_name in table_dict and table_dict[table_name]:
            columns.update(table_dict[table_name])
    df = df[df.columns.intersection(columns)]

    if table_keys[table_name] is None:
        df.reset_index(allow_duplicates=True)

    drop_columns = df.columns[df.columns.str.contains('^Unnamed', case=False)]
    df.drop(drop_columns, axis=1, inplace=True)
    return df


def merge_table_from_dataframe(df: pd.DataFrame, table_name: str, engine: Engine):
    """Using SQL Server MERGE, upsert data in bulk.

    Args:
        df: Pandas dataframe to merge into table.
        table_name: Table to merge dataframe into.
        engine: SQL connection engine.
    """
    key_columns = table_keys[table_name]
    if not key_columns:
        # No keys found, inserting full table.
        insert_data(df, table_name, engine)
        return

    # Create temp table name
    temp_table = f"#temp_{table_name}_{int(time.time())}"

    # 1. Upload dataframe to temporary table
    metadata = MetaData(schema=config.DB_SCHEMA)
    Table(temp_table, metadata, *get_column_list_with_types(table_name))
    metadata.create_all(engine)

    insert_data(df, temp_table, engine)

    # 2. Build MERGE statement
    target_table = f"[{config.DB_NAME}].[{config.DB_SCHEMA}].[{table_name}]"
    temp_table = f"[{config.DB_NAME}].[{config.DB_SCHEMA}].[{temp_table}]"

    # ON clause - match on primary keys
    key_columns = table_keys[table_name]
    on_conditions = []
    for key in key_columns:
        on_conditions.append(f"target.[{key}] = source.[{key}]")
    on_clause = " AND ".join(on_conditions)

    # SET clause - all columns except keys
    data_columns = [col for col in df.columns if col not in key_columns]
    set_conditions = []
    for col in data_columns:
        set_conditions.append(f"[{col}] = source.[{col}]")
    set_clause = ", ".join(set_conditions)

    # INSERT clause - all columns
    all_columns = df.columns.tolist()
    insert_columns = ", ".join([f"[{col}]" for col in all_columns])
    insert_values = ", ".join([f"source.[{col}]" for col in all_columns])

    merge_sql = f"""
    MERGE {target_table} AS target
    USING {temp_table} AS source
    ON {on_clause}
    WHEN MATCHED THEN
        UPDATE SET {set_clause}
    WHEN NOT MATCHED THEN
        INSERT ({insert_columns})
        VALUES ({insert_values})
    OUTPUT $action, inserted.*;
    """

    # 3. Run merge and receive results
    with engine.connect() as conn:
        conn.execute(text(merge_sql))
        conn.commit()

    # Clean up temp table for good measure
    try:
        with engine.connect() as conn:
            conn.execute(text(f"DROP TABLE IF EXISTS {temp_table}"))
            conn.commit()
    except SQLAlchemyError:
        pass  # Temp tables are cleaned automatically


def create_table(table_name: str, columns_list: list[str], oc: OrchestratorConnection):
    """Create table in the SQL database with the table name and columns.

    Args:
        table_name: Table name for the table.
    """
    connection_string = oc.get_constant(config.DB_CONNECTION).value
    engine = create_engine(connection_string)

    metadata = MetaData(schema=config.DB_SCHEMA)
    primary_keys = table_keys[table_name] if table_name in table_keys else None

    if primary_keys:
        primary_key_constraint = PrimaryKeyConstraint(*primary_keys)
        columns_list.append(primary_key_constraint)

    Table(table_name, metadata, *columns_list)

    metadata.create_all(engine)


def get_column_list_with_types(table_name: str):
    """Lookup types and return list of Columns for table."""
    columns_list = []
    for col in table_used_columns[table_name]:
        column_type = type_mapping[data_types[table_name][col]]
        columns_list.append(Column(col, column_type))
    return columns_list
