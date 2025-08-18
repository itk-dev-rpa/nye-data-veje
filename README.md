# ODE Ingest from KMD Opus Debitor to SQL
This is a repo for mapping data from KMD Opus Debitor through ODE extracted files.

# Usage
The scripts are designed to be run through OpenOrchestrator.
In OO, you must provide the following process arguments:
```
'{
        "create_table": False,
        "insert_total_data": False,
        "insert_delta_data": True,
        "from_to_date": None
}'
```
The arguments above will be used to update delta data daily, and will be the most common usage scenario.
If you need to set up new tables or reload total data, you should set create_table and/or insert_total_data to True.
Use "from_to_date": ["01011999", "01012025"] to define a date range for total data ingest.

OO also needs two constants present:
```
NDV File Directory = \\\\adm.aarhuskommune.dk\\AAK\\Faelles\\MKB\\BackofficeDebitor_Rapporter
```
```
NDV Connection String = mssql+pyodbc://@SRVSQLHOTEL05/BackDataLake-Test?trusted_connection=yes&driver=ODBC+Driver+17+for+SQL+Server
```