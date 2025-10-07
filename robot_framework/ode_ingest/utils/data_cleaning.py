"""
data_cleaning.py

Provides basic utilities for cleaning DataFrames, such as removing unnecessary columns,
trimming whitespace, and standardizing column names. Should be used as the first step in data processing.
"""

import pandas as pd


def clean_basic_data(df: pd.DataFrame) -> pd.DataFrame:
    """
    Performs basic cleaning on a DataFrame:
    - Strips leading and trailing whitespace from string columns.
    - Removes periods from string columns.
    - Drops 'unnamed' columns (commonly from Excel exports).
    - Standardizes column names by replacing spaces with underscores and stripping whitespace.

    Args:
        df: The DataFrame to clean.

    Returns:
        A copy of the DataFrame with the above changes applied.
    """
    df = df.copy()
    unnamed_cols = df.columns[df.columns.str.contains('^Unnamed', case=False, na=False)]
    if len(unnamed_cols) > 0:
        df = df.drop(columns=unnamed_cols)
    df.columns = df.columns.str.replace(' ', '_').str.strip()
    return df
