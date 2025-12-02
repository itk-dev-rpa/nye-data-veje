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
    # Keep existing implementation unchanged
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


def generate_create_table_sql(target_table: str, schema_dict: dict,
                              primary_keys: list, schema: str,
                              drop_if_exists: bool = True) -> str:
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
        pk_constraint = f",\n    CONSTRAINT [PK_{target_table}] PRIMARY KEY CLUSTERED ({pk_cols})"

    drop_statement = ""
    if drop_if_exists:
        drop_statement = f"""IF OBJECT_ID('[{schema}].[{target_table}]', 'U') IS NOT NULL
    DROP TABLE [{schema}].[{target_table}];

"""

    return f"""{drop_statement}CREATE TABLE [{schema}].[{target_table}] (
{',\n'.join(columns)}{pk_constraint}
);
"""


def generate_insert_sql(source_table: str, target_table: str, schema_dict: dict,
                        primary_keys: list, schema: str,
                        apply_transformations: bool = True,
                        merge_mode: bool = False) -> str:
    """
    Generate INSERT or MERGE statement with optional transformations.

    Args:
        source_table: Source table name
        target_table: Target table name
        schema_dict: Column definitions
        primary_keys: List of primary key columns
        schema: Database schema
        apply_transformations: If True, apply type conversions (for Typed). If False, copy raw (for Backup)
        merge_mode: If True, use MERGE for upsert. If False, use INSERT
    """

    column_names = list(schema_dict.keys())

    if apply_transformations:
        # Apply transformations for Typed database
        conversions = []
        for col_name, col_type in schema_dict.items():
            conversions.append(generate_column_conversion(col_name, col_type))
    else:
        # Raw copy for Backup database
        conversions = [f"    [{col}]" for col in column_names]

    columns_clause = ',\n    '.join([f'[{col}]' for col in column_names])

    if merge_mode and primary_keys:
        # MERGE mode for Combi database (upsert)
        return _generate_merge_sql(source_table, target_table, column_names,
                                   primary_keys, schema, conversions)

    elif primary_keys and apply_transformations:
        # INSERT with deduplication for Typed database
        pk_partition = ', '.join([f'[{pk}]' for pk in primary_keys])
        pk_null_check = ' AND '.join([f'[{pk}] IS NOT NULL' for pk in primary_keys])

        return f"""
-- Report rows with NULL in primary key columns (will be excluded)
SELECT
    'NULL_IN_PRIMARY_KEY' as issue_type,
    '{target_table}' as table_name,
{',\n'.join([f"    [{pk}]" for pk in primary_keys])},
    CASE
{chr(10).join([f"        WHEN [{pk}] IS NULL THEN '{pk}'" for pk in primary_keys])}
    END as null_column
FROM [{schema}].[{source_table}]
WHERE NOT ({pk_null_check});

-- Count of excluded rows
SELECT
    COUNT(*) as rows_with_null_pk,
    {chr(10).join([f"    SUM(CASE WHEN [{pk}] IS NULL THEN 1 ELSE 0 END) as [null_{pk}]," for pk in primary_keys])}
    (SELECT COUNT(*) FROM [{schema}].[{source_table}]) as total_source_rows
FROM [{schema}].[{source_table}];

-- Transform and load data (excluding NULL primary keys and handling duplicates)
WITH source_data AS (
    SELECT
{',\n'.join(conversions)},
        ROW_NUMBER() OVER (PARTITION BY {pk_partition} ORDER BY (SELECT NULL)) as rn
    FROM [{schema}].[{source_table}]
    WHERE {pk_null_check}  -- Exclude rows with NULL in primary key
)
INSERT INTO [{schema}].[{target_table}] (
    {columns_clause}
)
SELECT
    {',\n    '.join([f'[{col}]' for col in column_names])}
FROM source_data
WHERE rn = 1;  -- Only first occurrence of each key
"""
    else:
        # Simple INSERT (for Backup or tables without primary keys)
        return f"""
-- {'Transform and load data' if apply_transformations else 'Copy raw data'}
INSERT INTO [{schema}].[{target_table}] (
    {columns_clause}
)
SELECT
{',\n'.join(conversions)}
FROM [{schema}].[{source_table}];
"""


def _generate_merge_sql(source_table: str, target_table: str, column_names: list,
                        primary_keys: list, schema: str, conversions: list) -> str:
    """Generate MERGE statement for upsert operations."""

    pk_join = ' AND '.join([f'target.[{pk}] = source.[{pk}]' for pk in primary_keys])
    update_cols = ', '.join([f'target.[{col}] = source.[{col}]'
                             for col in column_names if col not in primary_keys])
    columns_clause = ', '.join([f'[{col}]' for col in column_names])
    values_clause = ', '.join([f'source.[{col}]' for col in column_names])

    return f"""
-- Merge data into {target_table}
MERGE INTO [{schema}].[{target_table}] AS target
USING (
    SELECT
{',\n'.join(conversions)}
    FROM [{schema}].[{source_table}]
) AS source
ON {pk_join}
WHEN MATCHED THEN
    UPDATE SET {update_cols}
WHEN NOT MATCHED THEN
    INSERT ({columns_clause})
    VALUES ({values_clause});
"""


def generate_transform_script_v2(
        base_table: str,
        data_subset: str,  # "Delta" or "Total"
        schema_dict: dict,
        primary_keys: list,
        source_db_type: str,  # "Staging", "Backup", "Typed"
        target_db_type: str,  # "Backup", "Typed", "Combi"
        output_dir: Path,
        schema: str
) -> Path:
    """
    Generate transformation SQL script with configurable source and target databases.

    Args:
        base_table: Base table name (e.g., "Aftaleindhold")
        data_subset: "Delta" or "Total"
        schema_dict: Column type definitions
        primary_keys: List of primary key columns
        source_db_type: Source database type
        target_db_type: Target database type
        output_dir: Directory to write SQL scripts
        schema: Database schema name
    """

    # Construct table names
    source_table = f"{base_table}_{data_subset}"
    if source_db_type != "Staging":
        source_table += f"_{source_db_type}"

    target_table = f"{base_table}_{data_subset}_{target_db_type}"

    output_file = output_dir / f"transform_{source_table}_to_{target_table}.sql"

    pk_info = ', '.join(primary_keys) if primary_keys else 'None'

    # Determine transformation mode
    apply_transformations = target_db_type in ["Typed", "Combi"]
    merge_mode = target_db_type == "Combi"
    drop_if_exists = target_db_type != "Combi"  # Don't drop Combi, we merge into it

    # Generate verification queries
    verification_queries = _generate_verification_sql(
        source_table, target_table, primary_keys, schema, target_db_type
    )

    script = f"""
-- ============================================================
-- Transformation: {source_table} → {target_table}
-- Type: {source_db_type} to {target_db_type}
-- Primary key: {pk_info}
-- Mode: {'MERGE (upsert)' if merge_mode else 'INSERT'}
-- Generated automatically - review before executing
-- ============================================================

USE [{config.DB_NAME}];
GO

{generate_create_table_sql(target_table, schema_dict, primary_keys, schema, drop_if_exists)}
GO

{generate_insert_sql(source_table, target_table, schema_dict, primary_keys, schema, apply_transformations, merge_mode)}
GO

{verification_queries}
GO
"""

    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(script)

    return output_file


def _generate_verification_sql(source_table: str, target_table: str,
                               primary_keys: list, schema: str,
                               target_db_type: str) -> str:
    """Generate verification queries appropriate for the target database type."""

    if not primary_keys:
        return f"""
-- ============================================================
-- VERIFICATION RESULTS
-- ============================================================

-- Row count verification
SELECT
    'ROW_COUNTS' as metric,
    (SELECT COUNT(*) FROM [{schema}].[{source_table}]) as source_rows,
    (SELECT COUNT(*) FROM [{schema}].[{target_table}]) as target_rows;
"""

    pk_select = ", '|', ".join([f'[{pk}]' for pk in primary_keys])
    if len(primary_keys) > 1:
        pk_select = f"CONCAT({pk_select})"

    return f"""
-- ============================================================
-- VERIFICATION RESULTS
-- ============================================================

-- Final row counts
SELECT
    'ROW_COUNTS' as metric,
    (SELECT COUNT(*) FROM [{schema}].[{source_table}]) as source_rows,
    (SELECT COUNT(*) FROM [{schema}].[{target_table}]) as target_rows,
    (SELECT COUNT(*) FROM [{schema}].[{source_table}]) -
    (SELECT COUNT(*) FROM [{schema}].[{target_table}]) as excluded_rows;

-- Verify unique keys in target
SELECT
    'KEY_UNIQUENESS' as metric,
    COUNT(*) as total_rows,
    COUNT(DISTINCT {pk_select}) as unique_keys,
    COUNT(*) - COUNT(DISTINCT {pk_select}) as should_be_zero
FROM [{schema}].[{target_table}];

-- Check for any NULLs in primary keys
SELECT
    'NULL_CHECK_IN_TARGET' as metric,
    {',\n    '.join([f"SUM(CASE WHEN [{pk}] IS NULL THEN 1 ELSE 0 END) as [null_{pk}]" for pk in primary_keys])},
    COUNT(*) as total_rows
FROM [{schema}].[{target_table}];

-- Sample of transformed data
SELECT TOP 100 * FROM [{schema}].[{target_table}]
ORDER BY {', '.join([f'[{pk}]' for pk in primary_keys])};
"""


def generate_pipeline_scripts(
        tables: list[str],
        data_types: dict,
        table_keys: dict,
        pipeline_steps: list[tuple[str, str, str]],  # [(source_db, target_db, data_subset)]
        output_dir: Path = Path('sql_transforms')
) -> None:
    """
    Generate SQL transformation scripts for a complete pipeline.

    Args:
        tables: List of table names
        data_types: Dictionary of table schemas
        table_keys: Dictionary of primary keys
        pipeline_steps: List of (source_db_type, target_db_type, data_subset) tuples
        output_dir: Output directory for scripts
    """

    output_dir.mkdir(exist_ok=True)

    summary = []

    for table in tables:
        schema = data_types.get(table)
        keys = table_keys.get(table, [])

        if not schema:
            print(f"  ⚠ No schema for {table}, skipping")
            continue

        for source_db, target_db, data_subset in pipeline_steps:
            print(f"Generating script: {table}_{data_subset} ({source_db} → {target_db})...")

            script_file = generate_transform_script_v2(
                table, data_subset, schema, keys,
                source_db, target_db, output_dir, config.DB_SCHEMA
            )

            print(f"  ✓ {script_file.name}")

            summary.append({
                'table': table,
                'data_subset': data_subset,
                'source': source_db,
                'target': target_db,
                'has_pk': bool(keys),
                'pk_columns': keys,
                'script': script_file.name
            })

    # Generate summary file
    _write_summary_file(summary, output_dir)

    print(f"\n✓ All scripts generated in {output_dir}")


def _write_summary_file(summary: list[dict], output_dir: Path):
    """Write summary of generated scripts."""
    summary_file = output_dir / "00_SUMMARY.txt"

    with open(summary_file, 'w', encoding='utf-8') as f:
        f.write("=" * 70 + "\n")
        f.write("SQL TRANSFORMATION SCRIPTS SUMMARY\n")
        f.write("=" * 70 + "\n\n")

        # Group by pipeline step
        from collections import defaultdict
        by_step = defaultdict(list)

        for item in summary:
            step_key = f"{item['source']} → {item['target']} ({item['data_subset']})"
            by_step[step_key].append(item)

        for step_name, items in by_step.items():
            f.write(f"\n{step_name}\n")
            f.write("-" * 70 + "\n")
            for item in items:
                pk_info = f"PK: {', '.join(item['pk_columns'])}" if item['has_pk'] else "No PK"
                f.write(f"{item['table']:<30} {pk_info}\n")

        f.write("\n" + "=" * 70 + "\n")
        f.write(f"Total scripts: {len(summary)}\n")
        f.write("=" * 70 + "\n")

    print(f"✓ Summary written to {summary_file}")


if __name__ == "__main__":
    all_tables = list(table_columns.data_types.keys())

    # Example: Generate scripts for Delta pipeline
    # Staging → Backup, Staging → Typed, Typed → Combi
    delta_pipeline_steps = [
        ("Staging", "Backup", "Delta"),
        ("Staging", "Typed", "Delta"),
        ("Staging", "Combi", "Delta"),
    ]

    # Example: Generate scripts for Total pipeline
    # Staging → Backup, Staging → Typed
    total_pipeline_steps = [
        ("Staging", "Backup", "Total"),
        ("Staging", "Typed", "Total"),
        ("Staging", "Combi", "Total"),
    ]

    print("Generating Delta pipeline scripts...")
    generate_pipeline_scripts(
        all_tables,
        table_columns.data_types,
        table_columns.table_keys,
        delta_pipeline_steps,
        output_dir=Path('sql_transforms/delta')
    )

    print("\nGenerating Total pipeline scripts...")
    generate_pipeline_scripts(
        all_tables,
        table_columns.data_types,
        table_columns.table_keys,
        total_pipeline_steps,
        output_dir=Path('sql_transforms/total')
    )

    print("\n" + "=" * 70)
    print("Next steps:")
    print("  1. Review generated SQL scripts in sql_transforms/")
    print("  2. Check 00_SUMMARY.txt files for overview")
    print("  3. Execute scripts using updated run_sql_transforms.py")
    print("=" * 70)