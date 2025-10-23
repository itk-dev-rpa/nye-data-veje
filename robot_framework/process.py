"""This module contains the main process of the robot."""
import json
import os

from OpenOrchestrator.orchestrator_connection.connection import OrchestratorConnection

from robot_framework.ode_ingest import upload_tables
from robot_framework.ode_ingest.utils import db_utils


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

    process_arguments = json.loads(orchestrator_connection.process_arguments)
    create_table = process_arguments["create_table"]
    insert_total_data = process_arguments["insert_total_data"]
    update_total_from_delta = process_arguments["update_total_from_delta"]
    from_to_date = process_arguments["from_to_date"]

    for table in tables:
        if create_table:
            orchestrator_connection.log_trace(f"Create table for {table}")
            db_utils.create_table(table, db_utils.get_column_list_with_types(table), orchestrator_connection)
        if insert_total_data:
            orchestrator_connection.log_trace(f"Inserting total data for {table}")
            upload_tables.insert_total_data(table, orchestrator_connection, from_to_date=from_to_date)
        if update_total_from_delta:
            orchestrator_connection.log_trace(f"Inserting delta data for {table}")
            upload_tables.update_total_from_delta(table, orchestrator_connection)


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
