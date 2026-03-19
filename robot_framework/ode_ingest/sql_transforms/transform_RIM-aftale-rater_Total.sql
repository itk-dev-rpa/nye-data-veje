
    -- ============================================================
    -- Pipeline Script for RIM-aftale-rater (Total)
    -- Source:  RIM-aftale-rater_Total_Staging
    -- Targets: RIM-aftale-rater_Total_Backup, RIM-aftale-rater_Total_Typed, RIM-aftale-rater
    -- Generated automatically
    -- ============================================================

    USE [BackDataLake-Test];
    GO

    -- A. Ensure Target Tables Exist
    ------------------------------------------------------------
    
    IF OBJECT_ID('[ode].[RIM-aftale-rater_Total_Backup]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[RIM-aftale-rater_Total_Backup] (
        [Ændret_den] NVARCHAR(MAX) NULL,
    [Aftale] NVARCHAR(MAX) NULL,
    [Aftalekonto] NVARCHAR(MAX) NULL,
    [Aftalekontotype] NVARCHAR(MAX) NULL,
    [Aftalenummer] NVARCHAR(MAX) NULL,
    [Aftalestatus] NVARCHAR(MAX) NULL,
    [Aftaletype] NVARCHAR(MAX) NULL,
    [Basisdato_renteberegning] NVARCHAR(MAX) NULL,
    [Bilagsnummer] NVARCHAR(MAX) NULL,
    [Creation_Amount] NVARCHAR(MAX) NULL,
    [Deltransaktion] NVARCHAR(MAX) NULL,
    [EFI-nummer] NVARCHAR(MAX) NULL,
    [Forældelsesdato] NVARCHAR(MAX) NULL,
    [Fordringstype] NVARCHAR(MAX) NULL,
    [Forretningspartner] NVARCHAR(MAX) NULL,
    [Gentagelsesposition] NVARCHAR(MAX) NULL,
    [Henstand_til] NVARCHAR(MAX) NULL,
    [Hovedtransaktion] NVARCHAR(MAX) NULL,
    [Indholdsart] NVARCHAR(MAX) NULL,
    [Kommune_kode] NVARCHAR(MAX) NULL,
    [Konvertering_status] NVARCHAR(MAX) NULL,
    [KravsType] NVARCHAR(MAX) NULL,
    [Markering_for_tilbagekald] NVARCHAR(MAX) NULL,
    [Nettoforfald] NVARCHAR(MAX) NULL,
    [Oprettet_den] NVARCHAR(MAX) NULL,
    [Original_Amount] NVARCHAR(MAX) NULL,
    [Position] NVARCHAR(MAX) NULL,
    [Produktionsenh] NVARCHAR(MAX) NULL,
    [Ratespecifikation] NVARCHAR(MAX) NULL,
    [ReturÅrsagText] NVARCHAR(MAX) NULL,
    [ReturAarsagKode] NVARCHAR(MAX) NULL,
    [Returdato] NVARCHAR(MAX) NULL,
    [SBS_dokumentnummer] NVARCHAR(MAX) NULL,
    [SBS_Document_Number] NVARCHAR(MAX) NULL,
    [Sidste_rentefrie_indbetalingsdato] NVARCHAR(MAX) NULL,
    [Slettes] NVARCHAR(MAX) NULL,
    [Slutdato_for_forrentn] NVARCHAR(MAX) NULL,
    [SRI_dato] NVARCHAR(MAX) NULL,
    [Status] NVARCHAR(MAX) NULL,
    [Stiftelsesdato] NVARCHAR(MAX) NULL,
    [System_dato] NVARCHAR(MAX) NULL,
    [Text_Position_Number] NVARCHAR(MAX) NULL,
    [Tilb_Virkningsdato] NVARCHAR(MAX) NULL,
    [TilbageAarsagKode] NVARCHAR(MAX) NULL,
    [UdlBeløb_int_valuta] NVARCHAR(MAX) NULL,
    [Udligningsdato] NVARCHAR(MAX) NULL,
    [Valørdato] NVARCHAR(MAX) NULL,
    [Valuta] NVARCHAR(MAX) NULL,
    [Ydelsesperiode_fra] NVARCHAR(MAX) NULL,
    [Ydelsesperiode_til] NVARCHAR(MAX) NULL,
    [export_date] NVARCHAR(MAX) NULL,
    [file_origin] NVARCHAR(MAX) NULL,
    [row_number] NVARCHAR(MAX) NULL,
    [etl_version] NVARCHAR(MAX) NULL
        );
    END
    
    
    IF OBJECT_ID('[ode].[RIM-aftale-rater_Total_Typed]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[RIM-aftale-rater_Total_Typed] (
        [Ændret_den] DATE NULL,
    [Aftale] NVARCHAR(255) NULL,
    [Aftalekonto] NVARCHAR(255) NULL,
    [Aftalekontotype] NVARCHAR(255) NULL,
    [Aftalenummer] NVARCHAR(255) NULL,
    [Aftalestatus] NVARCHAR(255) NULL,
    [Aftaletype] NVARCHAR(255) NULL,
    [Basisdato_renteberegning] DATE NULL,
    [Bilagsnummer] NVARCHAR(255) NULL,
    [Creation_Amount] DECIMAL(15,2) NULL,
    [Deltransaktion] NVARCHAR(255) NULL,
    [EFI-nummer] INT NULL,
    [Forældelsesdato] DATE NULL,
    [Fordringstype] NVARCHAR(255) NULL,
    [Forretningspartner] NVARCHAR(255) NULL,
    [Gentagelsesposition] INT NULL,
    [Henstand_til] DATE NULL,
    [Hovedtransaktion] NVARCHAR(255) NULL,
    [Indholdsart] NVARCHAR(255) NULL,
    [Kommune_kode] NVARCHAR(255) NULL,
    [Konvertering_status] NVARCHAR(255) NULL,
    [KravsType] NVARCHAR(255) NULL,
    [Markering_for_tilbagekald] NVARCHAR(255) NULL,
    [Nettoforfald] DATE NULL,
    [Oprettet_den] DATE NULL,
    [Original_Amount] DECIMAL(15,2) NULL,
    [Position] INT NULL,
    [Produktionsenh] INT NULL,
    [Ratespecifikation] NVARCHAR(255) NULL,
    [ReturÅrsagText] NVARCHAR(255) NULL,
    [ReturAarsagKode] NVARCHAR(255) NULL,
    [Returdato] DATE NULL,
    [SBS_dokumentnummer] NVARCHAR(255) NULL,
    [SBS_Document_Number] NVARCHAR(255) NULL,
    [Sidste_rentefrie_indbetalingsdato] NVARCHAR(255) NULL,
    [Slettes] NVARCHAR(255) NULL,
    [Slutdato_for_forrentn] DATE NULL,
    [SRI_dato] DATE NULL,
    [Status] NVARCHAR(255) NULL,
    [Stiftelsesdato] DATE NULL,
    [System_dato] DATE NULL,
    [Text_Position_Number] DECIMAL(15,2) NULL,
    [Tilb_Virkningsdato] DATE NULL,
    [TilbageAarsagKode] NVARCHAR(255) NULL,
    [UdlBeløb_int_valuta] DECIMAL(15,2) NULL,
    [Udligningsdato] DATE NULL,
    [Valørdato] DATE NULL,
    [Valuta] NVARCHAR(255) NULL,
    [Ydelsesperiode_fra] DATE NULL,
    [Ydelsesperiode_til] DATE NULL,
    [export_date] DATE NULL,
    [file_origin] NVARCHAR(255) NULL,
    [row_number] INT NULL,
    [etl_version] NVARCHAR(50) NULL
        );
    END
    
    
    IF OBJECT_ID('[ode].[RIM-aftale-rater]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[RIM-aftale-rater] (
        [Ændret_den] DATE NULL,
    [Aftale] NVARCHAR(255) NULL,
    [Aftalekonto] NVARCHAR(255) NULL,
    [Aftalekontotype] NVARCHAR(255) NULL,
    [Aftalenummer] NVARCHAR(255) NULL,
    [Aftalestatus] NVARCHAR(255) NULL,
    [Aftaletype] NVARCHAR(255) NULL,
    [Basisdato_renteberegning] DATE NULL,
    [Bilagsnummer] NVARCHAR(255) NULL,
    [Creation_Amount] DECIMAL(15,2) NULL,
    [Deltransaktion] NVARCHAR(255) NULL,
    [EFI-nummer] INT NULL,
    [Forældelsesdato] DATE NULL,
    [Fordringstype] NVARCHAR(255) NULL,
    [Forretningspartner] NVARCHAR(255) NULL,
    [Gentagelsesposition] INT NULL,
    [Henstand_til] DATE NULL,
    [Hovedtransaktion] NVARCHAR(255) NULL,
    [Indholdsart] NVARCHAR(255) NULL,
    [Kommune_kode] NVARCHAR(255) NULL,
    [Konvertering_status] NVARCHAR(255) NULL,
    [KravsType] NVARCHAR(255) NULL,
    [Markering_for_tilbagekald] NVARCHAR(255) NULL,
    [Nettoforfald] DATE NULL,
    [Oprettet_den] DATE NULL,
    [Original_Amount] DECIMAL(15,2) NULL,
    [Position] INT NULL,
    [Produktionsenh] INT NULL,
    [Ratespecifikation] NVARCHAR(255) NULL,
    [ReturÅrsagText] NVARCHAR(255) NULL,
    [ReturAarsagKode] NVARCHAR(255) NULL,
    [Returdato] DATE NULL,
    [SBS_dokumentnummer] NVARCHAR(255) NULL,
    [SBS_Document_Number] NVARCHAR(255) NULL,
    [Sidste_rentefrie_indbetalingsdato] NVARCHAR(255) NULL,
    [Slettes] NVARCHAR(255) NULL,
    [Slutdato_for_forrentn] DATE NULL,
    [SRI_dato] DATE NULL,
    [Status] NVARCHAR(255) NULL,
    [Stiftelsesdato] DATE NULL,
    [System_dato] DATE NULL,
    [Text_Position_Number] DECIMAL(15,2) NULL,
    [Tilb_Virkningsdato] DATE NULL,
    [TilbageAarsagKode] NVARCHAR(255) NULL,
    [UdlBeløb_int_valuta] DECIMAL(15,2) NULL,
    [Udligningsdato] DATE NULL,
    [Valørdato] DATE NULL,
    [Valuta] NVARCHAR(255) NULL,
    [Ydelsesperiode_fra] DATE NULL,
    [Ydelsesperiode_til] DATE NULL,
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
    INSERT INTO [ode].[RIM-aftale-rater_Total_Backup] (
        [Ændret_den],
    [Aftale],
    [Aftalekonto],
    [Aftalekontotype],
    [Aftalenummer],
    [Aftalestatus],
    [Aftaletype],
    [Basisdato_renteberegning],
    [Bilagsnummer],
    [Creation_Amount],
    [Deltransaktion],
    [EFI-nummer],
    [Forældelsesdato],
    [Fordringstype],
    [Forretningspartner],
    [Gentagelsesposition],
    [Henstand_til],
    [Hovedtransaktion],
    [Indholdsart],
    [Kommune_kode],
    [Konvertering_status],
    [KravsType],
    [Markering_for_tilbagekald],
    [Nettoforfald],
    [Oprettet_den],
    [Original_Amount],
    [Position],
    [Produktionsenh],
    [Ratespecifikation],
    [ReturÅrsagText],
    [ReturAarsagKode],
    [Returdato],
    [SBS_dokumentnummer],
    [SBS_Document_Number],
    [Sidste_rentefrie_indbetalingsdato],
    [Slettes],
    [Slutdato_for_forrentn],
    [SRI_dato],
    [Status],
    [Stiftelsesdato],
    [System_dato],
    [Text_Position_Number],
    [Tilb_Virkningsdato],
    [TilbageAarsagKode],
    [UdlBeløb_int_valuta],
    [Udligningsdato],
    [Valørdato],
    [Valuta],
    [Ydelsesperiode_fra],
    [Ydelsesperiode_til],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    )
    SELECT
        [Ændret_den],
    [Aftale],
    [Aftalekonto],
    [Aftalekontotype],
    [Aftalenummer],
    [Aftalestatus],
    [Aftaletype],
    [Basisdato_renteberegning],
    [Bilagsnummer],
    [Creation_Amount],
    [Deltransaktion],
    [EFI-nummer],
    [Forældelsesdato],
    [Fordringstype],
    [Forretningspartner],
    [Gentagelsesposition],
    [Henstand_til],
    [Hovedtransaktion],
    [Indholdsart],
    [Kommune_kode],
    [Konvertering_status],
    [KravsType],
    [Markering_for_tilbagekald],
    [Nettoforfald],
    [Oprettet_den],
    [Original_Amount],
    [Position],
    [Produktionsenh],
    [Ratespecifikation],
    [ReturÅrsagText],
    [ReturAarsagKode],
    [Returdato],
    [SBS_dokumentnummer],
    [SBS_Document_Number],
    [Sidste_rentefrie_indbetalingsdato],
    [Slettes],
    [Slutdato_for_forrentn],
    [SRI_dato],
    [Status],
    [Stiftelsesdato],
    [System_dato],
    [Text_Position_Number],
    [Tilb_Virkningsdato],
    [TilbageAarsagKode],
    [UdlBeløb_int_valuta],
    [Udligningsdato],
    [Valørdato],
    [Valuta],
    [Ydelsesperiode_fra],
    [Ydelsesperiode_til],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    FROM [ode].[RIM-aftale-rater_Total_Staging];
    
    GO
    
    
    -- 2. TYPED: Transform and insert (No PK defined)
    INSERT INTO [ode].[RIM-aftale-rater_Total_Typed] (
        [Ændret_den],
    [Aftale],
    [Aftalekonto],
    [Aftalekontotype],
    [Aftalenummer],
    [Aftalestatus],
    [Aftaletype],
    [Basisdato_renteberegning],
    [Bilagsnummer],
    [Creation_Amount],
    [Deltransaktion],
    [EFI-nummer],
    [Forældelsesdato],
    [Fordringstype],
    [Forretningspartner],
    [Gentagelsesposition],
    [Henstand_til],
    [Hovedtransaktion],
    [Indholdsart],
    [Kommune_kode],
    [Konvertering_status],
    [KravsType],
    [Markering_for_tilbagekald],
    [Nettoforfald],
    [Oprettet_den],
    [Original_Amount],
    [Position],
    [Produktionsenh],
    [Ratespecifikation],
    [ReturÅrsagText],
    [ReturAarsagKode],
    [Returdato],
    [SBS_dokumentnummer],
    [SBS_Document_Number],
    [Sidste_rentefrie_indbetalingsdato],
    [Slettes],
    [Slutdato_for_forrentn],
    [SRI_dato],
    [Status],
    [Stiftelsesdato],
    [System_dato],
    [Text_Position_Number],
    [Tilb_Virkningsdato],
    [TilbageAarsagKode],
    [UdlBeløb_int_valuta],
    [Udligningsdato],
    [Valørdato],
    [Valuta],
    [Ydelsesperiode_fra],
    [Ydelsesperiode_til],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    )
    SELECT
        CASE
            WHEN [Ændret_den] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Ændret_den]) = 8 AND [Ændret_den] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Ændret_den], 112)
            WHEN [Ændret_den] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Ændret_den], 104)
            ELSE TRY_CONVERT(DATE, [Ændret_den], 23)
        END AS [Ændret_den],
    LTRIM(RTRIM([Aftale])) AS [Aftale],
    LTRIM(RTRIM([Aftalekonto])) AS [Aftalekonto],
    LTRIM(RTRIM([Aftalekontotype])) AS [Aftalekontotype],
    LTRIM(RTRIM([Aftalenummer])) AS [Aftalenummer],
    LTRIM(RTRIM([Aftalestatus])) AS [Aftalestatus],
    LTRIM(RTRIM([Aftaletype])) AS [Aftaletype],
    CASE
            WHEN [Basisdato_renteberegning] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Basisdato_renteberegning]) = 8 AND [Basisdato_renteberegning] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Basisdato_renteberegning], 112)
            WHEN [Basisdato_renteberegning] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Basisdato_renteberegning], 104)
            ELSE TRY_CONVERT(DATE, [Basisdato_renteberegning], 23)
        END AS [Basisdato_renteberegning],
    LTRIM(RTRIM([Bilagsnummer])) AS [Bilagsnummer],
    CASE
            WHEN [Creation_Amount] IS NULL OR [Creation_Amount] = '' OR [Creation_Amount] = '0' THEN NULL
            WHEN [Creation_Amount] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Creation_Amount], LEN([Creation_Amount])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Creation_Amount], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Creation_Amount],
    LTRIM(RTRIM([Deltransaktion])) AS [Deltransaktion],
    TRY_CAST(REPLACE([EFI-nummer], '.', '') AS INT) AS [EFI-nummer],
    CASE
            WHEN [Forældelsesdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Forældelsesdato]) = 8 AND [Forældelsesdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Forældelsesdato], 112)
            WHEN [Forældelsesdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Forældelsesdato], 104)
            ELSE TRY_CONVERT(DATE, [Forældelsesdato], 23)
        END AS [Forældelsesdato],
    LTRIM(RTRIM([Fordringstype])) AS [Fordringstype],
    LTRIM(RTRIM([Forretningspartner])) AS [Forretningspartner],
    TRY_CAST(REPLACE([Gentagelsesposition], '.', '') AS INT) AS [Gentagelsesposition],
    CASE
            WHEN [Henstand_til] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Henstand_til]) = 8 AND [Henstand_til] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Henstand_til], 112)
            WHEN [Henstand_til] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Henstand_til], 104)
            ELSE TRY_CONVERT(DATE, [Henstand_til], 23)
        END AS [Henstand_til],
    LTRIM(RTRIM([Hovedtransaktion])) AS [Hovedtransaktion],
    LTRIM(RTRIM([Indholdsart])) AS [Indholdsart],
    LTRIM(RTRIM([Kommune_kode])) AS [Kommune_kode],
    LTRIM(RTRIM([Konvertering_status])) AS [Konvertering_status],
    LTRIM(RTRIM([KravsType])) AS [KravsType],
    LTRIM(RTRIM([Markering_for_tilbagekald])) AS [Markering_for_tilbagekald],
    CASE
            WHEN [Nettoforfald] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Nettoforfald]) = 8 AND [Nettoforfald] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Nettoforfald], 112)
            WHEN [Nettoforfald] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Nettoforfald], 104)
            ELSE TRY_CONVERT(DATE, [Nettoforfald], 23)
        END AS [Nettoforfald],
    CASE
            WHEN [Oprettet_den] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Oprettet_den]) = 8 AND [Oprettet_den] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Oprettet_den], 112)
            WHEN [Oprettet_den] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Oprettet_den], 104)
            ELSE TRY_CONVERT(DATE, [Oprettet_den], 23)
        END AS [Oprettet_den],
    CASE
            WHEN [Original_Amount] IS NULL OR [Original_Amount] = '' OR [Original_Amount] = '0' THEN NULL
            WHEN [Original_Amount] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Original_Amount], LEN([Original_Amount])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Original_Amount], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Original_Amount],
    TRY_CAST(REPLACE([Position], '.', '') AS INT) AS [Position],
    TRY_CAST(REPLACE([Produktionsenh], '.', '') AS INT) AS [Produktionsenh],
    LTRIM(RTRIM([Ratespecifikation])) AS [Ratespecifikation],
    LTRIM(RTRIM([ReturÅrsagText])) AS [ReturÅrsagText],
    LTRIM(RTRIM([ReturAarsagKode])) AS [ReturAarsagKode],
    CASE
            WHEN [Returdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Returdato]) = 8 AND [Returdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Returdato], 112)
            WHEN [Returdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Returdato], 104)
            ELSE TRY_CONVERT(DATE, [Returdato], 23)
        END AS [Returdato],
    LTRIM(RTRIM([SBS_dokumentnummer])) AS [SBS_dokumentnummer],
    LTRIM(RTRIM([SBS_Document_Number])) AS [SBS_Document_Number],
    LTRIM(RTRIM([Sidste_rentefrie_indbetalingsdato])) AS [Sidste_rentefrie_indbetalingsdato],
    LTRIM(RTRIM([Slettes])) AS [Slettes],
    CASE
            WHEN [Slutdato_for_forrentn] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Slutdato_for_forrentn]) = 8 AND [Slutdato_for_forrentn] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Slutdato_for_forrentn], 112)
            WHEN [Slutdato_for_forrentn] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Slutdato_for_forrentn], 104)
            ELSE TRY_CONVERT(DATE, [Slutdato_for_forrentn], 23)
        END AS [Slutdato_for_forrentn],
    CASE
            WHEN [SRI_dato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([SRI_dato]) = 8 AND [SRI_dato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [SRI_dato], 112)
            WHEN [SRI_dato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [SRI_dato], 104)
            ELSE TRY_CONVERT(DATE, [SRI_dato], 23)
        END AS [SRI_dato],
    LTRIM(RTRIM([Status])) AS [Status],
    CASE
            WHEN [Stiftelsesdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Stiftelsesdato]) = 8 AND [Stiftelsesdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Stiftelsesdato], 112)
            WHEN [Stiftelsesdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Stiftelsesdato], 104)
            ELSE TRY_CONVERT(DATE, [Stiftelsesdato], 23)
        END AS [Stiftelsesdato],
    CASE
            WHEN [System_dato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([System_dato]) = 8 AND [System_dato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [System_dato], 112)
            WHEN [System_dato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [System_dato], 104)
            ELSE TRY_CONVERT(DATE, [System_dato], 23)
        END AS [System_dato],
    CASE
            WHEN [Text_Position_Number] IS NULL OR [Text_Position_Number] = '' OR [Text_Position_Number] = '0' THEN NULL
            WHEN [Text_Position_Number] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Text_Position_Number], LEN([Text_Position_Number])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Text_Position_Number], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Text_Position_Number],
    CASE
            WHEN [Tilb_Virkningsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Tilb_Virkningsdato]) = 8 AND [Tilb_Virkningsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Tilb_Virkningsdato], 112)
            WHEN [Tilb_Virkningsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Tilb_Virkningsdato], 104)
            ELSE TRY_CONVERT(DATE, [Tilb_Virkningsdato], 23)
        END AS [Tilb_Virkningsdato],
    LTRIM(RTRIM([TilbageAarsagKode])) AS [TilbageAarsagKode],
    CASE
            WHEN [UdlBeløb_int_valuta] IS NULL OR [UdlBeløb_int_valuta] = '' OR [UdlBeløb_int_valuta] = '0' THEN NULL
            WHEN [UdlBeløb_int_valuta] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([UdlBeløb_int_valuta], LEN([UdlBeløb_int_valuta])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([UdlBeløb_int_valuta], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [UdlBeløb_int_valuta],
    CASE
            WHEN [Udligningsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Udligningsdato]) = 8 AND [Udligningsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Udligningsdato], 112)
            WHEN [Udligningsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Udligningsdato], 104)
            ELSE TRY_CONVERT(DATE, [Udligningsdato], 23)
        END AS [Udligningsdato],
    CASE
            WHEN [Valørdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Valørdato]) = 8 AND [Valørdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Valørdato], 112)
            WHEN [Valørdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Valørdato], 104)
            ELSE TRY_CONVERT(DATE, [Valørdato], 23)
        END AS [Valørdato],
    LTRIM(RTRIM([Valuta])) AS [Valuta],
    CASE
            WHEN [Ydelsesperiode_fra] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Ydelsesperiode_fra]) = 8 AND [Ydelsesperiode_fra] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Ydelsesperiode_fra], 112)
            WHEN [Ydelsesperiode_fra] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Ydelsesperiode_fra], 104)
            ELSE TRY_CONVERT(DATE, [Ydelsesperiode_fra], 23)
        END AS [Ydelsesperiode_fra],
    CASE
            WHEN [Ydelsesperiode_til] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Ydelsesperiode_til]) = 8 AND [Ydelsesperiode_til] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Ydelsesperiode_til], 112)
            WHEN [Ydelsesperiode_til] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Ydelsesperiode_til], 104)
            ELSE TRY_CONVERT(DATE, [Ydelsesperiode_til], 23)
        END AS [Ydelsesperiode_til],
    CASE
            WHEN [export_date] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([export_date]) = 8 AND [export_date] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [export_date], 112)
            WHEN [export_date] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [export_date], 104)
            ELSE TRY_CONVERT(DATE, [export_date], 23)
        END AS [export_date],
    LTRIM(RTRIM([file_origin])) AS [file_origin],
    TRY_CAST(REPLACE([row_number], '.', '') AS INT) AS [row_number],
    LTRIM(RTRIM([etl_version])) AS [etl_version]
    FROM [ode].[RIM-aftale-rater_Total_Staging];
    
    GO
    
    
    -- 3. SNAPSHOT: Total Replacement (No PK)
    WITH new_data AS (
        SELECT
        CASE
            WHEN [Ændret_den] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Ændret_den]) = 8 AND [Ændret_den] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Ændret_den], 112)
            WHEN [Ændret_den] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Ændret_den], 104)
            ELSE TRY_CONVERT(DATE, [Ændret_den], 23)
        END AS [Ændret_den],
    LTRIM(RTRIM([Aftale])) AS [Aftale],
    LTRIM(RTRIM([Aftalekonto])) AS [Aftalekonto],
    LTRIM(RTRIM([Aftalekontotype])) AS [Aftalekontotype],
    LTRIM(RTRIM([Aftalenummer])) AS [Aftalenummer],
    LTRIM(RTRIM([Aftalestatus])) AS [Aftalestatus],
    LTRIM(RTRIM([Aftaletype])) AS [Aftaletype],
    CASE
            WHEN [Basisdato_renteberegning] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Basisdato_renteberegning]) = 8 AND [Basisdato_renteberegning] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Basisdato_renteberegning], 112)
            WHEN [Basisdato_renteberegning] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Basisdato_renteberegning], 104)
            ELSE TRY_CONVERT(DATE, [Basisdato_renteberegning], 23)
        END AS [Basisdato_renteberegning],
    LTRIM(RTRIM([Bilagsnummer])) AS [Bilagsnummer],
    CASE
            WHEN [Creation_Amount] IS NULL OR [Creation_Amount] = '' OR [Creation_Amount] = '0' THEN NULL
            WHEN [Creation_Amount] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Creation_Amount], LEN([Creation_Amount])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Creation_Amount], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Creation_Amount],
    LTRIM(RTRIM([Deltransaktion])) AS [Deltransaktion],
    TRY_CAST(REPLACE([EFI-nummer], '.', '') AS INT) AS [EFI-nummer],
    CASE
            WHEN [Forældelsesdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Forældelsesdato]) = 8 AND [Forældelsesdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Forældelsesdato], 112)
            WHEN [Forældelsesdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Forældelsesdato], 104)
            ELSE TRY_CONVERT(DATE, [Forældelsesdato], 23)
        END AS [Forældelsesdato],
    LTRIM(RTRIM([Fordringstype])) AS [Fordringstype],
    LTRIM(RTRIM([Forretningspartner])) AS [Forretningspartner],
    TRY_CAST(REPLACE([Gentagelsesposition], '.', '') AS INT) AS [Gentagelsesposition],
    CASE
            WHEN [Henstand_til] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Henstand_til]) = 8 AND [Henstand_til] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Henstand_til], 112)
            WHEN [Henstand_til] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Henstand_til], 104)
            ELSE TRY_CONVERT(DATE, [Henstand_til], 23)
        END AS [Henstand_til],
    LTRIM(RTRIM([Hovedtransaktion])) AS [Hovedtransaktion],
    LTRIM(RTRIM([Indholdsart])) AS [Indholdsart],
    LTRIM(RTRIM([Kommune_kode])) AS [Kommune_kode],
    LTRIM(RTRIM([Konvertering_status])) AS [Konvertering_status],
    LTRIM(RTRIM([KravsType])) AS [KravsType],
    LTRIM(RTRIM([Markering_for_tilbagekald])) AS [Markering_for_tilbagekald],
    CASE
            WHEN [Nettoforfald] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Nettoforfald]) = 8 AND [Nettoforfald] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Nettoforfald], 112)
            WHEN [Nettoforfald] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Nettoforfald], 104)
            ELSE TRY_CONVERT(DATE, [Nettoforfald], 23)
        END AS [Nettoforfald],
    CASE
            WHEN [Oprettet_den] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Oprettet_den]) = 8 AND [Oprettet_den] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Oprettet_den], 112)
            WHEN [Oprettet_den] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Oprettet_den], 104)
            ELSE TRY_CONVERT(DATE, [Oprettet_den], 23)
        END AS [Oprettet_den],
    CASE
            WHEN [Original_Amount] IS NULL OR [Original_Amount] = '' OR [Original_Amount] = '0' THEN NULL
            WHEN [Original_Amount] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Original_Amount], LEN([Original_Amount])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Original_Amount], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Original_Amount],
    TRY_CAST(REPLACE([Position], '.', '') AS INT) AS [Position],
    TRY_CAST(REPLACE([Produktionsenh], '.', '') AS INT) AS [Produktionsenh],
    LTRIM(RTRIM([Ratespecifikation])) AS [Ratespecifikation],
    LTRIM(RTRIM([ReturÅrsagText])) AS [ReturÅrsagText],
    LTRIM(RTRIM([ReturAarsagKode])) AS [ReturAarsagKode],
    CASE
            WHEN [Returdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Returdato]) = 8 AND [Returdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Returdato], 112)
            WHEN [Returdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Returdato], 104)
            ELSE TRY_CONVERT(DATE, [Returdato], 23)
        END AS [Returdato],
    LTRIM(RTRIM([SBS_dokumentnummer])) AS [SBS_dokumentnummer],
    LTRIM(RTRIM([SBS_Document_Number])) AS [SBS_Document_Number],
    LTRIM(RTRIM([Sidste_rentefrie_indbetalingsdato])) AS [Sidste_rentefrie_indbetalingsdato],
    LTRIM(RTRIM([Slettes])) AS [Slettes],
    CASE
            WHEN [Slutdato_for_forrentn] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Slutdato_for_forrentn]) = 8 AND [Slutdato_for_forrentn] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Slutdato_for_forrentn], 112)
            WHEN [Slutdato_for_forrentn] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Slutdato_for_forrentn], 104)
            ELSE TRY_CONVERT(DATE, [Slutdato_for_forrentn], 23)
        END AS [Slutdato_for_forrentn],
    CASE
            WHEN [SRI_dato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([SRI_dato]) = 8 AND [SRI_dato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [SRI_dato], 112)
            WHEN [SRI_dato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [SRI_dato], 104)
            ELSE TRY_CONVERT(DATE, [SRI_dato], 23)
        END AS [SRI_dato],
    LTRIM(RTRIM([Status])) AS [Status],
    CASE
            WHEN [Stiftelsesdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Stiftelsesdato]) = 8 AND [Stiftelsesdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Stiftelsesdato], 112)
            WHEN [Stiftelsesdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Stiftelsesdato], 104)
            ELSE TRY_CONVERT(DATE, [Stiftelsesdato], 23)
        END AS [Stiftelsesdato],
    CASE
            WHEN [System_dato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([System_dato]) = 8 AND [System_dato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [System_dato], 112)
            WHEN [System_dato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [System_dato], 104)
            ELSE TRY_CONVERT(DATE, [System_dato], 23)
        END AS [System_dato],
    CASE
            WHEN [Text_Position_Number] IS NULL OR [Text_Position_Number] = '' OR [Text_Position_Number] = '0' THEN NULL
            WHEN [Text_Position_Number] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Text_Position_Number], LEN([Text_Position_Number])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Text_Position_Number], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Text_Position_Number],
    CASE
            WHEN [Tilb_Virkningsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Tilb_Virkningsdato]) = 8 AND [Tilb_Virkningsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Tilb_Virkningsdato], 112)
            WHEN [Tilb_Virkningsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Tilb_Virkningsdato], 104)
            ELSE TRY_CONVERT(DATE, [Tilb_Virkningsdato], 23)
        END AS [Tilb_Virkningsdato],
    LTRIM(RTRIM([TilbageAarsagKode])) AS [TilbageAarsagKode],
    CASE
            WHEN [UdlBeløb_int_valuta] IS NULL OR [UdlBeløb_int_valuta] = '' OR [UdlBeløb_int_valuta] = '0' THEN NULL
            WHEN [UdlBeløb_int_valuta] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([UdlBeløb_int_valuta], LEN([UdlBeløb_int_valuta])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([UdlBeløb_int_valuta], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [UdlBeløb_int_valuta],
    CASE
            WHEN [Udligningsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Udligningsdato]) = 8 AND [Udligningsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Udligningsdato], 112)
            WHEN [Udligningsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Udligningsdato], 104)
            ELSE TRY_CONVERT(DATE, [Udligningsdato], 23)
        END AS [Udligningsdato],
    CASE
            WHEN [Valørdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Valørdato]) = 8 AND [Valørdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Valørdato], 112)
            WHEN [Valørdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Valørdato], 104)
            ELSE TRY_CONVERT(DATE, [Valørdato], 23)
        END AS [Valørdato],
    LTRIM(RTRIM([Valuta])) AS [Valuta],
    CASE
            WHEN [Ydelsesperiode_fra] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Ydelsesperiode_fra]) = 8 AND [Ydelsesperiode_fra] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Ydelsesperiode_fra], 112)
            WHEN [Ydelsesperiode_fra] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Ydelsesperiode_fra], 104)
            ELSE TRY_CONVERT(DATE, [Ydelsesperiode_fra], 23)
        END AS [Ydelsesperiode_fra],
    CASE
            WHEN [Ydelsesperiode_til] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Ydelsesperiode_til]) = 8 AND [Ydelsesperiode_til] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Ydelsesperiode_til], 112)
            WHEN [Ydelsesperiode_til] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Ydelsesperiode_til], 104)
            ELSE TRY_CONVERT(DATE, [Ydelsesperiode_til], 23)
        END AS [Ydelsesperiode_til],
    CASE
            WHEN [export_date] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([export_date]) = 8 AND [export_date] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [export_date], 112)
            WHEN [export_date] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [export_date], 104)
            ELSE TRY_CONVERT(DATE, [export_date], 23)
        END AS [export_date],
    LTRIM(RTRIM([file_origin])) AS [file_origin],
    TRY_CAST(REPLACE([row_number], '.', '') AS INT) AS [row_number],
    LTRIM(RTRIM([etl_version])) AS [etl_version]
        FROM [ode].[RIM-aftale-rater_Total_Staging]
    )
    INSERT INTO [ode].[RIM-aftale-rater] ([Ændret_den], [Aftale], [Aftalekonto], [Aftalekontotype], [Aftalenummer], [Aftalestatus], [Aftaletype], [Basisdato_renteberegning], [Bilagsnummer], [Creation_Amount], [Deltransaktion], [EFI-nummer], [Forældelsesdato], [Fordringstype], [Forretningspartner], [Gentagelsesposition], [Henstand_til], [Hovedtransaktion], [Indholdsart], [Kommune_kode], [Konvertering_status], [KravsType], [Markering_for_tilbagekald], [Nettoforfald], [Oprettet_den], [Original_Amount], [Position], [Produktionsenh], [Ratespecifikation], [ReturÅrsagText], [ReturAarsagKode], [Returdato], [SBS_dokumentnummer], [SBS_Document_Number], [Sidste_rentefrie_indbetalingsdato], [Slettes], [Slutdato_for_forrentn], [SRI_dato], [Status], [Stiftelsesdato], [System_dato], [Text_Position_Number], [Tilb_Virkningsdato], [TilbageAarsagKode], [UdlBeløb_int_valuta], [Udligningsdato], [Valørdato], [Valuta], [Ydelsesperiode_fra], [Ydelsesperiode_til], [export_date], [file_origin], [row_number], [etl_version])
    SELECT [Ændret_den], [Aftale], [Aftalekonto], [Aftalekontotype], [Aftalenummer], [Aftalestatus], [Aftaletype], [Basisdato_renteberegning], [Bilagsnummer], [Creation_Amount], [Deltransaktion], [EFI-nummer], [Forældelsesdato], [Fordringstype], [Forretningspartner], [Gentagelsesposition], [Henstand_til], [Hovedtransaktion], [Indholdsart], [Kommune_kode], [Konvertering_status], [KravsType], [Markering_for_tilbagekald], [Nettoforfald], [Oprettet_den], [Original_Amount], [Position], [Produktionsenh], [Ratespecifikation], [ReturÅrsagText], [ReturAarsagKode], [Returdato], [SBS_dokumentnummer], [SBS_Document_Number], [Sidste_rentefrie_indbetalingsdato], [Slettes], [Slutdato_for_forrentn], [SRI_dato], [Status], [Stiftelsesdato], [System_dato], [Text_Position_Number], [Tilb_Virkningsdato], [TilbageAarsagKode], [UdlBeløb_int_valuta], [Udligningsdato], [Valørdato], [Valuta], [Ydelsesperiode_fra], [Ydelsesperiode_til], [export_date], [file_origin], [row_number], [etl_version] FROM new_data;
    
    GO

    
    -- D. Validation Metrics
    ------------------------------------------------------------
    SELECT 
        'ROW_COUNTS' as metric,
        (SELECT COUNT(*) FROM [ode].[RIM-aftale-rater_Total_Staging]) as source_rows,
        (SELECT COUNT(*) FROM [ode].[RIM-aftale-rater]) as target_rows;
    
    GO

    -- C. Cleanup (Optional - Staging table usually kept until file move is confirmed)
    DROP TABLE [ode].[RIM-aftale-rater_Total_Staging];
    GO
    