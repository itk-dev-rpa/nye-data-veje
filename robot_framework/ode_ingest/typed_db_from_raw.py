import os
from sqlalchemy import create_engine
from OpenOrchestrator.orchestrator_connection.connection import OrchestratorConnection

from robot_framework import config
from robot_framework.ode_ingest.utils import dataframe_utils, db_utils

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


def main(oc: OrchestratorConnection):
    connection_string = oc.get_constant(config.DB_CONNECTION).value
    engine = create_engine(connection_string, fast_executemany=True)

    for table in tables:
        for suffix in ["Total"]:
            sql_table = f"{table}_{suffix}"
            print(f"Creating table {sql_table}")
            db_utils.create_table(f"{sql_table}_Typed", db_utils.get_column_list_with_types(table), oc)
            print(f"Reading from {sql_table}")
            df = dataframe_utils.load_df_from_sql(sql_table, engine)
            print(f"Configuring {sql_table}")
            df = dataframe_utils.set_types_and_keys(df, table, sql_table, oc)
            print(f"Uploading {sql_table}")
            df.to_sql(f"{sql_table}_Typed", connection_string, schema=config.DB_SCHEMA, if_exists='replace', chunksize=1000)


if __name__ == "__main__":
    conn_string = os.getenv("OpenOrchestratorConnString")
    crypto_key = os.getenv("OpenOrchestratorKey")
    oc = OrchestratorConnection("ODE test", conn_string, crypto_key, "")
    main(oc)
