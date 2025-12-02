"""
run_pipeline.py

Main entry point for running data pipelines.
"""
from pathlib import Path
from sqlalchemy import create_engine
from OpenOrchestrator.orchestrator_connection.connection import OrchestratorConnection

from robot_framework import config
from robot_framework.ode_ingest.pipeline.pipeline_config import DELTA_PIPELINE, TOTAL_PIPELINE
from robot_framework.ode_ingest.pipeline.pipeline_executor import PipelineExecutor
from robot_framework.ode_ingest import table_columns


def run_delta_pipeline(tables: list[str], oc: OrchestratorConnection):
    """Run delta processing pipeline for specified tables."""
    connection_string = oc.get_constant(config.DB_CONNECTION).value
    engine = create_engine(connection_string)
    
    executor = PipelineExecutor(engine, oc)
    
    all_stats = []
    
    for table in tables:
        print(f"\n{'='*70}")
        print(f"Processing {table}")
        print(f"{'='*70}")
        
        stats = executor.execute_pipeline(DELTA_PIPELINE, table)
        all_stats.append(stats)
        
        if stats['errors']:
            print(f"✗ Errors occurred for {table}")
            for error in stats['errors']:
                print(f"  - {error}")
        else:
            print(f"✓ Successfully completed pipeline for {table}")
    
    return all_stats


def run_total_pipeline(tables: list[str], oc: OrchestratorConnection):
    """Run total data processing pipeline for specified tables."""
    connection_string = oc.get_constant(config.DB_CONNECTION).value
    engine = create_engine(connection_string)
    
    executor = PipelineExecutor(engine, oc)
    
    all_stats = []
    
    for table in tables:
        print(f"\n{'='*70}")
        print(f"Processing {table}")
        print(f"{'='*70}")
        
        stats = executor.execute_pipeline(TOTAL_PIPELINE, table)
        all_stats.append(stats)
    
    return all_stats


if __name__ == "__main__":
    import os
    
    conn_string = os.getenv("OpenOrchestratorConnString")
    crypto_key = os.getenv("OpenOrchestratorKey")
    oc = OrchestratorConnection("ODE test", conn_string, crypto_key, "")
    
    # Example: Process delta for all tables
    all_tables = list(table_columns.data_types.keys())
    
    print("Running DELTA pipeline...")
    run_delta_pipeline(all_tables, oc)
