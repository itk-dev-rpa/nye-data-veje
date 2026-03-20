from dataclasses import dataclass, field
from typing import Optional, Dict, List, Any, Union
from sqlalchemy import String, Date, Integer

@dataclass
class TableDefinition:
    """Defines the contract for a generic table configuration."""
    name: str
    data_types: Dict[str, Any]  # Maps column name to SQLAlchemy type
    ignored_columns: Dict[str, Any] = field(default_factory=dict)
    keys: Optional[List[str]] = None
    date_columns: Optional[Union[List[str], str]] = None
    column_aliases: Dict[str, str] = field(default_factory=dict)

    @property
    def used_columns(self) -> List[str]:
        """Returns the list of columns to be imported, derived from data_types keys."""
        return list(self.data_types.keys())

# Common metadata columns used across all tables
metadata_columns = {
    'export_date': Date,
    'file_origin': String(255),
    'row_number': Integer,
    'etl_version': String(50)
}