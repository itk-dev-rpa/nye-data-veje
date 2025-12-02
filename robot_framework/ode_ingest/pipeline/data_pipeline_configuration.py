
"""
pipeline_config.py

Configuration for data pipelines defining how data flows through different databases.
"""
from enum import Enum
from dataclasses import dataclass
from typing import Optional


class DatabaseType(Enum):
    """Types of databases in our pipeline."""
    STAGING = "Staging"       # Raw data, all strings, temporary
    BACKUP = "Backup"          # Raw text backup, permanent
    TYPED = "Typed"            # Transformed and typed data
    COMBI = "Combi"            # Combined snapshot view


class DataSubset(Enum):
    """Type of data extraction."""
    DELTA = "Delta"            # Incremental changes
    TOTAL = "Total"            # Full snapshot


@dataclass
class PipelineStep:
    """Defines a single transformation step in the pipeline."""
    source_db: DatabaseType
    target_db: DatabaseType
    data_subset: DataSubset
    use_primary_key: bool
    add_load_date: bool = False
    add_etl_metadata: bool = True
    
    def get_source_table_name(self, base_table: str) -> str:
        """Generate source table name based on configuration."""
        parts = [base_table, self.data_subset.value]
        if self.source_db != DatabaseType.STAGING:
            parts.append(self.source_db.value)
        return "_".join(parts)
    
    def get_target_table_name(self, base_table: str) -> str:
        """Generate target table name based on configuration."""
        return f"{base_table}_{self.data_subset.value}_{self.target_db.value}"


@dataclass
class Pipeline:
    """Defines a complete data pipeline with multiple steps."""
    name: str
    steps: list[PipelineStep]
    
    def get_step_description(self) -> str:
        """Get human-readable description of pipeline."""
        steps_desc = " → ".join([
            f"{step.source_db.value} to {step.target_db.value}"
            for step in self.steps
        ])
        return f"{self.name}: {steps_desc}"


# ============================================================
# PREDEFINED PIPELINES
# ============================================================

# Pipeline for delta data: Staging → Backup → Typed → Combi
DELTA_PIPELINE = Pipeline(
    name="Delta Processing",
    steps=[
        PipelineStep(
            source_db=DatabaseType.STAGING,
            target_db=DatabaseType.BACKUP,
            data_subset=DataSubset.DELTA,
            use_primary_key=False,  # Backup keeps all versions
            add_load_date=True,
        ),
        PipelineStep(
            source_db=DatabaseType.STAGING,
            target_db=DatabaseType.TYPED,
            data_subset=DataSubset.DELTA,
            use_primary_key=False,  # Typed keeps all versions
            add_load_date=True,
        ),
        PipelineStep(
            source_db=DatabaseType.TYPED,
            target_db=DatabaseType.COMBI,
            data_subset=DataSubset.DELTA,
            use_primary_key=True,  # Combi shows latest state
            add_load_date=False,
        ),
    ]
)

# Pipeline for total data: Staging → Backup → Typed
TOTAL_PIPELINE = Pipeline(
    name="Total Data Processing",
    steps=[
        PipelineStep(
            source_db=DatabaseType.STAGING,
            target_db=DatabaseType.BACKUP,
            data_subset=DataSubset.TOTAL,
            use_primary_key=False,
            add_load_date=True,
        ),
        PipelineStep(
            source_db=DatabaseType.STAGING,
            target_db=DatabaseType.TYPED,
            data_subset=DataSubset.TOTAL,
            use_primary_key=True,
            add_load_date=True,
        ),
    ]
)
