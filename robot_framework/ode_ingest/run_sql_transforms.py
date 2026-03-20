"""SQL transformation script executor with validation and logging.

This module executes the generated SQL transformation scripts and captures
validation metrics including row counts, data quality issues, and execution status.
Results are logged to a JSON file for auditing and troubleshooting.
"""
from pathlib import Path
from sqlalchemy import create_engine, text
import os
import json
from datetime import datetime

from OpenOrchestrator.orchestrator_connection.connection import OrchestratorConnection
from robot_framework import config


def execute_sql_string_with_validation(sql_content: str, engine,
                                       validation_log: dict, log_key: str) -> None:
    """Execute SQL transformation script string and capture validation metrics.

    Splits SQL content by GO statements and executes each batch separately.
    Captures row counts and data quality issues from validation queries.

    Args:
        sql_content: SQL script content as string
        engine: SQLAlchemy engine for database connection
        validation_log: Dictionary to store validation results (modified in-place)
        log_key: Key for the validation log entry

    Raises:
        Exception: Re-raises any SQL execution errors after logging them
    """
    print(f"\nExecuting transformation for {log_key}...")

    # Split by GO statements
    batches = [batch.strip() for batch in sql_content.split('GO\n') if batch.strip()]

    validation_log[log_key] = {
        'executed_at': datetime.now().isoformat(),
        'script': 'in-memory',
        'status': 'in_progress',
        'issues': []
    }

    for i, batch in enumerate(batches[1:], 1):
        if not batch:
            continue

        # Skip if the ENTIRE batch is just comments
        lines = [line.strip() for line in batch.split('\n') if line.strip()]
        if all(line.startswith('--') for line in lines):
            continue
        batch = "\n".join(line for line in lines if not line.startswith("--"))
        with engine.begin() as connection:
            try:
                result = connection.execute(text(batch))
                try:
                    # Capture results from SELECT statements
                    if batch.strip().upper().startswith(('SELECT', 'WITH')):
                        rows = result.fetchall()
                        if rows:
                            # Check if it's a validation query
                            first_row = rows[0]

                            # NULL in primary key report
                            if len(rows) > 0 and 'NULL_IN_PRIMARY_KEY' in str(first_row):
                                print(f"  ⚠ Found {len(rows)} rows with NULL in primary key")
                                validation_log[log_key]['issues'].append({
                                    'type': 'null_in_primary_key',
                                    'count': len(rows),
                                    'sample': [dict(row._mapping) for row in rows[:5]]
                                })

                            # Row count metrics
                            elif 'ROW_COUNTS' in str(first_row):
                                row_dict = dict(first_row._mapping)
                                print(f"  Source rows: {row_dict.get('source_rows', 'N/A')}")
                                print(f"  Target rows: {row_dict.get('target_rows', 'N/A')}")
                                if 'excluded_rows' in row_dict:
                                    excluded = row_dict['excluded_rows']
                                    if excluded > 0:
                                        print(f"  ⚠ Excluded rows: {excluded}")

                                validation_log[log_key]['row_counts'] = row_dict

                    connection.commit()
                except Exception:
                    # Some queries don't return results (INSERT, CREATE, etc)
                    pass

            except Exception as exc:
                print(f"  ✗ Error in batch {i}: {exc}")
                validation_log[log_key]['status'] = 'failed'
                validation_log[log_key]['error'] = str(exc)
                raise

    validation_log[log_key]['status'] = 'completed'
    print(f"  ✓ Transformation completed")


def execute_sql_file_with_validation(filepath: Path, engine,
                                     validation_log: dict, log_key: str = None) -> None:
    """Execute SQL transformation script from file and capture validation metrics.

    Wrapper around execute_sql_string_with_validation that reads from a file.

    Args:
        filepath: Path to the SQL transformation script
        engine: SQLAlchemy engine for database connection
        validation_log: Dictionary to store validation results (modified in-place)
        log_key: Optional custom key for the validation log entry (defaults to filename)

    Raises:
        Exception: Re-raises any SQL execution errors after logging them
    """
    print(f"\nExecuting {filepath.name}...")

    with open(filepath, 'r', encoding='utf-8') as f:
        sql_content = f.read()

    if log_key is None:
        log_key = filepath.stem.replace('transform_', '')

    # Update to use file name in log
    execute_sql_string_with_validation(sql_content, engine, validation_log, log_key)
    # Override the script name to show actual file
    validation_log[log_key]['script'] = filepath.name
    print(f"  ✓ {filepath.name} completed")


def run_all_transforms(sql_dir: Path, oc,
                       validation_log_file: Path = Path('transform_validation.json')) -> None:
    """Execute all SQL transformation scripts in a directory with validation tracking.

    Processes all transform_*.sql files in the specified directory, logs results,
    and generates a summary report.

    Args:
        sql_dir: Directory containing SQL transformation scripts
        oc: OpenOrchestrator connection for config access
        validation_log_file: Path to JSON file for storing validation results
    """

    connection_string = oc.get_constant(config.DB_CONNECTION).value
    engine = create_engine(connection_string)

    validation_log = {}

    # Run table transformation scripts
    table_scripts = sorted([f for f in sql_dir.glob("transform_*.sql")])

    print(f"Found {len(table_scripts)} table transformation scripts\n")
    print("="*70)

    for script_file in table_scripts:
        try:
            execute_sql_file_with_validation(script_file, engine, validation_log)
        except Exception as exc:
            print(f"\n✗ Failed to execute {script_file.name}")
            print(f"  Error: {exc}")

            # response = input("\nContinue with remaining scripts? (y/n): ")
            # if response.lower() != 'y':
            #     print("Stopping execution")
            #     break
            print("Continuing...\n")

        # Save validation log after each table
        with open(validation_log_file, 'w', encoding='utf-8') as f:
            json.dump(validation_log, f, indent=2)

    # Generate summary report
    print("\n" + "="*70)
    print("TRANSFORMATION SUMMARY")
    print("="*70)

    total_tables = len(validation_log)
    completed = sum(1 for v in validation_log.values() if v['status'] == 'completed')
    failed = sum(1 for v in validation_log.values() if v['status'] == 'failed')

    print(f"\nTotal tables: {total_tables}")
    print(f"Completed: {completed}")
    print(f"Failed: {failed}")

    # Tables with issues
    tables_with_issues = [
        table for table, info in validation_log.items()
        if info.get('issues')
    ]

    if tables_with_issues:
        print(f"\n⚠ Tables with validation issues: {len(tables_with_issues)}")
        for table in tables_with_issues:
            issues = validation_log[table]['issues']
            for issue in issues:
                print(f"  - {table}: {issue['type']} ({issue['count']} rows)")

    print(f"\n✓ Detailed validation log saved to: {validation_log_file}")
    print("="*70)


if __name__ == "__main__":
    conn_string = os.getenv("OpenOrchestratorConnString")
    crypto_key = os.getenv("OpenOrchestratorKey")
    oc = OrchestratorConnection("ODE test", conn_string, crypto_key, "")

    sql_dir = Path('sql_transforms')

    connection_string = oc.get_constant(config.DB_CONNECTION).value
    engine = create_engine(connection_string)
    execute_sql_file_with_validation(Path("sql_transforms/transform_RIM-aftale-rater_Delta.sql"), engine, {})
    # if not sql_dir.exists():
    #     print(f"Error: Directory {sql_dir} not found")
    #     print("Run generate_transform_sql.py first to generate scripts")
    # else:
    #     run_all_transforms(sql_dir, oc)
