"""
date_utils.py

Contains utility functions for date conversion and filtering of DataFrames based on date intervals.
Uses standard formats from csv_config.py to ensure consistency.
"""
from dataclasses import dataclass
from typing import List

import pandas as pd

from robot_framework.config import DATE_FORMATS


@dataclass
class DateRangeColumn:
    """Dataclass for setting the date range targeting a specific column for a data upload.
    """
    column: str | list[str]
    start_date: str
    end_date: str


def convert_dates(df: pd.DataFrame, date_columns: List[str]) -> pd.DataFrame:
    """
    Converts columns containing dates in a DataFrame to datetime objects, trying multiple formats.
    If conversion succeeds for some values with a format, that format is used for the column.

    Args:
        df: DataFrame with columns containing dates as strings.
        date_columns: List of column names to convert to datetime.
        date_formats: List of date formats to try in order.

    Returns:
        DataFrame with updated date columns.
    """
    for col in date_columns:
        if col not in df.columns:
            continue
        df[col] = df[col].replace('00.00.0000', pd.NaT)
        for date_format in DATE_FORMATS:
            try:
                new_col = pd.to_datetime(df[col], format=date_format, errors='coerce')
                if new_col.notna().sum() > 0:
                    df[col] = new_col
                    break
            except (ValueError, TypeError, pd.errors.OutOfBoundsDatetime):
                continue
    return df


def apply_date_filter(df: pd.DataFrame, date_filter: dict) -> pd.DataFrame:
    """
    Filters a DataFrame based on a date interval in a specified column.

    Args:
        df: DataFrame to filter.
        date_filter: Dict with keys 'column', 'start_date', and 'end_date' (all str).

    Returns:
        Filtered DataFrame with only rows within the given interval.
    """
    column = date_filter['column']
    start_date = date_filter['start_date']
    end_date = date_filter['end_date']
    start_dt = pd.to_datetime(start_date, format='%Y%m%d')
    end_dt = pd.to_datetime(end_date, format='%Y%m%d')
    temp_date_col = pd.to_datetime(df[column], format='%Y%m%d', errors='coerce')
    mask = (temp_date_col >= start_dt) & (temp_date_col <= end_dt)
    return df.loc[mask]
