"""
dataframe_utils.py

Functions for creating and cleaning pandas DataFrames from files.
"""
from pathlib import Path
from typing import List, Optional

import pandas as pd
import numpy as np
from sqlalchemy import Engine, Date, Numeric, Integer
from OpenOrchestrator.orchestrator_connection.connection import OrchestratorConnection
from robot_framework.ode_ingest.table_columns import table_keys, table_used_columns, data_types
from robot_framework.ode_ingest.utils.date_utils import DateRangeColumn
from robot_framework.ode_ingest.utils import date_utils, number_utils
from robot_framework import config


def create_dataframe_from_file(
    file_path: str,
    table_name: str,
    oc: OrchestratorConnection,
    date_filter: Optional[DateRangeColumn] = None
) -> Optional[pd.DataFrame]:
    """
    Create a pandas DataFrame from a file, applying cleaning and column selection.

    Args:
        file_path: Path to the file.
        table_name: Name of the table (for column selection).
        oc: OrchestratorConnection for error logging.
        date_filter: Optional date filter for rows.

    Returns:
        A pandas DataFrame containing formatted data, or None if file does not exist.
    """
    csv_file = Path(file_path)

    if not csv_file.exists():
        return None

    raw_df = load_raw_df(file_path)

    df = set_types_and_keys(raw_df, table_name, file_path, oc, date_filter)

    return df


def load_raw_df(filepath: str) -> pd.DataFrame:
    """Create a raw dataframe from CSV filepath, attempting several possible encodings.

    Args:
        filepath: Path to file, formatted as CSV.

    Raises:
        ValueError: Raised if no encoding works.

    Returns:
        Pandas dataframe containing data from file.
    """
    raw_df = None
    for encoding in config.ENCODINGS:
        try:
            raw_df = pd.read_csv(filepath, dtype=str, encoding=encoding, sep=";")
            break
        except UnicodeDecodeError:
            continue
    if raw_df is None:
        raise ValueError(f"Could not read {filepath} with encodings: {config.ENCODINGS}")
    return raw_df


def load_df_from_sql(table_name: str, engine: Engine) -> pd.DataFrame:
    return pd.read_sql(f'SELECT * FROM [{config.DB_NAME}].[{config.DB_SCHEMA}].[{table_name}]', engine)


def _validate_initial_keys(
    df: pd.DataFrame,
    keys: List[str],
    identifier: str,
    oc: OrchestratorConnection
) -> pd.DataFrame:
    """
    Validate that key columns have no missing or empty values.
    Logs errors and drops rows with missing keys.

    Args:
        df: DataFrame to validate
        table_keys: List of column names that are required keys
        identifier: Identifier of table being processed (for logging)
        oc: OrchestratorConnection for error logging

    Returns:
        DataFrame with rows containing missing keys removed
    """
    for key_value in keys:
        missing_keys = df[df[key_value].isna() | (df[key_value].str.strip() == '')]
        if len(missing_keys) > 0:
            oc.log_error(f"Table '{identifier}' missing keys: {missing_keys.index.tolist()}")
            df = df.dropna(subset=[key_value])
    return df


def _validate_final_keys(
    df: pd.DataFrame,
    keys: List[str],
    date_columns: Optional[List[str]],
    identifier: str,
    oc: OrchestratorConnection
) -> pd.DataFrame:
    """
    Final validation of key columns after type conversion.
    Skips date columns and logs/removes rows with missing keys.

    Args:
        df: DataFrame to validate
        table_keys: List of column names that are required keys
        date_columns: List of date columns to skip in validation
        identifier: Identifier of table being processed (for logging)
        oc: OrchestratorConnection for error logging

    Returns:
        DataFrame with invalid rows removed
    """
    missing_mask = pd.Series(False, index=df.index)
    for col in keys:
        if date_columns and col in date_columns:
            continue
        col_missing = df[col].isna()
        if col_missing.any():
            missing_rows = df[col_missing].index.tolist()
            oc.log_error(
                f"Table '{identifier}' missing key values in column '{col}' at rows: {missing_rows}"
            )
        missing_mask |= col_missing
    return df[~missing_mask]


def convert_null(df: pd.DataFrame) -> pd.DataFrame:
    """Convert stringified nulls and numpy nulls to pandas NA.

    Args:
        df: Pandas DataFrame that needs conversion.

    Returns:
        Dataframe with values converted to pd.NA.
    """
    return df.replace(['', ' ', 'nan', 'NaN', 'None', np.nan], pd.NA).convert_dtypes()


def set_types_and_keys(df: pd.DataFrame, table_name: str, identifier: str, oc: OrchestratorConnection, date_filter: Optional[dict] = None) -> pd.DataFrame:
    date_columns = [col for col, type_ in data_types[table_name].items() if type_ == Date]
    number_columns = [col for col, type_ in data_types[table_name].items() if type_ in [Numeric, Integer]]
    keys = table_keys[table_name]

    if keys:
        df = _validate_initial_keys(df, keys, identifier, oc)

    # 4. Date and number conversion
    if date_columns:
        df = date_utils.convert_dates(df, date_columns)
    if number_columns:
        df = number_utils.convert_numbers(df, number_columns)

    # 5. Date filtering
    if date_filter:
        df = date_utils.apply_date_filter(df, date_filter)

    # 6. Set empty strings to NULL and final key validation
    df = convert_null(df)

    if keys:
        df = _validate_final_keys(df, keys, date_columns, identifier, oc)

    if df.empty:
        raise BrokenPipeError("Dataframe was cleared by null check.")

    columns = set()
    for table_dict in [table_used_columns, table_keys]:
        if table_name in table_dict and table_dict[table_name]:
            columns.update(table_dict[table_name])
    df = df[df.columns.intersection(columns)]

    if table_keys[table_name] is None:
        df.reset_index(allow_duplicates=True)

    return df
