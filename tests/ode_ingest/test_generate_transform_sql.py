"""Unit tests for the SQL transformation generator.

These tests lock in the current behavior of the SQL generator so that the
fixes planned in Fase 2-5 can be applied with regression confidence.
Tests that capture behavior known to change in a future issue are marked
with a comment referencing the relevant fase.
"""
import pytest
from sqlalchemy import Integer, Date, DateTime, Numeric, String

from robot_framework.ode_ingest.generate_transform_sql import (
    generate_backup_insert_sql,
    generate_column_conversion,
    generate_create_table_sql,
    generate_snapshot_merge_sql,
    generate_transform_script_string,
    generate_typed_insert_sql,
    generate_validation_sql,
    get_sql_type_string,
)


class TestGetSqlTypeString:
    @pytest.mark.parametrize("sa_type,expected", [
        (Integer, "INT"),
        (Date, "DATE"),
        (DateTime, "DATE"),
        (String, "NVARCHAR(MAX)"),
    ])
    def test_class_types(self, sa_type, expected):
        assert get_sql_type_string(sa_type) == expected

    def test_date_instance(self):
        assert get_sql_type_string(Date()) == "DATE"

    def test_string_with_length(self):
        assert get_sql_type_string(String(255)) == "NVARCHAR(255)"

    def test_string_without_length(self):
        assert get_sql_type_string(String()) == "NVARCHAR(MAX)"

    def test_numeric_class_default(self):
        assert get_sql_type_string(Numeric) == "DECIMAL(18,2)"

    def test_numeric_with_precision_and_scale(self):
        assert get_sql_type_string(Numeric(precision=15, scale=2)) == "DECIMAL(15,2)"

    def test_unknown_type_falls_back_to_nvarchar_max(self):
        assert get_sql_type_string(object) == "NVARCHAR(MAX)"


class TestGenerateColumnConversion:
    def test_integer_strips_thousand_separator_and_casts(self):
        sql = generate_column_conversion("Antal", Integer)
        assert "TRY_CAST" in sql
        assert "REPLACE([Antal], '.', '')" in sql
        assert "AS INT" in sql

    def test_string_only_trims_no_replace(self):
        # Locks current generic-String behavior. Bilagsnummer-normalisering
        # (REPLACE('.', '')) skal håndteres kolonne-specifikt Python-side i
        # issue Fase 4 (3b) — ikke i den generiske SQL-konvertering.
        sql = generate_column_conversion("Aftalenummer", String(255))
        assert "LTRIM(RTRIM([Aftalenummer]))" in sql
        assert "REPLACE" not in sql

    def test_date_lists_all_null_sentinels(self):
        sql = generate_column_conversion("Bilagsdato", Date)
        assert "'00000000'" in sql
        assert "'00.00.0000'" in sql
        assert "'0000-00-00'" in sql
        assert "THEN NULL" in sql

    def test_date_handles_three_input_formats(self):
        sql = generate_column_conversion("Bilagsdato", Date)
        # YYYYMMDD (style 112), DD.MM.YYYY (style 104), ISO (style 23)
        assert ", 112)" in sql
        assert ", 104)" in sql
        assert ", 23)" in sql

    def test_numeric_handles_trailing_minus(self):
        sql = generate_column_conversion("Beløb", Numeric(precision=15, scale=2))
        assert "LIKE '%-'" in sql
        assert "* -1" in sql

    def test_numeric_handles_danish_decimal_format(self):
        sql = generate_column_conversion("Beløb", Numeric(precision=15, scale=2))
        # Strip thousand-separator dots, then convert comma decimal to dot
        assert "REPLACE([Beløb], '.', '')" in sql
        assert "DECIMAL(18,2)" in sql

    def test_source_col_defaults_to_col_name(self):
        sql = generate_column_conversion("MyCol", String)
        assert "[MyCol]" in sql

    def test_source_col_overrides_col_name(self):
        sql = generate_column_conversion("TargetCol", String, source_col="SourceCol")
        assert "[SourceCol]" in sql
        assert "AS [TargetCol]" in sql

    def test_unknown_type_passes_through_unchanged(self):
        sql = generate_column_conversion("UnknownCol", object)
        assert "[UnknownCol] AS [UnknownCol]" in sql


class TestGenerateCreateTableSql:
    SCHEMA = {"Col1": Integer, "Col2": String(50), "Col3": Date}

    def test_backup_uses_nvarchar_max_for_all_columns(self):
        sql = generate_create_table_sql(
            "Tbl_Backup", self.SCHEMA,
            primary_keys=["Col1"], schema="ode", table_type="backup"
        )
        assert "[Col1] NVARCHAR(MAX) NULL" in sql
        assert "[Col2] NVARCHAR(MAX) NULL" in sql
        assert "[Col3] NVARCHAR(MAX) NULL" in sql
        assert "PRIMARY KEY" not in sql

    def test_typed_uses_proper_types_all_nullable(self):
        sql = generate_create_table_sql(
            "Tbl_Typed", self.SCHEMA,
            primary_keys=["Col1"], schema="ode", table_type="typed"
        )
        assert "[Col1] INT NULL" in sql
        assert "[Col2] NVARCHAR(50) NULL" in sql
        assert "[Col3] DATE NULL" in sql
        assert "PRIMARY KEY" not in sql

    def test_snapshot_with_pk_constrains_columns_and_adds_constraint(self):
        sql = generate_create_table_sql(
            "Tbl", self.SCHEMA,
            primary_keys=["Col1", "Col2"], schema="ode", table_type="snapshot"
        )
        assert "[Col1] INT NOT NULL" in sql
        assert "[Col2] NVARCHAR(50) NOT NULL" in sql
        assert "[Col3] DATE NULL" in sql  # non-PK stays nullable
        assert "CONSTRAINT [PK_Tbl] PRIMARY KEY CLUSTERED ([Col1], [Col2])" in sql

    def test_snapshot_without_pk_adds_no_constraint(self):
        sql = generate_create_table_sql(
            "Tbl", {"Col1": Integer},
            primary_keys=[], schema="ode", table_type="snapshot"
        )
        assert "[Col1] INT NULL" in sql
        assert "PRIMARY KEY" not in sql

    def test_wraps_in_if_object_id_check(self):
        # Issue Fase 5 (4c): IF OBJECT_ID … IS NULL propagerer ikke kolonne-
        # tilføjelser til eksisterende tabeller — schema drift.
        sql = generate_create_table_sql(
            "Tbl", {"Col1": Integer},
            primary_keys=["Col1"], schema="ode", table_type="snapshot"
        )
        assert "IF OBJECT_ID('[ode].[Tbl]', 'U') IS NULL" in sql
        assert "CREATE TABLE [ode].[Tbl]" in sql


class TestGenerateBackupInsertSql:
    def test_inserts_columns_as_is(self):
        sql = generate_backup_insert_sql(
            "Src_Staging", "Src_Backup",
            {"A": Integer, "B": String}, schema="ode"
        )
        assert "INSERT INTO [ode].[Src_Backup]" in sql
        assert "FROM [ode].[Src_Staging]" in sql
        assert "[A]" in sql
        assert "[B]" in sql


class TestGenerateTypedInsertSql:
    def test_with_pk_dedups_within_batch_and_filters_null_pk(self):
        sql = generate_typed_insert_sql(
            "Tbl_Staging", "Tbl_Typed",
            {"PK1": Integer, "PK2": String(50), "Data": String(255)},
            primary_keys=["PK1", "PK2"], schema="ode"
        )
        assert "ROW_NUMBER() OVER (PARTITION BY [PK1], [PK2]" in sql
        # Issue Fase 4 (3a): nondeterministisk dedup. Tiebreaker mangler.
        assert "ORDER BY (SELECT NULL)" in sql
        assert "[PK1] IS NOT NULL" in sql
        assert "[PK2] IS NOT NULL" in sql
        assert "WHERE rn = 1" in sql

    def test_without_pk_simple_insert(self):
        sql = generate_typed_insert_sql(
            "Tbl_Staging", "Tbl_Typed",
            {"Data": String(255)},
            primary_keys=[], schema="ode"
        )
        assert "ROW_NUMBER" not in sql
        assert "INSERT INTO [ode].[Tbl_Typed]" in sql


class TestGenerateSnapshotMergeSql:
    SCHEMA_WITH_PK = {"PK": Integer, "Data": String(255)}
    SCHEMA_NO_PK = {"Data": String(255)}

    def test_total_with_pk_inserts_without_truncate(self):
        # LOCKS CURRENT BEHAVIOR — issue Fase 2: Total mangler TRUNCATE.
        # Dette er årsagen til 12x oppustning i Bilag-aaben. Når Fase 2
        # implementeres, skal denne assertion ændres til at kræve TRUNCATE.
        sql = generate_snapshot_merge_sql(
            source_table="Tbl_Staging", target_table="Tbl",
            schema_dict=self.SCHEMA_WITH_PK,
            primary_keys=["PK"], schema="ode", is_delta=False
        )
        assert "INSERT INTO [ode].[Tbl]" in sql
        assert "TRUNCATE" not in sql

    def test_delta_with_pk_uses_merge_upsert(self):
        sql = generate_snapshot_merge_sql(
            source_table="Tbl_Staging", target_table="Tbl",
            schema_dict=self.SCHEMA_WITH_PK,
            primary_keys=["PK"], schema="ode", is_delta=True
        )
        assert "MERGE INTO [ode].[Tbl]" in sql
        assert "WHEN MATCHED THEN" in sql
        assert "UPDATE SET" in sql
        assert "WHEN NOT MATCHED THEN" in sql

    def test_total_without_pk_appends_without_truncate(self):
        # Issue Fase 2 — samme rod-årsag som test_total_with_pk_inserts_without_truncate.
        sql = generate_snapshot_merge_sql(
            source_table="Tbl_Staging", target_table="Tbl",
            schema_dict=self.SCHEMA_NO_PK,
            primary_keys=[], schema="ode", is_delta=False
        )
        assert "INSERT INTO [ode].[Tbl]" in sql
        assert "TRUNCATE" not in sql
        assert "MERGE" not in sql

    def test_delta_without_pk_appends(self):
        sql = generate_snapshot_merge_sql(
            source_table="Tbl_Staging", target_table="Tbl",
            schema_dict=self.SCHEMA_NO_PK,
            primary_keys=[], schema="ode", is_delta=True
        )
        assert "INSERT INTO [ode].[Tbl]" in sql
        assert "MERGE" not in sql

    def test_with_pk_dedups_within_batch(self):
        sql = generate_snapshot_merge_sql(
            source_table="Tbl_Staging", target_table="Tbl",
            schema_dict=self.SCHEMA_WITH_PK,
            primary_keys=["PK"], schema="ode", is_delta=True
        )
        assert "ROW_NUMBER() OVER" in sql
        # Issue Fase 4 (3a) — samme nondeterminisme som typed insert
        assert "ORDER BY (SELECT NULL)" in sql


class TestGenerateValidationSql:
    def test_produces_row_count_metric(self):
        sql = generate_validation_sql("Tbl_Staging", "Tbl", "ode")
        assert "ROW_COUNTS" in sql
        assert "COUNT(*) FROM [ode].[Tbl_Staging]" in sql
        assert "COUNT(*) FROM [ode].[Tbl]" in sql
        assert "source_rows" in sql
        assert "target_rows" in sql


class TestGenerateTransformScriptString:
    SCHEMA = {"PK": Integer, "Data": String(255)}

    def test_full_script_contains_all_phases(self):
        sql = generate_transform_script_string(
            table="MyTbl", suffix="Delta",
            schema_dict=self.SCHEMA,
            primary_keys=["PK"], schema="ode"
        )
        assert "USE [" in sql
        assert "MyTbl_Delta_Backup" in sql
        assert "MyTbl_Delta_Typed" in sql
        assert "1. BACKUP" in sql
        assert "2. TYPED" in sql
        assert "3. SNAPSHOT" in sql
        assert "ROW_COUNTS" in sql
        assert "DROP TABLE [ode].[MyTbl_Delta_Staging]" in sql

    def test_total_suffix_uses_insert_path(self):
        sql = generate_transform_script_string(
            table="MyTbl", suffix="Total",
            schema_dict=self.SCHEMA,
            primary_keys=["PK"], schema="ode"
        )
        # is_delta=False path → INSERT, no MERGE
        assert "MERGE INTO" not in sql
        # Issue Fase 2 — TRUNCATE mangler stadig
        assert "TRUNCATE" not in sql

    def test_delta_suffix_uses_merge_path(self):
        sql = generate_transform_script_string(
            table="MyTbl", suffix="Delta",
            schema_dict=self.SCHEMA,
            primary_keys=["PK"], schema="ode"
        )
        assert "MERGE INTO [ode].[MyTbl]" in sql
