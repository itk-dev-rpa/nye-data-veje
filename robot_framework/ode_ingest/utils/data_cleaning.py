"""Basic DataFrame cleaning utilities.

Provides basic utilities for cleaning DataFrames:
- Removing unnecessary columns (unnamed Excel export columns)
- Trimming whitespace from column names
- Standardizing column names (spaces to underscores)
- Ensuring unique column names

Should be used as the first step in data processing before type conversion.
"""

import pandas as pd


def clean_basic_data(df: pd.DataFrame) -> pd.DataFrame:
    """
    Performs basic cleaning on a DataFrame:
    - Drops 'unnamed' columns (commonly from Excel exports).
    - Standardizes column names by replacing spaces with underscores and stripping whitespace.
    - Make column names unique.

    Args:
        df: The DataFrame to clean.

    Returns:
        A copy of the DataFrame with the above changes applied.
    """
    df = df.copy()
    unnamed_cols = df.columns[df.columns.str.contains('^Unnamed', case=False, na=False)]
    if len(unnamed_cols) > 0:
        df = df.drop(columns=unnamed_cols)
    df.columns = df.columns.str.replace(' ', '_').str.replace('.', '').str.strip()
    df.columns = make_columns_unique(df.columns)
    return df


def make_columns_unique(cols):
    """Run through columns and assign extra numbers to any duplicates.

    Args:
        cols: List of columns from a pandas dataframe.

    Returns:
        List of columns with numbers added to duplicates.
    """
    seen = {}
    result = []
    for col in cols:
        if col not in seen:
            seen[col] = 1
            result.append(col)
        else:
            seen[col] += 1
            result.append(f"{col}_{seen[col]}")
    return result
