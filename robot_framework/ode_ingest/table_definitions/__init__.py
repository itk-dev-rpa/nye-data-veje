from typing import List
from .common import TableDefinition, metadata_columns

# Import definition groups
from . import bilag
from . import aftaler
from . import rim
from . import betalinger
from . import stamdata

# 1. Collect all definitions into a single list
_all_definitions: List[TableDefinition] = []
_all_definitions.extend(bilag.definitions)
_all_definitions.extend(aftaler.definitions)
_all_definitions.extend(rim.definitions)
_all_definitions.extend(betalinger.definitions)
_all_definitions.extend(stamdata.definitions)

# 2. Generate the centralized structures used by the application
# This maintains backward compatibility with existing variable names

# The master list of table names (The "Single Source of Truth" list)
ALL_TABLE_NAMES = [d.name for d in _all_definitions]

# Legacy dictionaries (auto-generated from the objects)
table_keys = {d.name: d.keys for d in _all_definitions}
table_used_columns = {d.name: d.used_columns for d in _all_definitions}
table_column_alias = {d.name: d.column_aliases for d in _all_definitions if d.column_aliases}
data_types = {d.name: d.data_types for d in _all_definitions}

# Handle the date columns logic
table_date_columns = {}
for d in _all_definitions:
    table_date_columns[d.name] = d.date_columns
