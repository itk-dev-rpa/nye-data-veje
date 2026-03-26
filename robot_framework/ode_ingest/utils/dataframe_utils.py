"""Pandas DataFrame utilities for data loading and validation.

Provides functions for:
- Loading CSV files with multiple encoding fallback
- Type conversion (dates, numbers)
- Primary key validation
- NULL handling
- SQL table loading
"""
from pathlib import Path

import pandas as pd
from robot_framework import config


def load_raw_df(filepath: Path) -> pd.DataFrame:
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
