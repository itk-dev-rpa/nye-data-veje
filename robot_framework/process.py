"""This module contains the main process of the robot."""
import json
import os
from pathlib import Path

from OpenOrchestrator.orchestrator_connection.connection import OrchestratorConnection
from sqlalchemy import create_engine

from robot_framework.ode_ingest import raw_upload, run_sql_transforms, profiling, table_definitions
from robot_framework.ode_ingest.utils import file_utils
from robot_framework import config


tables = [  # List of tables to work on
    "Aftaleindhold",
    "BO-aftale-haendelse",
    "BO-aftale",
    "Bilag-aaben",
    "Bilag-master",
    "FP-aftale",
    "Bilag-lukket",
    "Forretningspartner",
    "Indbetalinger",
    "Opsaetning-Aftalekontotype",
    "Opsaetning-Rykkerniveau",
    "RIM-aftale-rater",
    "RIM-aftale-renter",
    "RIM-aftale",
    "Rykker",
    "UU-aftale-haefter",
    "UU-aftale",
]


def process(orchestrator_connection: OrchestratorConnection) -> None:
    """Do the primary process of the robot."""
    orchestrator_connection.log_trace("Running process.")
    connection_string = orchestrator_connection.get_constant(config.DB_CONNECTION).value
    engine = create_engine(connection_string, fast_executemany=True)
    sql_transform_path = Path("ode_ingest/sql_transforms")

    # Check if SQL transform directory exists
    if not sql_transform_path.exists():
        error_msg = (
            f"ERROR: SQL transform directory not found: {sql_transform_path}\n"
            f"Please run 'python robot_framework/ode_ingest/generate_transform_sql.py' to generate the SQL scripts."
        )
        orchestrator_connection.log_error(error_msg)
        raise FileNotFoundError(error_msg)

    validation_log_file: Path = Path('transform_validation.json')
    validation_log = {}
    if validation_log_file.exists():
        try:
            with open(validation_log_file, 'r', encoding='utf-8') as f:
                validation_log = json.load(f)
        except json.JSONDecodeError:
            print("Kunne ikke læse eksisterende logfil (muligvis tom eller korrupt). Starter ny.")

    directory = orchestrator_connection.get_constant(config.DATA_DIRECTORY).value
    for table_name in tables:
        table_schema = table_definitions.data_types.get(table_name, {})
        table_schema.update(table_definitions.metadata_columns)
        for subset in ["Total", "Delta"]:
            files = file_utils.find_files(directory, f"{table_name}_{subset}")
            if not files:
                continue
            files = file_utils.sort_files(files)

            script_path = Path(sql_transform_path, f"transform_{table_name}_{subset}.sql")
            if not script_path.exists():
                print(f"  ⚠ Advarsel: Transformations-script ikke fundet: {script_path}")

            # Loop through all files and add them to staging table
            for file_path in files:
                try:
                    df, stats = raw_upload.process_file(file_path, f"{table_name}")
                    print(f"\nLoaded file {file_path}: \n{stats}.")
                    df.to_sql(f"{table_name}_{subset}_Staging", engine, schema=config.DB_SCHEMA, if_exists='append', index=False)
                    print(f"\nStaged {table_name}_{subset}.")
                    # data_profile = profiling.profile_table(f"{table_name}_{subset}_Staging", engine, table_schema)
                    run_sql_transforms.execute_sql_file_with_validation(script_path, engine, validation_log, log_key=f"{table_name}_{subset} ({file_path.name})")
                    file_utils.move_processed_files(file_path)
                    raw_upload.log_ingest_stats(engine, f"{table_name}_{subset}", file_path.name, stats, "Success")
                except Exception as e:
                    print(f"  ✗ FEJL ved behandling af {file_path.name}: {e}")
                    stats = stats if stats else {}
                    raw_upload.log_ingest_stats(engine, f"{table_name}_{subset}", file_path.name, stats,"Fail", str(e))
                    break

                with open(validation_log_file, 'w', encoding='utf-8') as f:
                    json.dump(validation_log, f, indent=2)



if __name__ == "__main__":
    conn_string = os.getenv("OpenOrchestratorConnString")
    crypto_key = os.getenv("OpenOrchestratorKey")
    oc = OrchestratorConnection("ODE test", conn_string, crypto_key, "")

    process(oc)
