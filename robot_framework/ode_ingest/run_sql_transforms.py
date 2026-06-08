"""SQL transformation script executor with validation and logging.

This module executes the generated SQL transformation scripts and captures
validation metrics including row counts, data quality issues, and execution status.
Results are logged to a JSON file for auditing and troubleshooting.
"""
import os
import json
from pathlib import Path
from datetime import datetime

from sqlalchemy import create_engine, text
from sqlalchemy.exc import SQLAlchemyError, ResourceClosedError

from OpenOrchestrator.orchestrator_connection.connection import OrchestratorConnection
from robot_framework import config


def _process_validation_results(rows, log_key: str, validation_log: dict,
                                orchestrator_connection: OrchestratorConnection) -> None:
    """Process validation query results and log metrics.

    Args:
        rows: Query result rows
        log_key: Key for validation log entry
        validation_log: Dictionary to store validation results
        orchestrator_connection: OO connection used to surface metrics in the central log.
    """
    if not rows:
        return

    first_row = rows[0]

    # NULL in primary key report
    if 'NULL_IN_PRIMARY_KEY' in str(first_row):
        msg = f"Found {len(rows)} rows with NULL in primary key"
        print(msg)
        orchestrator_connection.log_info(msg)
        validation_log[log_key]['issues'].append({
            'type': 'null_in_primary_key',
            'count': len(rows),
            'sample': [dict(row._mapping) for row in rows[:5]]  # pylint: disable=protected-access
        })

    # Row count metrics
    elif 'ROW_COUNTS' in str(first_row):
        row_dict = dict(first_row._mapping)  # pylint: disable=protected-access
        src_msg = f"Source rows: {row_dict.get('source_rows', 'N/A')}"
        tgt_msg = f"Target rows: {row_dict.get('target_rows', 'N/A')}"
        print(src_msg)
        print(tgt_msg)
        orchestrator_connection.log_trace(src_msg)
        orchestrator_connection.log_trace(tgt_msg)
        if 'excluded_rows' in row_dict:
            excluded = row_dict['excluded_rows']
            if excluded > 0:
                msg = f"Excluded rows: {excluded}"
                print(msg)
                orchestrator_connection.log_info(msg)

        validation_log[log_key]['row_counts'] = row_dict


def execute_sql_string_with_validation(sql_content: str, engine,
                                       validation_log: dict, log_key: str,
                                       orchestrator_connection: OrchestratorConnection) -> None:
    """Execute SQL transformation script string and capture validation metrics.

    Splits SQL content by GO statements and executes each batch separately.
    Captures row counts and data quality issues from validation queries.

    Args:
        sql_content: SQL script content as string
        engine: SQLAlchemy engine for database connection
        validation_log: Dictionary to store validation results (modified in-place)
        log_key: Key for the validation log entry
        orchestrator_connection: OO connection used to forward progress and
            SQL-execution errors to OO's log in addition to stdout.

    Raises:
        Exception: Re-raises any SQL execution errors after logging them
    """
    msg = f"Executing transformation for {log_key}..."
    print(msg)
    orchestrator_connection.log_trace(msg)

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
                # Capture results from SELECT statements
                if batch.strip().upper().startswith(('SELECT', 'WITH')):
                    try:
                        rows = result.fetchall()
                        _process_validation_results(rows, log_key, validation_log,
                                                    orchestrator_connection=orchestrator_connection)
                    except ResourceClosedError:
                        # Some queries don't return results (INSERT, CREATE, etc)
                        pass

                connection.commit()

            except SQLAlchemyError as exc:
                err_msg = f"Error in batch {i}: {exc}"
                print(err_msg)
                orchestrator_connection.log_error(err_msg)
                validation_log[log_key]['status'] = 'failed'
                validation_log[log_key]['error'] = str(exc)
                raise

    validation_log[log_key]['status'] = 'completed'
    done_msg = "Transformation completed"
    print(done_msg)
    orchestrator_connection.log_trace(done_msg)


def execute_sql_file_with_validation(filepath: Path, engine,
                                     validation_log: dict,
                                     orchestrator_connection: OrchestratorConnection,
                                     log_key: str = None) -> None:
    """Execute SQL transformation script from file and capture validation metrics.

    Wrapper around execute_sql_string_with_validation that reads from a file.

    Args:
        filepath: Path to the SQL transformation script
        engine: SQLAlchemy engine for database connection
        validation_log: Dictionary to store validation results (modified in-place)
        orchestrator_connection: OO connection, threaded through to
            ``execute_sql_string_with_validation`` for centralized logging.
        log_key: Optional custom key for the validation log entry (defaults to filename)

    Raises:
        Exception: Re-raises any SQL execution errors after logging them
    """
    msg = f"Executing {filepath.name}..."
    print(msg)
    orchestrator_connection.log_trace(msg)

    with open(filepath, 'r', encoding='utf-8') as f:
        sql_content = f.read()

    if log_key is None:
        log_key = filepath.stem.replace('transform_', '')

    # Update to use file name in log
    execute_sql_string_with_validation(sql_content, engine, validation_log, log_key,
                                       orchestrator_connection=orchestrator_connection)
    # Override the script name to show actual file
    validation_log[log_key]['script'] = filepath.name
    done_msg = f"{filepath.name} completed"
    print(done_msg)
    orchestrator_connection.log_trace(done_msg)


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
            execute_sql_file_with_validation(script_file, engine, validation_log,
                                             orchestrator_connection=oc)
        except SQLAlchemyError as exc:
            print(f"\nFailed to execute {script_file.name}")
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
        print(f"\nTables with validation issues: {len(tables_with_issues)}")
        for table in tables_with_issues:
            issues = validation_log[table]['issues']
            for issue in issues:
                print(f"  - {table}: {issue['type']} ({issue['count']} rows)")

    print(f"\nDetailed validation log saved to: {validation_log_file}")
    print("="*70)


if __name__ == "__main__":
    conn_string = os.getenv("OpenOrchestratorConnString")
    crypto_key = os.getenv("OpenOrchestratorKey")
    oc_main = OrchestratorConnection("ODE test", conn_string, crypto_key, "", "")

    sql_dir_main = Path('sql_transforms')

    conn_str = oc_main.get_constant(config.DB_CONNECTION).value
    db_engine = create_engine(conn_str)
    execute_sql_file_with_validation(Path("sql_transforms/transform_RIM-aftale-rater_Delta.sql"), db_engine, {},
                                     orchestrator_connection=oc_main)
    # if not sql_dir.exists():
    #     print(f"Error: Directory {sql_dir} not found")
    #     print("Run generate_transform_sql.py first to generate scripts")
    # else:
    #     run_all_transforms(sql_dir, oc)
