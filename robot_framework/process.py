"""This module contains the main process of the robot."""
import json
import os
from pathlib import Path

from OpenOrchestrator.orchestrator_connection.connection import OrchestratorConnection
from sqlalchemy import create_engine

from robot_framework.ode_ingest import raw_upload
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

    directory = orchestrator_connection.get_constant(config.DATA_DIRECTORY).value
    for table_name in tables:
        for subset in ["Total", "Delta"]:
            files = file_utils.find_files(directory, f"{table_name}_{subset}")
            for file in files:
                file_path = Path(file)
                df = raw_upload.process_file(file_path, f"{table_name}")
                df.to_sql(f"{table_name}_{subset}_Staging", engine, schema=config.DB_SCHEMA, if_exists='append', index=False)
                file_utils.move_processed_files(file_path)
            # TODO: Run SQL pipeline


if __name__ == "__main__":
    conn_string = os.getenv("OpenOrchestratorConnString")
    crypto_key = os.getenv("OpenOrchestratorKey")
    arguments = {
        "create_table": True,
        "insert_total_data": True,
        "update_total_from_delta": False,
        "insert_delta_data": True,
        "from_to_date": None
    }
    oc = OrchestratorConnection("ODE test", conn_string, crypto_key, json.dumps(arguments))

    process(oc)
