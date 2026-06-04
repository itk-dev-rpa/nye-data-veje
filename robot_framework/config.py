"""Configurations for this robot."""
# The number of times the robot retries on an error before terminating.
MAX_RETRY_COUNT = 3

# Whether the robot should be marked as failed if MAX_RETRY_COUNT is reached.
FAIL_ROBOT_ON_TOO_MANY_ERRORS = True

# Error screenshot config
SMTP_SERVER = "smtp.adm.aarhuskommune.dk"
SMTP_PORT = 25
SCREENSHOT_SENDER = "robot@friend.dk"

# Constant/Credential names
ERROR_EMAIL = "Error Email"
DB_CONNECTION = "NDV Connection String"
DATA_DIRECTORY = "NDV File Directory"

ENCODINGS = ['utf-8', 'latin-1', 'cp1252']

DATE_FORMATS = [
    '%d-%m-%Y', '%d/%m/%Y', '%Y%m%d', '%Y-%m-%d', '%d.%m.%Y', '%d-%m-%y', '%d/%m/%y',
]

TABLES_TO_PROCESS = None  # None = all, eller en liste
DB_SCHEMA = "ode"
DB_NAME = "BackDataLake-Test"
