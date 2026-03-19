
    -- ============================================================
    -- Pipeline Script for UU-aftale-haefter (Total)
    -- Source:  UU-aftale-haefter_Total_Staging
    -- Targets: UU-aftale-haefter_Total_Backup, UU-aftale-haefter_Total_Typed, UU-aftale-haefter
    -- Generated automatically
    -- ============================================================

    USE [BackDataLake-Test];
    GO

    -- A. Ensure Target Tables Exist
    ------------------------------------------------------------
    
    IF OBJECT_ID('[ode].[UU-aftale-haefter_Total_Backup]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[UU-aftale-haefter_Total_Backup] (
        [Klient] NVARCHAR(MAX) NULL,
    [Aftale] NVARCHAR(MAX) NULL,
    [Aftalekonto] NVARCHAR(MAX) NULL,
    [Aftalenummer] NVARCHAR(MAX) NULL,
    [BetFormReference] NVARCHAR(MAX) NULL,
    [Forretningspartner] NVARCHAR(MAX) NULL,
    [Hovedhæfter] NVARCHAR(MAX) NULL,
    [Hæfter_fjernet] NVARCHAR(MAX) NULL,
    [Hæfter_tilføjet] NVARCHAR(MAX) NULL,
    [Kommune_kode] NVARCHAR(MAX) NULL,
    [export_date] NVARCHAR(MAX) NULL,
    [file_origin] NVARCHAR(MAX) NULL,
    [row_number] NVARCHAR(MAX) NULL,
    [etl_version] NVARCHAR(MAX) NULL
        );
    END
    
    
    IF OBJECT_ID('[ode].[UU-aftale-haefter_Total_Typed]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[UU-aftale-haefter_Total_Typed] (
        [Klient] NVARCHAR(255) NULL,
    [Aftale] NVARCHAR(255) NULL,
    [Aftalekonto] NVARCHAR(255) NULL,
    [Aftalenummer] NVARCHAR(255) NULL,
    [BetFormReference] NVARCHAR(255) NULL,
    [Forretningspartner] NVARCHAR(255) NULL,
    [Hovedhæfter] NVARCHAR(255) NULL,
    [Hæfter_fjernet] DATE NULL,
    [Hæfter_tilføjet] DATE NULL,
    [Kommune_kode] NVARCHAR(255) NULL,
    [export_date] DATE NULL,
    [file_origin] NVARCHAR(255) NULL,
    [row_number] INT NULL,
    [etl_version] NVARCHAR(50) NULL
        );
    END
    
    
    IF OBJECT_ID('[ode].[UU-aftale-haefter]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[UU-aftale-haefter] (
        [Klient] NVARCHAR(255) NOT NULL,
    [Aftale] NVARCHAR(255) NULL,
    [Aftalekonto] NVARCHAR(255) NULL,
    [Aftalenummer] NVARCHAR(255) NOT NULL,
    [BetFormReference] NVARCHAR(255) NULL,
    [Forretningspartner] NVARCHAR(255) NOT NULL,
    [Hovedhæfter] NVARCHAR(255) NULL,
    [Hæfter_fjernet] DATE NULL,
    [Hæfter_tilføjet] DATE NULL,
    [Kommune_kode] NVARCHAR(255) NULL,
    [export_date] DATE NULL,
    [file_origin] NVARCHAR(255) NULL,
    [row_number] INT NULL,
    [etl_version] NVARCHAR(50) NULL,
    CONSTRAINT [PK_UU-aftale-haefter] PRIMARY KEY CLUSTERED ([Klient], [Aftalenummer], [Forretningspartner])
        );
    END
    
    GO

    -- B. Execute Pipeline Steps
    ------------------------------------------------------------
    
    
    -- 1. BACKUP: Copy raw data from Staging to Backup
    INSERT INTO [ode].[UU-aftale-haefter_Total_Backup] (
        [Klient],
    [Aftale],
    [Aftalekonto],
    [Aftalenummer],
    [BetFormReference],
    [Forretningspartner],
    [Hovedhæfter],
    [Hæfter_fjernet],
    [Hæfter_tilføjet],
    [Kommune_kode],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    )
    SELECT
        [Klient],
    [Aftale],
    [Aftalekonto],
    [Aftalenummer],
    [BetFormReference],
    [Forretningspartner],
    [Hovedhæfter],
    [Hæfter_fjernet],
    [Hæfter_tilføjet],
    [Kommune_kode],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    FROM [ode].[UU-aftale-haefter_Total_Staging];
    
    GO
    
    
    -- 2. TYPED: Transform and insert into Typed history
    --    Note: Rows with invalid Primary Keys after conversion are skipped here but exist in Backup.
    WITH transformed_data AS (
        SELECT
        LTRIM(RTRIM([Klient])) AS [Klient],
    LTRIM(RTRIM([Aftale])) AS [Aftale],
    LTRIM(RTRIM([Aftalekonto])) AS [Aftalekonto],
    LTRIM(RTRIM([Aftalenummer])) AS [Aftalenummer],
    LTRIM(RTRIM([BetFormReference])) AS [BetFormReference],
    LTRIM(RTRIM([Forretningspartner])) AS [Forretningspartner],
    LTRIM(RTRIM([Hovedhæfter])) AS [Hovedhæfter],
    CASE
            WHEN [Hæfter_fjernet] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Hæfter_fjernet]) = 8 AND [Hæfter_fjernet] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Hæfter_fjernet], 112)
            WHEN [Hæfter_fjernet] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Hæfter_fjernet], 104)
            ELSE TRY_CONVERT(DATE, [Hæfter_fjernet], 23)
        END AS [Hæfter_fjernet],
    CASE
            WHEN [Hæfter_tilføjet] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Hæfter_tilføjet]) = 8 AND [Hæfter_tilføjet] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Hæfter_tilføjet], 112)
            WHEN [Hæfter_tilføjet] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Hæfter_tilføjet], 104)
            ELSE TRY_CONVERT(DATE, [Hæfter_tilføjet], 23)
        END AS [Hæfter_tilføjet],
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
        FROM [ode].[UU-aftale-haefter_Total_Staging]
    ),
    valid_data AS (
        SELECT *,
            ROW_NUMBER() OVER (PARTITION BY [Klient], [Aftalenummer], [Forretningspartner] ORDER BY (SELECT NULL)) as rn
        FROM transformed_data
        WHERE [Klient] IS NOT NULL AND [Aftalenummer] IS NOT NULL AND [Forretningspartner] IS NOT NULL
    )
    INSERT INTO [ode].[UU-aftale-haefter_Total_Typed] (
        [Klient],
    [Aftale],
    [Aftalekonto],
    [Aftalenummer],
    [BetFormReference],
    [Forretningspartner],
    [Hovedhæfter],
    [Hæfter_fjernet],
    [Hæfter_tilføjet],
    [Kommune_kode],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    )
    SELECT
        [Klient],
    [Aftale],
    [Aftalekonto],
    [Aftalenummer],
    [BetFormReference],
    [Forretningspartner],
    [Hovedhæfter],
    [Hæfter_fjernet],
    [Hæfter_tilføjet],
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
        LTRIM(RTRIM([Klient])) AS [Klient],
    LTRIM(RTRIM([Aftale])) AS [Aftale],
    LTRIM(RTRIM([Aftalekonto])) AS [Aftalekonto],
    LTRIM(RTRIM([Aftalenummer])) AS [Aftalenummer],
    LTRIM(RTRIM([BetFormReference])) AS [BetFormReference],
    LTRIM(RTRIM([Forretningspartner])) AS [Forretningspartner],
    LTRIM(RTRIM([Hovedhæfter])) AS [Hovedhæfter],
    CASE
            WHEN [Hæfter_fjernet] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Hæfter_fjernet]) = 8 AND [Hæfter_fjernet] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Hæfter_fjernet], 112)
            WHEN [Hæfter_fjernet] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Hæfter_fjernet], 104)
            ELSE TRY_CONVERT(DATE, [Hæfter_fjernet], 23)
        END AS [Hæfter_fjernet],
    CASE
            WHEN [Hæfter_tilføjet] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Hæfter_tilføjet]) = 8 AND [Hæfter_tilføjet] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Hæfter_tilføjet], 112)
            WHEN [Hæfter_tilføjet] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Hæfter_tilføjet], 104)
            ELSE TRY_CONVERT(DATE, [Hæfter_tilføjet], 23)
        END AS [Hæfter_tilføjet],
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
                ROW_NUMBER() OVER (PARTITION BY [Klient], [Aftalenummer], [Forretningspartner] ORDER BY (SELECT NULL)) as rn
            FROM [ode].[UU-aftale-haefter_Total_Staging]
        ) t WHERE rn = 1 AND [Klient] IS NOT NULL AND [Aftalenummer] IS NOT NULL AND [Forretningspartner] IS NOT NULL
    )
    INSERT INTO [ode].[UU-aftale-haefter] ([Klient], [Aftale], [Aftalekonto], [Aftalenummer], [BetFormReference], [Forretningspartner], [Hovedhæfter], [Hæfter_fjernet], [Hæfter_tilføjet], [Kommune_kode], [export_date], [file_origin], [row_number], [etl_version])
    SELECT [Klient], [Aftale], [Aftalekonto], [Aftalenummer], [BetFormReference], [Forretningspartner], [Hovedhæfter], [Hæfter_fjernet], [Hæfter_tilføjet], [Kommune_kode], [export_date], [file_origin], [row_number], [etl_version] FROM new_data;
    
    GO

    
    -- D. Validation Metrics
    ------------------------------------------------------------
    SELECT 
        'ROW_COUNTS' as metric,
        (SELECT COUNT(*) FROM [ode].[UU-aftale-haefter_Total_Staging]) as source_rows,
        (SELECT COUNT(*) FROM [ode].[UU-aftale-haefter]) as target_rows;
    
    GO

    -- C. Cleanup (Optional - Staging table usually kept until file move is confirmed)
    DROP TABLE [ode].[UU-aftale-haefter_Total_Staging];
    GO
    