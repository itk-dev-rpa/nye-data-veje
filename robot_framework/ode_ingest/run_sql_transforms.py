"""SQL transformation script executor with validation and logging.

This module executes the generated SQL transformation scripts and captures
validation metrics including row counts, data quality issues, and execution status.
Results are logged to a JSON file for auditing and troubleshooting.
"""
import os
import json
from pathlib import Path
from datetime import datetime
import re

from sqlalchemy import create_engine, text
from sqlalchemy.exc import SQLAlchemyError, ResourceClosedError

from OpenOrchestrator.orchestrator_connection.connection import OrchestratorConnection
from robot_framework import config


def _process_validation_results(rows, log_key: str, validation_log: dict) -> None:
    """Process validation query results and log metrics.

    Expects validation SELECTs to return a column named `metric` and either
    a `cnt`/`count` integer or a set of named columns for row counts.
    Any metric with a positive count is added to `issues`.
    """
    if not rows:
        return

    # Ensure basic sections exist
    entry = validation_log.setdefault(log_key, {})
    entry.setdefault('issues', [])

    for row in rows:
        row_dict = dict(row._mapping)  # pylint: disable=protected-access
        metric = str(row_dict.get('metric', '')).upper()
        if not metric:
            continue

        # Generic row counts block
        if metric == 'ROW_COUNTS':
            # Support optional typed_rows/final_rows keys
            entry['row_counts'] = row_dict
            src = row_dict.get('source_rows')
            tgt = row_dict.get('target_rows') or row_dict.get('final_rows')
            if src is not None:
                print(f"  Source rows: {src}")
            if tgt is not None:
                print(f"  Target rows: {tgt}")
            continue

        # All other metrics treated as issues with cnt/count value
        cnt = row_dict.get('cnt', row_dict.get('count', 0))
        try:
            cnt_int = int(cnt) if cnt is not None else 0
        except (TypeError, ValueError):
            cnt_int = 0
        if cnt_int > 0:
            entry['issues'].append({'type': metric, 'count': cnt_int})
            print(f"  ⚠ {metric}: {cnt_int}")


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

    # Robust split by GO statements (case-insensitive, supports CRLF and whitespace)
    batches = [b.strip() for b in re.split(r"(?im)^\s*GO\s*$", sql_content) if b.strip()]

    validation_log[log_key] = {
        'executed_at': datetime.now().isoformat(),
        'script': 'in-memory',
        'status': 'in_progress',
        'issues': []
    }

    for i, batch in enumerate(batches, 1):
        if not batch:
            continue

        # Remove pure comment lines but keep code
        lines = [line for line in batch.split('\n') if line.strip()]
        code_lines = [ln for ln in lines if not ln.lstrip().startswith('--')]
        if not code_lines:
            continue
        batch_to_run = "\n".join(code_lines)
        with engine.begin() as connection:
            try:
                result = connection.execute(text(batch_to_run))
                # Try to capture results from SELECT statements (if any)
                try:
                    rows = result.fetchall()
                    _process_validation_results(rows, log_key, validation_log)
                except ResourceClosedError:
                    # Batch does not return a result set (CREATE/INSERT/UPDATE/etc)
                    pass

                connection.commit()

            except SQLAlchemyError as exc:
                print(f"  ✗ Error in batch {i}: {exc}")
                validation_log[log_key]['status'] = 'failed'
                validation_log[log_key]['error'] = str(exc)
                raise

    validation_log[log_key]['status'] = 'completed'
    print("  ✓ Transformation completed")


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
    table_scripts = sorted(list(sql_dir.glob("transform_*.sql")))

    print(f"Found {len(table_scripts)} table transformation scripts\n")
    print("="*70)

    for script_file in table_scripts:
        try:
            execute_sql_file_with_validation(script_file, engine, validation_log)
        except SQLAlchemyError as exc:
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
    oc_main = OrchestratorConnection("ODE test", conn_string, crypto_key, "", "")

    sql_dir_main = Path('sql_transforms')

    conn_str = oc_main.get_constant(config.DB_CONNECTION).value
    db_engine = create_engine(conn_str)
    execute_sql_file_with_validation(Path("sql_transforms/transform_RIM-aftale-rater_Delta.sql"), db_engine, {})
    # if not sql_dir.exists():
    #     print(f"Error: Directory {sql_dir} not found")
    #     print("Run generate_transform_sql.py first to generate scripts")
    # else:
    #     run_all_transforms(sql_dir, oc)
