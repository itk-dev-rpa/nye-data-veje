"""Unit tests for data cleaning utilities, including Forretningspartner normalization."""
import pandas as pd
import pytest

from robot_framework.ode_ingest.utils.data_cleaning import (
    clean_basic_data,
    make_columns_unique,
    normalize_forretningspartner_series,
    normalize_forretningspartner_value,
)


class TestCleanBasicData:
    def test_drops_unnamed_columns(self):
        df = pd.DataFrame({"A": [1], "Unnamed: 1": [2], "B": [3]})
        result = clean_basic_data(df)
        assert "Unnamed: 1" not in result.columns
        assert list(result.columns) == ["A", "B"]

    def test_drops_unnamed_case_insensitive(self):
        df = pd.DataFrame({"unnamed: 2": [1], "A": [2]})
        result = clean_basic_data(df)
        assert "unnamed: 2" not in result.columns

    def test_replaces_spaces_with_underscores(self):
        df = pd.DataFrame({"My Column": [1], "Other Col Name": [2]})
        result = clean_basic_data(df)
        assert "My_Column" in result.columns
        assert "Other_Col_Name" in result.columns

    def test_removes_dots_in_column_names(self):
        df = pd.DataFrame({"Col.Name": [1]})
        result = clean_basic_data(df)
        assert "ColName" in result.columns

    def test_returns_copy_not_view(self):
        df = pd.DataFrame({"A": [1]})
        result = clean_basic_data(df)
        result.loc[0, "A"] = 999
        assert df.loc[0, "A"] == 1


class TestMakeColumnsUnique:
    def test_all_unique_unchanged(self):
        assert make_columns_unique(["A", "B", "C"]) == ["A", "B", "C"]

    def test_one_duplicate_gets_suffix(self):
        assert make_columns_unique(["A", "B", "A"]) == ["A", "B", "A_2"]

    def test_multiple_duplicates_increment(self):
        assert make_columns_unique(["A", "A", "A", "A"]) == ["A", "A_2", "A_3", "A_4"]

    def test_mixed_pattern(self):
        result = make_columns_unique(["X", "Y", "X", "Z", "Y", "X"])
        assert result == ["X", "Y", "X_2", "Z", "Y_2", "X_3"]


class TestNormalizeForretningspartnerValue:
    @pytest.mark.parametrize("value", [None, "", "   "])
    def test_empty_returns_none(self, value):
        assert normalize_forretningspartner_value(value) is None

    @pytest.mark.parametrize("value,expected", [
        ("12345678", "12345678"),
        ("00012345", "00012345"),
        ("12345", "00012345"),
        ("1", "00000001"),
        ("01234567", "01234567"),
    ])
    def test_pads_to_eight_digits(self, value, expected):
        assert normalize_forretningspartner_value(value) == expected

    def test_strips_leading_zeros_then_pads(self):
        # 9-character input → lstrip removes the leading zero → 8 digits
        assert normalize_forretningspartner_value("012345678") == "12345678"

    @pytest.mark.parametrize("value", [
        "123456789",
        "0123456789",
        "9999999999",
    ])
    def test_more_than_eight_significant_digits_raises(self, value):
        with pytest.raises(ValueError, match="mere end 8 cifre"):
            normalize_forretningspartner_value(value)

    @pytest.mark.parametrize("value", ["abc", "12.34", "12-34", "12 34", "1a2"])
    def test_non_digit_raises(self, value):
        with pytest.raises(ValueError, match="ikke-kun cifre"):
            normalize_forretningspartner_value(value)

    def test_strips_whitespace_before_validation(self):
        assert normalize_forretningspartner_value("  12345  ") == "00012345"

    def test_all_zeros_pads_to_eight_zeros(self):
        # Captures current behavior: lstrip + left-pad → "00000000".
        # Docstring claims this becomes "0" — discrepancy left for future cleanup.
        assert normalize_forretningspartner_value("0000") == "00000000"


class TestNormalizeForretningspartnerSeries:
    def test_applies_to_each_value(self):
        s = pd.Series(["12345", "00012345", "1", None])
        result = normalize_forretningspartner_series(s)
        assert list(result) == ["00012345", "00012345", "00000001", None]

    def test_propagates_exception_on_bad_value(self):
        s = pd.Series(["12345", "abc"])
        with pytest.raises(ValueError):
            normalize_forretningspartner_series(s)
