"""This is the CSV Cleaner class, which is responsible for reading data from CSV, setting date formats and filtering columns. It is very much the result of AI."""

from pathlib import Path
from dataclasses import dataclass
from typing import Dict, List, Optional

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


# pylint: disable=too-many-instance-attributes
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
        Read CSV with automatic data type conversion.

        Args:
            filepath: Path for CSV-fil.
            date_columns: List of columns to convert to dates.
            number_columns: List of columns to convert to integers.
            date_filter: Dict with 'column', 'start_date', 'end_date' for filtering
        """

        df = None

        # Try different encodings.
        for encoding in self.encodings:
            try:
                df = pd.read_csv(filepath, dtype=str, encoding=encoding, **self.csv_config)
                break
            except UnicodeDecodeError:
                continue

        if df is None:
            raise ValueError(f"Could not read {filepath} with any of these encodings: {self.encodings}")

        # Clean data
        df = self._clean_basic_data(df)

        # Check for missing key values
        if not table_keys:
            table_keys = []
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

        return df

    def _clean_basic_data(self, df: pd.DataFrame) -> pd.DataFrame:
        """Basic data cleaning, replacing/removing whitespace and removing periods.

        Args:
            df: Pandas dataframe in need of cleaning.
        """

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

            # Try reading with different formats.
            converted = False
            for date_format in self.date_formats:
                try:
                    new_col = pd.to_datetime(df[col], format=date_format, errors='coerce')
                    successful_conversions = new_col.notna().sum()
                    if successful_conversions:
                        converted = True
                        df[col] = new_col
                        break
                except (ValueError, TypeError, pd.errors.OutOfBoundsDatetime):
                    continue

            if not converted:
                # Pandas auto format as fallback.
                try:
                    df[col] = pd.to_datetime(df[col], errors='coerce', dayfirst=True)
                    converted = True
                except (ValueError, TypeError, pd.errors.OutOfBoundsDatetime):
                    print(f"Could not convert {col} to date")

            # Convert to format ddmmyyyy (as string)
            if converted:
                df[col] = df[col].dt.strftime('%Y%m%d')
                df[col] = df[col].fillna(pd.NA)

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

            has_decimals = df[col].astype(str).str.contains(',', na=False).any()

            if has_decimals:
                df[col] = self._safe_float_conversion(df[col])
            else:
                df[col] = np.floor(pd.to_numeric(df[col].str.replace(".", ""), errors='coerce')).astype('Int64')

            df[col].fillna(0)

        return df

    def _safe_float_conversion(self, series: pd.Series) -> pd.Series:
        """Convert to float with danish seperator.

        Args:
            series: The pandas series to work on."""

        def convert_danish_number(value):
            if pd.isna(value) or value == '':
                return None

            value_str = str(value).strip()

            if '.' in value_str and ',' in value_str:
                value_str = value_str.replace('.', '').replace(',', '.')
            elif ',' in value_str:
                value_str = value_str.replace(',', '.')

            try:
                return float(value_str)
            except (ValueError, TypeError):
                return np.nan

        converted = series.apply(convert_danish_number)
        return converted

    def analyze_csv(self, filepath: Path) -> Dict:
        """Analyse the first 100 rows and return a dictionary of types.

        Args:
            filepath: Path to the file to analyze.
        """
        sample_df = None

        for encoding in self.encodings:
            try:
                sample_df = pd.read_csv(filepath, dtype=str, encoding=encoding, nrows=100, **self.csv_config)
                break
            except UnicodeDecodeError:
                continue

        if sample_df is None:
            raise ValueError(f"Could not read {filepath} with any of these encodings: {self.encodings}")
        sample_df = self._clean_basic_data(sample_df)

        analysis = {
            'total_columns': len(sample_df.columns),
            'columns': list(sample_df.columns),
            'suggested_types': {}
        }

        for col in sample_df.columns:

            # Suggest data type
            suggested_type = self._suggest_column_type(sample_df[col])
            analysis['suggested_types'][col] = suggested_type

        return analysis

    def _suggest_column_type(self, series: pd.Series) -> str:
        """Suggest data type (text, date or number) based on content."""

        # Drop null values
        non_null = series.dropna().astype(str)

        if len(non_null) == 0:
            return 'text'

        # Check for dates
        for pattern in self.date_patterns:
            if non_null.str.match(pattern).any():
                return 'date'

        # Check for numbers: is a digit without leading zeroes, unless everything is zero
        is_numeric = non_null.str.replace('[,.]', '', regex=True).str.isdigit().all() and (non_null[0] != "0" or all(c == "0" for c in non_null))

        if is_numeric:
            return 'number'

        return 'text'

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
