
    -- ============================================================
    -- Pipeline Script for Opsaetning-Aftalekontotype (Total)
    -- Source:  Opsaetning-Aftalekontotype_Total_Staging
    -- Targets: Opsaetning-Aftalekontotype_Total_Backup, Opsaetning-Aftalekontotype_Total_Typed, Opsaetning-Aftalekontotype
    -- Generated automatically
    -- ============================================================

    USE [BackDataLake-Test];
    GO

    -- A. Ensure Target Tables Exist
    ------------------------------------------------------------
    
    IF OBJECT_ID('[ode].[Opsaetning-Aftalekontotype_Total_Backup]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[Opsaetning-Aftalekontotype_Total_Backup] (
        [Klient] NVARCHAR(MAX) NULL,
    [Sprognøgle] NVARCHAR(MAX) NULL,
    [Aftalekontotype] NVARCHAR(MAX) NULL,
    [Kontotype_tekst] NVARCHAR(MAX) NULL,
    [export_date] NVARCHAR(MAX) NULL,
    [file_origin] NVARCHAR(MAX) NULL,
    [row_number] NVARCHAR(MAX) NULL,
    [etl_version] NVARCHAR(MAX) NULL
        );
    END
    
    
    IF OBJECT_ID('[ode].[Opsaetning-Aftalekontotype_Total_Typed]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[Opsaetning-Aftalekontotype_Total_Typed] (
        [Klient] DECIMAL(15,2) NULL,
    [Sprognøgle] NVARCHAR(255) NULL,
    [Aftalekontotype] NVARCHAR(255) NULL,
    [Kontotype_tekst] NVARCHAR(255) NULL,
    [export_date] DATE NULL,
    [file_origin] NVARCHAR(255) NULL,
    [row_number] INT NULL,
    [etl_version] NVARCHAR(50) NULL
        );
    END
    
    
    IF OBJECT_ID('[ode].[Opsaetning-Aftalekontotype]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[Opsaetning-Aftalekontotype] (
        [Klient] DECIMAL(15,2) NOT NULL,
    [Sprognøgle] NVARCHAR(255) NOT NULL,
    [Aftalekontotype] NVARCHAR(255) NOT NULL,
    [Kontotype_tekst] NVARCHAR(255) NULL,
    [export_date] DATE NULL,
    [file_origin] NVARCHAR(255) NULL,
    [row_number] INT NULL,
    [etl_version] NVARCHAR(50) NULL,
    CONSTRAINT [PK_Opsaetning-Aftalekontotype] PRIMARY KEY CLUSTERED ([Klient], [Sprognøgle], [Aftalekontotype])
        );
    END
    
    GO

    -- B. Execute Pipeline Steps
    ------------------------------------------------------------
    
    
    -- 1. BACKUP: Copy raw data from Staging to Backup
    INSERT INTO [ode].[Opsaetning-Aftalekontotype_Total_Backup] (
        [Klient],
    [Sprognøgle],
    [Aftalekontotype],
    [Kontotype_tekst],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    )
    SELECT
        [Klient],
    [Sprognøgle],
    [Aftalekontotype],
    [Kontotype_tekst],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    FROM [ode].[Opsaetning-Aftalekontotype_Total_Staging];
    
    GO
    
    
    -- 2. TYPED: Transform and insert into Typed history
    --    Note: Rows with invalid Primary Keys after conversion are skipped here but exist in Backup.
    WITH transformed_data AS (
        SELECT
        CASE
            WHEN [Klient] IS NULL OR [Klient] = '' OR [Klient] = '0' THEN NULL
            WHEN [Klient] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Klient], LEN([Klient])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Klient], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Klient],
    LTRIM(RTRIM([Sprognøgle])) AS [Sprognøgle],
    LTRIM(RTRIM([Aftalekontotype])) AS [Aftalekontotype],
    LTRIM(RTRIM([Kontotype_tekst])) AS [Kontotype_tekst],
    CASE
            WHEN [export_date] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([export_date]) = 8 AND [export_date] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [export_date], 112)
            WHEN [export_date] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [export_date], 104)
            ELSE TRY_CONVERT(DATE, [export_date], 23)
        END AS [export_date],
    LTRIM(RTRIM([file_origin])) AS [file_origin],
    TRY_CAST(REPLACE([row_number], '.', '') AS INT) AS [row_number],
    LTRIM(RTRIM([etl_version])) AS [etl_version]
        FROM [ode].[Opsaetning-Aftalekontotype_Total_Staging]
    ),
    valid_data AS (
        SELECT *,
            ROW_NUMBER() OVER (PARTITION BY [Klient], [Sprognøgle], [Aftalekontotype] ORDER BY (SELECT NULL)) as rn
        FROM transformed_data
        WHERE [Klient] IS NOT NULL AND [Sprognøgle] IS NOT NULL AND [Aftalekontotype] IS NOT NULL
    )
    INSERT INTO [ode].[Opsaetning-Aftalekontotype_Total_Typed] (
        [Klient],
    [Sprognøgle],
    [Aftalekontotype],
    [Kontotype_tekst],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    )
    SELECT
        [Klient],
    [Sprognøgle],
    [Aftalekontotype],
    [Kontotype_tekst],
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
        CASE
            WHEN [Klient] IS NULL OR [Klient] = '' OR [Klient] = '0' THEN NULL
            WHEN [Klient] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Klient], LEN([Klient])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Klient], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Klient],
    LTRIM(RTRIM([Sprognøgle])) AS [Sprognøgle],
    LTRIM(RTRIM([Aftalekontotype])) AS [Aftalekontotype],
    LTRIM(RTRIM([Kontotype_tekst])) AS [Kontotype_tekst],
    CASE
            WHEN [export_date] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([export_date]) = 8 AND [export_date] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [export_date], 112)
            WHEN [export_date] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [export_date], 104)
            ELSE TRY_CONVERT(DATE, [export_date], 23)
        END AS [export_date],
    LTRIM(RTRIM([file_origin])) AS [file_origin],
    TRY_CAST(REPLACE([row_number], '.', '') AS INT) AS [row_number],
    LTRIM(RTRIM([etl_version])) AS [etl_version],
                ROW_NUMBER() OVER (PARTITION BY [Klient], [Sprognøgle], [Aftalekontotype] ORDER BY (SELECT NULL)) as rn
            FROM [ode].[Opsaetning-Aftalekontotype_Total_Staging]
        ) t WHERE rn = 1 AND [Klient] IS NOT NULL AND [Sprognøgle] IS NOT NULL AND [Aftalekontotype] IS NOT NULL
    )
    INSERT INTO [ode].[Opsaetning-Aftalekontotype] ([Klient], [Sprognøgle], [Aftalekontotype], [Kontotype_tekst], [export_date], [file_origin], [row_number], [etl_version])
    SELECT [Klient], [Sprognøgle], [Aftalekontotype], [Kontotype_tekst], [export_date], [file_origin], [row_number], [etl_version] FROM new_data;
    
    GO

    
    -- D. Validation Metrics
    ------------------------------------------------------------
    SELECT 
        'ROW_COUNTS' as metric,
        (SELECT COUNT(*) FROM [ode].[Opsaetning-Aftalekontotype_Total_Staging]) as source_rows,
        (SELECT COUNT(*) FROM [ode].[Opsaetning-Aftalekontotype]) as target_rows;
    
    GO

    -- C. Cleanup (Optional - Staging table usually kept until file move is confirmed)
    DROP TABLE [ode].[Opsaetning-Aftalekontotype_Total_Staging];
    GO
    