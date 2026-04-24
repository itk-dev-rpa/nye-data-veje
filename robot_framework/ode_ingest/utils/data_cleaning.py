"""Basic DataFrame cleaning utilities.

Provides basic utilities for cleaning DataFrames:
- Removing unnecessary columns (unnamed Excel export columns)
- Trimming whitespace from column names
- Standardizing column names (spaces to underscores)
- Ensuring unique column names

Should be used as the first step in data processing before type conversion.
"""

import re
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


def normalize_forretningspartner_value(value: str) -> str | None:
    """Normalize a single Forretningspartner value according to business rules.

    Rules:
    - Only remove leading zeros (no other digits are removed)
    - After removing leading zeros, there may be at most 8 digits
    - If there are more than 8 digits and removing leading zeros does not fix it, raise ValueError
    - Empty/NaN stays None; a value consisting entirely of zeros becomes "0"

    Args:
        value: Raw value from source CSV

    Returns:
        Normalized string (digits only) or None

    Raises:
        ValueError: If non-digit characters are present or if length rule is violated
    """
    if value is None:
        return None
    s = str(value).strip()
    if s == "" or pd.isna(s):
        return None
    # Must be digits only
    if not re.fullmatch(r"\d+", s):
        raise ValueError(f"Forretningspartner indeholder ikke-kun cifre: '{value}'")
    # Remove leading zeros only
    trimmed = s.lstrip('0')
    if len(trimmed) < 8:
        trimmed = f"{'0' * (8 - len(trimmed))}{trimmed}"
    # Enforce max 8 digits
    if len(trimmed) > 8:
        raise ValueError(f"Forretningspartner har mere end 8 cifre efter normalisering: '{value}' -> '{trimmed}'")
    return trimmed


def normalize_forretningspartner_series(series: pd.Series) -> pd.Series:
    """Apply normalization to a pandas Series of Forretningspartner values.

    Converts invalid entries into exceptions to be handled by the caller.
    """
    return series.apply(normalize_forretningspartner_value)
