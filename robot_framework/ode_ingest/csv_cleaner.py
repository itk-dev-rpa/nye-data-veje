"""This is the CSV Cleaner class, which is responsible for reading data from CSV, setting date formats and filtering columns. It is very much the result of AI."""

from pathlib import Path
from dataclasses import dataclass
from typing import List, Optional
from decimal import Decimal

import pandas as pd
import numpy as np
from OpenOrchestrator.orchestrator_connection.connection import OrchestratorConnection


@dataclass
class DateRangeColumn:
    """Dataclass for setting the date range targeting a specific column for a data upload.
    """
    column: str | list[str]
    start_date: str
    end_date: str


# pylint: disable=too-many-instance-attributes, too-many-branches, too-few-public-methods
class CSVCleaner:
    """
    A class for consistent handling of CSV-files with data type conversion.
    """

    def __init__(self, encodings: List[str] = None):
        self.csv_config = {
            'sep': ';',  # Danish standard separator
            'decimal': ',',  # Danish decimal separator
            'thousands': '.',  # Danish thousands separator
            'na_values': ['', ' ', 'nan', 'NaN', 'NULL', 'null', '-', 'N/A'],
            'keep_default_na': True,
            'skipinitialspace': True
        }

        # Encoding fallback list
        self.encodings = encodings or ['utf-8', 'latin-1', 'cp1252']

        # Date formats to test for
        self.date_formats = [
            '%d-%m-%Y',  # 01-12-2024
            '%d/%m/%Y',  # 01/12/2024
            '%Y%m%d',    # 20241201
            '%Y-%m-%d',  # 2024-12-01
            '%d.%m.%Y',  # 01.12.2024
            '%d-%m-%y',  # 01-12-24
            '%d/%m/%y',  # 01/12/24
        ]

        # Regex patterns for date components
        self.day = r'(?:0[1-9]|[12][0-9]|3[01])'      # 01-31
        self.month = r'(?:0[1-9]|1[0-2])'             # 01-12
        self.year_4 = r'(?:19|20)\d{2}'               # 1900-2099
        self.year_2 = r'\d{2}'                        # 00-99
        self.sep_opt = r'[-/\.]?'                     # Optional separators

        self.date_patterns = [
            # dd[-/.]mm[-/.]yyyy eller ddmmyyyy
            rf'\b{self.day}{self.sep_opt}{self.month}{self.sep_opt}{self.year_4}\b',

            # dd[-/.]mm[-/.]yy eller ddmmyy
            rf'\b{self.day}{self.sep_opt}{self.month}{self.sep_opt}{self.year_2}\b',

            # yyyy-mm-dd eller yyyymmdd
            rf'\b{self.year_4}{self.sep_opt}{self.month}{self.sep_opt}{self.day}\b',

            # mm[-/.]dd[-/.]yyyy eller mmddyyyy
            rf'\b{self.month}{self.sep_opt}{self.day}{self.sep_opt}{self.year_4}\b'
        ]

    # pylint: disable=too-many-positional-arguments
    def read_csv_with_types(self, filepath: Path,
                            oc: OrchestratorConnection,
                            table_keys: Optional[List[str]] = None,
                            date_columns: Optional[List[str]] = None,
                            number_columns: Optional[List[str]] = None,
                            date_filter: Optional[DateRangeColumn] = None) -> pd.DataFrame:
        """
        Read CSV with data type conversion.

        Args:
            filepath: Path for CSV-fil.
            oc: OpenOrchestrator connection.
            table_keys: (Optional) A list of table keys used for indexing.
            date_columns: (Optional) List of columns to convert to dates.
            number_columns: (Optional) List of columns to convert to integers.
            date_filter: (Optional) Dict with 'column', 'start_date', 'end_date' for filtering
            check_data: Should data conversion be checked for errors?
        """
        raw_df = None

        # Try different encodings.
        for encoding in self.encodings:
            try:
                raw_df = pd.read_csv(filepath, dtype=str, encoding=encoding, **self.csv_config)
                break
            except UnicodeDecodeError:
                continue

        if raw_df is None:
            raise ValueError(f"Could not read {filepath} with any of these encodings: {self.encodings}")
        if raw_df.empty:
            return raw_df

        # Clean data
        raw_df = self._clean_basic_data(raw_df)
        df = raw_df.copy()

        # Check for missing key values
        if table_keys:
            for key_value in table_keys:
                missing_keys = df[df[key_value].isna() | (df[key_value].str.strip() == '')]
                if len(missing_keys) > 0:
                    oc.log_error(f"File '{filepath}' missing keys: {missing_keys.index.tolist()}")
                    df = df.dropna(subset=[key_value])

        # Convert data types
        if date_columns:
            df = self._convert_dates(df, date_columns)

        if number_columns:
            df = self._convert_numbers(df, number_columns)

        if date_filter:
            df = self._apply_date_filter(df, date_filter)

        # Convert empty strings to NULL
        df = df.replace(['', ' ', 'nan', 'NaN', np.nan], pd.NA).convert_dtypes()
        # Check for missing key values
        if table_keys:
            missing_mask = pd.Series(False, index=df.index)
            for col in table_keys:
                if col in date_columns:  # Date columns can't be checked, inconsistent formatting.
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

    def _clean_basic_data(self, df: pd.DataFrame) -> pd.DataFrame:
        """Basic data cleaning, replacing/removing whitespace and removing periods.

        Args:
            df: Pandas dataframe in need of cleaning.
        """
        df = df.copy()
        for col in df.columns:
            if df[col].dtype == 'object':
                df[col] = df[col].astype(str).str.strip().replace(".", "")

        # Remove 'unnamed' columns.
        unnamed_cols = df.columns[df.columns.str.contains('^Unnamed', case=False, na=False)]
        if len(unnamed_cols) > 0:
            df = df.drop(columns=unnamed_cols)

        df.columns = df.columns.str.replace(' ', '_').str.strip()

        return df

    def _convert_dates(self, df: pd.DataFrame, date_columns: List[str]) -> pd.DataFrame:
        """Convert columns with dates to a useful format.

        Args:
            df: Pandas dataframe with dates that need formatting.
            date_columns: List of columns with dates to convert.
        """

        for col in date_columns:
            if col not in df.columns:
                continue
            df[col] = df[col].replace('00.00.0000', pd.NaT)

            # Try reading with different formats.
            for date_format in self.date_formats:
                try:
                    new_col = pd.to_datetime(df[col], format=date_format, errors='coerce')
                    successful_conversions = new_col.notna().sum()
                    if successful_conversions > 0:
                        df[col] = new_col
                        break
                except (ValueError, TypeError, pd.errors.OutOfBoundsDatetime):
                    continue
        return df

    def _convert_numbers(self, df: pd.DataFrame, number_columns: List[str]) -> pd.DataFrame:
        """Convert to integers if there are no commas in the number, floats if there is.

        Args:
            df: Pandas dataframe to convert values in.
            number_columns: List of columns with identified numbers.
        """

        for col in number_columns:
            if col not in df.columns:
                continue

            # build a mask of negative numbers in wrong format
            m_neg = df[col].str.endswith("-")
            df[col] = df[col].str.rstrip("-")

            # Format numbers with or without decimals
            has_decimals = df[col].astype(str).str.contains(',', na=False).any()
            if has_decimals:
                df[col] = self._safe_float_conversion(df[col])
            else:
                df[col] = np.floor(pd.to_numeric(df[col].str.replace(".", ""), errors='coerce')).astype('Int64')
            error_df = df[~df[col].apply(self._is_numeric)]
            if not error_df.empty:
                print(error_df)
            # Apply the mask to recreate the negatives
            df[col] = np.where(m_neg, -df[col], df[col])
            # Store values as strings to avoid errors on upload
            df[col] = df[col].astype(str)

        return df

    def _safe_float_conversion(self, series: pd.Series) -> pd.Series:
        """Convert to decimal.Decimal from numbers that may use Danish separators.

        Args:
            series: A pandas series containing numbers to convert to danish formatted decimals.
        """
        def convert_danish_number(value):
            if pd.isna(value) or value == '':
                return None
            value_str = str(value).strip()

            # Remove thousand separator and replace comma with dot
            if '.' in value_str and ',' in value_str:
                value_str = value_str.replace('.', '').replace(',', '.')
            elif ',' in value_str:
                value_str = value_str.replace(',', '.')
            return Decimal(value_str).quantize(Decimal("0.01"))  # Match SQL NUMERIC(15,2)

        # Convert series
        converted = series.apply(convert_danish_number)
        return converted

    def _apply_date_filter(self, df: pd.DataFrame, date_filter: DateRangeColumn) -> pd.DataFrame:
        """Filter data frame based on date interval.

        Args:
            df: Pandas dataframe to filter.
            date_filter: Which column to use for date check.
        """

        if not all([date_filter.column, date_filter.start_date, date_filter.end_date]):
            print("Warning: Incomplete date-filter configuration.")
            return df

        if (isinstance(date_filter.column, list) and not all(c in df.columns for c in date_filter.column)) or isinstance(date_filter.column, str) and date_filter.column not in df.columns:
            print(f"Warning: Filter-column '{date_filter.column}' does not exist.")
            return df

        # Convert filter-dates to pandas datetime
        start_dt = pd.to_datetime(date_filter.start_date, format='%Y%m%d')
        end_dt = pd.to_datetime(date_filter.end_date, format='%Y%m%d')

        if isinstance(date_filter.column, list):
            mask = pd.Series(False, index=df.index)
            for col in date_filter.column:
                temp_date_col = pd.to_datetime(df[col], format='%Y%m%d', errors='coerce')
                mask |= (temp_date_col >= start_dt) & (temp_date_col <= end_dt)
        else:
            temp_date_col = pd.to_datetime(df[date_filter.column], format='%Y%m%d', errors='coerce')
            mask = (temp_date_col >= start_dt) & (temp_date_col <= end_dt)

        filtered_df = df.loc[mask]

        if len(filtered_df) == 0:
            print("Warning: No rows matched the date filter.")

        return filtered_df

    def _is_numeric(self, value) -> bool:
        """Check if value is numeric, including Decimal."""
        return isinstance(value, (int, float, Decimal)) and not pd.isna(value)
