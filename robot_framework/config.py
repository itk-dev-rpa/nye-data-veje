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
