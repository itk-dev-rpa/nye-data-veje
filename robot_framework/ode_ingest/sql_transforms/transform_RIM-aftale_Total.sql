
    -- ============================================================
    -- Pipeline Script for RIM-aftale (Total)
    -- Source:  RIM-aftale_Total_Staging
    -- Targets: RIM-aftale_Total_Backup, RIM-aftale_Total_Typed, RIM-aftale
    -- Generated automatically
    -- ============================================================

    USE [BackDataLake-Test];
    GO

    -- A. Ensure Target Tables Exist
    ------------------------------------------------------------
    
    IF OBJECT_ID('[ode].[RIM-aftale_Total_Backup]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[RIM-aftale_Total_Backup] (
        [Åbent_beløb_for_perioden] NVARCHAR(MAX) NULL,
    [Ændret_den] NVARCHAR(MAX) NULL,
    [Ændringsårsagstekst] NVARCHAR(MAX) NULL,
    [Ændringsårsagskode] NVARCHAR(MAX) NULL,
    [Aftalenummer] NVARCHAR(MAX) NULL,
    [Aftalestatus] NVARCHAR(MAX) NULL,
    [Aftaletype] NVARCHAR(MAX) NULL,
    [Afvis] NVARCHAR(MAX) NULL,
    [ActionStatusCode] NVARCHAR(MAX) NULL,
    [Aktionkode] NVARCHAR(MAX) NULL,
    [Aktions-id] NVARCHAR(MAX) NULL,
    [Basisdato_renteberegning] NVARCHAR(MAX) NULL,
    [Beløb_accepteret] NVARCHAR(MAX) NULL,
    [Beløb] NVARCHAR(MAX) NULL,
    [Bilagsnummer] NVARCHAR(MAX) NULL,
    [EFI-nummer] NVARCHAR(MAX) NULL,
    [Forældelsesdato] NVARCHAR(MAX) NULL,
    [Forretningspartner] NVARCHAR(MAX) NULL,
    [Kommune_kode] NVARCHAR(MAX) NULL,
    [KravsType] NVARCHAR(MAX) NULL,
    [Krydsende_handling] NVARCHAR(MAX) NULL,
    [Markering_for_tilbagekald] NVARCHAR(MAX) NULL,
    [Medhæfter_status] NVARCHAR(MAX) NULL,
    [Modtagelsesdato] NVARCHAR(MAX) NULL,
    [Oprettet_den] NVARCHAR(MAX) NULL,
    [Oprettet_kl] NVARCHAR(MAX) NULL,
    [Recall_Amount] NVARCHAR(MAX) NULL,
    [Reduceret_beløb] NVARCHAR(MAX) NULL,
    [Reference_til_ændring] NVARCHAR(MAX) NULL,
    [Rest_beløb_markering] NVARCHAR(MAX) NULL,
    [RestBeløb] NVARCHAR(MAX) NULL,
    [ReturAarsagKode] NVARCHAR(MAX) NULL,
    [ReturÅrsagText] NVARCHAR(MAX) NULL,
    [Returdato] NVARCHAR(MAX) NULL,
    [RIM_ændringsdato] NVARCHAR(MAX) NULL,
    [SBS_dokumentnummer] NVARCHAR(MAX) NULL,
    [Slutdato_for_forrentn] NVARCHAR(MAX) NULL,
    [Snitflade_Status] NVARCHAR(MAX) NULL,
    [Status] NVARCHAR(MAX) NULL,
    [System_dato] NVARCHAR(MAX) NULL,
    [Tilb_Virkningsdato] NVARCHAR(MAX) NULL,
    [TilbageAarsagKode] NVARCHAR(MAX) NULL,
    [Trans_Beløb] NVARCHAR(MAX) NULL,
    [Trans_flag] NVARCHAR(MAX) NULL,
    [Trans_header_ID] NVARCHAR(MAX) NULL,
    [Trans_sekvens_nr] NVARCHAR(MAX) NULL,
    [Transaktion_identifikator] NVARCHAR(MAX) NULL,
    [Transdato] NVARCHAR(MAX) NULL,
    [Transtid] NVARCHAR(MAX) NULL,
    [UdlBeløb_int_valuta] NVARCHAR(MAX) NULL,
    [Udligningsdato] NVARCHAR(MAX) NULL,
    [UUID] NVARCHAR(MAX) NULL,
    [Valuta] NVARCHAR(MAX) NULL,
    [Valutanøgle] NVARCHAR(MAX) NULL,
    [Virkningsdato] NVARCHAR(MAX) NULL,
    [export_date] NVARCHAR(MAX) NULL,
    [file_origin] NVARCHAR(MAX) NULL,
    [row_number] NVARCHAR(MAX) NULL,
    [etl_version] NVARCHAR(MAX) NULL
        );
    END
    
    
    IF OBJECT_ID('[ode].[RIM-aftale_Total_Typed]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[RIM-aftale_Total_Typed] (
        [Åbent_beløb_for_perioden] DECIMAL(15,2) NULL,
    [Ændret_den] DATE NULL,
    [Ændringsårsagstekst] NVARCHAR(255) NULL,
    [Ændringsårsagskode] NVARCHAR(255) NULL,
    [Aftalenummer] NVARCHAR(255) NULL,
    [Aftalestatus] NVARCHAR(255) NULL,
    [Aftaletype] NVARCHAR(255) NULL,
    [Afvis] NVARCHAR(255) NULL,
    [ActionStatusCode] NVARCHAR(255) NULL,
    [Aktionkode] NVARCHAR(255) NULL,
    [Aktions-id] INT NULL,
    [Basisdato_renteberegning] DATE NULL,
    [Beløb_accepteret] DECIMAL(15,2) NULL,
    [Beløb] DECIMAL(15,2) NULL,
    [Bilagsnummer] NVARCHAR(255) NULL,
    [EFI-nummer] INT NULL,
    [Forældelsesdato] DATE NULL,
    [Forretningspartner] NVARCHAR(255) NULL,
    [Kommune_kode] NVARCHAR(255) NULL,
    [KravsType] NVARCHAR(255) NULL,
    [Krydsende_handling] NVARCHAR(255) NULL,
    [Markering_for_tilbagekald] NVARCHAR(255) NULL,
    [Medhæfter_status] NVARCHAR(255) NULL,
    [Modtagelsesdato] DATE NULL,
    [Oprettet_den] DATE NULL,
    [Oprettet_kl] NVARCHAR(255) NULL,
    [Recall_Amount] DECIMAL(15,2) NULL,
    [Reduceret_beløb] NVARCHAR(255) NULL,
    [Reference_til_ændring] NVARCHAR(255) NULL,
    [Rest_beløb_markering] NVARCHAR(255) NULL,
    [RestBeløb] DECIMAL(15,2) NULL,
    [ReturAarsagKode] NVARCHAR(255) NULL,
    [ReturÅrsagText] NVARCHAR(255) NULL,
    [Returdato] DATE NULL,
    [RIM_ændringsdato] NVARCHAR(255) NULL,
    [SBS_dokumentnummer] NVARCHAR(255) NULL,
    [Slutdato_for_forrentn] DATE NULL,
    [Snitflade_Status] NVARCHAR(255) NULL,
    [Status] NVARCHAR(255) NULL,
    [System_dato] DATE NULL,
    [Tilb_Virkningsdato] DATE NULL,
    [TilbageAarsagKode] NVARCHAR(255) NULL,
    [Trans_Beløb] DECIMAL(15,2) NULL,
    [Trans_flag] NVARCHAR(255) NULL,
    [Trans_header_ID] INT NULL,
    [Trans_sekvens_nr] INT NULL,
    [Transaktion_identifikator] NVARCHAR(255) NULL,
    [Transdato] DATE NULL,
    [Transtid] NVARCHAR(255) NULL,
    [UdlBeløb_int_valuta] DECIMAL(15,2) NULL,
    [Udligningsdato] DATE NULL,
    [UUID] NVARCHAR(255) NULL,
    [Valuta] NVARCHAR(255) NULL,
    [Valutanøgle] NVARCHAR(255) NULL,
    [Virkningsdato] DATE NULL,
    [export_date] DATE NULL,
    [file_origin] NVARCHAR(255) NULL,
    [row_number] INT NULL,
    [etl_version] NVARCHAR(50) NULL
        );
    END
    
    
    IF OBJECT_ID('[ode].[RIM-aftale]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[RIM-aftale] (
        [Åbent_beløb_for_perioden] DECIMAL(15,2) NULL,
    [Ændret_den] DATE NULL,
    [Ændringsårsagstekst] NVARCHAR(255) NULL,
    [Ændringsårsagskode] NVARCHAR(255) NULL,
    [Aftalenummer] NVARCHAR(255) NULL,
    [Aftalestatus] NVARCHAR(255) NULL,
    [Aftaletype] NVARCHAR(255) NULL,
    [Afvis] NVARCHAR(255) NULL,
    [ActionStatusCode] NVARCHAR(255) NULL,
    [Aktionkode] NVARCHAR(255) NULL,
    [Aktions-id] INT NULL,
    [Basisdato_renteberegning] DATE NULL,
    [Beløb_accepteret] DECIMAL(15,2) NULL,
    [Beløb] DECIMAL(15,2) NULL,
    [Bilagsnummer] NVARCHAR(255) NULL,
    [EFI-nummer] INT NULL,
    [Forældelsesdato] DATE NULL,
    [Forretningspartner] NVARCHAR(255) NULL,
    [Kommune_kode] NVARCHAR(255) NULL,
    [KravsType] NVARCHAR(255) NULL,
    [Krydsende_handling] NVARCHAR(255) NULL,
    [Markering_for_tilbagekald] NVARCHAR(255) NULL,
    [Medhæfter_status] NVARCHAR(255) NULL,
    [Modtagelsesdato] DATE NULL,
    [Oprettet_den] DATE NULL,
    [Oprettet_kl] NVARCHAR(255) NULL,
    [Recall_Amount] DECIMAL(15,2) NULL,
    [Reduceret_beløb] NVARCHAR(255) NULL,
    [Reference_til_ændring] NVARCHAR(255) NULL,
    [Rest_beløb_markering] NVARCHAR(255) NULL,
    [RestBeløb] DECIMAL(15,2) NULL,
    [ReturAarsagKode] NVARCHAR(255) NULL,
    [ReturÅrsagText] NVARCHAR(255) NULL,
    [Returdato] DATE NULL,
    [RIM_ændringsdato] NVARCHAR(255) NULL,
    [SBS_dokumentnummer] NVARCHAR(255) NULL,
    [Slutdato_for_forrentn] DATE NULL,
    [Snitflade_Status] NVARCHAR(255) NULL,
    [Status] NVARCHAR(255) NULL,
    [System_dato] DATE NULL,
    [Tilb_Virkningsdato] DATE NULL,
    [TilbageAarsagKode] NVARCHAR(255) NULL,
    [Trans_Beløb] DECIMAL(15,2) NULL,
    [Trans_flag] NVARCHAR(255) NULL,
    [Trans_header_ID] INT NULL,
    [Trans_sekvens_nr] INT NULL,
    [Transaktion_identifikator] NVARCHAR(255) NULL,
    [Transdato] DATE NULL,
    [Transtid] NVARCHAR(255) NULL,
    [UdlBeløb_int_valuta] DECIMAL(15,2) NULL,
    [Udligningsdato] DATE NULL,
    [UUID] NVARCHAR(255) NULL,
    [Valuta] NVARCHAR(255) NULL,
    [Valutanøgle] NVARCHAR(255) NULL,
    [Virkningsdato] DATE NULL,
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
    INSERT INTO [ode].[RIM-aftale_Total_Backup] (
        [Åbent_beløb_for_perioden],
    [Ændret_den],
    [Ændringsårsagstekst],
    [Ændringsårsagskode],
    [Aftalenummer],
    [Aftalestatus],
    [Aftaletype],
    [Afvis],
    [ActionStatusCode],
    [Aktionkode],
    [Aktions-id],
    [Basisdato_renteberegning],
    [Beløb_accepteret],
    [Beløb],
    [Bilagsnummer],
    [EFI-nummer],
    [Forældelsesdato],
    [Forretningspartner],
    [Kommune_kode],
    [KravsType],
    [Krydsende_handling],
    [Markering_for_tilbagekald],
    [Medhæfter_status],
    [Modtagelsesdato],
    [Oprettet_den],
    [Oprettet_kl],
    [Recall_Amount],
    [Reduceret_beløb],
    [Reference_til_ændring],
    [Rest_beløb_markering],
    [RestBeløb],
    [ReturAarsagKode],
    [ReturÅrsagText],
    [Returdato],
    [RIM_ændringsdato],
    [SBS_dokumentnummer],
    [Slutdato_for_forrentn],
    [Snitflade_Status],
    [Status],
    [System_dato],
    [Tilb_Virkningsdato],
    [TilbageAarsagKode],
    [Trans_Beløb],
    [Trans_flag],
    [Trans_header_ID],
    [Trans_sekvens_nr],
    [Transaktion_identifikator],
    [Transdato],
    [Transtid],
    [UdlBeløb_int_valuta],
    [Udligningsdato],
    [UUID],
    [Valuta],
    [Valutanøgle],
    [Virkningsdato],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    )
    SELECT
        [Åbent_beløb_for_perioden],
    [Ændret_den],
    [Ændringsårsagstekst],
    [Ændringsårsagskode],
    [Aftalenummer],
    [Aftalestatus],
    [Aftaletype],
    [Afvis],
    [ActionStatusCode],
    [Aktionkode],
    [Aktions-id],
    [Basisdato_renteberegning],
    [Beløb_accepteret],
    [Beløb],
    [Bilagsnummer],
    [EFI-nummer],
    [Forældelsesdato],
    [Forretningspartner],
    [Kommune_kode],
    [KravsType],
    [Krydsende_handling],
    [Markering_for_tilbagekald],
    [Medhæfter_status],
    [Modtagelsesdato],
    [Oprettet_den],
    [Oprettet_kl],
    [Recall_Amount],
    [Reduceret_beløb],
    [Reference_til_ændring],
    [Rest_beløb_markering],
    [RestBeløb],
    [ReturAarsagKode],
    [ReturÅrsagText],
    [Returdato],
    [RIM_ændringsdato],
    [SBS_dokumentnummer],
    [Slutdato_for_forrentn],
    [Snitflade_Status],
    [Status],
    [System_dato],
    [Tilb_Virkningsdato],
    [TilbageAarsagKode],
    [Trans_Beløb],
    [Trans_flag],
    [Trans_header_ID],
    [Trans_sekvens_nr],
    [Transaktion_identifikator],
    [Transdato],
    [Transtid],
    [UdlBeløb_int_valuta],
    [Udligningsdato],
    [UUID],
    [Valuta],
    [Valutanøgle],
    [Virkningsdato],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    FROM [ode].[RIM-aftale_Total_Staging];
    
    GO
    
    
    -- 2. TYPED: Transform and insert (No PK defined)
    INSERT INTO [ode].[RIM-aftale_Total_Typed] (
        [Åbent_beløb_for_perioden],
    [Ændret_den],
    [Ændringsårsagstekst],
    [Ændringsårsagskode],
    [Aftalenummer],
    [Aftalestatus],
    [Aftaletype],
    [Afvis],
    [ActionStatusCode],
    [Aktionkode],
    [Aktions-id],
    [Basisdato_renteberegning],
    [Beløb_accepteret],
    [Beløb],
    [Bilagsnummer],
    [EFI-nummer],
    [Forældelsesdato],
    [Forretningspartner],
    [Kommune_kode],
    [KravsType],
    [Krydsende_handling],
    [Markering_for_tilbagekald],
    [Medhæfter_status],
    [Modtagelsesdato],
    [Oprettet_den],
    [Oprettet_kl],
    [Recall_Amount],
    [Reduceret_beløb],
    [Reference_til_ændring],
    [Rest_beløb_markering],
    [RestBeløb],
    [ReturAarsagKode],
    [ReturÅrsagText],
    [Returdato],
    [RIM_ændringsdato],
    [SBS_dokumentnummer],
    [Slutdato_for_forrentn],
    [Snitflade_Status],
    [Status],
    [System_dato],
    [Tilb_Virkningsdato],
    [TilbageAarsagKode],
    [Trans_Beløb],
    [Trans_flag],
    [Trans_header_ID],
    [Trans_sekvens_nr],
    [Transaktion_identifikator],
    [Transdato],
    [Transtid],
    [UdlBeløb_int_valuta],
    [Udligningsdato],
    [UUID],
    [Valuta],
    [Valutanøgle],
    [Virkningsdato],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    )
    SELECT
        CASE
            WHEN [Åbent_beløb_for_perioden] IS NULL OR [Åbent_beløb_for_perioden] = '' OR [Åbent_beløb_for_perioden] = '0' THEN NULL
            WHEN [Åbent_beløb_for_perioden] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Åbent_beløb_for_perioden], LEN([Åbent_beløb_for_perioden])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Åbent_beløb_for_perioden], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Åbent_beløb_for_perioden],
    CASE
            WHEN [Ændret_den] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Ændret_den]) = 8 AND [Ændret_den] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Ændret_den], 112)
            WHEN [Ændret_den] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Ændret_den], 104)
            ELSE TRY_CONVERT(DATE, [Ændret_den], 23)
        END AS [Ændret_den],
    LTRIM(RTRIM([Ændringsårsagstekst])) AS [Ændringsårsagstekst],
    LTRIM(RTRIM([Ændringsårsagskode])) AS [Ændringsårsagskode],
    LTRIM(RTRIM([Aftalenummer])) AS [Aftalenummer],
    LTRIM(RTRIM([Aftalestatus])) AS [Aftalestatus],
    LTRIM(RTRIM([Aftaletype])) AS [Aftaletype],
    LTRIM(RTRIM([Afvis])) AS [Afvis],
    LTRIM(RTRIM([ActionStatusCode])) AS [ActionStatusCode],
    LTRIM(RTRIM([Aktionkode])) AS [Aktionkode],
    TRY_CAST(REPLACE([Aktions-id], '.', '') AS INT) AS [Aktions-id],
    CASE
            WHEN [Basisdato_renteberegning] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Basisdato_renteberegning]) = 8 AND [Basisdato_renteberegning] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Basisdato_renteberegning], 112)
            WHEN [Basisdato_renteberegning] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Basisdato_renteberegning], 104)
            ELSE TRY_CONVERT(DATE, [Basisdato_renteberegning], 23)
        END AS [Basisdato_renteberegning],
    CASE
            WHEN [Beløb_accepteret] IS NULL OR [Beløb_accepteret] = '' OR [Beløb_accepteret] = '0' THEN NULL
            WHEN [Beløb_accepteret] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Beløb_accepteret], LEN([Beløb_accepteret])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Beløb_accepteret], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Beløb_accepteret],
    CASE
            WHEN [Beløb] IS NULL OR [Beløb] = '' OR [Beløb] = '0' THEN NULL
            WHEN [Beløb] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Beløb], LEN([Beløb])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Beløb], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Beløb],
    LTRIM(RTRIM([Bilagsnummer])) AS [Bilagsnummer],
    TRY_CAST(REPLACE([EFI-nummer], '.', '') AS INT) AS [EFI-nummer],
    CASE
            WHEN [Forældelsesdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Forældelsesdato]) = 8 AND [Forældelsesdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Forældelsesdato], 112)
            WHEN [Forældelsesdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Forældelsesdato], 104)
            ELSE TRY_CONVERT(DATE, [Forældelsesdato], 23)
        END AS [Forældelsesdato],
    LTRIM(RTRIM([Forretningspartner])) AS [Forretningspartner],
    LTRIM(RTRIM([Kommune_kode])) AS [Kommune_kode],
    LTRIM(RTRIM([KravsType])) AS [KravsType],
    LTRIM(RTRIM([Krydsende_handling])) AS [Krydsende_handling],
    LTRIM(RTRIM([Markering_for_tilbagekald])) AS [Markering_for_tilbagekald],
    LTRIM(RTRIM([Medhæfter_status])) AS [Medhæfter_status],
    CASE
            WHEN [Modtagelsesdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Modtagelsesdato]) = 8 AND [Modtagelsesdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Modtagelsesdato], 112)
            WHEN [Modtagelsesdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Modtagelsesdato], 104)
            ELSE TRY_CONVERT(DATE, [Modtagelsesdato], 23)
        END AS [Modtagelsesdato],
    CASE
            WHEN [Oprettet_den] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Oprettet_den]) = 8 AND [Oprettet_den] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Oprettet_den], 112)
            WHEN [Oprettet_den] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Oprettet_den], 104)
            ELSE TRY_CONVERT(DATE, [Oprettet_den], 23)
        END AS [Oprettet_den],
    LTRIM(RTRIM([Oprettet_kl])) AS [Oprettet_kl],
    CASE
            WHEN [Recall_Amount] IS NULL OR [Recall_Amount] = '' OR [Recall_Amount] = '0' THEN NULL
            WHEN [Recall_Amount] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Recall_Amount], LEN([Recall_Amount])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Recall_Amount], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Recall_Amount],
    LTRIM(RTRIM([Reduceret_beløb])) AS [Reduceret_beløb],
    LTRIM(RTRIM([Reference_til_ændring])) AS [Reference_til_ændring],
    LTRIM(RTRIM([Rest_beløb_markering])) AS [Rest_beløb_markering],
    CASE
            WHEN [RestBeløb] IS NULL OR [RestBeløb] = '' OR [RestBeløb] = '0' THEN NULL
            WHEN [RestBeløb] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([RestBeløb], LEN([RestBeløb])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([RestBeløb], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [RestBeløb],
    LTRIM(RTRIM([ReturAarsagKode])) AS [ReturAarsagKode],
    LTRIM(RTRIM([ReturÅrsagText])) AS [ReturÅrsagText],
    CASE
            WHEN [Returdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Returdato]) = 8 AND [Returdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Returdato], 112)
            WHEN [Returdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Returdato], 104)
            ELSE TRY_CONVERT(DATE, [Returdato], 23)
        END AS [Returdato],
    LTRIM(RTRIM([RIM_ændringsdato])) AS [RIM_ændringsdato],
    LTRIM(RTRIM([SBS_dokumentnummer])) AS [SBS_dokumentnummer],
    CASE
            WHEN [Slutdato_for_forrentn] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Slutdato_for_forrentn]) = 8 AND [Slutdato_for_forrentn] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Slutdato_for_forrentn], 112)
            WHEN [Slutdato_for_forrentn] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Slutdato_for_forrentn], 104)
            ELSE TRY_CONVERT(DATE, [Slutdato_for_forrentn], 23)
        END AS [Slutdato_for_forrentn],
    LTRIM(RTRIM([Snitflade_Status])) AS [Snitflade_Status],
    LTRIM(RTRIM([Status])) AS [Status],
    CASE
            WHEN [System_dato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([System_dato]) = 8 AND [System_dato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [System_dato], 112)
            WHEN [System_dato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [System_dato], 104)
            ELSE TRY_CONVERT(DATE, [System_dato], 23)
        END AS [System_dato],
    CASE
            WHEN [Tilb_Virkningsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Tilb_Virkningsdato]) = 8 AND [Tilb_Virkningsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Tilb_Virkningsdato], 112)
            WHEN [Tilb_Virkningsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Tilb_Virkningsdato], 104)
            ELSE TRY_CONVERT(DATE, [Tilb_Virkningsdato], 23)
        END AS [Tilb_Virkningsdato],
    LTRIM(RTRIM([TilbageAarsagKode])) AS [TilbageAarsagKode],
    CASE
            WHEN [Trans_Beløb] IS NULL OR [Trans_Beløb] = '' OR [Trans_Beløb] = '0' THEN NULL
            WHEN [Trans_Beløb] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Trans_Beløb], LEN([Trans_Beløb])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Trans_Beløb], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Trans_Beløb],
    LTRIM(RTRIM([Trans_flag])) AS [Trans_flag],
    TRY_CAST(REPLACE([Trans_header_ID], '.', '') AS INT) AS [Trans_header_ID],
    TRY_CAST(REPLACE([Trans_sekvens_nr], '.', '') AS INT) AS [Trans_sekvens_nr],
    LTRIM(RTRIM([Transaktion_identifikator])) AS [Transaktion_identifikator],
    CASE
            WHEN [Transdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Transdato]) = 8 AND [Transdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Transdato], 112)
            WHEN [Transdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Transdato], 104)
            ELSE TRY_CONVERT(DATE, [Transdato], 23)
        END AS [Transdato],
    LTRIM(RTRIM([Transtid])) AS [Transtid],
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
    LTRIM(RTRIM([UUID])) AS [UUID],
    LTRIM(RTRIM([Valuta])) AS [Valuta],
    LTRIM(RTRIM([Valutanøgle])) AS [Valutanøgle],
    CASE
            WHEN [Virkningsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Virkningsdato]) = 8 AND [Virkningsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Virkningsdato], 112)
            WHEN [Virkningsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Virkningsdato], 104)
            ELSE TRY_CONVERT(DATE, [Virkningsdato], 23)
        END AS [Virkningsdato],
    CASE
            WHEN [export_date] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([export_date]) = 8 AND [export_date] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [export_date], 112)
            WHEN [export_date] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [export_date], 104)
            ELSE TRY_CONVERT(DATE, [export_date], 23)
        END AS [export_date],
    LTRIM(RTRIM([file_origin])) AS [file_origin],
    TRY_CAST(REPLACE([row_number], '.', '') AS INT) AS [row_number],
    LTRIM(RTRIM([etl_version])) AS [etl_version]
    FROM [ode].[RIM-aftale_Total_Staging];
    
    GO
    
    
    -- 3. SNAPSHOT: Total Replacement (No PK)
    WITH new_data AS (
        SELECT
        CASE
            WHEN [Åbent_beløb_for_perioden] IS NULL OR [Åbent_beløb_for_perioden] = '' OR [Åbent_beløb_for_perioden] = '0' THEN NULL
            WHEN [Åbent_beløb_for_perioden] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Åbent_beløb_for_perioden], LEN([Åbent_beløb_for_perioden])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Åbent_beløb_for_perioden], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Åbent_beløb_for_perioden],
    CASE
            WHEN [Ændret_den] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Ændret_den]) = 8 AND [Ændret_den] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Ændret_den], 112)
            WHEN [Ændret_den] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Ændret_den], 104)
            ELSE TRY_CONVERT(DATE, [Ændret_den], 23)
        END AS [Ændret_den],
    LTRIM(RTRIM([Ændringsårsagstekst])) AS [Ændringsårsagstekst],
    LTRIM(RTRIM([Ændringsårsagskode])) AS [Ændringsårsagskode],
    LTRIM(RTRIM([Aftalenummer])) AS [Aftalenummer],
    LTRIM(RTRIM([Aftalestatus])) AS [Aftalestatus],
    LTRIM(RTRIM([Aftaletype])) AS [Aftaletype],
    LTRIM(RTRIM([Afvis])) AS [Afvis],
    LTRIM(RTRIM([ActionStatusCode])) AS [ActionStatusCode],
    LTRIM(RTRIM([Aktionkode])) AS [Aktionkode],
    TRY_CAST(REPLACE([Aktions-id], '.', '') AS INT) AS [Aktions-id],
    CASE
            WHEN [Basisdato_renteberegning] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Basisdato_renteberegning]) = 8 AND [Basisdato_renteberegning] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Basisdato_renteberegning], 112)
            WHEN [Basisdato_renteberegning] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Basisdato_renteberegning], 104)
            ELSE TRY_CONVERT(DATE, [Basisdato_renteberegning], 23)
        END AS [Basisdato_renteberegning],
    CASE
            WHEN [Beløb_accepteret] IS NULL OR [Beløb_accepteret] = '' OR [Beløb_accepteret] = '0' THEN NULL
            WHEN [Beløb_accepteret] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Beløb_accepteret], LEN([Beløb_accepteret])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Beløb_accepteret], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Beløb_accepteret],
    CASE
            WHEN [Beløb] IS NULL OR [Beløb] = '' OR [Beløb] = '0' THEN NULL
            WHEN [Beløb] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Beløb], LEN([Beløb])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Beløb], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Beløb],
    LTRIM(RTRIM([Bilagsnummer])) AS [Bilagsnummer],
    TRY_CAST(REPLACE([EFI-nummer], '.', '') AS INT) AS [EFI-nummer],
    CASE
            WHEN [Forældelsesdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Forældelsesdato]) = 8 AND [Forældelsesdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Forældelsesdato], 112)
            WHEN [Forældelsesdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Forældelsesdato], 104)
            ELSE TRY_CONVERT(DATE, [Forældelsesdato], 23)
        END AS [Forældelsesdato],
    LTRIM(RTRIM([Forretningspartner])) AS [Forretningspartner],
    LTRIM(RTRIM([Kommune_kode])) AS [Kommune_kode],
    LTRIM(RTRIM([KravsType])) AS [KravsType],
    LTRIM(RTRIM([Krydsende_handling])) AS [Krydsende_handling],
    LTRIM(RTRIM([Markering_for_tilbagekald])) AS [Markering_for_tilbagekald],
    LTRIM(RTRIM([Medhæfter_status])) AS [Medhæfter_status],
    CASE
            WHEN [Modtagelsesdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Modtagelsesdato]) = 8 AND [Modtagelsesdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Modtagelsesdato], 112)
            WHEN [Modtagelsesdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Modtagelsesdato], 104)
            ELSE TRY_CONVERT(DATE, [Modtagelsesdato], 23)
        END AS [Modtagelsesdato],
    CASE
            WHEN [Oprettet_den] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Oprettet_den]) = 8 AND [Oprettet_den] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Oprettet_den], 112)
            WHEN [Oprettet_den] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Oprettet_den], 104)
            ELSE TRY_CONVERT(DATE, [Oprettet_den], 23)
        END AS [Oprettet_den],
    LTRIM(RTRIM([Oprettet_kl])) AS [Oprettet_kl],
    CASE
            WHEN [Recall_Amount] IS NULL OR [Recall_Amount] = '' OR [Recall_Amount] = '0' THEN NULL
            WHEN [Recall_Amount] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Recall_Amount], LEN([Recall_Amount])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Recall_Amount], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Recall_Amount],
    LTRIM(RTRIM([Reduceret_beløb])) AS [Reduceret_beløb],
    LTRIM(RTRIM([Reference_til_ændring])) AS [Reference_til_ændring],
    LTRIM(RTRIM([Rest_beløb_markering])) AS [Rest_beløb_markering],
    CASE
            WHEN [RestBeløb] IS NULL OR [RestBeløb] = '' OR [RestBeløb] = '0' THEN NULL
            WHEN [RestBeløb] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([RestBeløb], LEN([RestBeløb])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([RestBeløb], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [RestBeløb],
    LTRIM(RTRIM([ReturAarsagKode])) AS [ReturAarsagKode],
    LTRIM(RTRIM([ReturÅrsagText])) AS [ReturÅrsagText],
    CASE
            WHEN [Returdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Returdato]) = 8 AND [Returdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Returdato], 112)
            WHEN [Returdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Returdato], 104)
            ELSE TRY_CONVERT(DATE, [Returdato], 23)
        END AS [Returdato],
    LTRIM(RTRIM([RIM_ændringsdato])) AS [RIM_ændringsdato],
    LTRIM(RTRIM([SBS_dokumentnummer])) AS [SBS_dokumentnummer],
    CASE
            WHEN [Slutdato_for_forrentn] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Slutdato_for_forrentn]) = 8 AND [Slutdato_for_forrentn] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Slutdato_for_forrentn], 112)
            WHEN [Slutdato_for_forrentn] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Slutdato_for_forrentn], 104)
            ELSE TRY_CONVERT(DATE, [Slutdato_for_forrentn], 23)
        END AS [Slutdato_for_forrentn],
    LTRIM(RTRIM([Snitflade_Status])) AS [Snitflade_Status],
    LTRIM(RTRIM([Status])) AS [Status],
    CASE
            WHEN [System_dato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([System_dato]) = 8 AND [System_dato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [System_dato], 112)
            WHEN [System_dato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [System_dato], 104)
            ELSE TRY_CONVERT(DATE, [System_dato], 23)
        END AS [System_dato],
    CASE
            WHEN [Tilb_Virkningsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Tilb_Virkningsdato]) = 8 AND [Tilb_Virkningsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Tilb_Virkningsdato], 112)
            WHEN [Tilb_Virkningsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Tilb_Virkningsdato], 104)
            ELSE TRY_CONVERT(DATE, [Tilb_Virkningsdato], 23)
        END AS [Tilb_Virkningsdato],
    LTRIM(RTRIM([TilbageAarsagKode])) AS [TilbageAarsagKode],
    CASE
            WHEN [Trans_Beløb] IS NULL OR [Trans_Beløb] = '' OR [Trans_Beløb] = '0' THEN NULL
            WHEN [Trans_Beløb] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Trans_Beløb], LEN([Trans_Beløb])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Trans_Beløb], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Trans_Beløb],
    LTRIM(RTRIM([Trans_flag])) AS [Trans_flag],
    TRY_CAST(REPLACE([Trans_header_ID], '.', '') AS INT) AS [Trans_header_ID],
    TRY_CAST(REPLACE([Trans_sekvens_nr], '.', '') AS INT) AS [Trans_sekvens_nr],
    LTRIM(RTRIM([Transaktion_identifikator])) AS [Transaktion_identifikator],
    CASE
            WHEN [Transdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Transdato]) = 8 AND [Transdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Transdato], 112)
            WHEN [Transdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Transdato], 104)
            ELSE TRY_CONVERT(DATE, [Transdato], 23)
        END AS [Transdato],
    LTRIM(RTRIM([Transtid])) AS [Transtid],
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
    LTRIM(RTRIM([UUID])) AS [UUID],
    LTRIM(RTRIM([Valuta])) AS [Valuta],
    LTRIM(RTRIM([Valutanøgle])) AS [Valutanøgle],
    CASE
            WHEN [Virkningsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Virkningsdato]) = 8 AND [Virkningsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Virkningsdato], 112)
            WHEN [Virkningsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Virkningsdato], 104)
            ELSE TRY_CONVERT(DATE, [Virkningsdato], 23)
        END AS [Virkningsdato],
    CASE
            WHEN [export_date] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([export_date]) = 8 AND [export_date] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [export_date], 112)
            WHEN [export_date] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [export_date], 104)
            ELSE TRY_CONVERT(DATE, [export_date], 23)
        END AS [export_date],
    LTRIM(RTRIM([file_origin])) AS [file_origin],
    TRY_CAST(REPLACE([row_number], '.', '') AS INT) AS [row_number],
    LTRIM(RTRIM([etl_version])) AS [etl_version]
        FROM [ode].[RIM-aftale_Total_Staging]
    )
    INSERT INTO [ode].[RIM-aftale] ([Åbent_beløb_for_perioden], [Ændret_den], [Ændringsårsagstekst], [Ændringsårsagskode], [Aftalenummer], [Aftalestatus], [Aftaletype], [Afvis], [ActionStatusCode], [Aktionkode], [Aktions-id], [Basisdato_renteberegning], [Beløb_accepteret], [Beløb], [Bilagsnummer], [EFI-nummer], [Forældelsesdato], [Forretningspartner], [Kommune_kode], [KravsType], [Krydsende_handling], [Markering_for_tilbagekald], [Medhæfter_status], [Modtagelsesdato], [Oprettet_den], [Oprettet_kl], [Recall_Amount], [Reduceret_beløb], [Reference_til_ændring], [Rest_beløb_markering], [RestBeløb], [ReturAarsagKode], [ReturÅrsagText], [Returdato], [RIM_ændringsdato], [SBS_dokumentnummer], [Slutdato_for_forrentn], [Snitflade_Status], [Status], [System_dato], [Tilb_Virkningsdato], [TilbageAarsagKode], [Trans_Beløb], [Trans_flag], [Trans_header_ID], [Trans_sekvens_nr], [Transaktion_identifikator], [Transdato], [Transtid], [UdlBeløb_int_valuta], [Udligningsdato], [UUID], [Valuta], [Valutanøgle], [Virkningsdato], [export_date], [file_origin], [row_number], [etl_version])
    SELECT [Åbent_beløb_for_perioden], [Ændret_den], [Ændringsårsagstekst], [Ændringsårsagskode], [Aftalenummer], [Aftalestatus], [Aftaletype], [Afvis], [ActionStatusCode], [Aktionkode], [Aktions-id], [Basisdato_renteberegning], [Beløb_accepteret], [Beløb], [Bilagsnummer], [EFI-nummer], [Forældelsesdato], [Forretningspartner], [Kommune_kode], [KravsType], [Krydsende_handling], [Markering_for_tilbagekald], [Medhæfter_status], [Modtagelsesdato], [Oprettet_den], [Oprettet_kl], [Recall_Amount], [Reduceret_beløb], [Reference_til_ændring], [Rest_beløb_markering], [RestBeløb], [ReturAarsagKode], [ReturÅrsagText], [Returdato], [RIM_ændringsdato], [SBS_dokumentnummer], [Slutdato_for_forrentn], [Snitflade_Status], [Status], [System_dato], [Tilb_Virkningsdato], [TilbageAarsagKode], [Trans_Beløb], [Trans_flag], [Trans_header_ID], [Trans_sekvens_nr], [Transaktion_identifikator], [Transdato], [Transtid], [UdlBeløb_int_valuta], [Udligningsdato], [UUID], [Valuta], [Valutanøgle], [Virkningsdato], [export_date], [file_origin], [row_number], [etl_version] FROM new_data;
    
    GO

    
    -- D. Validation Metrics
    ------------------------------------------------------------
    SELECT 
        'ROW_COUNTS' as metric,
        (SELECT COUNT(*) FROM [ode].[RIM-aftale_Total_Staging]) as source_rows,
        (SELECT COUNT(*) FROM [ode].[RIM-aftale]) as target_rows;
    
    GO

    -- C. Cleanup (Optional - Staging table usually kept until file move is confirmed)
    DROP TABLE [ode].[RIM-aftale_Total_Staging];
    GO
    