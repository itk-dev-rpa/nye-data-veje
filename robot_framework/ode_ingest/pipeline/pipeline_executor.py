"""
pipeline_executor.py

Execute data pipelines with configurable source/target databases.
"""
from pathlib import Path
from typing import Optional
from sqlalchemy import Engine, create_engine

from robot_framework import config
from robot_framework.ode_ingest.pipeline_config import (
    Pipeline, PipelineStep, DatabaseType, DataSubset
)
from robot_framework.ode_ingest.utils import db_utils
from robot_framework.ode_ingest import table_columns


class PipelineExecutor:
    """Execute pipeline steps with configurable databases."""
    
    def __init__(self, engine: Engine, orchestrator_connection=None):
        self.engine = engine
        self.oc = orchestrator_connection
    
    def log(self, message: str, level: str = "info"):
        """Log message to orchestrator or console."""
        if self.oc:
            if level == "error":
                self.oc.log_error(message)
            else:
                self.oc.log_trace(message)
        else:
            print(f"[{level.upper()}] {message}")
    
    def execute_pipeline(self, pipeline: Pipeline, table_name: str, 
                        staging_data_loaded: bool = True) -> dict:
        """
        Execute a complete pipeline for a table.
        
        Args:
            pipeline: Pipeline configuration to execute
            table_name: Base table name (e.g., "Aftaleindhold")
            staging_data_loaded: Whether data is already in staging
            
        Returns:
            Statistics dictionary with results from each step
        """
        stats = {
            'table': table_name,
            'pipeline': pipeline.name,
            'steps': [],
            'errors': []
        }
        
        self.log(f"Starting pipeline '{pipeline.name}' for {table_name}")
        self.log(f"  {pipeline.get_step_description()}")
        
        for idx, step in enumerate(pipeline.steps, 1):
            self.log(f"Step {idx}/{len(pipeline.steps)}: "
                    f"{step.source_db.value} → {step.target_db.value}")
            
            try:
                step_stats = self.execute_step(step, table_name)
                stats['steps'].append(step_stats)
                
                self.log(f"  ✓ {step_stats['rows_affected']} rows affected")
                
            except Exception as e:
                error_msg = f"Error in step {idx}: {str(e)}"
                self.log(error_msg, "error")
                stats['errors'].append(error_msg)
                break  # Stop pipeline on error
        
        return stats
    
    def execute_step(self, step: PipelineStep, table_name: str) -> dict:
        """
        Execute a single pipeline step.
        
        Returns:
            Statistics about the step execution
        """
        source_table = step.get_source_table_name(table_name)
        target_table = step.get_target_table_name(table_name)
        
        # Get primary keys if needed
        primary_keys = None
        if step.use_primary_key:
            primary_keys = table_columns.table_keys.get(table_name, [])
        
        # Get row counts
        rows_before = self._get_row_count(target_table, create_if_missing=True)
        
        # Determine transformation type based on target database
        if step.target_db == DatabaseType.BACKUP:
            # Backup: just copy raw data
            rows_affected = self._copy_raw_data(
                source_table, target_table, 
                add_load_date=step.add_load_date
            )
        elif step.target_db == DatabaseType.TYPED:
            # Typed: apply transformations
            rows_affected = self._transform_and_load(
                source_table, target_table, table_name,
                primary_keys, add_load_date=step.add_load_date
            )
        elif step.target_db == DatabaseType.COMBI:
            # Combi: merge from typed
            rows_affected = self._merge_to_combi(
                source_table, target_table, table_name, primary_keys
            )
        else:
            raise ValueError(f"Unknown target database type: {step.target_db}")
        
        rows_after = self._get_row_count(target_table)
        
        return {
            'source': source_table,
            'target': target_table,
            'rows_before': rows_before,
            'rows_after': rows_after,
            'rows_affected': rows_affected,
        }
    
    def _get_row_count(self, table_name: str, create_if_missing: bool = False) -> int:
        """Get row count, optionally creating table if it doesn't exist."""
        try:
            return db_utils.get_table_row_count(table_name, self.engine)
        except:
            if create_if_missing:
                # Table doesn't exist, will be created during insert
                return 0
            raise
    
    def _copy_raw_data(self, source_table: str, target_table: str, 
                      add_load_date: bool) -> int:
        """Copy raw data without transformation (for backup)."""
        from sqlalchemy import text
        
        # Get columns from source
        columns = db_utils.get_column_list(source_table, self.engine)
        col_list = ", ".join([f"[{col}]" for col in columns])
        
        load_date_clause = ""
        if add_load_date:
            load_date_clause = ", GETDATE() AS LoadDate"
        
        # Simple INSERT from source to target
        insert_sql = f"""
        INSERT INTO [{config.DB_SCHEMA}].[{target_table}] 
        ({col_list}{', LoadDate' if add_load_date else ''})
        SELECT {col_list}{load_date_clause}
        FROM [{config.DB_SCHEMA}].[{source_table}]
        """
        
        with self.engine.begin() as conn:
            result = conn.execute(text(insert_sql))
            return result.rowcount
    
    def _transform_and_load(self, source_table: str, target_table: str,
                           base_table_name: str, primary_keys: Optional[list[str]],
                           add_load_date: bool) -> int:
        """Transform data using generated SQL scripts."""
        # This would use your existing generate_transform_sql logic
        # but with configurable source/target tables
        
        from robot_framework.ode_ingest.generate_transform_sql import (
            generate_column_conversion
        )
        
        schema_dict = table_columns.data_types.get(base_table_name)
        if not schema_dict:
            raise ValueError(f"No schema definition for {base_table_name}")
        
        # Generate transformations
        conversions = []
        for col_name, col_type in schema_dict.items():
            conversions.append(generate_column_conversion(col_name, col_type))
        
        # Build INSERT with transformations
        # (simplified - you'd want to reuse more from generate_transform_sql)
        from sqlalchemy import text
        
        with self.engine.begin() as conn:
            # Create target table if needed
            # Then insert transformed data
            # This is where you'd integrate your existing transformation logic
            pass
        
        return 0  # Return actual row count
    
    def _merge_to_combi(self, source_table: str, target_table: str,
                       base_table_name: str, primary_keys: list[str]) -> int:
        """Merge typed data into combi table."""
        # Use existing merge logic from db_utils
        import pandas as pd
        
        # Read from typed table
        query = f"SELECT * FROM [{config.DB_SCHEMA}].[{source_table}]"
        df = pd.read_sql(query, self.engine)
        
        # Merge into combi
        from robot_framework.ode_ingest.utils.db_utils import merge_table_from_dataframe
        merge_table_from_dataframe(df, target_table, self.engine)
        
        return len(df)
