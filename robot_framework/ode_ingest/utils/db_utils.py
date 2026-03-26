"""
db_utils.py

Database utility functions for inserting, merging, and creating tables.
"""

import time
from typing import List
import pandas as pd
from sqlalchemy import create_engine, text, Engine, Table, MetaData, PrimaryKeyConstraint, Column
from sqlalchemy.exc import SQLAlchemyError
from OpenOrchestrator.orchestrator_connection.connection import OrchestratorConnection
from robot_framework import config
from robot_framework.ode_ingest.table_definitions import all_tables


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
    key_columns = all_tables[table_name].keys
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


def create_table(table_name: str, columns_list: List[Column], oc: OrchestratorConnection) -> None:
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
    primary_keys = all_tables[table_name].keys

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
    for col in all_tables[table_name].used_columns:
        column_type = all_tables[table_name].data_types[col]
        columns_list.append(Column(col, column_type))
    return columns_list


def get_table_row_count(table_name: str, engine: Engine) -> int:
    """Get the number of rows in a table."""
    with engine.connect() as conn:
        result = conn.execute(
            text(f"SELECT COUNT(*) FROM [{config.DB_SCHEMA}].[{table_name}]")
        )
        return result.scalar()


def drop_table_if_exists(table_name: str, engine: Engine):
    """Drop a table if it exists."""
    with engine.connect() as conn:
        conn.execute(
            text(f"IF OBJECT_ID('[{config.DB_SCHEMA}].[{table_name}]', 'U') IS NOT NULL "
                 f"DROP TABLE [{config.DB_SCHEMA}].[{table_name}]")
        )
        conn.commit()


def execute_sql(sql: str, engine: Engine):
    """Execute a SQL statement."""
    with engine.connect() as conn:
        conn.execute(text(sql))
        conn.commit()


def get_column_list(table_name: str, engine: Engine) -> list[str]:
    """Get list of column names from a table."""
    with engine.connect() as conn:
        result = conn.execute(
            text(f"""
                SELECT COLUMN_NAME
                FROM INFORMATION_SCHEMA.COLUMNS
                WHERE TABLE_SCHEMA = '{config.DB_SCHEMA}'
                AND TABLE_NAME = '{table_name}'
                ORDER BY ORDINAL_POSITION
            """)
        )
        return [row[0] for row in result]
