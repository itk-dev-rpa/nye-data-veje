
import json
import os

from OpenOrchestrator.orchestrator_connection.connection import OrchestratorConnection

import pandas as pd
from robot_framework.ode_ingest import ode_ingest as ode
from robot_framework.ode_ingest.table_columns import table_used_columns

csv_config = {
    'sep': ';',  # Danish standard separator
    'decimal': ',',  # Danish decimal separator
    'thousands': '.',  # Danish thousands separator
    'na_values': ['', ' ', 'nan', 'NaN', 'NULL', 'null', '-', 'N/A'],
    'keep_default_na': True,
    'skipinitialspace': True
}


tables = [  # List of tables to work on
    # "Aftaleindhold",
    # "BO-aftale-haendelse",
    # "BO-aftale",
    # "Bilag-aaben",
    # "Bilag-master",
    # "FP-aftale",
    # "Bilag-lukket",
    # "Forretningspartner",
    # "Indbetalinger",
    "Opsaetning-Aftalekontotype",
    "Opsaetning-Rykkerniveau",
    "RIM-aftale-rater",
    "RIM-aftale-renter",
    "RIM-aftale",
    "Rykker",
    "UU-aftale-haefter",
    "UU-aftale",
]


def check_files(table_name: str, postfix: str, folder: str, check_columns_for_null: list[str]):
    files = ode.find_files(folder, f"{table_name}_{postfix}")
    for file_name in files:
        for encoding in ['utf-8', 'latin-1', 'cp1252']:
            try:
                df = pd.read_csv(file_name, dtype=str, encoding=encoding, **csv_config)
                for c in check_columns_for_null:
                    null_df = df[pd.isnull(df[c])]
                    print(null_df)
                    if len(null_df) > 0:
                        print("We found one!")
            except:
                continue


def check_processed_files(table_name: str, postfix: str, folder: str, check_columns_for_null: list[str], oc: OrchestratorConnection):
    files = ode.find_files(folder, f"{table_name}_{postfix}")
    for file_name in files:
        df = ode.create_dataframe_from_file(file_name, table_name, oc)
        for c in check_columns_for_null:
            null_df = df[pd.isnull(df[c])]
            print(null_df)
            if len(null_df) > 0:
                print(f"We found one! {file_name}")


def compare_raw_vs_processed(table_name: str, postfix: str, folder: str, oc: OrchestratorConnection):
    print(f"Reading table {table_name} {postfix}")
    files = ode.find_files(folder, f"{table_name}_{postfix}")
    for file_name in files:
        # Læs rå version
        raw_df = None
        for encoding in ['utf-8', 'latin-1', 'cp1252']:
            try:
                raw_df = pd.read_csv(file_name, dtype=str, encoding=encoding, **csv_config)
                break
            except:
                continue

        if raw_df is None:
            print(f"Kunne ikke læse {file_name}")
            continue
        raw_df = _clean_basic_data(raw_df)

        # Læs behandlet version
        processed_df = ode.create_dataframe_from_file(file_name, table_name, oc)
        table_columns = set(table_used_columns[table_name]) & set(raw_df.columns)
        # Sammenlign for hver kolonne
        for col in table_columns:

            # Find rækker hvor værdier er forskellige OG ikke begge missing
            raw_missing = raw_df[col].apply(is_effectively_null)
            proc_missing = pd.isna(processed_df[col])

            # Kun flag hvis en bliver missing når den ikke var det før
            new_nulls = (~raw_missing) & proc_missing

            if new_nulls.any():
                print(f"{file_name}, col: {col}\nNye nulls:")
                for idx in raw_df[new_nulls].index[:5]:
                    print(f"  Række {idx}: '{raw_df.loc[idx, col]}' -> null")
                    return True
    return False


def _clean_basic_data(df: pd.DataFrame) -> pd.DataFrame:
    """Basic data cleaning, replacing/removing whitespace and removing periods.

    Args:
        df: Pandas dataframe in need of cleaning.
    """

    for col in df.columns:
        if df[col].dtype == 'object':
            df[col] = df[col].astype(str).str.strip().replace(".", "")

    # Remove 'unnamed' columns.
    unnamed_cols = df.columns[df.columns.str.contains('^Unnamed', case=False, na=False)]
    if len(unnamed_cols) > 0:
        df = df.drop(columns=unnamed_cols)

    df.columns = df.columns.str.replace(' ', '_').str.strip()

    return df


def is_effectively_null(val):
    """Tjek om værdi skal behandles som null"""
    if pd.isna(val):
        return True
    if isinstance(val, str):
        val_lower = val.lower().strip()
        if val_lower == 'nan':
            return True
        if len(val_lower) > 1 and val_lower.isdigit() and all(c == '0' for c in val_lower):
            return True
    return False


if __name__ == '__main__':
    conn_string = os.getenv("OpenOrchestratorConnString")
    crypto_key = os.getenv("OpenOrchestratorKey")
    arguments = {
        "create_table": False,
        "insert_total_data": False,
        "insert_delta_data": True,
        "from_to_date": None
    }
    oc = OrchestratorConnection("ODE test", conn_string, crypto_key, json.dumps(arguments))
    for domain in ["Total", "Delta"]:
        for table in tables:
            if compare_raw_vs_processed(table, domain, f"\\\\adm.aarhuskommune.dk\\AAK\\Faelles\\MKB\\BackofficeDebitor_Rapporter\\processed_{domain.lower()}_files", oc):
                continue
    # check_processed_files("Indbetalinger", "Total", "\\\\adm.aarhuskommune.dk\\AAK\\Faelles\\MKB\\BackofficeDebitor_Rapporter\\processed_total_files", ["Beløb"], oc)
