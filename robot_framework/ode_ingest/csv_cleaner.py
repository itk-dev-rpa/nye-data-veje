"""
csv_cleaner.py

Contains the CSVCleaner class, which orchestrates the workflow for reading, cleaning,
date and number conversion, and filtering of CSV files. The class uses utility functions
from the other modules and can be used for automated import and validation of data.
"""

from pathlib import Path
from typing import List, Optional

import pandas as pd
import numpy as np

from robot_framework import config
from robot_framework.ode_ingest.utils import data_cleaning, date_utils, number_utils


class CSVCleaner:
    """
    Class for reading, cleaning, and transforming CSV data.
    Uses utility functions to handle Danish formats and
    supports validation, conversion, and filtering.
    """

    def __init__(self, encodings: Optional[List[str]] = None):
        """
        Initialize CSVCleaner with configuration parameters.

        Args:
            encodings: Optional list of text encodings to try when reading files.
        """
        self.csv_config = config.CSV_CONFIG
        self.encodings = encodings or config.ENCODINGS

    def read_csv_with_types(
        self,
        filepath: Path,
        oc,  # OrchestratorConnection
        table_keys: Optional[List[str]] = None,
        date_columns: Optional[List[str]] = None,
        number_columns: Optional[List[str]] = None,
        date_filter: Optional[dict] = None
    ) -> pd.DataFrame:
        """
        Reads a CSV file, cleans and converts the data, validates keys, and filters by date.

        Args:
            filepath: Path to the CSV file.
            oc: OrchestratorConnection for error logging.
            table_keys: List of column names to use as keys (should not be empty).
            date_columns: List of column names to convert to dates.
            number_columns: List of column names to convert to numbers.
            date_filter: Dict with keys 'column', 'start_date', 'end_date' for date filtering.

        Returns:
            DataFrame with cleaned and validated data.
        """
        # 1. Read CSV
        raw_df = None
        for encoding in self.encodings:
            try:
                raw_df = pd.read_csv(filepath, dtype=str, encoding=encoding, **self.csv_config)
                break
            except UnicodeDecodeError:
                continue
        if raw_df is None:
            raise ValueError(f"Could not read {filepath} with encodings: {self.encodings}")
        if raw_df.empty:
            return raw_df

        # 2. Basic cleaning
        df = data_cleaning.clean_basic_data(raw_df)

        # 3. Check for missing key values
        if table_keys:
            for key_value in table_keys:
                missing_keys = df[df[key_value].isna() | (df[key_value].str.strip() == '')]
                if len(missing_keys) > 0:
                    oc.log_error(f"File '{filepath}' missing keys: {missing_keys.index.tolist()}")
                    df = df.dropna(subset=[key_value])

        # 4. Date and number conversion
        if date_columns:
            df = date_utils.convert_dates(df, date_columns)
        if number_columns:
            df = number_utils.convert_numbers(df, number_columns)

        # 5. Date filtering
        if date_filter:
            df = date_utils.apply_date_filter(df, date_filter)

        # 6. Set empty strings to NULL and check missing keys again
        df = df.replace(['', ' ', 'nan', 'NaN', np.nan], pd.NA).convert_dtypes()
        if table_keys:
            missing_mask = pd.Series(False, index=df.index)
            for col in table_keys:
                if date_columns and col in date_columns:
                    continue
                col_missing = df[col].isna()
                if col_missing.any():
                    missing_rows = df[col_missing].index.tolist()
                    oc.log_error(f"File '{filepath}' missing key values in column '{col}' at rows: {missing_rows}")
                missing_mask |= col_missing
            df = df[~missing_mask]

        if df.empty:
            raise BrokenPipeError("Dataframe was cleared by null check.")

        return df
