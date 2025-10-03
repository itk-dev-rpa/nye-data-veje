"""
db_utils.py

Database utility functions for inserting, merging, and creating tables.
"""

import time
from typing import List
import pandas as pd
from sqlalchemy import create_engine, text, Engine, Table, MetaData, PrimaryKeyConstraint, Column, String, Date, Numeric
from sqlalchemy.exc import SQLAlchemyError
from robot_framework import config
from robot_framework.ode_ingest.table_columns import table_keys, table_used_columns, data_types

type_mapping = {
    'text': String(255),
    'number': Numeric(precision=15, scale=2),
    'date': Date
}


def insert_data(df: pd.DataFrame, table_name: str, engine: Engine) -> None:
    """
    Insert data from a DataFrame into an SQL table.

    Args:
        df: DataFrame containing data to insert.
        table_name: SQL table to insert data into.
        engine: SQLAlchemy Engine to use for the connection.
    """
    metadata = MetaData()
    table = Table(table_name, metadata, autoload_with=engine, schema=config.DB_SCHEMA)

    with engine.begin() as conn:
        conn.execute(table.insert(), df.to_dict('records'))


def merge_table_from_dataframe(df: pd.DataFrame, table_name: str, engine: Engine) -> None:
    """
    Upsert data in bulk using SQL Server MERGE.

    Args:
        df: DataFrame to merge into the table.
        table_name: Table to merge the DataFrame into.
        engine: SQLAlchemy Engine for database connection.
    """
    key_columns = table_keys[table_name]
    if not key_columns:
        insert_data(df, table_name, engine)
        return

    temp_table = f"#temp_{table_name}_{int(time.time())}"

    metadata = MetaData(schema=config.DB_SCHEMA)
    Table(temp_table, metadata, *get_column_list_with_types(table_name))
    metadata.create_all(engine)

    insert_data(df, temp_table, engine)

    target_table = f"[{config.DB_NAME}].[{config.DB_SCHEMA}].[{table_name}]"
    temp_table_qualified = f"[{config.DB_NAME}].[{config.DB_SCHEMA}].[{temp_table}]"

    on_conditions = [f"target.[{key}] = source.[{key}]" for key in key_columns]
    on_clause = " AND ".join(on_conditions)
    data_columns = [col for col in df.columns if col not in key_columns]
    set_conditions = [f"[{col}] = source.[{col}]" for col in data_columns]
    set_clause = ", ".join(set_conditions)
    all_columns = df.columns.tolist()
    insert_columns = ", ".join([f"[{col}]" for col in all_columns])
    insert_values = ", ".join([f"source.[{col}]" for col in all_columns])

    merge_sql = f"""
    MERGE {target_table} AS target
    USING {temp_table_qualified} AS source
    ON {on_clause}
    WHEN MATCHED THEN
        UPDATE SET {set_clause}
    WHEN NOT MATCHED THEN
        INSERT ({insert_columns})
        VALUES ({insert_values})
    OUTPUT $action, inserted.*;
    """

    with engine.connect() as conn:
        conn.execute(text(merge_sql))
        conn.commit()

    try:
        with engine.connect() as conn:
            conn.execute(text(f"DROP TABLE IF EXISTS {temp_table_qualified}"))
            conn.commit()
    except SQLAlchemyError:
        pass  # Temp tables are typically cleaned automatically


def create_table(table_name: str, columns_list: List[Column], oc) -> None:
    """
    Create a table in the SQL database with the specified name and columns.

    Args:
        table_name: Name for the new table.
        columns_list: List of Column objects.
        oc: OrchestratorConnection for obtaining connection string.
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


def get_column_list_with_types(table_name: str) -> List[Column]:
    """
    Lookup and return a list of SQLAlchemy Column objects with types for a given table.

    Args:
        table_name: Name of the table.

    Returns:
        List of SQLAlchemy Column objects.
    """
    columns_list = []
    for col in table_used_columns[table_name]:
        column_type = type_mapping[data_types[table_name][col]]
        columns_list.append(Column(col, column_type))
    return columns_list
