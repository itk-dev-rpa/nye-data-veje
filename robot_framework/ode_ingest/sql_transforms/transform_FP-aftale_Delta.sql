
    -- ============================================================
    -- Pipeline Script for FP-aftale (Delta)
    -- Source:  FP-aftale_Delta_Staging
    -- Targets: FP-aftale_Delta_Backup, FP-aftale_Delta_Typed, FP-aftale
    -- Generated automatically
    -- ============================================================

    USE [BackDataLake-Test];
    GO

    -- A. Ensure Target Tables Exist
    ------------------------------------------------------------
    
    IF OBJECT_ID('[ode].[FP-aftale_Delta_Backup]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[FP-aftale_Delta_Backup] (
        [AA_type] NVARCHAR(MAX) NULL,
    [Ændret_den] NVARCHAR(MAX) NULL,
    [Aftale] NVARCHAR(MAX) NULL,
    [Aftalekonto] NVARCHAR(MAX) NULL,
    [Aftalenummer] NVARCHAR(MAX) NULL,
    [Aftaleposition] NVARCHAR(MAX) NULL,
    [Aftalestatus] NVARCHAR(MAX) NULL,
    [Aftaletype] NVARCHAR(MAX) NULL,
    [Årsag_til_luk_aftale] NVARCHAR(MAX) NULL,
    [Besvaret] NVARCHAR(MAX) NULL,
    [Bilagsnummer] NVARCHAR(MAX) NULL,
    [Forretningspartner] NVARCHAR(MAX) NULL,
    [Kommune_kode] NVARCHAR(MAX) NULL,
    [Konvertering] NVARCHAR(MAX) NULL,
    [Lukket_den] NVARCHAR(MAX) NULL,
    [Niveau_Aftale_Position] NVARCHAR(MAX) NULL,
    [Oprettet_den] NVARCHAR(MAX) NULL,
    [Position] NVARCHAR(MAX) NULL,
    [System_dato] NVARCHAR(MAX) NULL,
    [Tilføjelsesdato] NVARCHAR(MAX) NULL,
    [UdlBeløb_int_valuta] NVARCHAR(MAX) NULL,
    [Valuta] NVARCHAR(MAX) NULL,
    [export_date] NVARCHAR(MAX) NULL,
    [file_origin] NVARCHAR(MAX) NULL,
    [row_number] NVARCHAR(MAX) NULL,
    [etl_version] NVARCHAR(MAX) NULL
        );
    END
    
    
    IF OBJECT_ID('[ode].[FP-aftale_Delta_Typed]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[FP-aftale_Delta_Typed] (
        [AA_type] NVARCHAR(255) NULL,
    [Ændret_den] DATE NULL,
    [Aftale] NVARCHAR(255) NULL,
    [Aftalekonto] NVARCHAR(255) NULL,
    [Aftalenummer] NVARCHAR(255) NULL,
    [Aftaleposition] INT NULL,
    [Aftalestatus] NVARCHAR(255) NULL,
    [Aftaletype] NVARCHAR(255) NULL,
    [Årsag_til_luk_aftale] NVARCHAR(255) NULL,
    [Besvaret] DATE NULL,
    [Bilagsnummer] NVARCHAR(255) NULL,
    [Forretningspartner] NVARCHAR(255) NULL,
    [Kommune_kode] NVARCHAR(255) NULL,
    [Konvertering] NVARCHAR(255) NULL,
    [Lukket_den] DATE NULL,
    [Niveau_Aftale_Position] NVARCHAR(255) NULL,
    [Oprettet_den] DATE NULL,
    [Position] INT NULL,
    [System_dato] DATE NULL,
    [Tilføjelsesdato] DATE NULL,
    [UdlBeløb_int_valuta] DECIMAL(15,2) NULL,
    [Valuta] NVARCHAR(255) NULL,
    [export_date] DATE NULL,
    [file_origin] NVARCHAR(255) NULL,
    [row_number] INT NULL,
    [etl_version] NVARCHAR(50) NULL
        );
    END
    
    
    IF OBJECT_ID('[ode].[FP-aftale]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[FP-aftale] (
        [AA_type] NVARCHAR(255) NULL,
    [Ændret_den] DATE NULL,
    [Aftale] NVARCHAR(255) NULL,
    [Aftalekonto] NVARCHAR(255) NULL,
    [Aftalenummer] NVARCHAR(255) NULL,
    [Aftaleposition] INT NULL,
    [Aftalestatus] NVARCHAR(255) NULL,
    [Aftaletype] NVARCHAR(255) NULL,
    [Årsag_til_luk_aftale] NVARCHAR(255) NULL,
    [Besvaret] DATE NULL,
    [Bilagsnummer] NVARCHAR(255) NULL,
    [Forretningspartner] NVARCHAR(255) NULL,
    [Kommune_kode] NVARCHAR(255) NULL,
    [Konvertering] NVARCHAR(255) NULL,
    [Lukket_den] DATE NULL,
    [Niveau_Aftale_Position] NVARCHAR(255) NULL,
    [Oprettet_den] DATE NULL,
    [Position] INT NULL,
    [System_dato] DATE NULL,
    [Tilføjelsesdato] DATE NULL,
    [UdlBeløb_int_valuta] DECIMAL(15,2) NULL,
    [Valuta] NVARCHAR(255) NULL,
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
    INSERT INTO [ode].[FP-aftale_Delta_Backup] (
        [AA_type],
    [Ændret_den],
    [Aftale],
    [Aftalekonto],
    [Aftalenummer],
    [Aftaleposition],
    [Aftalestatus],
    [Aftaletype],
    [Årsag_til_luk_aftale],
    [Besvaret],
    [Bilagsnummer],
    [Forretningspartner],
    [Kommune_kode],
    [Konvertering],
    [Lukket_den],
    [Niveau_Aftale_Position],
    [Oprettet_den],
    [Position],
    [System_dato],
    [Tilføjelsesdato],
    [UdlBeløb_int_valuta],
    [Valuta],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    )
    SELECT
        [AA_type],
    [Ændret_den],
    [Aftale],
    [Aftalekonto],
    [Aftalenummer],
    [Aftaleposition],
    [Aftalestatus],
    [Aftaletype],
    [Årsag_til_luk_aftale],
    [Besvaret],
    [Bilagsnummer],
    [Forretningspartner],
    [Kommune_kode],
    [Konvertering],
    [Lukket_den],
    [Niveau_Aftale_Position],
    [Oprettet_den],
    [Position],
    [System_dato],
    [Tilføjelsesdato],
    [UdlBeløb_int_valuta],
    [Valuta],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    FROM [ode].[FP-aftale_Delta_Staging];
    
    GO
    
    
    -- 2. TYPED: Transform and insert (No PK defined)
    INSERT INTO [ode].[FP-aftale_Delta_Typed] (
        [AA_type],
    [Ændret_den],
    [Aftale],
    [Aftalekonto],
    [Aftalenummer],
    [Aftaleposition],
    [Aftalestatus],
    [Aftaletype],
    [Årsag_til_luk_aftale],
    [Besvaret],
    [Bilagsnummer],
    [Forretningspartner],
    [Kommune_kode],
    [Konvertering],
    [Lukket_den],
    [Niveau_Aftale_Position],
    [Oprettet_den],
    [Position],
    [System_dato],
    [Tilføjelsesdato],
    [UdlBeløb_int_valuta],
    [Valuta],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    )
    SELECT
        LTRIM(RTRIM([AA_type])) AS [AA_type],
    CASE
            WHEN [Ændret_den] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Ændret_den]) = 8 AND [Ændret_den] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Ændret_den], 112)
            WHEN [Ændret_den] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Ændret_den], 104)
            ELSE TRY_CONVERT(DATE, [Ændret_den], 23)
        END AS [Ændret_den],
    LTRIM(RTRIM([Aftale])) AS [Aftale],
    LTRIM(RTRIM([Aftalekonto])) AS [Aftalekonto],
    LTRIM(RTRIM([Aftalenummer])) AS [Aftalenummer],
    TRY_CAST(REPLACE([Aftaleposition], '.', '') AS INT) AS [Aftaleposition],
    LTRIM(RTRIM([Aftalestatus])) AS [Aftalestatus],
    LTRIM(RTRIM([Aftaletype])) AS [Aftaletype],
    LTRIM(RTRIM([Årsag_til_luk_aftale])) AS [Årsag_til_luk_aftale],
    CASE
            WHEN [Besvaret] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Besvaret]) = 8 AND [Besvaret] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Besvaret], 112)
            WHEN [Besvaret] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Besvaret], 104)
            ELSE TRY_CONVERT(DATE, [Besvaret], 23)
        END AS [Besvaret],
    LTRIM(RTRIM([Bilagsnummer])) AS [Bilagsnummer],
    LTRIM(RTRIM([Forretningspartner])) AS [Forretningspartner],
    LTRIM(RTRIM([Kommune_kode])) AS [Kommune_kode],
    LTRIM(RTRIM([Konvertering])) AS [Konvertering],
    CASE
            WHEN [Lukket_den] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Lukket_den]) = 8 AND [Lukket_den] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Lukket_den], 112)
            WHEN [Lukket_den] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Lukket_den], 104)
            ELSE TRY_CONVERT(DATE, [Lukket_den], 23)
        END AS [Lukket_den],
    LTRIM(RTRIM([Niveau_Aftale_Position])) AS [Niveau_Aftale_Position],
    CASE
            WHEN [Oprettet_den] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Oprettet_den]) = 8 AND [Oprettet_den] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Oprettet_den], 112)
            WHEN [Oprettet_den] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Oprettet_den], 104)
            ELSE TRY_CONVERT(DATE, [Oprettet_den], 23)
        END AS [Oprettet_den],
    TRY_CAST(REPLACE([Position], '.', '') AS INT) AS [Position],
    CASE
            WHEN [System_dato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([System_dato]) = 8 AND [System_dato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [System_dato], 112)
            WHEN [System_dato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [System_dato], 104)
            ELSE TRY_CONVERT(DATE, [System_dato], 23)
        END AS [System_dato],
    CASE
            WHEN [Tilføjelsesdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Tilføjelsesdato]) = 8 AND [Tilføjelsesdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Tilføjelsesdato], 112)
            WHEN [Tilføjelsesdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Tilføjelsesdato], 104)
            ELSE TRY_CONVERT(DATE, [Tilføjelsesdato], 23)
        END AS [Tilføjelsesdato],
    CASE
            WHEN [UdlBeløb_int_valuta] IS NULL OR [UdlBeløb_int_valuta] = '' OR [UdlBeløb_int_valuta] = '0' THEN NULL
            WHEN [UdlBeløb_int_valuta] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([UdlBeløb_int_valuta], LEN([UdlBeløb_int_valuta])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([UdlBeløb_int_valuta], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [UdlBeløb_int_valuta],
    LTRIM(RTRIM([Valuta])) AS [Valuta],
    CASE
            WHEN [export_date] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([export_date]) = 8 AND [export_date] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [export_date], 112)
            WHEN [export_date] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [export_date], 104)
            ELSE TRY_CONVERT(DATE, [export_date], 23)
        END AS [export_date],
    LTRIM(RTRIM([file_origin])) AS [file_origin],
    TRY_CAST(REPLACE([row_number], '.', '') AS INT) AS [row_number],
    LTRIM(RTRIM([etl_version])) AS [etl_version]
    FROM [ode].[FP-aftale_Delta_Staging];
    
    GO
    
    
    -- 3. SNAPSHOT: Delta Append (No PK)
    WITH new_data AS (
        SELECT
        LTRIM(RTRIM([AA_type])) AS [AA_type],
    CASE
            WHEN [Ændret_den] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Ændret_den]) = 8 AND [Ændret_den] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Ændret_den], 112)
            WHEN [Ændret_den] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Ændret_den], 104)
            ELSE TRY_CONVERT(DATE, [Ændret_den], 23)
        END AS [Ændret_den],
    LTRIM(RTRIM([Aftale])) AS [Aftale],
    LTRIM(RTRIM([Aftalekonto])) AS [Aftalekonto],
    LTRIM(RTRIM([Aftalenummer])) AS [Aftalenummer],
    TRY_CAST(REPLACE([Aftaleposition], '.', '') AS INT) AS [Aftaleposition],
    LTRIM(RTRIM([Aftalestatus])) AS [Aftalestatus],
    LTRIM(RTRIM([Aftaletype])) AS [Aftaletype],
    LTRIM(RTRIM([Årsag_til_luk_aftale])) AS [Årsag_til_luk_aftale],
    CASE
            WHEN [Besvaret] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Besvaret]) = 8 AND [Besvaret] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Besvaret], 112)
            WHEN [Besvaret] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Besvaret], 104)
            ELSE TRY_CONVERT(DATE, [Besvaret], 23)
        END AS [Besvaret],
    LTRIM(RTRIM([Bilagsnummer])) AS [Bilagsnummer],
    LTRIM(RTRIM([Forretningspartner])) AS [Forretningspartner],
    LTRIM(RTRIM([Kommune_kode])) AS [Kommune_kode],
    LTRIM(RTRIM([Konvertering])) AS [Konvertering],
    CASE
            WHEN [Lukket_den] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Lukket_den]) = 8 AND [Lukket_den] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Lukket_den], 112)
            WHEN [Lukket_den] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Lukket_den], 104)
            ELSE TRY_CONVERT(DATE, [Lukket_den], 23)
        END AS [Lukket_den],
    LTRIM(RTRIM([Niveau_Aftale_Position])) AS [Niveau_Aftale_Position],
    CASE
            WHEN [Oprettet_den] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Oprettet_den]) = 8 AND [Oprettet_den] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Oprettet_den], 112)
            WHEN [Oprettet_den] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Oprettet_den], 104)
            ELSE TRY_CONVERT(DATE, [Oprettet_den], 23)
        END AS [Oprettet_den],
    TRY_CAST(REPLACE([Position], '.', '') AS INT) AS [Position],
    CASE
            WHEN [System_dato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([System_dato]) = 8 AND [System_dato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [System_dato], 112)
            WHEN [System_dato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [System_dato], 104)
            ELSE TRY_CONVERT(DATE, [System_dato], 23)
        END AS [System_dato],
    CASE
            WHEN [Tilføjelsesdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Tilføjelsesdato]) = 8 AND [Tilføjelsesdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Tilføjelsesdato], 112)
            WHEN [Tilføjelsesdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Tilføjelsesdato], 104)
            ELSE TRY_CONVERT(DATE, [Tilføjelsesdato], 23)
        END AS [Tilføjelsesdato],
    CASE
            WHEN [UdlBeløb_int_valuta] IS NULL OR [UdlBeløb_int_valuta] = '' OR [UdlBeløb_int_valuta] = '0' THEN NULL
            WHEN [UdlBeløb_int_valuta] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([UdlBeløb_int_valuta], LEN([UdlBeløb_int_valuta])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([UdlBeløb_int_valuta], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [UdlBeløb_int_valuta],
    LTRIM(RTRIM([Valuta])) AS [Valuta],
    CASE
            WHEN [export_date] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([export_date]) = 8 AND [export_date] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [export_date], 112)
            WHEN [export_date] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [export_date], 104)
            ELSE TRY_CONVERT(DATE, [export_date], 23)
        END AS [export_date],
    LTRIM(RTRIM([file_origin])) AS [file_origin],
    TRY_CAST(REPLACE([row_number], '.', '') AS INT) AS [row_number],
    LTRIM(RTRIM([etl_version])) AS [etl_version]
        FROM [ode].[FP-aftale_Delta_Staging]
    )
    INSERT INTO [ode].[FP-aftale] ([AA_type], [Ændret_den], [Aftale], [Aftalekonto], [Aftalenummer], [Aftaleposition], [Aftalestatus], [Aftaletype], [Årsag_til_luk_aftale], [Besvaret], [Bilagsnummer], [Forretningspartner], [Kommune_kode], [Konvertering], [Lukket_den], [Niveau_Aftale_Position], [Oprettet_den], [Position], [System_dato], [Tilføjelsesdato], [UdlBeløb_int_valuta], [Valuta], [export_date], [file_origin], [row_number], [etl_version])
    SELECT [AA_type], [Ændret_den], [Aftale], [Aftalekonto], [Aftalenummer], [Aftaleposition], [Aftalestatus], [Aftaletype], [Årsag_til_luk_aftale], [Besvaret], [Bilagsnummer], [Forretningspartner], [Kommune_kode], [Konvertering], [Lukket_den], [Niveau_Aftale_Position], [Oprettet_den], [Position], [System_dato], [Tilføjelsesdato], [UdlBeløb_int_valuta], [Valuta], [export_date], [file_origin], [row_number], [etl_version] FROM new_data;
    
    GO

    
    -- D. Validation Metrics
    ------------------------------------------------------------
    SELECT 
        'ROW_COUNTS' as metric,
        (SELECT COUNT(*) FROM [ode].[FP-aftale_Delta_Staging]) as source_rows,
        (SELECT COUNT(*) FROM [ode].[FP-aftale]) as target_rows;
    
    GO

    -- C. Cleanup (Optional - Staging table usually kept until file move is confirmed)
    DROP TABLE [ode].[FP-aftale_Delta_Staging];
    GO
    