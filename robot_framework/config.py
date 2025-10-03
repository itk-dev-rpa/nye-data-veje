"""Configurations for this robot."""

DB_SCHEMA = "ode"
DB_NAME = "BackDataLake-Test"
DB_CONNECTION = "NDV Connection String"
DATA_DIRECTORY = "NDV File Directory"

# Error screenshot config
SMTP_SERVER = "smtp.adm.aarhuskommune.dk"
SMTP_PORT = 25
SCREENSHOT_SENDER = "robot@friend.dk"

# The number of times the robot retries on an error before terminating.
MAX_RETRY_COUNT = 3

CSV_CONFIG = {
    'sep': ';',
    'decimal': ',',
    'thousands': '.',
    'na_values': ['', ' ', 'nan', 'NaN', 'NULL', 'null', '-', 'N/A'],
    'keep_default_na': True,
    'skipinitialspace': True,
}

ENCODINGS = ['utf-8', 'latin-1', 'cp1252']

DATE_FORMATS = [
    '%d-%m-%Y', '%d/%m/%Y', '%Y%m%d', '%Y-%m-%d', '%d.%m.%Y', '%d-%m-%y', '%d/%m/%y',
]