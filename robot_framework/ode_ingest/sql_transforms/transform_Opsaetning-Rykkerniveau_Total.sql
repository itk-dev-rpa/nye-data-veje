
    -- ============================================================
    -- Pipeline Script for Opsaetning-Rykkerniveau (Total)
    -- Source:  Opsaetning-Rykkerniveau_Total_Staging
    -- Targets: Opsaetning-Rykkerniveau_Total_Backup, Opsaetning-Rykkerniveau_Total_Typed, Opsaetning-Rykkerniveau
    -- Generated automatically
    -- ============================================================

    USE [BackDataLake-Test];
    GO

    -- A. Ensure Target Tables Exist
    ------------------------------------------------------------
    
    IF OBJECT_ID('[ode].[Opsaetning-Rykkerniveau_Total_Backup]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[Opsaetning-Rykkerniveau_Total_Backup] (
        [Sprognøgle] NVARCHAR(MAX) NULL,
    [Rykkeprocedure] NVARCHAR(MAX) NULL,
    [Rykkeniveau] NVARCHAR(MAX) NULL,
    [Betegnelse] NVARCHAR(MAX) NULL,
    [Kommune_kode] NVARCHAR(MAX) NULL,
    [export_date] NVARCHAR(MAX) NULL,
    [file_origin] NVARCHAR(MAX) NULL,
    [row_number] NVARCHAR(MAX) NULL,
    [etl_version] NVARCHAR(MAX) NULL
        );
    END
    
    
    IF OBJECT_ID('[ode].[Opsaetning-Rykkerniveau_Total_Typed]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[Opsaetning-Rykkerniveau_Total_Typed] (
        [Sprognøgle] NVARCHAR(255) NULL,
    [Rykkeprocedure] NVARCHAR(255) NULL,
    [Rykkeniveau] INT NULL,
    [Betegnelse] NVARCHAR(255) NULL,
    [Kommune_kode] NVARCHAR(255) NULL,
    [export_date] DATE NULL,
    [file_origin] NVARCHAR(255) NULL,
    [row_number] INT NULL,
    [etl_version] NVARCHAR(50) NULL
        );
    END
    
    
    IF OBJECT_ID('[ode].[Opsaetning-Rykkerniveau]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[Opsaetning-Rykkerniveau] (
        [Sprognøgle] NVARCHAR(255) NOT NULL,
    [Rykkeprocedure] NVARCHAR(255) NOT NULL,
    [Rykkeniveau] INT NOT NULL,
    [Betegnelse] NVARCHAR(255) NULL,
    [Kommune_kode] NVARCHAR(255) NULL,
    [export_date] DATE NULL,
    [file_origin] NVARCHAR(255) NULL,
    [row_number] INT NULL,
    [etl_version] NVARCHAR(50) NULL,
    CONSTRAINT [PK_Opsaetning-Rykkerniveau] PRIMARY KEY CLUSTERED ([Sprognøgle], [Rykkeprocedure], [Rykkeniveau])
        );
    END
    
    GO

    -- B. Execute Pipeline Steps
    ------------------------------------------------------------
    
    
    -- 1. BACKUP: Copy raw data from Staging to Backup
    INSERT INTO [ode].[Opsaetning-Rykkerniveau_Total_Backup] (
        [Sprognøgle],
    [Rykkeprocedure],
    [Rykkeniveau],
    [Betegnelse],
    [Kommune_kode],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    )
    SELECT
        [Sprognøgle],
    [Rykkeprocedure],
    [Rykkeniveau],
    [Betegnelse],
    [Kommune_kode],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    FROM [ode].[Opsaetning-Rykkerniveau_Total_Staging];
    
    GO
    
    
    -- 2. TYPED: Transform and insert into Typed history
    --    Note: Rows with invalid Primary Keys after conversion are skipped here but exist in Backup.
    WITH transformed_data AS (
        SELECT
        LTRIM(RTRIM([Sprognøgle])) AS [Sprognøgle],
    LTRIM(RTRIM([Rykkeprocedure])) AS [Rykkeprocedure],
    TRY_CAST(REPLACE([Rykkeniveau], '.', '') AS INT) AS [Rykkeniveau],
    LTRIM(RTRIM([Betegnelse])) AS [Betegnelse],
    LTRIM(RTRIM([Kommune_kode])) AS [Kommune_kode],
    CASE
            WHEN [export_date] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([export_date]) = 8 AND [export_date] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [export_date], 112)
            WHEN [export_date] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [export_date], 104)
            ELSE TRY_CONVERT(DATE, [export_date], 23)
        END AS [export_date],
    LTRIM(RTRIM([file_origin])) AS [file_origin],
    TRY_CAST(REPLACE([row_number], '.', '') AS INT) AS [row_number],
    LTRIM(RTRIM([etl_version])) AS [etl_version]
        FROM [ode].[Opsaetning-Rykkerniveau_Total_Staging]
    ),
    valid_data AS (
        SELECT *,
            ROW_NUMBER() OVER (PARTITION BY [Sprognøgle], [Rykkeprocedure], [Rykkeniveau] ORDER BY (SELECT NULL)) as rn
        FROM transformed_data
        WHERE [Sprognøgle] IS NOT NULL AND [Rykkeprocedure] IS NOT NULL AND [Rykkeniveau] IS NOT NULL
    )
    INSERT INTO [ode].[Opsaetning-Rykkerniveau_Total_Typed] (
        [Sprognøgle],
    [Rykkeprocedure],
    [Rykkeniveau],
    [Betegnelse],
    [Kommune_kode],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    )
    SELECT
        [Sprognøgle],
    [Rykkeprocedure],
    [Rykkeniveau],
    [Betegnelse],
    [Kommune_kode],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    FROM valid_data
    WHERE rn = 1;
    
    GO
    
    
    -- 3. SNAPSHOT: Insert total, expecting no duplicates

    
    WITH new_data AS (
        SELECT * FROM (
            SELECT
        LTRIM(RTRIM([Sprognøgle])) AS [Sprognøgle],
    LTRIM(RTRIM([Rykkeprocedure])) AS [Rykkeprocedure],
    TRY_CAST(REPLACE([Rykkeniveau], '.', '') AS INT) AS [Rykkeniveau],
    LTRIM(RTRIM([Betegnelse])) AS [Betegnelse],
    LTRIM(RTRIM([Kommune_kode])) AS [Kommune_kode],
    CASE
            WHEN [export_date] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([export_date]) = 8 AND [export_date] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [export_date], 112)
            WHEN [export_date] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [export_date], 104)
            ELSE TRY_CONVERT(DATE, [export_date], 23)
        END AS [export_date],
    LTRIM(RTRIM([file_origin])) AS [file_origin],
    TRY_CAST(REPLACE([row_number], '.', '') AS INT) AS [row_number],
    LTRIM(RTRIM([etl_version])) AS [etl_version],
                ROW_NUMBER() OVER (PARTITION BY [Sprognøgle], [Rykkeprocedure], [Rykkeniveau] ORDER BY (SELECT NULL)) as rn
            FROM [ode].[Opsaetning-Rykkerniveau_Total_Staging]
        ) t WHERE rn = 1 AND [Sprognøgle] IS NOT NULL AND [Rykkeprocedure] IS NOT NULL AND [Rykkeniveau] IS NOT NULL
    )
    INSERT INTO [ode].[Opsaetning-Rykkerniveau] ([Sprognøgle], [Rykkeprocedure], [Rykkeniveau], [Betegnelse], [Kommune_kode], [export_date], [file_origin], [row_number], [etl_version])
    SELECT [Sprognøgle], [Rykkeprocedure], [Rykkeniveau], [Betegnelse], [Kommune_kode], [export_date], [file_origin], [row_number], [etl_version] FROM new_data;
    
    GO

    
    -- D. Validation Metrics
    ------------------------------------------------------------
    SELECT 
        'ROW_COUNTS' as metric,
        (SELECT COUNT(*) FROM [ode].[Opsaetning-Rykkerniveau_Total_Staging]) as source_rows,
        (SELECT COUNT(*) FROM [ode].[Opsaetning-Rykkerniveau]) as target_rows;
    
    GO

    -- C. Cleanup (Optional - Staging table usually kept until file move is confirmed)
    DROP TABLE [ode].[Opsaetning-Rykkerniveau_Total_Staging];
    GO
    