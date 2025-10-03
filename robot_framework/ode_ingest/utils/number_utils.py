"""
number_utils.py

Contains utility functions for converting numeric columns in DataFrames,
including handling Danish decimal separators and checking if values are numeric.
"""
from decimal import Decimal

import pandas as pd
import numpy as np


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
        m_neg = df[col].str.endswith("-")
        df[col] = df[col].str.rstrip("-")
        has_decimals = df[col].astype(str).str.contains(',', na=False).any()
        if has_decimals:
            df[col] = safe_float_conversion(df[col])
        else:
            df[col] = np.floor(pd.to_numeric(df[col].str.replace(".", ""), errors='coerce')).astype('Int64')
        df[col] = np.where(m_neg, -df[col], df[col])
        df[col] = df[col].astype(str)
    return df
