"""
generate_transform_sql.py

Generate SQL scripts for transforming raw tables to typed tables with primary keys.
"""
from pathlib import Path
from sqlalchemy import Integer, Date, DateTime, Numeric, String
from robot_framework.ode_ingest import table_columns
from robot_framework import config


def get_sql_type_string(sa_type) -> str:
    """Convert SQLAlchemy type to SQL Server type string."""
    # Handle both class and instance
    if sa_type is Integer or (hasattr(sa_type, '__class__') and type(sa_type).__name__ == 'Integer'):
        return "INT"
    if sa_type in (Date, DateTime) or (hasattr(sa_type, '__class__') and type(sa_type).__name__ in ('Date', 'DateTime')):
        return "DATE"
    if sa_type is Numeric or (hasattr(sa_type, '__class__') and type(sa_type).__name__ == 'Numeric'):
        # Try to get precision/scale if it's an instance
        if hasattr(sa_type, 'precision') and hasattr(sa_type, 'scale'):
            precision = sa_type.precision or 18
            scale = sa_type.scale or 2
        else:
            precision, scale = 18, 2
        return f"DECIMAL({precision},{scale})"
    if sa_type is String or (hasattr(sa_type, '__class__') and type(sa_type).__name__ == 'String'):
        if hasattr(sa_type, 'length') and sa_type.length:
            return f"NVARCHAR({sa_type.length})"
        return "NVARCHAR(MAX)"
    return "NVARCHAR(MAX)"


def generate_column_conversion(col_name: str, sa_type, source_col: str = None) -> str:
    """Generate SQL conversion expression for a column - inline for performance."""
    if source_col is None:
        source_col = col_name

    # Get type name for comparison
    type_name = sa_type.__name__ if isinstance(sa_type, type) else type(sa_type).__name__

    if type_name == 'Integer':
        return f"""    TRY_CAST(REPLACE([{source_col}], '.', '') AS INT) AS [{col_name}]"""

    if type_name in ('Date', 'DateTime'):
        return f"""    CASE
        WHEN [{source_col}] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
        WHEN LEN([{source_col}]) = 8 AND [{source_col}] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [{source_col}], 112)
        WHEN [{source_col}] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [{source_col}], 104)
        ELSE TRY_CONVERT(DATE, [{source_col}], 23)
    END AS [{col_name}]"""

    if type_name == 'Numeric':
        return f"""    CASE
        WHEN [{source_col}] IS NULL OR [{source_col}] = '' OR [{source_col}] = '0' THEN NULL
        WHEN [{source_col}] LIKE '%-' THEN
            TRY_CAST(REPLACE(REPLACE(LEFT([{source_col}], LEN([{source_col}])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
        ELSE
            TRY_CAST(REPLACE(REPLACE([{source_col}], '.', ''), ',', '.') AS DECIMAL(18,2))
    END AS [{col_name}]"""

    if type_name == 'String':
        return f"""    LTRIM(RTRIM([{source_col}])) AS [{col_name}]"""

    return f"    [{source_col}] AS [{col_name}]"


def generate_create_table_sql(table_name: str, schema_dict: dict,
                              primary_keys: list, schema: str) -> str:
    """Generate CREATE TABLE statement with primary key."""

    columns = []
    for col_name, col_type in schema_dict.items():
        sql_type = get_sql_type_string(col_type)
        # Primary key columns must be NOT NULL
        nullable = "NOT NULL" if primary_keys and col_name in primary_keys else "NULL"
        columns.append(f"    [{col_name}] {sql_type} {nullable}")

    # Add primary key constraint
    pk_constraint = ""
    if primary_keys:
        pk_cols = ', '.join([f'[{pk}]' for pk in primary_keys])
        pk_constraint = f",\n    CONSTRAINT [PK_{table_name}_Typed] PRIMARY KEY CLUSTERED ({pk_cols})"
# TODO: Don't drop table if it already exists, append data instead
    # TODO: Target table name should be configurable, not just Typed (Backup, Typed, Combi)
    return f"""
IF OBJECT_ID('[{schema}].[{table_name}_Typed]', 'U') IS NOT NULL
    DROP TABLE [{schema}].[{table_name}_Typed];

CREATE TABLE [{schema}].[{table_name}_Typed] (
{',\n'.join(columns)}{pk_constraint}
);
"""


def generate_insert_sql(table_name: str, schema_dict: dict,
                        primary_keys: list, schema: str) -> str:
    """Generate INSERT statement with transformations, duplicate handling, and NULL validation."""

    column_names = list(schema_dict.keys())
    conversions = []
    for col_name, col_type in schema_dict.items():
        conversions.append(generate_column_conversion(col_name, col_type))

    columns_clause = ',\n    '.join([f'[{col}]' for col in column_names])

    if primary_keys:
        pk_partition = ', '.join([f'[{pk}]' for pk in primary_keys])
        pk_null_check = ' AND '.join([f'[{pk}] IS NOT NULL' for pk in primary_keys])
# TODO: From table should be staging
        return f"""
-- Report rows with NULL in primary key columns (will be excluded)
SELECT
    'NULL_IN_PRIMARY_KEY' as issue_type,
    '{table_name}' as table_name,
{',\n'.join([f"    [{pk}]" for pk in primary_keys])},
    CASE
{chr(10).join([f"        WHEN [{pk}] IS NULL THEN '{pk}'" for pk in primary_keys])}
    END as null_column
FROM [{schema}].[{table_name}]
WHERE NOT ({pk_null_check});

-- Count of excluded rows
SELECT
    COUNT(*) as rows_with_null_pk,
    {chr(10).join([f"    SUM(CASE WHEN [{pk}] IS NULL THEN 1 ELSE 0 END) as [null_{pk}]," for pk in primary_keys])}
    (SELECT COUNT(*) FROM [{schema}].[{table_name}]) as total_source_rows
FROM [{schema}].[{table_name}];

-- Transform and load data (excluding NULL primary keys and handling duplicates)
WITH source_data AS (
    SELECT
{',\n'.join(conversions)},
        ROW_NUMBER() OVER (PARTITION BY {pk_partition} ORDER BY (SELECT NULL)) as rn
    FROM [{schema}].[{table_name}]
    WHERE {pk_null_check}  -- Exclude rows with NULL in primary key
)
INSERT INTO [{schema}].[{table_name}_Typed] (
    {columns_clause}
)
SELECT
    {',\n    '.join([f'[{col}]' for col in column_names])}
FROM source_data
WHERE rn = 1;  -- Only first occurrence of each key
"""
    else:
        # No primary key - just insert all
        return f"""
-- Transform and load data (no primary key validation needed)
INSERT INTO [{schema}].[{table_name}_Typed] (
    {columns_clause}
)
SELECT
{',\n'.join(conversions)}
FROM [{schema}].[{table_name}];
"""
# TODO: Insert into should not just be Typed, but a configurable target table

def generate_transform_script(table: str, suffix: str, schema_dict: dict,
                              primary_keys: list, output_dir: Path,
                              schema: str) -> Path:
    """Generate complete transformation SQL script with validation reporting."""

    table_name = f"{table}_{suffix}"
    output_file = output_dir / f"transform_{table_name}.sql"

    pk_info = ', '.join(primary_keys) if primary_keys else 'None (will insert all rows)'

    verification_queries = ""
    if primary_keys:
        pk_select = ", '|', ".join([f'[{pk}]' for pk in primary_keys])
        if len(primary_keys) > 1:
            pk_select = f"CONCAT({pk_select})"
# TODO: Rework verification, especially table names
        verification_queries = f"""
-- ============================================================
-- VERIFICATION RESULTS
-- ============================================================

-- Final row counts
SELECT
    'ROW_COUNTS' as metric,
    (SELECT COUNT(*) FROM [{schema}].[{table_name}]) as source_rows,
    (SELECT COUNT(*) FROM [{schema}].[{table_name}_Typed]) as target_rows,
    (SELECT COUNT(*) FROM [{schema}].[{table_name}]) -
    (SELECT COUNT(*) FROM [{schema}].[{table_name}_Typed]) as excluded_rows;

-- Verify unique keys in target
SELECT
    'KEY_UNIQUENESS' as metric,
    COUNT(*) as total_rows,
    COUNT(DISTINCT {pk_select}) as unique_keys,
    COUNT(*) - COUNT(DISTINCT {pk_select}) as should_be_zero
FROM [{schema}].[{table_name}_Typed];

-- Check for any NULLs that shouldn't be there
SELECT
    'NULL_CHECK_IN_TARGET' as metric,
    {',\n'.join([f"    SUM(CASE WHEN [{pk}] IS NULL THEN 1 ELSE 0 END) as [null_{pk}]" for pk in primary_keys])},
    COUNT(*) as total_rows
FROM [{schema}].[{table_name}_Typed];
"""
    else:
        verification_queries = f"""
-- ============================================================
-- VERIFICATION RESULTS
-- ============================================================

-- Row count verification
SELECT
    'ROW_COUNTS' as metric,
    (SELECT COUNT(*) FROM [{schema}].[{table_name}]) as source_rows,
    (SELECT COUNT(*) FROM [{schema}].[{table_name}_Typed]) as target_rows;
"""

    script = f"""
-- ============================================================
-- Transformation script for {table_name}
-- Primary key: {pk_info}
-- Generated automatically - review before executing
-- ============================================================

USE [{config.DB_NAME}];
GO

{generate_create_table_sql(table_name, schema_dict, primary_keys, schema)}
GO

{generate_insert_sql(table_name, schema_dict, primary_keys, schema)}
GO

{verification_queries}
GO

-- Sample of transformed data
SELECT TOP 100 * FROM [{schema}].[{table_name}_Typed]
ORDER BY {', '.join([f'[{pk}]' for pk in primary_keys]) if primary_keys else '(SELECT NULL)'};
GO
"""

    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(script)

    return output_file


def generate_all_transform_scripts(tables: list[str], data_types: dict,
                                   table_keys: dict,
                                   output_dir: Path = Path('sql_transforms')) -> None:
    """Generate SQL transformation scripts for all tables with primary keys."""

    output_dir.mkdir(exist_ok=True)

    summary = []

    for table in tables:
        schema = data_types.get(table)
        keys = table_keys.get(table)

        if not schema:
            print(f"  ⚠ No schema for {table}, skipping")
            continue

        key_info = "No PK" if not keys else f"PK: {', '.join(keys)}"

        for suffix in ["Delta", "Total"]:
            if suffix == "Delta":
                keys = None
            print(f"Generating script for {table}_{suffix}...")
            script_file = generate_transform_script(
                table, suffix, schema, keys or [], output_dir, config.DB_SCHEMA
            )
            print(f"  ✓ {script_file.name}")
            print(f"    {key_info}")

            summary.append({
                'table': f"{table}_{suffix}",
                'has_pk': bool(keys),
                'pk_columns': keys or [],
                'script': script_file.name
            })

    # Generate summary file
    summary_file = output_dir / "00_SUMMARY.txt"
    with open(summary_file, 'w', encoding='utf-8') as f:
        f.write("="*70 + "\n")
        f.write("SQL TRANSFORMATION SCRIPTS SUMMARY\n")
        f.write("="*70 + "\n\n")

        f.write("Tables WITH primary keys (will deduplicate):\n")
        f.write("-"*70 + "\n")
        for item in summary:
            if item['has_pk']:
                f.write(f"{item['table']:<40} PK: {', '.join(item['pk_columns'])}\n")

        f.write("\n\nTables WITHOUT primary keys (will insert all rows):\n")
        f.write("-"*70 + "\n")
        for item in summary:
            if not item['has_pk']:
                f.write(f"{item['table']}\n")

        f.write("\n" + "="*70 + "\n")
        f.write(f"Total: {len(summary)} tables\n")
        f.write("="*70 + "\n")

    print(f"\n✓ All scripts generated in {output_dir}")
    print(f"✓ Summary written to {summary_file}")


if __name__ == "__main__":
    all_tables = list(table_columns.data_types.keys())

    generate_all_transform_scripts(
        all_tables,
        table_columns.data_types,
        table_columns.table_keys,
        output_dir=Path('sql_transforms')
    )

    print("\n" + "="*70)
    print("Next steps:")
    print("  1. Review generated SQL scripts in sql_transforms/")
    print("  2. Check 00_SUMMARY.txt for overview")
    print("  3. Execute scripts using run_sql_transforms.py")
    print("="*70)
