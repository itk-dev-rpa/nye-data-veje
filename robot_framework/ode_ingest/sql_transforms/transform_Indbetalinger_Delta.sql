
    -- ============================================================
    -- Pipeline Script for Indbetalinger (Delta)
    -- Source:  Indbetalinger_Delta_Staging
    -- Targets: Indbetalinger_Delta_Backup, Indbetalinger_Delta_Typed, Indbetalinger
    -- Generated automatically
    -- ============================================================

    USE [BackDataLake-Test];
    GO

    -- A. Ensure Target Tables Exist
    ------------------------------------------------------------
    
    IF OBJECT_ID('[ode].[Indbetalinger_Delta_Backup]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[Indbetalinger_Delta_Backup] (
        [Afdeling] NVARCHAR(MAX) NULL,
    [Afklaringsstatus] NVARCHAR(MAX) NULL,
    [Aftale] NVARCHAR(MAX) NULL,
    [Aftalekonto] NVARCHAR(MAX) NULL,
    [Annuller_status] NVARCHAR(MAX) NULL,
    [Anvendelsestekst] NVARCHAR(MAX) NULL,
    [Art_kilde] NVARCHAR(MAX) NULL,
    [Bankafregningskonto] NVARCHAR(MAX) NULL,
    [Bankforbindelse] NVARCHAR(MAX) NULL,
    [Beløb] NVARCHAR(MAX) NULL,
    [Betalings_art] NVARCHAR(MAX) NULL,
    [Betalingsidentifikator] NVARCHAR(MAX) NULL,
    [Betalingsmåde] NVARCHAR(MAX) NULL,
    [Betalingsretning] NVARCHAR(MAX) NULL,
    [Bilagsart] NVARCHAR(MAX) NULL,
    [Bilagsnummer] NVARCHAR(MAX) NULL,
    [Firmakode] NVARCHAR(MAX) NULL,
    [Forretningsområde] NVARCHAR(MAX) NULL,
    [Forretningspartner] NVARCHAR(MAX) NULL,
    [Kasse] NVARCHAR(MAX) NULL,
    [Kommune_kode] NVARCHAR(MAX) NULL,
    [Konto-ID] NVARCHAR(MAX) NULL,
    [Langtekst] NVARCHAR(MAX) NULL,
    [Løbenummer] NVARCHAR(MAX) NULL,
    [Oprettet_den] NVARCHAR(MAX) NULL,
    [Skæringsdato] NVARCHAR(MAX) NULL,
    [Stak] NVARCHAR(MAX) NULL,
    [Tidsstempel_for_deltaekstrakt] NVARCHAR(MAX) NULL,
    [Underapplikation] NVARCHAR(MAX) NULL,
    [Valørdato] NVARCHAR(MAX) NULL,
    [Valuta] NVARCHAR(MAX) NULL,
    [Varighed_af_afklaring] NVARCHAR(MAX) NULL,
    [export_date] NVARCHAR(MAX) NULL,
    [file_origin] NVARCHAR(MAX) NULL,
    [row_number] NVARCHAR(MAX) NULL,
    [etl_version] NVARCHAR(MAX) NULL
        );
    END
    
    
    IF OBJECT_ID('[ode].[Indbetalinger_Delta_Typed]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[Indbetalinger_Delta_Typed] (
        [Afdeling] NVARCHAR(255) NULL,
    [Afklaringsstatus] NVARCHAR(255) NULL,
    [Aftale] NVARCHAR(255) NULL,
    [Aftalekonto] NVARCHAR(255) NULL,
    [Annuller_status] NVARCHAR(255) NULL,
    [Anvendelsestekst] NVARCHAR(255) NULL,
    [Art_kilde] NVARCHAR(255) NULL,
    [Bankafregningskonto] NVARCHAR(255) NULL,
    [Bankforbindelse] NVARCHAR(255) NULL,
    [Beløb] DECIMAL(15,2) NULL,
    [Betalings_art] NVARCHAR(255) NULL,
    [Betalingsidentifikator] NVARCHAR(255) NULL,
    [Betalingsmåde] NVARCHAR(255) NULL,
    [Betalingsretning] NVARCHAR(255) NULL,
    [Bilagsart] NVARCHAR(255) NULL,
    [Bilagsnummer] INT NULL,
    [Firmakode] NVARCHAR(255) NULL,
    [Forretningsområde] NVARCHAR(255) NULL,
    [Forretningspartner] NVARCHAR(255) NULL,
    [Kasse] NVARCHAR(255) NULL,
    [Kommune_kode] NVARCHAR(255) NULL,
    [Konto-ID] NVARCHAR(255) NULL,
    [Langtekst] NVARCHAR(255) NULL,
    [Løbenummer] INT NULL,
    [Oprettet_den] DATE NULL,
    [Skæringsdato] DATE NULL,
    [Stak] NVARCHAR(255) NULL,
    [Tidsstempel_for_deltaekstrakt] DATE NULL,
    [Underapplikation] NVARCHAR(255) NULL,
    [Valørdato] DATE NULL,
    [Valuta] NVARCHAR(255) NULL,
    [Varighed_af_afklaring] INT NULL,
    [export_date] DATE NULL,
    [file_origin] NVARCHAR(255) NULL,
    [row_number] INT NULL,
    [etl_version] NVARCHAR(50) NULL
        );
    END
    
    
    IF OBJECT_ID('[ode].[Indbetalinger]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[Indbetalinger] (
        [Afdeling] NVARCHAR(255) NULL,
    [Afklaringsstatus] NVARCHAR(255) NULL,
    [Aftale] NVARCHAR(255) NULL,
    [Aftalekonto] NVARCHAR(255) NULL,
    [Annuller_status] NVARCHAR(255) NULL,
    [Anvendelsestekst] NVARCHAR(255) NULL,
    [Art_kilde] NVARCHAR(255) NOT NULL,
    [Bankafregningskonto] NVARCHAR(255) NULL,
    [Bankforbindelse] NVARCHAR(255) NULL,
    [Beløb] DECIMAL(15,2) NULL,
    [Betalings_art] NVARCHAR(255) NULL,
    [Betalingsidentifikator] NVARCHAR(255) NOT NULL,
    [Betalingsmåde] NVARCHAR(255) NULL,
    [Betalingsretning] NVARCHAR(255) NULL,
    [Bilagsart] NVARCHAR(255) NULL,
    [Bilagsnummer] INT NULL,
    [Firmakode] NVARCHAR(255) NULL,
    [Forretningsområde] NVARCHAR(255) NULL,
    [Forretningspartner] NVARCHAR(255) NULL,
    [Kasse] NVARCHAR(255) NULL,
    [Kommune_kode] NVARCHAR(255) NULL,
    [Konto-ID] NVARCHAR(255) NULL,
    [Langtekst] NVARCHAR(255) NULL,
    [Løbenummer] INT NOT NULL,
    [Oprettet_den] DATE NULL,
    [Skæringsdato] DATE NULL,
    [Stak] NVARCHAR(255) NULL,
    [Tidsstempel_for_deltaekstrakt] DATE NULL,
    [Underapplikation] NVARCHAR(255) NULL,
    [Valørdato] DATE NULL,
    [Valuta] NVARCHAR(255) NULL,
    [Varighed_af_afklaring] INT NULL,
    [export_date] DATE NULL,
    [file_origin] NVARCHAR(255) NULL,
    [row_number] INT NULL,
    [etl_version] NVARCHAR(50) NULL,
    CONSTRAINT [PK_Indbetalinger] PRIMARY KEY CLUSTERED ([Art_kilde], [Betalingsidentifikator], [Løbenummer])
        );
    END
    
    GO

    -- B. Execute Pipeline Steps
    ------------------------------------------------------------
    
    
    -- 1. BACKUP: Copy raw data from Staging to Backup
    INSERT INTO [ode].[Indbetalinger_Delta_Backup] (
        [Afdeling],
    [Afklaringsstatus],
    [Aftale],
    [Aftalekonto],
    [Annuller_status],
    [Anvendelsestekst],
    [Art_kilde],
    [Bankafregningskonto],
    [Bankforbindelse],
    [Beløb],
    [Betalings_art],
    [Betalingsidentifikator],
    [Betalingsmåde],
    [Betalingsretning],
    [Bilagsart],
    [Bilagsnummer],
    [Firmakode],
    [Forretningsområde],
    [Forretningspartner],
    [Kasse],
    [Kommune_kode],
    [Konto-ID],
    [Langtekst],
    [Løbenummer],
    [Oprettet_den],
    [Skæringsdato],
    [Stak],
    [Tidsstempel_for_deltaekstrakt],
    [Underapplikation],
    [Valørdato],
    [Valuta],
    [Varighed_af_afklaring],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    )
    SELECT
        [Afdeling],
    [Afklaringsstatus],
    [Aftale],
    [Aftalekonto],
    [Annuller_status],
    [Anvendelsestekst],
    [Art_kilde],
    [Bankafregningskonto],
    [Bankforbindelse],
    [Beløb],
    [Betalings_art],
    [Betalingsidentifikator],
    [Betalingsmåde],
    [Betalingsretning],
    [Bilagsart],
    [Bilagsnummer],
    [Firmakode],
    [Forretningsområde],
    [Forretningspartner],
    [Kasse],
    [Kommune_kode],
    [Konto-ID],
    [Langtekst],
    [Løbenummer],
    [Oprettet_den],
    [Skæringsdato],
    [Stak],
    [Tidsstempel_for_deltaekstrakt],
    [Underapplikation],
    [Valørdato],
    [Valuta],
    [Varighed_af_afklaring],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    FROM [ode].[Indbetalinger_Delta_Staging];
    
    GO
    
    
    -- 2. TYPED: Transform and insert into Typed history
    --    Note: Rows with invalid Primary Keys after conversion are skipped here but exist in Backup.
    WITH transformed_data AS (
        SELECT
        LTRIM(RTRIM([Afdeling])) AS [Afdeling],
    LTRIM(RTRIM([Afklaringsstatus])) AS [Afklaringsstatus],
    LTRIM(RTRIM([Aftale])) AS [Aftale],
    LTRIM(RTRIM([Aftalekonto])) AS [Aftalekonto],
    LTRIM(RTRIM([Annuller_status])) AS [Annuller_status],
    LTRIM(RTRIM([Anvendelsestekst])) AS [Anvendelsestekst],
    LTRIM(RTRIM([Art_kilde])) AS [Art_kilde],
    LTRIM(RTRIM([Bankafregningskonto])) AS [Bankafregningskonto],
    LTRIM(RTRIM([Bankforbindelse])) AS [Bankforbindelse],
    CASE
            WHEN [Beløb] IS NULL OR [Beløb] = '' OR [Beløb] = '0' THEN NULL
            WHEN [Beløb] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Beløb], LEN([Beløb])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Beløb], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Beløb],
    LTRIM(RTRIM([Betalings_art])) AS [Betalings_art],
    LTRIM(RTRIM([Betalingsidentifikator])) AS [Betalingsidentifikator],
    LTRIM(RTRIM([Betalingsmåde])) AS [Betalingsmåde],
    LTRIM(RTRIM([Betalingsretning])) AS [Betalingsretning],
    LTRIM(RTRIM([Bilagsart])) AS [Bilagsart],
    TRY_CAST(REPLACE([Bilagsnummer], '.', '') AS INT) AS [Bilagsnummer],
    LTRIM(RTRIM([Firmakode])) AS [Firmakode],
    LTRIM(RTRIM([Forretningsområde])) AS [Forretningsområde],
    LTRIM(RTRIM([Forretningspartner])) AS [Forretningspartner],
    LTRIM(RTRIM([Kasse])) AS [Kasse],
    LTRIM(RTRIM([Kommune_kode])) AS [Kommune_kode],
    LTRIM(RTRIM([Konto-ID])) AS [Konto-ID],
    LTRIM(RTRIM([Langtekst])) AS [Langtekst],
    TRY_CAST(REPLACE([Løbenummer], '.', '') AS INT) AS [Løbenummer],
    CASE
            WHEN [Oprettet_den] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Oprettet_den]) = 8 AND [Oprettet_den] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Oprettet_den], 112)
            WHEN [Oprettet_den] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Oprettet_den], 104)
            ELSE TRY_CONVERT(DATE, [Oprettet_den], 23)
        END AS [Oprettet_den],
    CASE
            WHEN [Skæringsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Skæringsdato]) = 8 AND [Skæringsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Skæringsdato], 112)
            WHEN [Skæringsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Skæringsdato], 104)
            ELSE TRY_CONVERT(DATE, [Skæringsdato], 23)
        END AS [Skæringsdato],
    LTRIM(RTRIM([Stak])) AS [Stak],
    CASE
            WHEN [Tidsstempel_for_deltaekstrakt] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Tidsstempel_for_deltaekstrakt]) = 8 AND [Tidsstempel_for_deltaekstrakt] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Tidsstempel_for_deltaekstrakt], 112)
            WHEN [Tidsstempel_for_deltaekstrakt] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Tidsstempel_for_deltaekstrakt], 104)
            ELSE TRY_CONVERT(DATE, [Tidsstempel_for_deltaekstrakt], 23)
        END AS [Tidsstempel_for_deltaekstrakt],
    LTRIM(RTRIM([Underapplikation])) AS [Underapplikation],
    CASE
            WHEN [Valørdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Valørdato]) = 8 AND [Valørdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Valørdato], 112)
            WHEN [Valørdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Valørdato], 104)
            ELSE TRY_CONVERT(DATE, [Valørdato], 23)
        END AS [Valørdato],
    LTRIM(RTRIM([Valuta])) AS [Valuta],
    TRY_CAST(REPLACE([Varighed_af_afklaring], '.', '') AS INT) AS [Varighed_af_afklaring],
    CASE
            WHEN [export_date] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([export_date]) = 8 AND [export_date] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [export_date], 112)
            WHEN [export_date] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [export_date], 104)
            ELSE TRY_CONVERT(DATE, [export_date], 23)
        END AS [export_date],
    LTRIM(RTRIM([file_origin])) AS [file_origin],
    TRY_CAST(REPLACE([row_number], '.', '') AS INT) AS [row_number],
    LTRIM(RTRIM([etl_version])) AS [etl_version]
        FROM [ode].[Indbetalinger_Delta_Staging]
    ),
    valid_data AS (
        SELECT *,
            ROW_NUMBER() OVER (PARTITION BY [Art_kilde], [Betalingsidentifikator], [Løbenummer] ORDER BY (SELECT NULL)) as rn
        FROM transformed_data
        WHERE [Art_kilde] IS NOT NULL AND [Betalingsidentifikator] IS NOT NULL AND [Løbenummer] IS NOT NULL
    )
    INSERT INTO [ode].[Indbetalinger_Delta_Typed] (
        [Afdeling],
    [Afklaringsstatus],
    [Aftale],
    [Aftalekonto],
    [Annuller_status],
    [Anvendelsestekst],
    [Art_kilde],
    [Bankafregningskonto],
    [Bankforbindelse],
    [Beløb],
    [Betalings_art],
    [Betalingsidentifikator],
    [Betalingsmåde],
    [Betalingsretning],
    [Bilagsart],
    [Bilagsnummer],
    [Firmakode],
    [Forretningsområde],
    [Forretningspartner],
    [Kasse],
    [Kommune_kode],
    [Konto-ID],
    [Langtekst],
    [Løbenummer],
    [Oprettet_den],
    [Skæringsdato],
    [Stak],
    [Tidsstempel_for_deltaekstrakt],
    [Underapplikation],
    [Valørdato],
    [Valuta],
    [Varighed_af_afklaring],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    )
    SELECT
        [Afdeling],
    [Afklaringsstatus],
    [Aftale],
    [Aftalekonto],
    [Annuller_status],
    [Anvendelsestekst],
    [Art_kilde],
    [Bankafregningskonto],
    [Bankforbindelse],
    [Beløb],
    [Betalings_art],
    [Betalingsidentifikator],
    [Betalingsmåde],
    [Betalingsretning],
    [Bilagsart],
    [Bilagsnummer],
    [Firmakode],
    [Forretningsområde],
    [Forretningspartner],
    [Kasse],
    [Kommune_kode],
    [Konto-ID],
    [Langtekst],
    [Løbenummer],
    [Oprettet_den],
    [Skæringsdato],
    [Stak],
    [Tidsstempel_for_deltaekstrakt],
    [Underapplikation],
    [Valørdato],
    [Valuta],
    [Varighed_af_afklaring],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    FROM valid_data
    WHERE rn = 1;
    
    GO
    
    
    -- 3. SNAPSHOT: Delta Merge (Upsert)
    
    WITH new_data AS (
        SELECT * FROM (
            SELECT
        LTRIM(RTRIM([Afdeling])) AS [Afdeling],
    LTRIM(RTRIM([Afklaringsstatus])) AS [Afklaringsstatus],
    LTRIM(RTRIM([Aftale])) AS [Aftale],
    LTRIM(RTRIM([Aftalekonto])) AS [Aftalekonto],
    LTRIM(RTRIM([Annuller_status])) AS [Annuller_status],
    LTRIM(RTRIM([Anvendelsestekst])) AS [Anvendelsestekst],
    LTRIM(RTRIM([Art_kilde])) AS [Art_kilde],
    LTRIM(RTRIM([Bankafregningskonto])) AS [Bankafregningskonto],
    LTRIM(RTRIM([Bankforbindelse])) AS [Bankforbindelse],
    CASE
            WHEN [Beløb] IS NULL OR [Beløb] = '' OR [Beløb] = '0' THEN NULL
            WHEN [Beløb] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Beløb], LEN([Beløb])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Beløb], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Beløb],
    LTRIM(RTRIM([Betalings_art])) AS [Betalings_art],
    LTRIM(RTRIM([Betalingsidentifikator])) AS [Betalingsidentifikator],
    LTRIM(RTRIM([Betalingsmåde])) AS [Betalingsmåde],
    LTRIM(RTRIM([Betalingsretning])) AS [Betalingsretning],
    LTRIM(RTRIM([Bilagsart])) AS [Bilagsart],
    TRY_CAST(REPLACE([Bilagsnummer], '.', '') AS INT) AS [Bilagsnummer],
    LTRIM(RTRIM([Firmakode])) AS [Firmakode],
    LTRIM(RTRIM([Forretningsområde])) AS [Forretningsområde],
    LTRIM(RTRIM([Forretningspartner])) AS [Forretningspartner],
    LTRIM(RTRIM([Kasse])) AS [Kasse],
    LTRIM(RTRIM([Kommune_kode])) AS [Kommune_kode],
    LTRIM(RTRIM([Konto-ID])) AS [Konto-ID],
    LTRIM(RTRIM([Langtekst])) AS [Langtekst],
    TRY_CAST(REPLACE([Løbenummer], '.', '') AS INT) AS [Løbenummer],
    CASE
            WHEN [Oprettet_den] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Oprettet_den]) = 8 AND [Oprettet_den] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Oprettet_den], 112)
            WHEN [Oprettet_den] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Oprettet_den], 104)
            ELSE TRY_CONVERT(DATE, [Oprettet_den], 23)
        END AS [Oprettet_den],
    CASE
            WHEN [Skæringsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Skæringsdato]) = 8 AND [Skæringsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Skæringsdato], 112)
            WHEN [Skæringsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Skæringsdato], 104)
            ELSE TRY_CONVERT(DATE, [Skæringsdato], 23)
        END AS [Skæringsdato],
    LTRIM(RTRIM([Stak])) AS [Stak],
    CASE
            WHEN [Tidsstempel_for_deltaekstrakt] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Tidsstempel_for_deltaekstrakt]) = 8 AND [Tidsstempel_for_deltaekstrakt] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Tidsstempel_for_deltaekstrakt], 112)
            WHEN [Tidsstempel_for_deltaekstrakt] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Tidsstempel_for_deltaekstrakt], 104)
            ELSE TRY_CONVERT(DATE, [Tidsstempel_for_deltaekstrakt], 23)
        END AS [Tidsstempel_for_deltaekstrakt],
    LTRIM(RTRIM([Underapplikation])) AS [Underapplikation],
    CASE
            WHEN [Valørdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Valørdato]) = 8 AND [Valørdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Valørdato], 112)
            WHEN [Valørdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Valørdato], 104)
            ELSE TRY_CONVERT(DATE, [Valørdato], 23)
        END AS [Valørdato],
    LTRIM(RTRIM([Valuta])) AS [Valuta],
    TRY_CAST(REPLACE([Varighed_af_afklaring], '.', '') AS INT) AS [Varighed_af_afklaring],
    CASE
            WHEN [export_date] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([export_date]) = 8 AND [export_date] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [export_date], 112)
            WHEN [export_date] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [export_date], 104)
            ELSE TRY_CONVERT(DATE, [export_date], 23)
        END AS [export_date],
    LTRIM(RTRIM([file_origin])) AS [file_origin],
    TRY_CAST(REPLACE([row_number], '.', '') AS INT) AS [row_number],
    LTRIM(RTRIM([etl_version])) AS [etl_version],
                ROW_NUMBER() OVER (PARTITION BY [Art_kilde], [Betalingsidentifikator], [Løbenummer] ORDER BY (SELECT NULL)) as rn
            FROM [ode].[Indbetalinger_Delta_Staging]
        ) t WHERE rn = 1 AND [Art_kilde] IS NOT NULL AND [Betalingsidentifikator] IS NOT NULL AND [Løbenummer] IS NOT NULL
    )
    MERGE INTO [ode].[Indbetalinger] AS target
    USING new_data AS source
    ON target.[Art_kilde] = source.[Art_kilde] AND target.[Betalingsidentifikator] = source.[Betalingsidentifikator] AND target.[Løbenummer] = source.[Løbenummer]
    WHEN MATCHED THEN
        UPDATE SET target.[Afdeling] = source.[Afdeling], target.[Afklaringsstatus] = source.[Afklaringsstatus], target.[Aftale] = source.[Aftale], target.[Aftalekonto] = source.[Aftalekonto], target.[Annuller_status] = source.[Annuller_status], target.[Anvendelsestekst] = source.[Anvendelsestekst], target.[Bankafregningskonto] = source.[Bankafregningskonto], target.[Bankforbindelse] = source.[Bankforbindelse], target.[Beløb] = source.[Beløb], target.[Betalings_art] = source.[Betalings_art], target.[Betalingsmåde] = source.[Betalingsmåde], target.[Betalingsretning] = source.[Betalingsretning], target.[Bilagsart] = source.[Bilagsart], target.[Bilagsnummer] = source.[Bilagsnummer], target.[Firmakode] = source.[Firmakode], target.[Forretningsområde] = source.[Forretningsområde], target.[Forretningspartner] = source.[Forretningspartner], target.[Kasse] = source.[Kasse], target.[Kommune_kode] = source.[Kommune_kode], target.[Konto-ID] = source.[Konto-ID], target.[Langtekst] = source.[Langtekst], target.[Oprettet_den] = source.[Oprettet_den], target.[Skæringsdato] = source.[Skæringsdato], target.[Stak] = source.[Stak], target.[Tidsstempel_for_deltaekstrakt] = source.[Tidsstempel_for_deltaekstrakt], target.[Underapplikation] = source.[Underapplikation], target.[Valørdato] = source.[Valørdato], target.[Valuta] = source.[Valuta], target.[Varighed_af_afklaring] = source.[Varighed_af_afklaring], target.[export_date] = source.[export_date], target.[file_origin] = source.[file_origin], target.[row_number] = source.[row_number], target.[etl_version] = source.[etl_version]
    WHEN NOT MATCHED THEN
        INSERT ([Afdeling], [Afklaringsstatus], [Aftale], [Aftalekonto], [Annuller_status], [Anvendelsestekst], [Art_kilde], [Bankafregningskonto], [Bankforbindelse], [Beløb], [Betalings_art], [Betalingsidentifikator], [Betalingsmåde], [Betalingsretning], [Bilagsart], [Bilagsnummer], [Firmakode], [Forretningsområde], [Forretningspartner], [Kasse], [Kommune_kode], [Konto-ID], [Langtekst], [Løbenummer], [Oprettet_den], [Skæringsdato], [Stak], [Tidsstempel_for_deltaekstrakt], [Underapplikation], [Valørdato], [Valuta], [Varighed_af_afklaring], [export_date], [file_origin], [row_number], [etl_version])
        VALUES (source.[Afdeling], source.[Afklaringsstatus], source.[Aftale], source.[Aftalekonto], source.[Annuller_status], source.[Anvendelsestekst], source.[Art_kilde], source.[Bankafregningskonto], source.[Bankforbindelse], source.[Beløb], source.[Betalings_art], source.[Betalingsidentifikator], source.[Betalingsmåde], source.[Betalingsretning], source.[Bilagsart], source.[Bilagsnummer], source.[Firmakode], source.[Forretningsområde], source.[Forretningspartner], source.[Kasse], source.[Kommune_kode], source.[Konto-ID], source.[Langtekst], source.[Løbenummer], source.[Oprettet_den], source.[Skæringsdato], source.[Stak], source.[Tidsstempel_for_deltaekstrakt], source.[Underapplikation], source.[Valørdato], source.[Valuta], source.[Varighed_af_afklaring], source.[export_date], source.[file_origin], source.[row_number], source.[etl_version]);
    
    GO

    
    -- D. Validation Metrics
    ------------------------------------------------------------
    SELECT 
        'ROW_COUNTS' as metric,
        (SELECT COUNT(*) FROM [ode].[Indbetalinger_Delta_Staging]) as source_rows,
        (SELECT COUNT(*) FROM [ode].[Indbetalinger]) as target_rows;
    
    GO

    -- C. Cleanup (Optional - Staging table usually kept until file move is confirmed)
    DROP TABLE [ode].[Indbetalinger_Delta_Staging];
    GO
    