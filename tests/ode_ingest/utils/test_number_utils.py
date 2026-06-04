"""Unit tests for Danish-format number conversion utilities."""
from decimal import Decimal

import pandas as pd
import pytest

from robot_framework.ode_ingest.utils.number_utils import (
    convert_number_series,
    convert_numbers,
    safe_float_conversion,
)


class TestSafeFloatConversion:
    def test_danish_thousand_and_decimal_separator(self):
        s = pd.Series(["1.234,56"])
        result = safe_float_conversion(s)
        assert result.iloc[0] == Decimal("1234.56")

    def test_simple_decimal_value(self):
        s = pd.Series(["0,50"])
        result = safe_float_conversion(s)
        assert result.iloc[0] == Decimal("0.50")

    def test_none_and_empty_become_none(self):
        s = pd.Series([None, ""])
        result = safe_float_conversion(s)
        assert result.iloc[0] is None
        assert result.iloc[1] is None

    def test_strips_surrounding_whitespace(self):
        s = pd.Series(["  100,00  "])
        result = safe_float_conversion(s)
        assert result.iloc[0] == Decimal("100.00")


class TestConvertNumberSeries:
    def test_integers_without_comma_become_int64(self):
        s = pd.Series(["100", "200", "300"])
        result = convert_number_series(s)
        assert result.dtype.name == "Int64"
        assert list(result) == [100, 200, 300]

    def test_thousand_separator_handled_in_int_mode(self):
        s = pd.Series(["1.234", "5.678"])
        result = convert_number_series(s)
        assert list(result) == [1234, 5678]

    def test_trailing_minus_marks_negative(self):
        s = pd.Series(["100-", "200"])
        result = convert_number_series(s)
        assert result.iloc[0] == -100
        assert result.iloc[1] == 200

    def test_comma_anywhere_in_series_forces_decimal_mode(self):
        s = pd.Series(["1,50", "100"])
        result = convert_number_series(s)
        assert result.iloc[0] == Decimal("1.50")

    def test_negative_decimal_with_trailing_minus(self):
        s = pd.Series(["1.234,56-"])
        result = convert_number_series(s)
        assert result.iloc[0] == Decimal("-1234.56")


class TestConvertNumbers:
    def test_returns_dataframe_with_converted_column(self):
        df = pd.DataFrame({"Beløb": ["100", "200"], "Andet": ["X", "Y"]})
        result = convert_numbers(df, ["Beløb"])
        # Result column is cast to string for storage; other columns untouched
        assert result["Andet"].iloc[0] == "X"
        assert "Beløb" in result.columns

    def test_skips_missing_columns_without_error(self):
        df = pd.DataFrame({"A": ["100"]})
        result = convert_numbers(df, ["Missing", "A"])
        assert "A" in result.columns
        assert "Missing" not in result.columns
