"""
generate_transform_sql.py

Generate SQL scripts for transforming raw tables to typed tables.
"""
from pathlib import Path
from sqlalchemy import Integer, Date, DateTime, Numeric, String
from robot_framework.ode_ingest import table_columns
from robot_framework import config


def get_sql_type_string(sa_type) -> str:
    """Convert SQLAlchemy type to SQL Server type string."""
    if sa_type is Integer:
        return "INT"
    if sa_type is Date:
        return "DATE"
    if sa_type is DateTime:
        return "DATETIME2"
    if isinstance(sa_type, Numeric):
        precision = getattr(sa_type, 'precision', 18)
        scale = getattr(sa_type, 'scale', 2)
        return f"DECIMAL({precision},{scale})"
    if isinstance(sa_type, String):
        length = getattr(sa_type, 'length', 'MAX')
        return f"NVARCHAR({length})"
    return "NVARCHAR(MAX)"


def generate_column_conversion(col_name: str, sa_type, source_col: str = None) -> str:
    """Generate SQL conversion expression for a column - inline for performance."""
    if source_col is None:
        source_col = col_name

    if sa_type is Integer:
        return f"""    TRY_CAST(REPLACE([{source_col}], '.', '') AS INT) AS [{col_name}]"""

    if sa_type in (Date, DateTime):
        return f"""    CASE 
        WHEN [{source_col}] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
        WHEN LEN([{source_col}]) = 8 AND [{source_col}] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [{source_col}], 112)
        WHEN [{source_col}] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [{source_col}], 104)
        ELSE TRY_CONVERT(DATE, [{source_col}], 23)
    END AS [{col_name}]"""

    if isinstance(sa_type, Numeric):
        return f"""    CASE 
        WHEN [{source_col}] IS NULL OR [{source_col}] = '' OR [{source_col}] = '0' THEN NULL
        WHEN [{source_col}] LIKE '%-' THEN 
            TRY_CAST(REPLACE(REPLACE(LEFT([{source_col}], LEN([{source_col}])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
        ELSE 
            TRY_CAST(REPLACE(REPLACE([{source_col}], '.', ''), ',', '.') AS DECIMAL(18,2))
    END AS [{col_name}]"""

    if isinstance(sa_type, String):
        return f"""    LTRIM(RTRIM([{source_col}])) AS [{col_name}]"""

    return f"    [{source_col}] AS [{col_name}]"


def generate_create_table_sql(table_name: str, schema_dict: dict, schema: str) -> str:
    """Generate CREATE TABLE statement."""

    columns = []
    for col_name, col_type in schema_dict.items():
        sql_type = get_sql_type_string(col_type)
        columns.append(f"    [{col_name}] {sql_type} NULL")

    return f"""
-- Create typed table for {table_name}
IF OBJECT_ID('[{schema}].[{table_name}_Typed]', 'U') IS NOT NULL
    DROP TABLE [{schema}].[{table_name}_Typed];

CREATE TABLE [{schema}].[{table_name}_Typed] (
{',\n'.join(columns)}
);
"""


def generate_insert_sql(table_name: str, schema_dict: dict, schema: str) -> str:
    """Generate INSERT statement with transformations."""

    conversions = []
    for col_name, col_type in schema_dict.items():
        conversions.append(generate_column_conversion(col_name, col_type))

    return f"""
-- Transform and load data
INSERT INTO [{schema}].[{table_name}_Typed]
SELECT
{',\n'.join(conversions)}
FROM [{schema}].[{table_name}];
"""


def generate_transform_script(table: str, suffix: str, schema_dict: dict,
                              output_dir: Path, schema: str) -> Path:
    """Generate complete transformation SQL script for a table."""

    table_name = f"{table}_{suffix}"
    output_file = output_dir / f"transform_{table_name}.sql"

    script = f"""
-- ============================================================
-- Transformation script for {table_name}
-- Generated automatically - review before executing
-- ============================================================

USE [{config.DB_NAME}];
GO

{generate_create_table_sql(table_name, schema_dict, schema)}

{generate_insert_sql(table_name, schema_dict, schema)}

-- Verify results
SELECT
    COUNT(*) as total_rows,
    COUNT(*) - COUNT([{list(schema_dict.keys())[0]}]) as first_col_nulls
FROM [{schema}].[{table_name}_Typed];

SELECT TOP 100 * FROM [{schema}].[{table_name}_Typed];
"""

    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(script)

    return output_file


def generate_helper_functions(output_dir: Path) -> Path:
    """Generate helper functions SQL script."""

    output_file = output_dir / "00_helper_functions.sql"

    script = f"""
-- ============================================================
-- Helper functions for data transformation
-- Run this FIRST before running table-specific scripts
-- ============================================================

USE [{config.DB_NAME}];
GO

-- Drop existing functions if they exist
IF OBJECT_ID('dbo.ConvertDanishDecimal', 'FN') IS NOT NULL
    DROP FUNCTION dbo.ConvertDanishDecimal;
GO

IF OBJECT_ID('dbo.ConvertFlexibleDate', 'FN') IS NOT NULL
    DROP FUNCTION dbo.ConvertFlexibleDate;
GO

-- Convert Danish decimal format with trailing minus
CREATE FUNCTION dbo.ConvertDanishDecimal(@value NVARCHAR(255))
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @result DECIMAL(18,2);
    DECLARE @cleaned NVARCHAR(255);

    -- Handle null/empty/zero variants
    IF @value IS NULL OR @value = '' OR @value = '0' OR LTRIM(RTRIM(@value)) = ''
        RETURN NULL;

    SET @value = LTRIM(RTRIM(@value));

    -- Handle trailing minus
    IF RIGHT(@value, 1) = '-'
    BEGIN
        SET @cleaned = REPLACE(REPLACE(LEFT(@value, LEN(@value)-1), '.', ''), ',', '.');
        SET @result = TRY_CAST(@cleaned AS DECIMAL(18,2)) * -1;
    END
    ELSE
    BEGIN
        SET @cleaned = REPLACE(REPLACE(@value, '.', ''), ',', '.');
        SET @result = TRY_CAST(@cleaned AS DECIMAL(18,2));
    END

    RETURN @result;
END;
GO

-- Convert flexible date formats
CREATE FUNCTION dbo.ConvertFlexibleDate(@value NVARCHAR(255))
RETURNS DATE
AS
BEGIN
    DECLARE @result DATE;

    -- Handle null/empty/invalid date variants
    IF @value IS NULL OR @value = ''
        OR @value IN ('00000000', '00.00.0000', '0000-00-00', '0')
        OR LTRIM(RTRIM(@value)) = ''
        RETURN NULL;

    SET @value = LTRIM(RTRIM(@value));

    -- Try YYYYMMDD (format 112)
    IF LEN(@value) = 8 AND @value NOT LIKE '%[^0-9]%'
    BEGIN
        SET @result = TRY_CONVERT(DATE, @value, 112);
        IF @result IS NOT NULL RETURN @result;
    END

    -- Try DD.MM.YYYY or DD/MM/YYYY (format 104)
    IF @value LIKE '__[./]__[./]____'
    BEGIN
        SET @result = TRY_CONVERT(DATE, @value, 104);
        IF @result IS NOT NULL RETURN @result;
    END

    -- Try YYYY-MM-DD (format 23 - ISO)
    SET @result = TRY_CONVERT(DATE, @value, 23);
    IF @result IS NOT NULL RETURN @result;

    -- If nothing worked, return NULL
    RETURN NULL;
END;
GO

PRINT 'Helper functions created successfully';
GO
"""

    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(script)

    return output_file


def generate_all_transform_scripts(tables: list[str], data_types: dict,
                                   output_dir: Path = Path('sql_transforms')) -> None:
    """Generate SQL transformation scripts for all tables."""

    output_dir.mkdir(exist_ok=True)

    # Generate helper functions first
    print("Generating helper functions...")
    helper_file = generate_helper_functions(output_dir)
    print(f"  ✓ {helper_file}")

    # Generate table-specific scripts
    for table in tables:
        schema = data_types.get(table)
        if not schema:
            print(f"  ⚠ No schema for {table}, skipping")
            continue

        for suffix in ["Total"]:  # Add "Delta" later
            print(f"Generating script for {table}_{suffix}...")
            script_file = generate_transform_script(
                table, suffix, schema, output_dir, config.DB_SCHEMA
            )
            print(f"  ✓ {script_file}")

    print(f"\n✓ All scripts generated in {output_dir}")
    print("\nExecution order:")
    print(f"  1. Run: {helper_file.name}")
    print("  2. Run table scripts in any order")


if __name__ == "__main__":
    all_tables = list(table_columns.data_types.keys())

    generate_all_transform_scripts(
        all_tables,
        table_columns.data_types,
        output_dir=Path('sql_transforms')
    )

    print("\n" + "="*60)
    print("Next steps:")
    print("  1. Review generated SQL scripts")
    print("  2. Update database name in scripts")
    print("  3. Execute 00_helper_functions.sql first")
    print("  4. Execute individual table scripts")
    print("="*60)
