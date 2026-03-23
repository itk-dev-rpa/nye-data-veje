"""
number_utils.py

Contains utility functions for converting numeric columns in DataFrames,
including handling Danish decimal separators and checking if values are numeric.
"""
from decimal import Decimal

import pandas as pd


def safe_float_conversion(series: pd.Series) -> pd.Series:
    """
    Converts a pandas Series with Danish decimal separators to Decimal objects.

    Args:
        series: Series with numbers as strings, e.g., '1.234,56'

    Returns:
        Series with Decimal objects.
    """
    def convert_danish_number(value):
        if pd.isna(value) or value == '':
            return None
        value_str = str(value).strip()
        if '.' in value_str and ',' in value_str:
            value_str = value_str.replace('.', '').replace(',', '.')
        elif ',' in value_str:
            value_str = value_str.replace(',', '.')
        return Decimal(value_str).quantize(Decimal("0.01"))
    converted = series.apply(convert_danish_number)
    return converted


def convert_numbers(df: pd.DataFrame, number_columns: list) -> pd.DataFrame:
    """
    Converts columns with numbers, either to Decimal (if a comma is present) or Int64 (no comma).
    Handles negative numbers indicated by a trailing '-'.

    Args:
        df: DataFrame with numbers as strings.
        number_columns: List of column names to convert.

    Returns:
        DataFrame with updated numeric columns.
    """
    for col in number_columns:
        if col not in df.columns:
            continue
        df[col] = convert_number_series(df[col]).astype(str)
    return df


def convert_number_series(series: pd.Series) -> pd.Series:
    """
    Convert a series containing strings to numbers, using trailing minus
    to properly set number as negative.
    """
    # Handle negatives
    m_neg = series.str.endswith("-", na=False)
    series_cleaned = series.str.rstrip("-")

    # Detect format
    has_decimals = series_cleaned.astype(str).str.contains(',', na=False).any()

    if has_decimals:
        converted = safe_float_conversion(series_cleaned)
    else:
        # Remove thousand separators, convert to integer
        converted = pd.to_numeric(
            series_cleaned.str.replace(".", "", regex=False),
            errors='coerce'
        )
        converted = converted.astype('Int64')  # Nullable integer

    # Apply negative sign
    result = converted.where(~m_neg, -converted)

    return result
