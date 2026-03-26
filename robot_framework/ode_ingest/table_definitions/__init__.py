"""Table definitions for KMD Opus ODE Debitor data.

This module consolidates all table schema definitions from various domain modules
(bilag, aftaler, rim, betalinger, stamdata) and provides centralized dictionaries
used throughout the application for type conversion, validation, and SQL generation.

The definitions use a dataclass-based approach (TableDefinition) to maintain
schema information including:
- Column data types (SQLAlchemy types) - Date columns are auto-detected from types
- Primary keys
- Column aliases for renamed fields
- Metadata columns added during ingestion

Usage:
    from robot_framework.ode_ingest.table_definitions import data_types, table_keys
"""
from typing import List
from sqlalchemy import String, Date, Integer
from .common import TableDefinition

# Import definition groups
from . import bilag
from . import aftaler
from . import rim
from . import betalinger
from . import stamdata

# 1. Collect all definitions into a single list
_all_definitions: List[TableDefinition] = (
    bilag.definitions +
    aftaler.definitions +
    rim.definitions +
    betalinger.definitions +
    stamdata.definitions
)

# 2. Generate convenient dictionary interfaces from TableDefinition objects
# These provide backward-compatible access patterns used throughout the codebase

# The master list of table names (The "Single Source of Truth" list)
ALL_TABLE_NAMES = [d.name for d in _all_definitions]

# Flattened dictionaries (auto-generated from TableDefinition objects)
all_tables = {d.name: d for d in _all_definitions}

# Metadata columns added to all tables during ingestion
metadata_columns = {
    'export_date': Date,         # Date extracted from filename (YYYY-MM-DD)
    'file_origin': String(255),  # Original filename
    'row_number': Integer,       # Row number within the file
    'etl_version': String(50)    # Version from pyproject.toml
}
