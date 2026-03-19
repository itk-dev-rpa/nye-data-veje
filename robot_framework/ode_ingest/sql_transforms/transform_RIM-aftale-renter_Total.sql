
    -- ============================================================
    -- Pipeline Script for RIM-aftale-renter (Total)
    -- Source:  RIM-aftale-renter_Total_Staging
    -- Targets: RIM-aftale-renter_Total_Backup, RIM-aftale-renter_Total_Typed, RIM-aftale-renter
    -- Generated automatically
    -- ============================================================

    USE [BackDataLake-Test];
    GO

    -- A. Ensure Target Tables Exist
    ------------------------------------------------------------
    
    IF OBJECT_ID('[ode].[RIM-aftale-renter_Total_Backup]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[RIM-aftale-renter_Total_Backup] (
        [Ændret_den] NVARCHAR(MAX) NULL,
    [Afklarings_status] NVARCHAR(MAX) NULL,
    [Aftalenummer] NVARCHAR(MAX) NULL,
    [Aftalestatus] NVARCHAR(MAX) NULL,
    [Aftaletype] NVARCHAR(MAX) NULL,
    [Basisdato_renteberegning] NVARCHAR(MAX) NULL,
    [EFI-nummer] NVARCHAR(MAX) NULL,
    [Egen_reference] NVARCHAR(MAX) NULL,
    [Forældelsesdato] NVARCHAR(MAX) NULL,
    [Fordring_artskode] NVARCHAR(MAX) NULL,
    [Fordring_kategorikode] NVARCHAR(MAX) NULL,
    [Forretningspartner] NVARCHAR(MAX) NULL,
    [Historisk_modtagelsesdato] NVARCHAR(MAX) NULL,
    [Hovedfordring_id] NVARCHAR(MAX) NULL,
    [Intr-posnr] NVARCHAR(MAX) NULL,
    [Kommune_kode] NVARCHAR(MAX) NULL,
    [Konvertering_status] NVARCHAR(MAX) NULL,
    [KravsType] NVARCHAR(MAX) NULL,
    [Markering_for_tilbagekald] NVARCHAR(MAX) NULL,
    [Min_beløb_ignoreret] NVARCHAR(MAX) NULL,
    [Modtagelsesdato] NVARCHAR(MAX) NULL,
    [Oprettet_den] NVARCHAR(MAX) NULL,
    [Oprettet_kl] NVARCHAR(MAX) NULL,
    [Overtagelse_af_inddrivelsesrenter] NVARCHAR(MAX) NULL,
    [P-nummer] NVARCHAR(MAX) NULL,
    [Periodetype_beskrivelse] NVARCHAR(MAX) NULL,
    [Produktionsenh] NVARCHAR(MAX) NULL,
    [Rente,_år_til_dato_beløb,_DKK] NVARCHAR(MAX) NULL,
    [Rente,_år_til_dato_beløb] NVARCHAR(MAX) NULL,
    [Rentebeløb,_DKK] NVARCHAR(MAX) NULL,
    [Rentebeløb] NVARCHAR(MAX) NULL,
    [Renteperiode_slut-dato] NVARCHAR(MAX) NULL,
    [Renteperiode_start-dato] NVARCHAR(MAX) NULL,
    [ReturAarsagKode] NVARCHAR(MAX) NULL,
    [ReturÅrsagText] NVARCHAR(MAX) NULL,
    [Returdato] NVARCHAR(MAX) NULL,
    [Slutdato_for_forrentn] NVARCHAR(MAX) NULL,
    [System_dato] NVARCHAR(MAX) NULL,
    [Tilb_Virkningsdato] NVARCHAR(MAX) NULL,
    [TilbageAarsagKode] NVARCHAR(MAX) NULL,
    [Tjek_af_nr_I_Basissystem] NVARCHAR(MAX) NULL,
    [Typekode] NVARCHAR(MAX) NULL,
    [Udledt_fra_betaling] NVARCHAR(MAX) NULL,
    [Udligningsdato] NVARCHAR(MAX) NULL,
    [Underretnings-id] NVARCHAR(MAX) NULL,
    [Valuta] NVARCHAR(MAX) NULL,
    [Valutakode] NVARCHAR(MAX) NULL,
    [export_date] NVARCHAR(MAX) NULL,
    [file_origin] NVARCHAR(MAX) NULL,
    [row_number] NVARCHAR(MAX) NULL,
    [etl_version] NVARCHAR(MAX) NULL
        );
    END
    
    
    IF OBJECT_ID('[ode].[RIM-aftale-renter_Total_Typed]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[RIM-aftale-renter_Total_Typed] (
        [Ændret_den] DATE NULL,
    [Afklarings_status] NVARCHAR(255) NULL,
    [Aftalenummer] NVARCHAR(255) NULL,
    [Aftalestatus] NVARCHAR(255) NULL,
    [Aftaletype] NVARCHAR(255) NULL,
    [Basisdato_renteberegning] DATE NULL,
    [EFI-nummer] INT NULL,
    [Egen_reference] NVARCHAR(255) NULL,
    [Forældelsesdato] DATE NULL,
    [Fordring_artskode] NVARCHAR(255) NULL,
    [Fordring_kategorikode] NVARCHAR(255) NULL,
    [Forretningspartner] NVARCHAR(255) NULL,
    [Historisk_modtagelsesdato] DATE NULL,
    [Hovedfordring_id] INT NULL,
    [Intr-posnr] INT NULL,
    [Kommune_kode] NVARCHAR(255) NULL,
    [Konvertering_status] NVARCHAR(255) NULL,
    [KravsType] NVARCHAR(255) NULL,
    [Markering_for_tilbagekald] NVARCHAR(255) NULL,
    [Min_beløb_ignoreret] NVARCHAR(255) NULL,
    [Modtagelsesdato] DATE NULL,
    [Oprettet_den] DATE NULL,
    [Oprettet_kl] NVARCHAR(255) NULL,
    [Overtagelse_af_inddrivelsesrenter] NVARCHAR(255) NULL,
    [P-nummer] INT NULL,
    [Periodetype_beskrivelse] NVARCHAR(255) NULL,
    [Produktionsenh] INT NULL,
    [Rente,_år_til_dato_beløb,_DKK] DECIMAL(15,2) NULL,
    [Rente,_år_til_dato_beløb] DECIMAL(15,2) NULL,
    [Rentebeløb,_DKK] DECIMAL(15,2) NULL,
    [Rentebeløb] DECIMAL(15,2) NULL,
    [Renteperiode_slut-dato] DATE NULL,
    [Renteperiode_start-dato] DATE NULL,
    [ReturAarsagKode] NVARCHAR(255) NULL,
    [ReturÅrsagText] NVARCHAR(255) NULL,
    [Returdato] DATE NULL,
    [Slutdato_for_forrentn] DATE NULL,
    [System_dato] DATE NULL,
    [Tilb_Virkningsdato] DATE NULL,
    [TilbageAarsagKode] NVARCHAR(255) NULL,
    [Tjek_af_nr_I_Basissystem] NVARCHAR(255) NULL,
    [Typekode] NVARCHAR(255) NULL,
    [Udledt_fra_betaling] NVARCHAR(255) NULL,
    [Udligningsdato] DATE NULL,
    [Underretnings-id] INT NULL,
    [Valuta] NVARCHAR(255) NULL,
    [Valutakode] NVARCHAR(255) NULL,
    [export_date] DATE NULL,
    [file_origin] NVARCHAR(255) NULL,
    [row_number] INT NULL,
    [etl_version] NVARCHAR(50) NULL
        );
    END
    
    
    IF OBJECT_ID('[ode].[RIM-aftale-renter]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[RIM-aftale-renter] (
        [Ændret_den] DATE NULL,
    [Afklarings_status] NVARCHAR(255) NULL,
    [Aftalenummer] NVARCHAR(255) NOT NULL,
    [Aftalestatus] NVARCHAR(255) NULL,
    [Aftaletype] NVARCHAR(255) NULL,
    [Basisdato_renteberegning] DATE NULL,
    [EFI-nummer] INT NULL,
    [Egen_reference] NVARCHAR(255) NULL,
    [Forældelsesdato] DATE NULL,
    [Fordring_artskode] NVARCHAR(255) NULL,
    [Fordring_kategorikode] NVARCHAR(255) NULL,
    [Forretningspartner] NVARCHAR(255) NULL,
    [Historisk_modtagelsesdato] DATE NULL,
    [Hovedfordring_id] INT NULL,
    [Intr-posnr] INT NOT NULL,
    [Kommune_kode] NVARCHAR(255) NULL,
    [Konvertering_status] NVARCHAR(255) NULL,
    [KravsType] NVARCHAR(255) NULL,
    [Markering_for_tilbagekald] NVARCHAR(255) NULL,
    [Min_beløb_ignoreret] NVARCHAR(255) NULL,
    [Modtagelsesdato] DATE NULL,
    [Oprettet_den] DATE NULL,
    [Oprettet_kl] NVARCHAR(255) NULL,
    [Overtagelse_af_inddrivelsesrenter] NVARCHAR(255) NULL,
    [P-nummer] INT NULL,
    [Periodetype_beskrivelse] NVARCHAR(255) NULL,
    [Produktionsenh] INT NULL,
    [Rente,_år_til_dato_beløb,_DKK] DECIMAL(15,2) NULL,
    [Rente,_år_til_dato_beløb] DECIMAL(15,2) NULL,
    [Rentebeløb,_DKK] DECIMAL(15,2) NULL,
    [Rentebeløb] DECIMAL(15,2) NULL,
    [Renteperiode_slut-dato] DATE NULL,
    [Renteperiode_start-dato] DATE NULL,
    [ReturAarsagKode] NVARCHAR(255) NULL,
    [ReturÅrsagText] NVARCHAR(255) NULL,
    [Returdato] DATE NULL,
    [Slutdato_for_forrentn] DATE NULL,
    [System_dato] DATE NULL,
    [Tilb_Virkningsdato] DATE NULL,
    [TilbageAarsagKode] NVARCHAR(255) NULL,
    [Tjek_af_nr_I_Basissystem] NVARCHAR(255) NULL,
    [Typekode] NVARCHAR(255) NULL,
    [Udledt_fra_betaling] NVARCHAR(255) NULL,
    [Udligningsdato] DATE NULL,
    [Underretnings-id] INT NULL,
    [Valuta] NVARCHAR(255) NULL,
    [Valutakode] NVARCHAR(255) NULL,
    [export_date] DATE NULL,
    [file_origin] NVARCHAR(255) NULL,
    [row_number] INT NULL,
    [etl_version] NVARCHAR(50) NULL,
    CONSTRAINT [PK_RIM-aftale-renter] PRIMARY KEY CLUSTERED ([Aftalenummer], [Intr-posnr])
        );
    END
    
    GO

    -- B. Execute Pipeline Steps
    ------------------------------------------------------------
    
    
    -- 1. BACKUP: Copy raw data from Staging to Backup
    INSERT INTO [ode].[RIM-aftale-renter_Total_Backup] (
        [Ændret_den],
    [Afklarings_status],
    [Aftalenummer],
    [Aftalestatus],
    [Aftaletype],
    [Basisdato_renteberegning],
    [EFI-nummer],
    [Egen_reference],
    [Forældelsesdato],
    [Fordring_artskode],
    [Fordring_kategorikode],
    [Forretningspartner],
    [Historisk_modtagelsesdato],
    [Hovedfordring_id],
    [Intr-posnr],
    [Kommune_kode],
    [Konvertering_status],
    [KravsType],
    [Markering_for_tilbagekald],
    [Min_beløb_ignoreret],
    [Modtagelsesdato],
    [Oprettet_den],
    [Oprettet_kl],
    [Overtagelse_af_inddrivelsesrenter],
    [P-nummer],
    [Periodetype_beskrivelse],
    [Produktionsenh],
    [Rente,_år_til_dato_beløb,_DKK],
    [Rente,_år_til_dato_beløb],
    [Rentebeløb,_DKK],
    [Rentebeløb],
    [Renteperiode_slut-dato],
    [Renteperiode_start-dato],
    [ReturAarsagKode],
    [ReturÅrsagText],
    [Returdato],
    [Slutdato_for_forrentn],
    [System_dato],
    [Tilb_Virkningsdato],
    [TilbageAarsagKode],
    [Tjek_af_nr_I_Basissystem],
    [Typekode],
    [Udledt_fra_betaling],
    [Udligningsdato],
    [Underretnings-id],
    [Valuta],
    [Valutakode],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    )
    SELECT
        [Ændret_den],
    [Afklarings_status],
    [Aftalenummer],
    [Aftalestatus],
    [Aftaletype],
    [Basisdato_renteberegning],
    [EFI-nummer],
    [Egen_reference],
    [Forældelsesdato],
    [Fordring_artskode],
    [Fordring_kategorikode],
    [Forretningspartner],
    [Historisk_modtagelsesdato],
    [Hovedfordring_id],
    [Intr-posnr],
    [Kommune_kode],
    [Konvertering_status],
    [KravsType],
    [Markering_for_tilbagekald],
    [Min_beløb_ignoreret],
    [Modtagelsesdato],
    [Oprettet_den],
    [Oprettet_kl],
    [Overtagelse_af_inddrivelsesrenter],
    [P-nummer],
    [Periodetype_beskrivelse],
    [Produktionsenh],
    [Rente,_år_til_dato_beløb,_DKK],
    [Rente,_år_til_dato_beløb],
    [Rentebeløb,_DKK],
    [Rentebeløb],
    [Renteperiode_slut-dato],
    [Renteperiode_start-dato],
    [ReturAarsagKode],
    [ReturÅrsagText],
    [Returdato],
    [Slutdato_for_forrentn],
    [System_dato],
    [Tilb_Virkningsdato],
    [TilbageAarsagKode],
    [Tjek_af_nr_I_Basissystem],
    [Typekode],
    [Udledt_fra_betaling],
    [Udligningsdato],
    [Underretnings-id],
    [Valuta],
    [Valutakode],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    FROM [ode].[RIM-aftale-renter_Total_Staging];
    
    GO
    
    
    -- 2. TYPED: Transform and insert into Typed history
    --    Note: Rows with invalid Primary Keys after conversion are skipped here but exist in Backup.
    WITH transformed_data AS (
        SELECT
        CASE
            WHEN [Ændret_den] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Ændret_den]) = 8 AND [Ændret_den] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Ændret_den], 112)
            WHEN [Ændret_den] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Ændret_den], 104)
            ELSE TRY_CONVERT(DATE, [Ændret_den], 23)
        END AS [Ændret_den],
    LTRIM(RTRIM([Afklarings_status])) AS [Afklarings_status],
    LTRIM(RTRIM([Aftalenummer])) AS [Aftalenummer],
    LTRIM(RTRIM([Aftalestatus])) AS [Aftalestatus],
    LTRIM(RTRIM([Aftaletype])) AS [Aftaletype],
    CASE
            WHEN [Basisdato_renteberegning] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Basisdato_renteberegning]) = 8 AND [Basisdato_renteberegning] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Basisdato_renteberegning], 112)
            WHEN [Basisdato_renteberegning] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Basisdato_renteberegning], 104)
            ELSE TRY_CONVERT(DATE, [Basisdato_renteberegning], 23)
        END AS [Basisdato_renteberegning],
    TRY_CAST(REPLACE([EFI-nummer], '.', '') AS INT) AS [EFI-nummer],
    LTRIM(RTRIM([Egen_reference])) AS [Egen_reference],
    CASE
            WHEN [Forældelsesdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Forældelsesdato]) = 8 AND [Forældelsesdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Forældelsesdato], 112)
            WHEN [Forældelsesdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Forældelsesdato], 104)
            ELSE TRY_CONVERT(DATE, [Forældelsesdato], 23)
        END AS [Forældelsesdato],
    LTRIM(RTRIM([Fordring_artskode])) AS [Fordring_artskode],
    LTRIM(RTRIM([Fordring_kategorikode])) AS [Fordring_kategorikode],
    LTRIM(RTRIM([Forretningspartner])) AS [Forretningspartner],
    CASE
            WHEN [Historisk_modtagelsesdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Historisk_modtagelsesdato]) = 8 AND [Historisk_modtagelsesdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Historisk_modtagelsesdato], 112)
            WHEN [Historisk_modtagelsesdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Historisk_modtagelsesdato], 104)
            ELSE TRY_CONVERT(DATE, [Historisk_modtagelsesdato], 23)
        END AS [Historisk_modtagelsesdato],
    TRY_CAST(REPLACE([Hovedfordring_id], '.', '') AS INT) AS [Hovedfordring_id],
    TRY_CAST(REPLACE([Intr-posnr], '.', '') AS INT) AS [Intr-posnr],
    LTRIM(RTRIM([Kommune_kode])) AS [Kommune_kode],
    LTRIM(RTRIM([Konvertering_status])) AS [Konvertering_status],
    LTRIM(RTRIM([KravsType])) AS [KravsType],
    LTRIM(RTRIM([Markering_for_tilbagekald])) AS [Markering_for_tilbagekald],
    LTRIM(RTRIM([Min_beløb_ignoreret])) AS [Min_beløb_ignoreret],
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
    LTRIM(RTRIM([Overtagelse_af_inddrivelsesrenter])) AS [Overtagelse_af_inddrivelsesrenter],
    TRY_CAST(REPLACE([P-nummer], '.', '') AS INT) AS [P-nummer],
    LTRIM(RTRIM([Periodetype_beskrivelse])) AS [Periodetype_beskrivelse],
    TRY_CAST(REPLACE([Produktionsenh], '.', '') AS INT) AS [Produktionsenh],
    CASE
            WHEN [Rente,_år_til_dato_beløb,_DKK] IS NULL OR [Rente,_år_til_dato_beløb,_DKK] = '' OR [Rente,_år_til_dato_beløb,_DKK] = '0' THEN NULL
            WHEN [Rente,_år_til_dato_beløb,_DKK] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Rente,_år_til_dato_beløb,_DKK], LEN([Rente,_år_til_dato_beløb,_DKK])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Rente,_år_til_dato_beløb,_DKK], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Rente,_år_til_dato_beløb,_DKK],
    CASE
            WHEN [Rente,_år_til_dato_beløb] IS NULL OR [Rente,_år_til_dato_beløb] = '' OR [Rente,_år_til_dato_beløb] = '0' THEN NULL
            WHEN [Rente,_år_til_dato_beløb] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Rente,_år_til_dato_beløb], LEN([Rente,_år_til_dato_beløb])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Rente,_år_til_dato_beløb], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Rente,_år_til_dato_beløb],
    CASE
            WHEN [Rentebeløb,_DKK] IS NULL OR [Rentebeløb,_DKK] = '' OR [Rentebeløb,_DKK] = '0' THEN NULL
            WHEN [Rentebeløb,_DKK] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Rentebeløb,_DKK], LEN([Rentebeløb,_DKK])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Rentebeløb,_DKK], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Rentebeløb,_DKK],
    CASE
            WHEN [Rentebeløb] IS NULL OR [Rentebeløb] = '' OR [Rentebeløb] = '0' THEN NULL
            WHEN [Rentebeløb] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Rentebeløb], LEN([Rentebeløb])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Rentebeløb], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Rentebeløb],
    CASE
            WHEN [Renteperiode_slut-dato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Renteperiode_slut-dato]) = 8 AND [Renteperiode_slut-dato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Renteperiode_slut-dato], 112)
            WHEN [Renteperiode_slut-dato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Renteperiode_slut-dato], 104)
            ELSE TRY_CONVERT(DATE, [Renteperiode_slut-dato], 23)
        END AS [Renteperiode_slut-dato],
    CASE
            WHEN [Renteperiode_start-dato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Renteperiode_start-dato]) = 8 AND [Renteperiode_start-dato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Renteperiode_start-dato], 112)
            WHEN [Renteperiode_start-dato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Renteperiode_start-dato], 104)
            ELSE TRY_CONVERT(DATE, [Renteperiode_start-dato], 23)
        END AS [Renteperiode_start-dato],
    LTRIM(RTRIM([ReturAarsagKode])) AS [ReturAarsagKode],
    LTRIM(RTRIM([ReturÅrsagText])) AS [ReturÅrsagText],
    CASE
            WHEN [Returdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Returdato]) = 8 AND [Returdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Returdato], 112)
            WHEN [Returdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Returdato], 104)
            ELSE TRY_CONVERT(DATE, [Returdato], 23)
        END AS [Returdato],
    CASE
            WHEN [Slutdato_for_forrentn] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Slutdato_for_forrentn]) = 8 AND [Slutdato_for_forrentn] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Slutdato_for_forrentn], 112)
            WHEN [Slutdato_for_forrentn] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Slutdato_for_forrentn], 104)
            ELSE TRY_CONVERT(DATE, [Slutdato_for_forrentn], 23)
        END AS [Slutdato_for_forrentn],
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
    LTRIM(RTRIM([Tjek_af_nr_I_Basissystem])) AS [Tjek_af_nr_I_Basissystem],
    LTRIM(RTRIM([Typekode])) AS [Typekode],
    LTRIM(RTRIM([Udledt_fra_betaling])) AS [Udledt_fra_betaling],
    CASE
            WHEN [Udligningsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Udligningsdato]) = 8 AND [Udligningsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Udligningsdato], 112)
            WHEN [Udligningsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Udligningsdato], 104)
            ELSE TRY_CONVERT(DATE, [Udligningsdato], 23)
        END AS [Udligningsdato],
    TRY_CAST(REPLACE([Underretnings-id], '.', '') AS INT) AS [Underretnings-id],
    LTRIM(RTRIM([Valuta])) AS [Valuta],
    LTRIM(RTRIM([Valutakode])) AS [Valutakode],
    CASE
            WHEN [export_date] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([export_date]) = 8 AND [export_date] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [export_date], 112)
            WHEN [export_date] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [export_date], 104)
            ELSE TRY_CONVERT(DATE, [export_date], 23)
        END AS [export_date],
    LTRIM(RTRIM([file_origin])) AS [file_origin],
    TRY_CAST(REPLACE([row_number], '.', '') AS INT) AS [row_number],
    LTRIM(RTRIM([etl_version])) AS [etl_version]
        FROM [ode].[RIM-aftale-renter_Total_Staging]
    ),
    valid_data AS (
        SELECT *,
            ROW_NUMBER() OVER (PARTITION BY [Aftalenummer], [Intr-posnr] ORDER BY (SELECT NULL)) as rn
        FROM transformed_data
        WHERE [Aftalenummer] IS NOT NULL AND [Intr-posnr] IS NOT NULL
    )
    INSERT INTO [ode].[RIM-aftale-renter_Total_Typed] (
        [Ændret_den],
    [Afklarings_status],
    [Aftalenummer],
    [Aftalestatus],
    [Aftaletype],
    [Basisdato_renteberegning],
    [EFI-nummer],
    [Egen_reference],
    [Forældelsesdato],
    [Fordring_artskode],
    [Fordring_kategorikode],
    [Forretningspartner],
    [Historisk_modtagelsesdato],
    [Hovedfordring_id],
    [Intr-posnr],
    [Kommune_kode],
    [Konvertering_status],
    [KravsType],
    [Markering_for_tilbagekald],
    [Min_beløb_ignoreret],
    [Modtagelsesdato],
    [Oprettet_den],
    [Oprettet_kl],
    [Overtagelse_af_inddrivelsesrenter],
    [P-nummer],
    [Periodetype_beskrivelse],
    [Produktionsenh],
    [Rente,_år_til_dato_beløb,_DKK],
    [Rente,_år_til_dato_beløb],
    [Rentebeløb,_DKK],
    [Rentebeløb],
    [Renteperiode_slut-dato],
    [Renteperiode_start-dato],
    [ReturAarsagKode],
    [ReturÅrsagText],
    [Returdato],
    [Slutdato_for_forrentn],
    [System_dato],
    [Tilb_Virkningsdato],
    [TilbageAarsagKode],
    [Tjek_af_nr_I_Basissystem],
    [Typekode],
    [Udledt_fra_betaling],
    [Udligningsdato],
    [Underretnings-id],
    [Valuta],
    [Valutakode],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    )
    SELECT
        [Ændret_den],
    [Afklarings_status],
    [Aftalenummer],
    [Aftalestatus],
    [Aftaletype],
    [Basisdato_renteberegning],
    [EFI-nummer],
    [Egen_reference],
    [Forældelsesdato],
    [Fordring_artskode],
    [Fordring_kategorikode],
    [Forretningspartner],
    [Historisk_modtagelsesdato],
    [Hovedfordring_id],
    [Intr-posnr],
    [Kommune_kode],
    [Konvertering_status],
    [KravsType],
    [Markering_for_tilbagekald],
    [Min_beløb_ignoreret],
    [Modtagelsesdato],
    [Oprettet_den],
    [Oprettet_kl],
    [Overtagelse_af_inddrivelsesrenter],
    [P-nummer],
    [Periodetype_beskrivelse],
    [Produktionsenh],
    [Rente,_år_til_dato_beløb,_DKK],
    [Rente,_år_til_dato_beløb],
    [Rentebeløb,_DKK],
    [Rentebeløb],
    [Renteperiode_slut-dato],
    [Renteperiode_start-dato],
    [ReturAarsagKode],
    [ReturÅrsagText],
    [Returdato],
    [Slutdato_for_forrentn],
    [System_dato],
    [Tilb_Virkningsdato],
    [TilbageAarsagKode],
    [Tjek_af_nr_I_Basissystem],
    [Typekode],
    [Udledt_fra_betaling],
    [Udligningsdato],
    [Underretnings-id],
    [Valuta],
    [Valutakode],
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
            WHEN [Ændret_den] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Ændret_den]) = 8 AND [Ændret_den] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Ændret_den], 112)
            WHEN [Ændret_den] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Ændret_den], 104)
            ELSE TRY_CONVERT(DATE, [Ændret_den], 23)
        END AS [Ændret_den],
    LTRIM(RTRIM([Afklarings_status])) AS [Afklarings_status],
    LTRIM(RTRIM([Aftalenummer])) AS [Aftalenummer],
    LTRIM(RTRIM([Aftalestatus])) AS [Aftalestatus],
    LTRIM(RTRIM([Aftaletype])) AS [Aftaletype],
    CASE
            WHEN [Basisdato_renteberegning] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Basisdato_renteberegning]) = 8 AND [Basisdato_renteberegning] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Basisdato_renteberegning], 112)
            WHEN [Basisdato_renteberegning] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Basisdato_renteberegning], 104)
            ELSE TRY_CONVERT(DATE, [Basisdato_renteberegning], 23)
        END AS [Basisdato_renteberegning],
    TRY_CAST(REPLACE([EFI-nummer], '.', '') AS INT) AS [EFI-nummer],
    LTRIM(RTRIM([Egen_reference])) AS [Egen_reference],
    CASE
            WHEN [Forældelsesdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Forældelsesdato]) = 8 AND [Forældelsesdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Forældelsesdato], 112)
            WHEN [Forældelsesdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Forældelsesdato], 104)
            ELSE TRY_CONVERT(DATE, [Forældelsesdato], 23)
        END AS [Forældelsesdato],
    LTRIM(RTRIM([Fordring_artskode])) AS [Fordring_artskode],
    LTRIM(RTRIM([Fordring_kategorikode])) AS [Fordring_kategorikode],
    LTRIM(RTRIM([Forretningspartner])) AS [Forretningspartner],
    CASE
            WHEN [Historisk_modtagelsesdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Historisk_modtagelsesdato]) = 8 AND [Historisk_modtagelsesdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Historisk_modtagelsesdato], 112)
            WHEN [Historisk_modtagelsesdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Historisk_modtagelsesdato], 104)
            ELSE TRY_CONVERT(DATE, [Historisk_modtagelsesdato], 23)
        END AS [Historisk_modtagelsesdato],
    TRY_CAST(REPLACE([Hovedfordring_id], '.', '') AS INT) AS [Hovedfordring_id],
    TRY_CAST(REPLACE([Intr-posnr], '.', '') AS INT) AS [Intr-posnr],
    LTRIM(RTRIM([Kommune_kode])) AS [Kommune_kode],
    LTRIM(RTRIM([Konvertering_status])) AS [Konvertering_status],
    LTRIM(RTRIM([KravsType])) AS [KravsType],
    LTRIM(RTRIM([Markering_for_tilbagekald])) AS [Markering_for_tilbagekald],
    LTRIM(RTRIM([Min_beløb_ignoreret])) AS [Min_beløb_ignoreret],
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
    LTRIM(RTRIM([Overtagelse_af_inddrivelsesrenter])) AS [Overtagelse_af_inddrivelsesrenter],
    TRY_CAST(REPLACE([P-nummer], '.', '') AS INT) AS [P-nummer],
    LTRIM(RTRIM([Periodetype_beskrivelse])) AS [Periodetype_beskrivelse],
    TRY_CAST(REPLACE([Produktionsenh], '.', '') AS INT) AS [Produktionsenh],
    CASE
            WHEN [Rente,_år_til_dato_beløb,_DKK] IS NULL OR [Rente,_år_til_dato_beløb,_DKK] = '' OR [Rente,_år_til_dato_beløb,_DKK] = '0' THEN NULL
            WHEN [Rente,_år_til_dato_beløb,_DKK] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Rente,_år_til_dato_beløb,_DKK], LEN([Rente,_år_til_dato_beløb,_DKK])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Rente,_år_til_dato_beløb,_DKK], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Rente,_år_til_dato_beløb,_DKK],
    CASE
            WHEN [Rente,_år_til_dato_beløb] IS NULL OR [Rente,_år_til_dato_beløb] = '' OR [Rente,_år_til_dato_beløb] = '0' THEN NULL
            WHEN [Rente,_år_til_dato_beløb] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Rente,_år_til_dato_beløb], LEN([Rente,_år_til_dato_beløb])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Rente,_år_til_dato_beløb], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Rente,_år_til_dato_beløb],
    CASE
            WHEN [Rentebeløb,_DKK] IS NULL OR [Rentebeløb,_DKK] = '' OR [Rentebeløb,_DKK] = '0' THEN NULL
            WHEN [Rentebeløb,_DKK] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Rentebeløb,_DKK], LEN([Rentebeløb,_DKK])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Rentebeløb,_DKK], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Rentebeløb,_DKK],
    CASE
            WHEN [Rentebeløb] IS NULL OR [Rentebeløb] = '' OR [Rentebeløb] = '0' THEN NULL
            WHEN [Rentebeløb] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Rentebeløb], LEN([Rentebeløb])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Rentebeløb], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Rentebeløb],
    CASE
            WHEN [Renteperiode_slut-dato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Renteperiode_slut-dato]) = 8 AND [Renteperiode_slut-dato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Renteperiode_slut-dato], 112)
            WHEN [Renteperiode_slut-dato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Renteperiode_slut-dato], 104)
            ELSE TRY_CONVERT(DATE, [Renteperiode_slut-dato], 23)
        END AS [Renteperiode_slut-dato],
    CASE
            WHEN [Renteperiode_start-dato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Renteperiode_start-dato]) = 8 AND [Renteperiode_start-dato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Renteperiode_start-dato], 112)
            WHEN [Renteperiode_start-dato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Renteperiode_start-dato], 104)
            ELSE TRY_CONVERT(DATE, [Renteperiode_start-dato], 23)
        END AS [Renteperiode_start-dato],
    LTRIM(RTRIM([ReturAarsagKode])) AS [ReturAarsagKode],
    LTRIM(RTRIM([ReturÅrsagText])) AS [ReturÅrsagText],
    CASE
            WHEN [Returdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Returdato]) = 8 AND [Returdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Returdato], 112)
            WHEN [Returdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Returdato], 104)
            ELSE TRY_CONVERT(DATE, [Returdato], 23)
        END AS [Returdato],
    CASE
            WHEN [Slutdato_for_forrentn] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Slutdato_for_forrentn]) = 8 AND [Slutdato_for_forrentn] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Slutdato_for_forrentn], 112)
            WHEN [Slutdato_for_forrentn] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Slutdato_for_forrentn], 104)
            ELSE TRY_CONVERT(DATE, [Slutdato_for_forrentn], 23)
        END AS [Slutdato_for_forrentn],
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
    LTRIM(RTRIM([Tjek_af_nr_I_Basissystem])) AS [Tjek_af_nr_I_Basissystem],
    LTRIM(RTRIM([Typekode])) AS [Typekode],
    LTRIM(RTRIM([Udledt_fra_betaling])) AS [Udledt_fra_betaling],
    CASE
            WHEN [Udligningsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Udligningsdato]) = 8 AND [Udligningsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Udligningsdato], 112)
            WHEN [Udligningsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Udligningsdato], 104)
            ELSE TRY_CONVERT(DATE, [Udligningsdato], 23)
        END AS [Udligningsdato],
    TRY_CAST(REPLACE([Underretnings-id], '.', '') AS INT) AS [Underretnings-id],
    LTRIM(RTRIM([Valuta])) AS [Valuta],
    LTRIM(RTRIM([Valutakode])) AS [Valutakode],
    CASE
            WHEN [export_date] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([export_date]) = 8 AND [export_date] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [export_date], 112)
            WHEN [export_date] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [export_date], 104)
            ELSE TRY_CONVERT(DATE, [export_date], 23)
        END AS [export_date],
    LTRIM(RTRIM([file_origin])) AS [file_origin],
    TRY_CAST(REPLACE([row_number], '.', '') AS INT) AS [row_number],
    LTRIM(RTRIM([etl_version])) AS [etl_version],
                ROW_NUMBER() OVER (PARTITION BY [Aftalenummer], [Intr-posnr] ORDER BY (SELECT NULL)) as rn
            FROM [ode].[RIM-aftale-renter_Total_Staging]
        ) t WHERE rn = 1 AND [Aftalenummer] IS NOT NULL AND [Intr-posnr] IS NOT NULL
    )
    INSERT INTO [ode].[RIM-aftale-renter] ([Ændret_den], [Afklarings_status], [Aftalenummer], [Aftalestatus], [Aftaletype], [Basisdato_renteberegning], [EFI-nummer], [Egen_reference], [Forældelsesdato], [Fordring_artskode], [Fordring_kategorikode], [Forretningspartner], [Historisk_modtagelsesdato], [Hovedfordring_id], [Intr-posnr], [Kommune_kode], [Konvertering_status], [KravsType], [Markering_for_tilbagekald], [Min_beløb_ignoreret], [Modtagelsesdato], [Oprettet_den], [Oprettet_kl], [Overtagelse_af_inddrivelsesrenter], [P-nummer], [Periodetype_beskrivelse], [Produktionsenh], [Rente,_år_til_dato_beløb,_DKK], [Rente,_år_til_dato_beløb], [Rentebeløb,_DKK], [Rentebeløb], [Renteperiode_slut-dato], [Renteperiode_start-dato], [ReturAarsagKode], [ReturÅrsagText], [Returdato], [Slutdato_for_forrentn], [System_dato], [Tilb_Virkningsdato], [TilbageAarsagKode], [Tjek_af_nr_I_Basissystem], [Typekode], [Udledt_fra_betaling], [Udligningsdato], [Underretnings-id], [Valuta], [Valutakode], [export_date], [file_origin], [row_number], [etl_version])
    SELECT [Ændret_den], [Afklarings_status], [Aftalenummer], [Aftalestatus], [Aftaletype], [Basisdato_renteberegning], [EFI-nummer], [Egen_reference], [Forældelsesdato], [Fordring_artskode], [Fordring_kategorikode], [Forretningspartner], [Historisk_modtagelsesdato], [Hovedfordring_id], [Intr-posnr], [Kommune_kode], [Konvertering_status], [KravsType], [Markering_for_tilbagekald], [Min_beløb_ignoreret], [Modtagelsesdato], [Oprettet_den], [Oprettet_kl], [Overtagelse_af_inddrivelsesrenter], [P-nummer], [Periodetype_beskrivelse], [Produktionsenh], [Rente,_år_til_dato_beløb,_DKK], [Rente,_år_til_dato_beløb], [Rentebeløb,_DKK], [Rentebeløb], [Renteperiode_slut-dato], [Renteperiode_start-dato], [ReturAarsagKode], [ReturÅrsagText], [Returdato], [Slutdato_for_forrentn], [System_dato], [Tilb_Virkningsdato], [TilbageAarsagKode], [Tjek_af_nr_I_Basissystem], [Typekode], [Udledt_fra_betaling], [Udligningsdato], [Underretnings-id], [Valuta], [Valutakode], [export_date], [file_origin], [row_number], [etl_version] FROM new_data;
    
    GO

    
    -- D. Validation Metrics
    ------------------------------------------------------------
    SELECT 
        'ROW_COUNTS' as metric,
        (SELECT COUNT(*) FROM [ode].[RIM-aftale-renter_Total_Staging]) as source_rows,
        (SELECT COUNT(*) FROM [ode].[RIM-aftale-renter]) as target_rows;
    
    GO

    -- C. Cleanup (Optional - Staging table usually kept until file move is confirmed)
    DROP TABLE [ode].[RIM-aftale-renter_Total_Staging];
    GO
    