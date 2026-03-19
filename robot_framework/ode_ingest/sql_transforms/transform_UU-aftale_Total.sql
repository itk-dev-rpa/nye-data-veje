
    -- ============================================================
    -- Pipeline Script for UU-aftale (Total)
    -- Source:  UU-aftale_Total_Staging
    -- Targets: UU-aftale_Total_Backup, UU-aftale_Total_Typed, UU-aftale
    -- Generated automatically
    -- ============================================================

    USE [BackDataLake-Test];
    GO

    -- A. Ensure Target Tables Exist
    ------------------------------------------------------------
    
    IF OBJECT_ID('[ode].[UU-aftale_Total_Backup]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[UU-aftale_Total_Backup] (
        [Aftalestatus] NVARCHAR(MAX) NULL,
    [Aftaletype] NVARCHAR(MAX) NULL,
    [Aftalenummer] NVARCHAR(MAX) NULL,
    [Indholdsart] NVARCHAR(MAX) NULL,
    [Aftale] NVARCHAR(MAX) NULL,
    [Aftalekonto] NVARCHAR(MAX) NULL,
    [Deltransaktion] NVARCHAR(MAX) NULL,
    [Bilagsnummer] NVARCHAR(MAX) NULL,
    [Position] NVARCHAR(MAX) NULL,
    [Hovedtransaktion] NVARCHAR(MAX) NULL,
    [Udligningsstatus] NVARCHAR(MAX) NULL,
    [Beløb] NVARCHAR(MAX) NULL,
    [Valuta] NVARCHAR(MAX) NULL,
    [Kommune_kode] NVARCHAR(MAX) NULL,
    [export_date] NVARCHAR(MAX) NULL,
    [file_origin] NVARCHAR(MAX) NULL,
    [row_number] NVARCHAR(MAX) NULL,
    [etl_version] NVARCHAR(MAX) NULL
        );
    END
    
    
    IF OBJECT_ID('[ode].[UU-aftale_Total_Typed]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[UU-aftale_Total_Typed] (
        [Aftalestatus] NVARCHAR(255) NULL,
    [Aftaletype] NVARCHAR(255) NULL,
    [Aftalenummer] NVARCHAR(255) NULL,
    [Indholdsart] NVARCHAR(255) NULL,
    [Aftale] NVARCHAR(255) NULL,
    [Aftalekonto] NVARCHAR(255) NULL,
    [Deltransaktion] NVARCHAR(255) NULL,
    [Bilagsnummer] NVARCHAR(255) NULL,
    [Position] INT NULL,
    [Hovedtransaktion] NVARCHAR(255) NULL,
    [Udligningsstatus] NVARCHAR(255) NULL,
    [Beløb] DECIMAL(15,2) NULL,
    [Valuta] NVARCHAR(255) NULL,
    [Kommune_kode] NVARCHAR(255) NULL,
    [export_date] DATE NULL,
    [file_origin] NVARCHAR(255) NULL,
    [row_number] INT NULL,
    [etl_version] NVARCHAR(50) NULL
        );
    END
    
    
    IF OBJECT_ID('[ode].[UU-aftale]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[UU-aftale] (
        [Aftalestatus] NVARCHAR(255) NULL,
    [Aftaletype] NVARCHAR(255) NULL,
    [Aftalenummer] NVARCHAR(255) NULL,
    [Indholdsart] NVARCHAR(255) NULL,
    [Aftale] NVARCHAR(255) NULL,
    [Aftalekonto] NVARCHAR(255) NULL,
    [Deltransaktion] NVARCHAR(255) NULL,
    [Bilagsnummer] NVARCHAR(255) NULL,
    [Position] INT NULL,
    [Hovedtransaktion] NVARCHAR(255) NULL,
    [Udligningsstatus] NVARCHAR(255) NULL,
    [Beløb] DECIMAL(15,2) NULL,
    [Valuta] NVARCHAR(255) NULL,
    [Kommune_kode] NVARCHAR(255) NULL,
    [export_date] DATE NULL,
    [file_origin] NVARCHAR(255) NULL,
    [row_number] INT NULL,
    [etl_version] NVARCHAR(50) NULL
        );
    END
    
    GO

    -- B. Execute Pipeline Steps
    ------------------------------------------------------------
    
    
    -- 1. BACKUP: Copy raw data from Staging to Backup
    INSERT INTO [ode].[UU-aftale_Total_Backup] (
        [Aftalestatus],
    [Aftaletype],
    [Aftalenummer],
    [Indholdsart],
    [Aftale],
    [Aftalekonto],
    [Deltransaktion],
    [Bilagsnummer],
    [Position],
    [Hovedtransaktion],
    [Udligningsstatus],
    [Beløb],
    [Valuta],
    [Kommune_kode],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    )
    SELECT
        [Aftalestatus],
    [Aftaletype],
    [Aftalenummer],
    [Indholdsart],
    [Aftale],
    [Aftalekonto],
    [Deltransaktion],
    [Bilagsnummer],
    [Position],
    [Hovedtransaktion],
    [Udligningsstatus],
    [Beløb],
    [Valuta],
    [Kommune_kode],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    FROM [ode].[UU-aftale_Total_Staging];
    
    GO
    
    
    -- 2. TYPED: Transform and insert (No PK defined)
    INSERT INTO [ode].[UU-aftale_Total_Typed] (
        [Aftalestatus],
    [Aftaletype],
    [Aftalenummer],
    [Indholdsart],
    [Aftale],
    [Aftalekonto],
    [Deltransaktion],
    [Bilagsnummer],
    [Position],
    [Hovedtransaktion],
    [Udligningsstatus],
    [Beløb],
    [Valuta],
    [Kommune_kode],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    )
    SELECT
        LTRIM(RTRIM([Aftalestatus])) AS [Aftalestatus],
    LTRIM(RTRIM([Aftaletype])) AS [Aftaletype],
    LTRIM(RTRIM([Aftalenummer])) AS [Aftalenummer],
    LTRIM(RTRIM([Indholdsart])) AS [Indholdsart],
    LTRIM(RTRIM([Aftale])) AS [Aftale],
    LTRIM(RTRIM([Aftalekonto])) AS [Aftalekonto],
    LTRIM(RTRIM([Deltransaktion])) AS [Deltransaktion],
    LTRIM(RTRIM([Bilagsnummer])) AS [Bilagsnummer],
    TRY_CAST(REPLACE([Position], '.', '') AS INT) AS [Position],
    LTRIM(RTRIM([Hovedtransaktion])) AS [Hovedtransaktion],
    LTRIM(RTRIM([Udligningsstatus])) AS [Udligningsstatus],
    CASE
            WHEN [Beløb] IS NULL OR [Beløb] = '' OR [Beløb] = '0' THEN NULL
            WHEN [Beløb] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Beløb], LEN([Beløb])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Beløb], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Beløb],
    LTRIM(RTRIM([Valuta])) AS [Valuta],
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
    FROM [ode].[UU-aftale_Total_Staging];
    
    GO
    
    
    -- 3. SNAPSHOT: Total Replacement (No PK)
    WITH new_data AS (
        SELECT
        LTRIM(RTRIM([Aftalestatus])) AS [Aftalestatus],
    LTRIM(RTRIM([Aftaletype])) AS [Aftaletype],
    LTRIM(RTRIM([Aftalenummer])) AS [Aftalenummer],
    LTRIM(RTRIM([Indholdsart])) AS [Indholdsart],
    LTRIM(RTRIM([Aftale])) AS [Aftale],
    LTRIM(RTRIM([Aftalekonto])) AS [Aftalekonto],
    LTRIM(RTRIM([Deltransaktion])) AS [Deltransaktion],
    LTRIM(RTRIM([Bilagsnummer])) AS [Bilagsnummer],
    TRY_CAST(REPLACE([Position], '.', '') AS INT) AS [Position],
    LTRIM(RTRIM([Hovedtransaktion])) AS [Hovedtransaktion],
    LTRIM(RTRIM([Udligningsstatus])) AS [Udligningsstatus],
    CASE
            WHEN [Beløb] IS NULL OR [Beløb] = '' OR [Beløb] = '0' THEN NULL
            WHEN [Beløb] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Beløb], LEN([Beløb])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Beløb], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Beløb],
    LTRIM(RTRIM([Valuta])) AS [Valuta],
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
        FROM [ode].[UU-aftale_Total_Staging]
    )
    INSERT INTO [ode].[UU-aftale] ([Aftalestatus], [Aftaletype], [Aftalenummer], [Indholdsart], [Aftale], [Aftalekonto], [Deltransaktion], [Bilagsnummer], [Position], [Hovedtransaktion], [Udligningsstatus], [Beløb], [Valuta], [Kommune_kode], [export_date], [file_origin], [row_number], [etl_version])
    SELECT [Aftalestatus], [Aftaletype], [Aftalenummer], [Indholdsart], [Aftale], [Aftalekonto], [Deltransaktion], [Bilagsnummer], [Position], [Hovedtransaktion], [Udligningsstatus], [Beløb], [Valuta], [Kommune_kode], [export_date], [file_origin], [row_number], [etl_version] FROM new_data;
    
    GO

    
    -- D. Validation Metrics
    ------------------------------------------------------------
    SELECT 
        'ROW_COUNTS' as metric,
        (SELECT COUNT(*) FROM [ode].[UU-aftale_Total_Staging]) as source_rows,
        (SELECT COUNT(*) FROM [ode].[UU-aftale]) as target_rows;
    
    GO

    -- C. Cleanup (Optional - Staging table usually kept until file move is confirmed)
    DROP TABLE [ode].[UU-aftale_Total_Staging];
    GO
    