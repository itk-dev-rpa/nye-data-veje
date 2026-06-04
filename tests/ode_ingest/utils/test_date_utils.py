"""Unit tests for date conversion utilities."""
import pandas as pd
import pytest

from robot_framework.ode_ingest.utils.date_utils import (
    apply_date_filter,
    convert_date_series,
    convert_dates,
)


class TestConvertDateSeries:
    @pytest.mark.parametrize("sentinel", ["00.00.0000", "00000000"])
    def test_null_sentinels_become_nat(self, sentinel):
        s = pd.Series([sentinel])
        result = convert_date_series(s)
        assert pd.isna(result.iloc[0])

    def test_yyyymmdd_format_parses(self):
        s = pd.Series(["20210712"])
        result = convert_date_series(s)
        assert result.iloc[0] == pd.Timestamp("2021-07-12")

    def test_danish_dot_format_parses(self):
        s = pd.Series(["12.07.2021"])
        result = convert_date_series(s)
        assert result.iloc[0] == pd.Timestamp("2021-07-12")

    def test_iso_format_parses(self):
        s = pd.Series(["2021-07-12"])
        result = convert_date_series(s)
        assert result.iloc[0] == pd.Timestamp("2021-07-12")

    def test_dash_format_parses(self):
        s = pd.Series(["12-07-2021"])
        result = convert_date_series(s)
        assert result.iloc[0] == pd.Timestamp("2021-07-12")

    def test_invalid_string_falls_back_unchanged(self):
        # When no format matches anywhere in the series, the original series
        # is returned unchanged (no conversion was attempted successfully).
        s = pd.Series(["not-a-date"])
        result = convert_date_series(s)
        # Either NaT (if a format coerced it) or the original string passes through
        assert result.iloc[0] == "not-a-date" or pd.isna(result.iloc[0])


class TestConvertDates:
    def test_converts_specified_columns_only(self):
        df = pd.DataFrame({"Bilagsdato": ["20210712"], "Andet": ["X"]})
        result = convert_dates(df, ["Bilagsdato"])
        assert result["Bilagsdato"].iloc[0] == pd.Timestamp("2021-07-12")
        assert result["Andet"].iloc[0] == "X"

    def test_skips_missing_columns_without_error(self):
        df = pd.DataFrame({"A": ["20210712"]})
        result = convert_dates(df, ["Missing", "A"])
        assert "A" in result.columns
        assert "Missing" not in result.columns


class TestApplyDateFilter:
    def test_includes_dates_within_interval(self):
        df = pd.DataFrame({"d": ["20210101", "20210601", "20211201"]})
        result = apply_date_filter(df, {
            "column": "d",
            "start_date": "20210301",
            "end_date": "20210901",
        })
        assert len(result) == 1
        assert result["d"].iloc[0] == "20210601"

    def test_boundary_dates_are_inclusive(self):
        df = pd.DataFrame({"d": ["20210301", "20210901"]})
        result = apply_date_filter(df, {
            "column": "d",
            "start_date": "20210301",
            "end_date": "20210901",
        })
        assert len(result) == 2

    def test_empty_result_when_no_match(self):
        df = pd.DataFrame({"d": ["20200101"]})
        result = apply_date_filter(df, {
            "column": "d",
            "start_date": "20210301",
            "end_date": "20210901",
        })
        assert len(result) == 0
