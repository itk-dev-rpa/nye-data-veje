"""Common table definition structures.

This module provides the base dataclass for table definitions used
throughout the ODE ingestion pipeline.
"""
from dataclasses import dataclass, field
from typing import Optional, Dict, List, Any


@dataclass
class TableDefinition:
    """Schema definition for a single table in the ODE data model.

    This dataclass encapsulates all schema information needed for processing
    a table through the ETL pipeline.

    Attributes:
        name: Table name as it appears in the source files and database
        data_types: Dictionary mapping column names to SQLAlchemy types (Date columns are auto-detected from types)
        ignored_columns: Columns present in source but not imported
        keys: List of column names forming the primary key (None if no PK)
        column_aliases: Mapping of old column names to new names (for renames)

    Properties:
        used_columns: Derived list of column names to import (from data_types keys)
    """
    name: str
    data_types: Dict[str, Any]  # Maps column name to SQLAlchemy type
    ignored_columns: Dict[str, Any] = field(default_factory=dict)
    keys: Optional[List[str]] = None
    column_aliases: Dict[str, str] = field(default_factory=dict)

    @property
    def used_columns(self) -> List[str]:
        """Returns the list of columns to be imported, derived from data_types keys."""
        return list(self.data_types.keys())
