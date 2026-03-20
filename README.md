# ODE Data Integration Pipeline

ETL pipeline for ingesting and transforming KMD Opus ODE Debitor data into SQL Server.

## Overview

This pipeline extracts data from KMD Opus ODE Debitor CSV exports, validates and transforms the data through multiple stages, and loads it into a SQL Server data warehouse. The pipeline is built on the OpenOrchestrator RPA framework.

## Architecture

### Pipeline Stages

The pipeline processes data through four stages:

1. **Staging** - Raw CSV data loaded with metadata tracking
2. **Backup** - Historical snapshot of staging data
3. **Typed** - Type-converted and validated data with primary key enforcement
4. **Snapshot** - Latest version of each record (upsert based on primary keys)

Each table is processed in two variants:
- **Total** - Full exports from source system
- **Delta** - Incremental changes only

### Data Flow

```
CSV Files (Total/Delta)
    ↓
[Ingestion] → Staging Tables
    ↓
[Backup SQL] → Backup Tables
    ↓
[Transform SQL] → Typed Tables (validation, type conversion)
    ↓
[Snapshot SQL] → Snapshot Tables (latest state)
```

## Project Structure

```
robot_framework/
├── process.py                      # Main ETL orchestration
├── config.py                       # Configuration constants
├── ode_ingest/
│   ├── table_definitions/          # Schema definitions (single source of truth)
│   │   ├── __init__.py            # Consolidated exports
│   │   ├── common.py              # TableDefinition dataclass
│   │   ├── aftaler.py             # Agreement tables
│   │   ├── bilag.py               # Invoice/document tables
│   │   ├── betalinger.py          # Payment tables
│   │   ├── rim.py                 # Installment agreement tables
│   │   └── stamdata.py            # Master data tables
│   ├── generate_transform_sql.py  # SQL script generation
│   ├── run_sql_transforms.py      # SQL execution with validation
│   └── utils/
│       ├── ingest_utils.py        # File processing and logging
│       ├── dataframe_utils.py     # DataFrame operations
│       ├── data_cleaning.py       # Data cleaning utilities
│       ├── date_utils.py          # Date conversion
│       ├── number_utils.py        # Number conversion
│       ├── file_utils.py          # File system operations
│       └── db_utils.py            # Database operations
```

## Key Features

### Schema-Driven Architecture

All table schemas are defined once using `TableDefinition` dataclass:

```python
bilag_master = TableDefinition(
    name="Bilag-master",
    keys=["Bilagsnummer", "Gentagelsesposition", "Position", "Delposition"],
    data_types={
        "Gentagelsesposition": Integer,
        "Registreringsdato": Date,
        "Beløb": Numeric(precision=15, scale=2),
        ...
    },
    column_aliases={'Bilagstype': 'Bilagsart'}
)
```

From these definitions, the pipeline automatically:
- Detects date columns from SQLAlchemy types
- Generates SQL transformation scripts
- Creates database tables with correct types
- Validates primary keys
- Applies column renames

### In-Memory SQL Generation

SQL transformation scripts are generated in-memory during execution rather than stored as files. This reduces git 
noise while maintaining debuggability. However, the scripts are still generated and stored in the `sql_transforms` 
directory.

### Metadata Tracking

Every row includes audit columns added during ingestion:
- `export_date` - Date from filename
- `file_origin` - Source filename
- `row_number` - Row number in original file
- `etl_version` - ETL pipeline version

### Validation & Logging

- Primary key validation with detailed error reporting
- Type conversion with date/number format handling
- Row-level validation logs in `transform_validation.json`
- Ingestion statistics logged to `ode.Data_Ingest_Log` table

## Data Domains

The pipeline processes five main data domains:

1. **Aftaler** (Agreements) - Payment plans, bankruptcy agreements, debt collection
2. **Bilag** (Invoices) - Master records, open and closed invoices
3. **Betalinger** (Payments) - Incoming payments and reminders
4. **RIM** (Installment Agreements) - Installment plans, schedules, and interest
5. **Stamdata** (Master Data) - Business partners, correspondence, client data

## Configuration

Key configuration in `config.py`:
- `DB_SCHEMA` - Target database schema (default: `ode`)
- `DB_NAME` - Target database name (default: `BackDataLake-Test`)
- `DB_CONNECTION` - OpenOrchestrator constant name for connection string
- `DATA_DIRECTORY` - OpenOrchestrator constant name for file directory
- `ENCODINGS` - CSV encoding fallback order (`['utf-8', 'latin-1', 'cp1252']`)
- `DATE_FORMATS` - Supported date formats for parsing

### OpenOrchestrator Configuration

OpenOrchestrator requires two constants:

```
NDV File Directory = \\adm.aarhuskommune.dk\AAK\Faelles\MKB\BackofficeDebitor_Rapporter
NDV Connection String = mssql+pyodbc://@SRVSQLHOTEL05/BackDataLake-Test?trusted_connection=yes&driver=ODBC+Driver+17+for+SQL+Server
```

## Running the Pipeline

The pipeline is executed through OpenOrchestrator via `robot_framework/process.py`.

### File Processing

The pipeline automatically discovers and processes files matching the pattern:
```
{TableName}_{Total|Delta}_YYYY-MM-DD*.csv
```

Files are processed in chronological order based on the date in the filename. After successful processing, files are moved to an archive folder.

## SQL Transformation Logic

Transformations are generated per-table and handle:

1. **Backup** - Copy staging → backup with timestamp
2. **Type Conversion** - Cast strings to proper types (dates, numbers)
3. **Primary Key Enforcement** - Deduplicate based on keys + metadata
4. **Snapshot Upsert** - MERGE into snapshot tables (latest version)

Validation metrics are captured at each stage and logged to JSON.

### Regenerating SQL Scripts

SQL transformation scripts are generated in-memory during execution. To generate scripts as files for debugging:

```bash
python robot_framework/ode_ingest/generate_transform_sql.py
```

Scripts will be written to `robot_framework/ode_ingest/sql_transforms/` (git-ignored).

## Dependencies

- **Python 3.11+**
- **SQLAlchemy** - Database abstraction and type definitions
- **Pandas** - DataFrame operations
- **OpenOrchestrator** - RPA framework for credential management
- **SQL Server** - Target data warehouse

Install dependencies:
```bash
pip install -r requirements.txt
```

## Design Principles

1. **Single Source of Truth** - Schema defined once in `table_definitions/`
2. **Type Safety** - SQLAlchemy types drive validation and conversion
3. **Auditability** - Full lineage tracking with metadata columns
4. **Idempotency** - Re-running same file produces same result
5. **Separation of Concerns** - Clear boundaries between ingestion, transformation, and loading

## Troubleshooting

### Validation Errors

Check `transform_validation.json` for detailed validation metrics from SQL transformations. Each transformation logs:
- Row counts at each stage
- Rows inserted/updated in snapshot
- Any validation failures

### Encoding Issues

The pipeline tries multiple encodings in order: `utf-8`, `latin-1`, `cp1252`. If files fail to load, check the encoding and add it to `config.ENCODINGS`.

### Date Parsing Failures

Date columns are automatically detected from SQLAlchemy `Date` types. The pipeline tries multiple formats defined in `config.DATE_FORMATS`. Invalid dates are logged and the rows are filtered out.

### Primary Key Violations

If duplicate primary keys are found (after accounting for metadata), the pipeline keeps the row with the highest `row_number`. Check the source files for true duplicates.
