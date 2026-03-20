"""
generate_transform_sql.py

Generate SQL scripts for transforming raw tables through the pipeline:
Staging -> Backup (Raw) -> Typed (History) -> Snapshot (Current State)
"""
from pathlib import Path
from sqlalchemy import Integer, Date, DateTime, Numeric, String
from robot_framework.ode_ingest import table_definitions as table_columns
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
                              primary_keys: list, schema: str,
                              table_type: str = "typed") -> str:
    """
    Generate CREATE TABLE statement.
    table_type: 'backup' (all NVARCHAR), 'typed' (Correct types), 'snapshot' (Correct types + PK)
    """
    columns = []
    for col_name, col_type in schema_dict.items():
        if table_type == "backup":
            sql_type = "NVARCHAR(MAX)"
            nullable = "NULL"
        else:
            sql_type = get_sql_type_string(col_type)
            # Primary key columns must be NOT NULL only for Snapshot
            if table_type == "snapshot" and primary_keys and col_name in primary_keys:
                nullable = "NOT NULL"
            else:
                nullable = "NULL"

        columns.append(f"    [{col_name}] {sql_type} {nullable}")

    # Add primary key constraint only for Snapshot
    pk_constraint = ""
    if table_type == "snapshot" and primary_keys:
        pk_cols = ', '.join([f'[{pk}]' for pk in primary_keys])
        pk_constraint = f",\n    CONSTRAINT [PK_{table_name}] PRIMARY KEY CLUSTERED ({pk_cols})"

    # Use IF NOT EXISTS to allow appending to existing Backup/Typed tables
    return f"""
    IF OBJECT_ID('[{schema}].[{table_name}]', 'U') IS NULL
    BEGIN
        CREATE TABLE [{schema}].[{table_name}] (
    {',\n'.join(columns)}{pk_constraint}
        );
    END
    """


def generate_backup_insert_sql(source_table: str, target_table: str,
                               schema_dict: dict, schema: str) -> str:
    """Generate INSERT for Backup (Raw Copy)."""
    column_names = list(schema_dict.keys())
    columns_clause = ',\n    '.join([f'[{col}]' for col in column_names])

    # Just select columns as-is, assuming they exist in staging
    select_clause = ',\n    '.join([f'[{col}]' for col in column_names])

    return f"""
    -- 1. BACKUP: Copy raw data from Staging to Backup
    INSERT INTO [{schema}].[{target_table}] (
        {columns_clause}
    )
    SELECT
        {select_clause}
    FROM [{schema}].[{source_table}];
    """


def generate_typed_insert_sql(source_table: str, target_table: str,
                              schema_dict: dict, primary_keys: list, schema: str) -> str:
    """Generate INSERT for Typed (Transformations, Append-Only)."""
    column_names = list(schema_dict.keys())
    conversions = [generate_column_conversion(col, dtype) for col, dtype in schema_dict.items()]
    columns_clause = ',\n    '.join([f'[{col}]' for col in column_names])

    # For Typed table, we just insert everything that converts successfully.
    # We do NOT deduplicate against existing history here, as it's a log of what was imported.
    # However, we might want to deduplicate *within the batch* if the file has dupes?
    # Let's assuming dedup within batch is good practice.

    if primary_keys:
        pk_partition = ', '.join([f'[{pk}]' for pk in primary_keys])
        # We filter out rows where PK becomes NULL after conversion

        return f"""
    -- 2. TYPED: Transform and insert into Typed history
    --    Note: Rows with invalid Primary Keys after conversion are skipped here but exist in Backup.
    WITH transformed_data AS (
        SELECT
    {',\n'.join(conversions)}
        FROM [{schema}].[{source_table}]
    ),
    valid_data AS (
        SELECT *,
            ROW_NUMBER() OVER (PARTITION BY {pk_partition} ORDER BY (SELECT NULL)) as rn
        FROM transformed_data
        WHERE {' AND '.join([f'[{pk}] IS NOT NULL' for pk in primary_keys])}
    )
    INSERT INTO [{schema}].[{target_table}] (
        {columns_clause}
    )
    SELECT
        {',\n    '.join([f'[{col}]' for col in column_names])}
    FROM valid_data
    WHERE rn = 1;
    """
    else:
        return f"""
    -- 2. TYPED: Transform and insert (No PK defined)
    INSERT INTO [{schema}].[{target_table}] (
        {columns_clause}
    )
    SELECT
    {',\n'.join(conversions)}
    FROM [{schema}].[{source_table}];
    """


def generate_snapshot_merge_sql(source_table: str, target_table: str,
                                schema_dict: dict, primary_keys: list,
                                schema: str, is_delta: bool) -> str:
    """
    Generate Merge/Insert for Snapshot (The active state).
    Refreshes the 'Main' table from the current Staging batch.
    """
    column_names = list(schema_dict.keys())
    conversions = [generate_column_conversion(col, dtype) for col, dtype in schema_dict.items()]
    columns_clause = ', '.join([f'[{col}]' for col in column_names])

    # Common CTE to get clean data from staging for the snapshot update
    cte_sql = f"""
    WITH new_data AS (
        SELECT * FROM (
            SELECT
    {',\n'.join(conversions)},
                ROW_NUMBER() OVER (PARTITION BY {', '.join([f'[{pk}]' for pk in primary_keys])} ORDER BY (SELECT NULL)) as rn
            FROM [{schema}].[{source_table}]
        ) t WHERE rn = 1 AND {' AND '.join([f'[{pk}] IS NOT NULL' for pk in primary_keys])}
    )"""

    if not primary_keys:
        # Without PK, we can only append.
        # If Total, we truncate first. If Delta, we just append.
        op_sql = f"""
        INSERT INTO [{schema}].[{target_table}] ({columns_clause})
        SELECT {columns_clause} FROM new_data;
        """
        if not is_delta:
             return f"""
    -- 3. SNAPSHOT: Total Replacement (No PK)
    WITH new_data AS (
        SELECT
    {',\n'.join(conversions)}
        FROM [{schema}].[{source_table}]
    )
    INSERT INTO [{schema}].[{target_table}] ({columns_clause})
    SELECT {columns_clause} FROM new_data;
    """
        else:
            return f"""
    -- 3. SNAPSHOT: Delta Append (No PK)
    WITH new_data AS (
        SELECT
    {',\n'.join(conversions)}
        FROM [{schema}].[{source_table}]
    )
    INSERT INTO [{schema}].[{target_table}] ({columns_clause})
    SELECT {columns_clause} FROM new_data;
    """

    # Logic WITH Primary Keys
    if not is_delta:
        # TOTAL: Replace everything
        return f"""
    -- 3. SNAPSHOT: Insert total, expecting no duplicates

    {cte_sql}
    INSERT INTO [{schema}].[{target_table}] ({columns_clause})
    SELECT {columns_clause} FROM new_data;
    """
    else:
        # DELTA: Merge
        pk_join = ' AND '.join([f'target.[{pk}] = source.[{pk}]' for pk in primary_keys])
        update_cols = ', '.join([f'target.[{col}] = source.[{col}]'
                                 for col in column_names if col not in primary_keys])
        values_clause = ', '.join([f'source.[{col}]' for col in column_names])

        return f"""
    -- 3. SNAPSHOT: Delta Merge (Upsert)
    {cte_sql}
    MERGE INTO [{schema}].[{target_table}] AS target
    USING new_data AS source
    ON {pk_join}
    WHEN MATCHED THEN
        UPDATE SET {update_cols}
    WHEN NOT MATCHED THEN
        INSERT ({columns_clause})
        VALUES ({values_clause});
    """


def generate_validation_sql(staging_table: str, snapshot_table: str, schema: str) -> str:
    """
    Generate validation query to output metrics for run_sql_transforms.py.
    Matches expectation of 'ROW_COUNTS' in the first column.
    """
    return f"""
    -- D. Validation Metrics
    ------------------------------------------------------------
    SELECT 
        'ROW_COUNTS' as metric,
        (SELECT COUNT(*) FROM [{schema}].[{staging_table}]) as source_rows,
        (SELECT COUNT(*) FROM [{schema}].[{snapshot_table}]) as target_rows;
    """


def generate_transform_script(table: str, suffix: str, schema_dict: dict,
                              primary_keys: list, output_dir: Path,
                              schema: str) -> Path:
    """Generate complete transformation SQL script for one table/file-type."""

    full_table_name = f"{table}_{suffix}"  # e.g., Aftale_Delta
    staging_table = f"{full_table_name}_Staging"
    backup_table = f"{full_table_name}_Backup"
    typed_table = f"{full_table_name}_Typed"
    snapshot_table = f"{table}"  # The 'Golden Record'

    output_file = output_dir / f"transform_{full_table_name}.sql"
    is_delta = (suffix == "Delta")

    script = f"""
    -- ============================================================
    -- Pipeline Script for {table} ({suffix})
    -- Source:  {staging_table}
    -- Targets: {backup_table}, {typed_table}, {snapshot_table}
    -- Generated automatically
    -- ============================================================

    USE [{config.DB_NAME}];
    GO

    -- A. Ensure Target Tables Exist
    ------------------------------------------------------------
    {generate_create_table_sql(backup_table, schema_dict, primary_keys, schema, "backup")}
    {generate_create_table_sql(typed_table, schema_dict, primary_keys, schema, "typed")}
    {generate_create_table_sql(snapshot_table, schema_dict, primary_keys, schema, "snapshot")}
    GO

    -- B. Execute Pipeline Steps
    ------------------------------------------------------------
    
    {generate_backup_insert_sql(staging_table, backup_table, schema_dict, schema)}
    GO
    
    {generate_typed_insert_sql(staging_table, typed_table, schema_dict, primary_keys, schema)}
    GO
    
    {generate_snapshot_merge_sql(staging_table, snapshot_table, schema_dict, primary_keys, schema, is_delta)}
    GO

    {generate_validation_sql(staging_table, snapshot_table, schema)}
    GO

    -- C. Cleanup (Optional - Staging table usually kept until file move is confirmed)
    DROP TABLE [{schema}].[{staging_table}];
    GO
    """

    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(script)

    return output_file


def generate_all_transform_scripts(tables: list[str], data_types: dict,
                                   table_keys: dict,
                                   output_dir: Path = Path('sql_transforms')) -> None:
    """Generate SQL transformation scripts for all tables."""

    output_dir.mkdir(exist_ok=True)
    summary = []

    for table in tables:
        # Ensure metadata columns are in the schema
        schema = data_types.get(table, {}).copy()
        schema.update(table_columns.metadata_columns)

        keys = table_keys.get(table)

        if not schema:
            print(f"  ⚠ No schema for {table}, skipping")
            continue

        key_info = "No PK" if not keys else f"PK: {', '.join(keys)}"

        for suffix in ["Total", "Delta"]:
            print(f"Generating pipeline script for {table} ({suffix})...")
            script_file = generate_transform_script(
                table, suffix, schema, keys or [], output_dir, config.DB_SCHEMA
            )
            print(f"  ✓ {script_file.name}")

            summary.append({
                'table': table,
                'type': suffix,
                'script': script_file.name,
                'pk': key_info
            })

    # Generate summary file
    summary_file = output_dir / "00_SUMMARY.txt"
    with open(summary_file, 'w', encoding='utf-8') as f:
        f.write("SQL PIPELINE SCRIPTS SUMMARY\n")
        f.write("="*70 + "\n")
        for item in summary:
            f.write(f"{item['script']:<45} | {item['pk']}\n")

    print(f"\n✓ All scripts generated in {output_dir}")


if __name__ == "__main__":
    all_tables = list(table_columns.data_types.keys())

    generate_all_transform_scripts(
        all_tables,
        table_columns.data_types,
        table_columns.table_keys,
        output_dir=Path('sql_transforms')
    )
