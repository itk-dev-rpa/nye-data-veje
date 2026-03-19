
    -- ============================================================
    -- Pipeline Script for BO-aftale (Total)
    -- Source:  BO-aftale_Total_Staging
    -- Targets: BO-aftale_Total_Backup, BO-aftale_Total_Typed, BO-aftale
    -- Generated automatically
    -- ============================================================

    USE [BackDataLake-Test];
    GO

    -- A. Ensure Target Tables Exist
    ------------------------------------------------------------
    
    IF OBJECT_ID('[ode].[BO-aftale_Total_Backup]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[BO-aftale_Total_Backup] (
        [Aftalestatus] NVARCHAR(MAX) NULL,
    [Aftaletype] NVARCHAR(MAX) NULL,
    [Aftalenummer] NVARCHAR(MAX) NULL,
    [Bilagsnummer] NVARCHAR(MAX) NULL,
    [Position] NVARCHAR(MAX) NULL,
    [Oprettet_beløb] NVARCHAR(MAX) NULL,
    [Valuta] NVARCHAR(MAX) NULL,
    [Første_anmeldelse] NVARCHAR(MAX) NULL,
    [Indbetalt_af_bobestyrer] NVARCHAR(MAX) NULL,
    [Fjernet] NVARCHAR(MAX) NULL,
    [Bobehandling] NVARCHAR(MAX) NULL,
    [Indholdsart] NVARCHAR(MAX) NULL,
    [Deltransaktion] NVARCHAR(MAX) NULL,
    [Hovedtransaktion] NVARCHAR(MAX) NULL,
    [Aftalekonto] NVARCHAR(MAX) NULL,
    [Aftale] NVARCHAR(MAX) NULL,
    [Kommune_kode] NVARCHAR(MAX) NULL,
    [Restbeløb] NVARCHAR(MAX) NULL,
    [Afskrevet] NVARCHAR(MAX) NULL,
    [Ændringer_efter_første_anmeld] NVARCHAR(MAX) NULL,
    [export_date] NVARCHAR(MAX) NULL,
    [file_origin] NVARCHAR(MAX) NULL,
    [row_number] NVARCHAR(MAX) NULL,
    [etl_version] NVARCHAR(MAX) NULL
        );
    END
    
    
    IF OBJECT_ID('[ode].[BO-aftale_Total_Typed]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[BO-aftale_Total_Typed] (
        [Aftalestatus] NVARCHAR(255) NULL,
    [Aftaletype] NVARCHAR(255) NULL,
    [Aftalenummer] NVARCHAR(255) NULL,
    [Bilagsnummer] NVARCHAR(255) NULL,
    [Position] INT NULL,
    [Oprettet_beløb] DECIMAL(15,2) NULL,
    [Valuta] NVARCHAR(255) NULL,
    [Første_anmeldelse] DECIMAL(15,2) NULL,
    [Indbetalt_af_bobestyrer] DECIMAL(15,2) NULL,
    [Fjernet] NVARCHAR(255) NULL,
    [Bobehandling] NVARCHAR(255) NULL,
    [Indholdsart] NVARCHAR(255) NULL,
    [Deltransaktion] NVARCHAR(255) NULL,
    [Hovedtransaktion] NVARCHAR(255) NULL,
    [Aftalekonto] NVARCHAR(255) NULL,
    [Aftale] NVARCHAR(255) NULL,
    [Kommune_kode] NVARCHAR(255) NULL,
    [Restbeløb] DECIMAL(15,2) NULL,
    [Afskrevet] DECIMAL(15,2) NULL,
    [Ændringer_efter_første_anmeld] DECIMAL(15,2) NULL,
    [export_date] DATE NULL,
    [file_origin] NVARCHAR(255) NULL,
    [row_number] INT NULL,
    [etl_version] NVARCHAR(50) NULL
        );
    END
    
    
    IF OBJECT_ID('[ode].[BO-aftale]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[BO-aftale] (
        [Aftalestatus] NVARCHAR(255) NULL,
    [Aftaletype] NVARCHAR(255) NULL,
    [Aftalenummer] NVARCHAR(255) NOT NULL,
    [Bilagsnummer] NVARCHAR(255) NOT NULL,
    [Position] INT NOT NULL,
    [Oprettet_beløb] DECIMAL(15,2) NULL,
    [Valuta] NVARCHAR(255) NULL,
    [Første_anmeldelse] DECIMAL(15,2) NULL,
    [Indbetalt_af_bobestyrer] DECIMAL(15,2) NULL,
    [Fjernet] NVARCHAR(255) NULL,
    [Bobehandling] NVARCHAR(255) NULL,
    [Indholdsart] NVARCHAR(255) NULL,
    [Deltransaktion] NVARCHAR(255) NULL,
    [Hovedtransaktion] NVARCHAR(255) NULL,
    [Aftalekonto] NVARCHAR(255) NULL,
    [Aftale] NVARCHAR(255) NULL,
    [Kommune_kode] NVARCHAR(255) NULL,
    [Restbeløb] DECIMAL(15,2) NULL,
    [Afskrevet] DECIMAL(15,2) NULL,
    [Ændringer_efter_første_anmeld] DECIMAL(15,2) NULL,
    [export_date] DATE NULL,
    [file_origin] NVARCHAR(255) NULL,
    [row_number] INT NULL,
    [etl_version] NVARCHAR(50) NULL,
    CONSTRAINT [PK_BO-aftale] PRIMARY KEY CLUSTERED ([Aftalenummer], [Bilagsnummer], [Position])
        );
    END
    
    GO

    -- B. Execute Pipeline Steps
    ------------------------------------------------------------
    
    
    -- 1. BACKUP: Copy raw data from Staging to Backup
    INSERT INTO [ode].[BO-aftale_Total_Backup] (
        [Aftalestatus],
    [Aftaletype],
    [Aftalenummer],
    [Bilagsnummer],
    [Position],
    [Oprettet_beløb],
    [Valuta],
    [Første_anmeldelse],
    [Indbetalt_af_bobestyrer],
    [Fjernet],
    [Bobehandling],
    [Indholdsart],
    [Deltransaktion],
    [Hovedtransaktion],
    [Aftalekonto],
    [Aftale],
    [Kommune_kode],
    [Restbeløb],
    [Afskrevet],
    [Ændringer_efter_første_anmeld],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    )
    SELECT
        [Aftalestatus],
    [Aftaletype],
    [Aftalenummer],
    [Bilagsnummer],
    [Position],
    [Oprettet_beløb],
    [Valuta],
    [Første_anmeldelse],
    [Indbetalt_af_bobestyrer],
    [Fjernet],
    [Bobehandling],
    [Indholdsart],
    [Deltransaktion],
    [Hovedtransaktion],
    [Aftalekonto],
    [Aftale],
    [Kommune_kode],
    [Restbeløb],
    [Afskrevet],
    [Ændringer_efter_første_anmeld],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    FROM [ode].[BO-aftale_Total_Staging];
    
    GO
    
    
    -- 2. TYPED: Transform and insert into Typed history
    --    Note: Rows with invalid Primary Keys after conversion are skipped here but exist in Backup.
    WITH transformed_data AS (
        SELECT
        LTRIM(RTRIM([Aftalestatus])) AS [Aftalestatus],
    LTRIM(RTRIM([Aftaletype])) AS [Aftaletype],
    LTRIM(RTRIM([Aftalenummer])) AS [Aftalenummer],
    LTRIM(RTRIM([Bilagsnummer])) AS [Bilagsnummer],
    TRY_CAST(REPLACE([Position], '.', '') AS INT) AS [Position],
    CASE
            WHEN [Oprettet_beløb] IS NULL OR [Oprettet_beløb] = '' OR [Oprettet_beløb] = '0' THEN NULL
            WHEN [Oprettet_beløb] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Oprettet_beløb], LEN([Oprettet_beløb])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Oprettet_beløb], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Oprettet_beløb],
    LTRIM(RTRIM([Valuta])) AS [Valuta],
    CASE
            WHEN [Første_anmeldelse] IS NULL OR [Første_anmeldelse] = '' OR [Første_anmeldelse] = '0' THEN NULL
            WHEN [Første_anmeldelse] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Første_anmeldelse], LEN([Første_anmeldelse])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Første_anmeldelse], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Første_anmeldelse],
    CASE
            WHEN [Indbetalt_af_bobestyrer] IS NULL OR [Indbetalt_af_bobestyrer] = '' OR [Indbetalt_af_bobestyrer] = '0' THEN NULL
            WHEN [Indbetalt_af_bobestyrer] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Indbetalt_af_bobestyrer], LEN([Indbetalt_af_bobestyrer])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Indbetalt_af_bobestyrer], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Indbetalt_af_bobestyrer],
    LTRIM(RTRIM([Fjernet])) AS [Fjernet],
    LTRIM(RTRIM([Bobehandling])) AS [Bobehandling],
    LTRIM(RTRIM([Indholdsart])) AS [Indholdsart],
    LTRIM(RTRIM([Deltransaktion])) AS [Deltransaktion],
    LTRIM(RTRIM([Hovedtransaktion])) AS [Hovedtransaktion],
    LTRIM(RTRIM([Aftalekonto])) AS [Aftalekonto],
    LTRIM(RTRIM([Aftale])) AS [Aftale],
    LTRIM(RTRIM([Kommune_kode])) AS [Kommune_kode],
    CASE
            WHEN [Restbeløb] IS NULL OR [Restbeløb] = '' OR [Restbeløb] = '0' THEN NULL
            WHEN [Restbeløb] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Restbeløb], LEN([Restbeløb])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Restbeløb], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Restbeløb],
    CASE
            WHEN [Afskrevet] IS NULL OR [Afskrevet] = '' OR [Afskrevet] = '0' THEN NULL
            WHEN [Afskrevet] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Afskrevet], LEN([Afskrevet])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Afskrevet], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Afskrevet],
    CASE
            WHEN [Ændringer_efter_første_anmeld] IS NULL OR [Ændringer_efter_første_anmeld] = '' OR [Ændringer_efter_første_anmeld] = '0' THEN NULL
            WHEN [Ændringer_efter_første_anmeld] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Ændringer_efter_første_anmeld], LEN([Ændringer_efter_første_anmeld])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Ændringer_efter_første_anmeld], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Ændringer_efter_første_anmeld],
    CASE
            WHEN [export_date] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([export_date]) = 8 AND [export_date] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [export_date], 112)
            WHEN [export_date] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [export_date], 104)
            ELSE TRY_CONVERT(DATE, [export_date], 23)
        END AS [export_date],
    LTRIM(RTRIM([file_origin])) AS [file_origin],
    TRY_CAST(REPLACE([row_number], '.', '') AS INT) AS [row_number],
    LTRIM(RTRIM([etl_version])) AS [etl_version]
        FROM [ode].[BO-aftale_Total_Staging]
    ),
    valid_data AS (
        SELECT *,
            ROW_NUMBER() OVER (PARTITION BY [Aftalenummer], [Bilagsnummer], [Position] ORDER BY (SELECT NULL)) as rn
        FROM transformed_data
        WHERE [Aftalenummer] IS NOT NULL AND [Bilagsnummer] IS NOT NULL AND [Position] IS NOT NULL
    )
    INSERT INTO [ode].[BO-aftale_Total_Typed] (
        [Aftalestatus],
    [Aftaletype],
    [Aftalenummer],
    [Bilagsnummer],
    [Position],
    [Oprettet_beløb],
    [Valuta],
    [Første_anmeldelse],
    [Indbetalt_af_bobestyrer],
    [Fjernet],
    [Bobehandling],
    [Indholdsart],
    [Deltransaktion],
    [Hovedtransaktion],
    [Aftalekonto],
    [Aftale],
    [Kommune_kode],
    [Restbeløb],
    [Afskrevet],
    [Ændringer_efter_første_anmeld],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    )
    SELECT
        [Aftalestatus],
    [Aftaletype],
    [Aftalenummer],
    [Bilagsnummer],
    [Position],
    [Oprettet_beløb],
    [Valuta],
    [Første_anmeldelse],
    [Indbetalt_af_bobestyrer],
    [Fjernet],
    [Bobehandling],
    [Indholdsart],
    [Deltransaktion],
    [Hovedtransaktion],
    [Aftalekonto],
    [Aftale],
    [Kommune_kode],
    [Restbeløb],
    [Afskrevet],
    [Ændringer_efter_første_anmeld],
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
        LTRIM(RTRIM([Aftalestatus])) AS [Aftalestatus],
    LTRIM(RTRIM([Aftaletype])) AS [Aftaletype],
    LTRIM(RTRIM([Aftalenummer])) AS [Aftalenummer],
    LTRIM(RTRIM([Bilagsnummer])) AS [Bilagsnummer],
    TRY_CAST(REPLACE([Position], '.', '') AS INT) AS [Position],
    CASE
            WHEN [Oprettet_beløb] IS NULL OR [Oprettet_beløb] = '' OR [Oprettet_beløb] = '0' THEN NULL
            WHEN [Oprettet_beløb] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Oprettet_beløb], LEN([Oprettet_beløb])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Oprettet_beløb], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Oprettet_beløb],
    LTRIM(RTRIM([Valuta])) AS [Valuta],
    CASE
            WHEN [Første_anmeldelse] IS NULL OR [Første_anmeldelse] = '' OR [Første_anmeldelse] = '0' THEN NULL
            WHEN [Første_anmeldelse] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Første_anmeldelse], LEN([Første_anmeldelse])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Første_anmeldelse], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Første_anmeldelse],
    CASE
            WHEN [Indbetalt_af_bobestyrer] IS NULL OR [Indbetalt_af_bobestyrer] = '' OR [Indbetalt_af_bobestyrer] = '0' THEN NULL
            WHEN [Indbetalt_af_bobestyrer] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Indbetalt_af_bobestyrer], LEN([Indbetalt_af_bobestyrer])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Indbetalt_af_bobestyrer], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Indbetalt_af_bobestyrer],
    LTRIM(RTRIM([Fjernet])) AS [Fjernet],
    LTRIM(RTRIM([Bobehandling])) AS [Bobehandling],
    LTRIM(RTRIM([Indholdsart])) AS [Indholdsart],
    LTRIM(RTRIM([Deltransaktion])) AS [Deltransaktion],
    LTRIM(RTRIM([Hovedtransaktion])) AS [Hovedtransaktion],
    LTRIM(RTRIM([Aftalekonto])) AS [Aftalekonto],
    LTRIM(RTRIM([Aftale])) AS [Aftale],
    LTRIM(RTRIM([Kommune_kode])) AS [Kommune_kode],
    CASE
            WHEN [Restbeløb] IS NULL OR [Restbeløb] = '' OR [Restbeløb] = '0' THEN NULL
            WHEN [Restbeløb] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Restbeløb], LEN([Restbeløb])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Restbeløb], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Restbeløb],
    CASE
            WHEN [Afskrevet] IS NULL OR [Afskrevet] = '' OR [Afskrevet] = '0' THEN NULL
            WHEN [Afskrevet] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Afskrevet], LEN([Afskrevet])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Afskrevet], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Afskrevet],
    CASE
            WHEN [Ændringer_efter_første_anmeld] IS NULL OR [Ændringer_efter_første_anmeld] = '' OR [Ændringer_efter_første_anmeld] = '0' THEN NULL
            WHEN [Ændringer_efter_første_anmeld] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Ændringer_efter_første_anmeld], LEN([Ændringer_efter_første_anmeld])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Ændringer_efter_første_anmeld], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Ændringer_efter_første_anmeld],
    CASE
            WHEN [export_date] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([export_date]) = 8 AND [export_date] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [export_date], 112)
            WHEN [export_date] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [export_date], 104)
            ELSE TRY_CONVERT(DATE, [export_date], 23)
        END AS [export_date],
    LTRIM(RTRIM([file_origin])) AS [file_origin],
    TRY_CAST(REPLACE([row_number], '.', '') AS INT) AS [row_number],
    LTRIM(RTRIM([etl_version])) AS [etl_version],
                ROW_NUMBER() OVER (PARTITION BY [Aftalenummer], [Bilagsnummer], [Position] ORDER BY (SELECT NULL)) as rn
            FROM [ode].[BO-aftale_Total_Staging]
        ) t WHERE rn = 1 AND [Aftalenummer] IS NOT NULL AND [Bilagsnummer] IS NOT NULL AND [Position] IS NOT NULL
    )
    INSERT INTO [ode].[BO-aftale] ([Aftalestatus], [Aftaletype], [Aftalenummer], [Bilagsnummer], [Position], [Oprettet_beløb], [Valuta], [Første_anmeldelse], [Indbetalt_af_bobestyrer], [Fjernet], [Bobehandling], [Indholdsart], [Deltransaktion], [Hovedtransaktion], [Aftalekonto], [Aftale], [Kommune_kode], [Restbeløb], [Afskrevet], [Ændringer_efter_første_anmeld], [export_date], [file_origin], [row_number], [etl_version])
    SELECT [Aftalestatus], [Aftaletype], [Aftalenummer], [Bilagsnummer], [Position], [Oprettet_beløb], [Valuta], [Første_anmeldelse], [Indbetalt_af_bobestyrer], [Fjernet], [Bobehandling], [Indholdsart], [Deltransaktion], [Hovedtransaktion], [Aftalekonto], [Aftale], [Kommune_kode], [Restbeløb], [Afskrevet], [Ændringer_efter_første_anmeld], [export_date], [file_origin], [row_number], [etl_version] FROM new_data;
    
    GO

    
    -- D. Validation Metrics
    ------------------------------------------------------------
    SELECT 
        'ROW_COUNTS' as metric,
        (SELECT COUNT(*) FROM [ode].[BO-aftale_Total_Staging]) as source_rows,
        (SELECT COUNT(*) FROM [ode].[BO-aftale]) as target_rows;
    
    GO

    -- C. Cleanup (Optional - Staging table usually kept until file move is confirmed)
    DROP TABLE [ode].[BO-aftale_Total_Staging];
    GO
    