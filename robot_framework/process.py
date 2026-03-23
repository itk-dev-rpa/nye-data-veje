"""Main ETL process for ODE Debitor data ingestion.

This module orchestrates the complete data pipeline:
1. Finds and loads raw CSV files from the data directory
2. Processes and stages data in SQL Server staging tables
3. Executes SQL transformations (Backup -> Typed -> Snapshot)
4. Logs validation results and ingestion statistics
"""
import json
import os
from pathlib import Path

from OpenOrchestrator.orchestrator_connection.connection import OrchestratorConnection
from sqlalchemy import create_engine

from robot_framework.ode_ingest import run_sql_transforms, table_definitions, generate_transform_sql
from robot_framework.ode_ingest.utils import file_utils, ingest_utils
from robot_framework import config


def process(orchestrator_connection: OrchestratorConnection) -> None:
    """Execute the complete ETL pipeline for all configured tables.

    This function processes each table by:
    1. Finding all Total and Delta files for the table
    2. Loading and staging each file to SQL Server
    3. Generating SQL transformations in-memory based on table schema
    4. Executing transformations through the pipeline (Backup -> Typed -> Snapshot)
    5. Logging statistics and validation results
    6. Moving processed files to archive

    Args:
        orchestrator_connection: OpenOrchestrator connection for logging and config access

    Raises:
        Exception: Any errors during file processing are caught, logged, and stop processing for that table
    """
    orchestrator_connection.log_trace("Running process.")
    connection_string = orchestrator_connection.get_constant(config.DB_CONNECTION).value
    engine = create_engine(connection_string, fast_executemany=True)

    validation_log_file: Path = Path('transform_validation.json')
    validation_log = {}
    if validation_log_file.exists():
        try:
            with open(validation_log_file, 'r', encoding='utf-8') as f:
                validation_log = json.load(f)
        except json.JSONDecodeError:
            print("Kunne ikke læse eksisterende logfil (muligvis tom eller korrupt). Starter ny.")

    directory = orchestrator_connection.get_constant(config.DATA_DIRECTORY).value
    tables_to_process = config.TABLES_TO_PROCESS or table_definitions.ALL_TABLE_NAMES
    for table_name in tables_to_process:
        table_schema = table_definitions.data_types.get(table_name, {})
        table_schema.update(table_definitions.metadata_columns)
        primary_keys = table_definitions.table_keys.get(table_name, [])

        for subset in ["Total", "Delta"]:
            files = file_utils.find_files(directory, f"{table_name}_{subset}")
            if not files:
                continue
            files = file_utils.sort_files(files)

            # Loop through all files and add them to staging table
            for file_path in files:
                try:
                    df, stats = ingest_utils.process_file(file_path, f"{table_name}")
                    print(f"\nLoaded file {file_path}: \n{stats}.")
                    df.to_sql(f"{table_name}_{subset}_Staging", engine, schema=config.DB_SCHEMA, if_exists='append', index=False)
                    print(f"\nStaged {table_name}_{subset}.")

                    # Generate and execute SQL transformation in-memory
                    sql_script = generate_transform_sql.generate_transform_script_string(
                        table=table_name,
                        suffix=subset,
                        schema_dict=table_schema,
                        primary_keys=primary_keys,
                        schema=config.DB_SCHEMA
                    )
                    run_sql_transforms.execute_sql_string_with_validation(
                        sql_script, engine, validation_log,
                        log_key=f"{table_name}_{subset} ({file_path.name})"
                    )

                    file_utils.move_processed_files(file_path)
                    ingest_utils.log_ingest_stats(engine, f"{table_name}_{subset}", file_path.name, stats, "Success")
                except Exception as e:  # pylint: disable=broad-exception-caught
                    print(f"  ✗ FEJL ved behandling af {file_path.name}: {e}")
                    stats = stats if stats else {}
                    ingest_utils.log_ingest_stats(engine, f"{table_name}_{subset}", file_path.name, stats,"Fail", str(e))
                    break

                with open(validation_log_file, 'w', encoding='utf-8') as f:
                    json.dump(validation_log, f, indent=2)



if __name__ == "__main__":
    conn_string = os.getenv("OpenOrchestratorConnString")
    crypto_key = os.getenv("OpenOrchestratorKey")
    oc = OrchestratorConnection("ODE test", conn_string, crypto_key, "")

    process(oc)
