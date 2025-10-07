"""
dataframe_utils.py

Functions for creating and cleaning pandas DataFrames from files.
"""

from pathlib import Path
from typing import Optional
import pandas as pd
from OpenOrchestrator.orchestrator_connection.connection import OrchestratorConnection
from robot_framework.ode_ingest import csv_cleaner
from robot_framework.ode_ingest.table_columns import table_keys, table_used_columns, data_types
from robot_framework.ode_ingest.utils.date_utils import DateRangeColumn


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

    date_cols = [col for col, type_ in data_types[table_name].items() if type_ == 'date']
    num_cols = [col for col, type_ in data_types[table_name].items() if type_ == 'number']

    df = csv_cleaner.read_csv_with_types(
        csv_file,
        oc,
        table_keys=table_keys[table_name],
        date_columns=date_cols,
        number_columns=num_cols,
        date_filter=date_filter
    )

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
