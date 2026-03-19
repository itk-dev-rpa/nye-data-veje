
    -- ============================================================
    -- Pipeline Script for Forretningspartner (Total)
    -- Source:  Forretningspartner_Total_Staging
    -- Targets: Forretningspartner_Total_Backup, Forretningspartner_Total_Typed, Forretningspartner
    -- Generated automatically
    -- ============================================================

    USE [BackDataLake-Test];
    GO

    -- A. Ensure Target Tables Exist
    ------------------------------------------------------------
    
    IF OBJECT_ID('[ode].[Forretningspartner_Total_Backup]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[Forretningspartner_Total_Backup] (
        [Klient] NVARCHAR(MAX) NULL,
    [Forretningspartner] NVARCHAR(MAX) NULL,
    [Identifikationsart] NVARCHAR(MAX) NULL,
    [Gyldig_fra] NVARCHAR(MAX) NULL,
    [Gyldig_til] NVARCHAR(MAX) NULL,
    [Datafordeleren_UUID] NVARCHAR(MAX) NULL,
    [Forretningspartner-GUID] NVARCHAR(MAX) NULL,
    [BW_Opdateringsmode] NVARCHAR(MAX) NULL,
    [Slettet] NVARCHAR(MAX) NULL,
    [export_date] NVARCHAR(MAX) NULL,
    [file_origin] NVARCHAR(MAX) NULL,
    [row_number] NVARCHAR(MAX) NULL,
    [etl_version] NVARCHAR(MAX) NULL
        );
    END
    
    
    IF OBJECT_ID('[ode].[Forretningspartner_Total_Typed]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[Forretningspartner_Total_Typed] (
        [Klient] NVARCHAR(255) NULL,
    [Forretningspartner] NVARCHAR(255) NULL,
    [Identifikationsart] NVARCHAR(255) NULL,
    [Gyldig_fra] DATE NULL,
    [Gyldig_til] DATE NULL,
    [Datafordeleren_UUID] NVARCHAR(255) NULL,
    [Forretningspartner-GUID] NVARCHAR(255) NULL,
    [BW_Opdateringsmode] NVARCHAR(255) NULL,
    [Slettet] NVARCHAR(255) NULL,
    [export_date] DATE NULL,
    [file_origin] NVARCHAR(255) NULL,
    [row_number] INT NULL,
    [etl_version] NVARCHAR(50) NULL
        );
    END
    
    
    IF OBJECT_ID('[ode].[Forretningspartner]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[Forretningspartner] (
        [Klient] NVARCHAR(255) NOT NULL,
    [Forretningspartner] NVARCHAR(255) NOT NULL,
    [Identifikationsart] NVARCHAR(255) NOT NULL,
    [Gyldig_fra] DATE NULL,
    [Gyldig_til] DATE NULL,
    [Datafordeleren_UUID] NVARCHAR(255) NULL,
    [Forretningspartner-GUID] NVARCHAR(255) NOT NULL,
    [BW_Opdateringsmode] NVARCHAR(255) NULL,
    [Slettet] NVARCHAR(255) NULL,
    [export_date] DATE NULL,
    [file_origin] NVARCHAR(255) NULL,
    [row_number] INT NULL,
    [etl_version] NVARCHAR(50) NULL,
    CONSTRAINT [PK_Forretningspartner] PRIMARY KEY CLUSTERED ([Klient], [Forretningspartner], [Identifikationsart], [Forretningspartner-GUID])
        );
    END
    
    GO

    -- B. Execute Pipeline Steps
    ------------------------------------------------------------
    
    
    -- 1. BACKUP: Copy raw data from Staging to Backup
    INSERT INTO [ode].[Forretningspartner_Total_Backup] (
        [Klient],
    [Forretningspartner],
    [Identifikationsart],
    [Gyldig_fra],
    [Gyldig_til],
    [Datafordeleren_UUID],
    [Forretningspartner-GUID],
    [BW_Opdateringsmode],
    [Slettet],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    )
    SELECT
        [Klient],
    [Forretningspartner],
    [Identifikationsart],
    [Gyldig_fra],
    [Gyldig_til],
    [Datafordeleren_UUID],
    [Forretningspartner-GUID],
    [BW_Opdateringsmode],
    [Slettet],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    FROM [ode].[Forretningspartner_Total_Staging];
    
    GO
    
    
    -- 2. TYPED: Transform and insert into Typed history
    --    Note: Rows with invalid Primary Keys after conversion are skipped here but exist in Backup.
    WITH transformed_data AS (
        SELECT
        LTRIM(RTRIM([Klient])) AS [Klient],
    LTRIM(RTRIM([Forretningspartner])) AS [Forretningspartner],
    LTRIM(RTRIM([Identifikationsart])) AS [Identifikationsart],
    CASE
            WHEN [Gyldig_fra] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Gyldig_fra]) = 8 AND [Gyldig_fra] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Gyldig_fra], 112)
            WHEN [Gyldig_fra] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Gyldig_fra], 104)
            ELSE TRY_CONVERT(DATE, [Gyldig_fra], 23)
        END AS [Gyldig_fra],
    CASE
            WHEN [Gyldig_til] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Gyldig_til]) = 8 AND [Gyldig_til] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Gyldig_til], 112)
            WHEN [Gyldig_til] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Gyldig_til], 104)
            ELSE TRY_CONVERT(DATE, [Gyldig_til], 23)
        END AS [Gyldig_til],
    LTRIM(RTRIM([Datafordeleren_UUID])) AS [Datafordeleren_UUID],
    LTRIM(RTRIM([Forretningspartner-GUID])) AS [Forretningspartner-GUID],
    LTRIM(RTRIM([BW_Opdateringsmode])) AS [BW_Opdateringsmode],
    LTRIM(RTRIM([Slettet])) AS [Slettet],
    CASE
            WHEN [export_date] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([export_date]) = 8 AND [export_date] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [export_date], 112)
            WHEN [export_date] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [export_date], 104)
            ELSE TRY_CONVERT(DATE, [export_date], 23)
        END AS [export_date],
    LTRIM(RTRIM([file_origin])) AS [file_origin],
    TRY_CAST(REPLACE([row_number], '.', '') AS INT) AS [row_number],
    LTRIM(RTRIM([etl_version])) AS [etl_version]
        FROM [ode].[Forretningspartner_Total_Staging]
    ),
    valid_data AS (
        SELECT *,
            ROW_NUMBER() OVER (PARTITION BY [Klient], [Forretningspartner], [Identifikationsart], [Forretningspartner-GUID] ORDER BY (SELECT NULL)) as rn
        FROM transformed_data
        WHERE [Klient] IS NOT NULL AND [Forretningspartner] IS NOT NULL AND [Identifikationsart] IS NOT NULL AND [Forretningspartner-GUID] IS NOT NULL
    )
    INSERT INTO [ode].[Forretningspartner_Total_Typed] (
        [Klient],
    [Forretningspartner],
    [Identifikationsart],
    [Gyldig_fra],
    [Gyldig_til],
    [Datafordeleren_UUID],
    [Forretningspartner-GUID],
    [BW_Opdateringsmode],
    [Slettet],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    )
    SELECT
        [Klient],
    [Forretningspartner],
    [Identifikationsart],
    [Gyldig_fra],
    [Gyldig_til],
    [Datafordeleren_UUID],
    [Forretningspartner-GUID],
    [BW_Opdateringsmode],
    [Slettet],
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
        LTRIM(RTRIM([Klient])) AS [Klient],
    LTRIM(RTRIM([Forretningspartner])) AS [Forretningspartner],
    LTRIM(RTRIM([Identifikationsart])) AS [Identifikationsart],
    CASE
            WHEN [Gyldig_fra] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Gyldig_fra]) = 8 AND [Gyldig_fra] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Gyldig_fra], 112)
            WHEN [Gyldig_fra] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Gyldig_fra], 104)
            ELSE TRY_CONVERT(DATE, [Gyldig_fra], 23)
        END AS [Gyldig_fra],
    CASE
            WHEN [Gyldig_til] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Gyldig_til]) = 8 AND [Gyldig_til] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Gyldig_til], 112)
            WHEN [Gyldig_til] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Gyldig_til], 104)
            ELSE TRY_CONVERT(DATE, [Gyldig_til], 23)
        END AS [Gyldig_til],
    LTRIM(RTRIM([Datafordeleren_UUID])) AS [Datafordeleren_UUID],
    LTRIM(RTRIM([Forretningspartner-GUID])) AS [Forretningspartner-GUID],
    LTRIM(RTRIM([BW_Opdateringsmode])) AS [BW_Opdateringsmode],
    LTRIM(RTRIM([Slettet])) AS [Slettet],
    CASE
            WHEN [export_date] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([export_date]) = 8 AND [export_date] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [export_date], 112)
            WHEN [export_date] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [export_date], 104)
            ELSE TRY_CONVERT(DATE, [export_date], 23)
        END AS [export_date],
    LTRIM(RTRIM([file_origin])) AS [file_origin],
    TRY_CAST(REPLACE([row_number], '.', '') AS INT) AS [row_number],
    LTRIM(RTRIM([etl_version])) AS [etl_version],
                ROW_NUMBER() OVER (PARTITION BY [Klient], [Forretningspartner], [Identifikationsart], [Forretningspartner-GUID] ORDER BY (SELECT NULL)) as rn
            FROM [ode].[Forretningspartner_Total_Staging]
        ) t WHERE rn = 1 AND [Klient] IS NOT NULL AND [Forretningspartner] IS NOT NULL AND [Identifikationsart] IS NOT NULL AND [Forretningspartner-GUID] IS NOT NULL
    )
    INSERT INTO [ode].[Forretningspartner] ([Klient], [Forretningspartner], [Identifikationsart], [Gyldig_fra], [Gyldig_til], [Datafordeleren_UUID], [Forretningspartner-GUID], [BW_Opdateringsmode], [Slettet], [export_date], [file_origin], [row_number], [etl_version])
    SELECT [Klient], [Forretningspartner], [Identifikationsart], [Gyldig_fra], [Gyldig_til], [Datafordeleren_UUID], [Forretningspartner-GUID], [BW_Opdateringsmode], [Slettet], [export_date], [file_origin], [row_number], [etl_version] FROM new_data;
    
    GO

    
    -- D. Validation Metrics
    ------------------------------------------------------------
    SELECT 
        'ROW_COUNTS' as metric,
        (SELECT COUNT(*) FROM [ode].[Forretningspartner_Total_Staging]) as source_rows,
        (SELECT COUNT(*) FROM [ode].[Forretningspartner]) as target_rows;
    
    GO

    -- C. Cleanup (Optional - Staging table usually kept until file move is confirmed)
    DROP TABLE [ode].[Forretningspartner_Total_Staging];
    GO
    