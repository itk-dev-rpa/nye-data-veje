
    -- ============================================================
    -- Pipeline Script for Bilag-lukket (Delta)
    -- Source:  Bilag-lukket_Delta_Staging
    -- Targets: Bilag-lukket_Delta_Backup, Bilag-lukket_Delta_Typed, Bilag-lukket
    -- Generated automatically
    -- ============================================================

    USE [BackDataLake-Test];
    GO

    -- A. Ensure Target Tables Exist
    ------------------------------------------------------------
    
    IF OBJECT_ID('[ode].[Bilag-lukket_Delta_Backup]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[Bilag-lukket_Delta_Backup] (
        [Intervalnummer] NVARCHAR(MAX) NULL,
    [Recordnummer] NVARCHAR(MAX) NULL,
    [Afskrivningsårsag] NVARCHAR(MAX) NULL,
    [Afskrivningsdato] NVARCHAR(MAX) NULL,
    [Aftaleindhold] NVARCHAR(MAX) NULL,
    [Aftalekonto] NVARCHAR(MAX) NULL,
    [Aftalekontotype] NVARCHAR(MAX) NULL,
    [Aftalenummer] NVARCHAR(MAX) NULL,
    [Aftalestatus] NVARCHAR(MAX) NULL,
    [Aftaletype] NVARCHAR(MAX) NULL,
    [Antal_poster] NVARCHAR(MAX) NULL,
    [Bankafregningskonto] NVARCHAR(MAX) NULL,
    [Beløb_intern_valuta] NVARCHAR(MAX) NULL,
    [Beløb] NVARCHAR(MAX) NULL,
    [BevillAnsvarssted] NVARCHAR(MAX) NULL,
    [Bevillingsposition] NVARCHAR(MAX) NULL,
    [Bevillingsprogram] NVARCHAR(MAX) NULL,
    [Bilagsdato] NVARCHAR(MAX) NULL,
    [Bilagsnummer] NVARCHAR(MAX) NULL,
    [Bilagstype_markering] NVARCHAR(MAX) NULL,
    [BogfDato_udligning] NVARCHAR(MAX) NULL,
    [Bogføringsdato] NVARCHAR(MAX) NULL,
    [Bortposteringsårsag] NVARCHAR(MAX) NULL,
    [Dato-ID] NVARCHAR(MAX) NULL,
    [Deltransaktion] NVARCHAR(MAX) NULL,
    [Firmakode] NVARCHAR(MAX) NULL,
    [Forretningspartner] NVARCHAR(MAX) NULL,
    [Fra] NVARCHAR(MAX) NULL,
    [Funktionsområde] NVARCHAR(MAX) NULL,
    [Henstand_til] NVARCHAR(MAX) NULL,
    [Hovedtransaktion] NVARCHAR(MAX) NULL,
    [Identifikation] NVARCHAR(MAX) NULL,
    [Indbetalingstype] NVARCHAR(MAX) NULL,
    [Indholdsart] NVARCHAR(MAX) NULL,
    [Kapitalmidler] NVARCHAR(MAX) NULL,
    [Klient] NVARCHAR(MAX) NULL,
    [Kommune_kode] NVARCHAR(MAX) NULL,
    [Kredit_oprindelses_dato] NVARCHAR(MAX) NULL,
    [Landenøgle] NVARCHAR(MAX) NULL,
    [Nettoforfald] NVARCHAR(MAX) NULL,
    [Original-FI-område] NVARCHAR(MAX) NULL,
    [Position] NVARCHAR(MAX) NULL,
    [Postnummer] NVARCHAR(MAX) NULL,
    [Referencebilagsnr] NVARCHAR(MAX) NULL,
    [Registreringsdato] NVARCHAR(MAX) NULL,
    [Rykkeniveau] NVARCHAR(MAX) NULL,
    [Rykkeprocedure] NVARCHAR(MAX) NULL,
    [SBS_dokumentnummer] NVARCHAR(MAX) NULL,
    [Sorteringsbetegnelse] NVARCHAR(MAX) NULL,
    [Statistiknøgle] NVARCHAR(MAX) NULL,
    [Til] NVARCHAR(MAX) NULL,
    [Tilbageført_via] NVARCHAR(MAX) NULL,
    [Udligning_kredit_oprindelse] NVARCHAR(MAX) NULL,
    [Udligning] NVARCHAR(MAX) NULL,
    [Udligningsårsag] NVARCHAR(MAX) NULL,
    [Udligningsbeløb] NVARCHAR(MAX) NULL,
    [Udligningsbilag] NVARCHAR(MAX) NULL,
    [Udligningsdato] NVARCHAR(MAX) NULL,
    [Udligningsstatus] NVARCHAR(MAX) NULL,
    [Udligningsvaluta] NVARCHAR(MAX) NULL,
    [Underapplikation] NVARCHAR(MAX) NULL,
    [Valørdato_udligning] NVARCHAR(MAX) NULL,
    [Valuta] NVARCHAR(MAX) NULL,
    [export_date] NVARCHAR(MAX) NULL,
    [file_origin] NVARCHAR(MAX) NULL,
    [row_number] NVARCHAR(MAX) NULL,
    [etl_version] NVARCHAR(MAX) NULL
        );
    END
    
    
    IF OBJECT_ID('[ode].[Bilag-lukket_Delta_Typed]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[Bilag-lukket_Delta_Typed] (
        [Intervalnummer] INT NULL,
    [Recordnummer] INT NULL,
    [Afskrivningsårsag] NVARCHAR(255) NULL,
    [Afskrivningsdato] DATE NULL,
    [Aftaleindhold] NVARCHAR(255) NULL,
    [Aftalekonto] NVARCHAR(255) NULL,
    [Aftalekontotype] NVARCHAR(255) NULL,
    [Aftalenummer] NVARCHAR(255) NULL,
    [Aftalestatus] NVARCHAR(255) NULL,
    [Aftaletype] NVARCHAR(255) NULL,
    [Antal_poster] INT NULL,
    [Bankafregningskonto] NVARCHAR(255) NULL,
    [Beløb_intern_valuta] DECIMAL(15,2) NULL,
    [Beløb] DECIMAL(15,2) NULL,
    [BevillAnsvarssted] NVARCHAR(255) NULL,
    [Bevillingsposition] NVARCHAR(255) NULL,
    [Bevillingsprogram] NVARCHAR(255) NULL,
    [Bilagsdato] DATE NULL,
    [Bilagsnummer] NVARCHAR(255) NULL,
    [Bilagstype_markering] NVARCHAR(255) NULL,
    [BogfDato_udligning] DATE NULL,
    [Bogføringsdato] DATE NULL,
    [Bortposteringsårsag] NVARCHAR(255) NULL,
    [Dato-ID] DATE NULL,
    [Deltransaktion] NVARCHAR(255) NULL,
    [Firmakode] NVARCHAR(255) NULL,
    [Forretningspartner] NVARCHAR(255) NULL,
    [Fra] DATE NULL,
    [Funktionsområde] NVARCHAR(255) NULL,
    [Henstand_til] DATE NULL,
    [Hovedtransaktion] NVARCHAR(255) NULL,
    [Identifikation] NVARCHAR(255) NULL,
    [Indbetalingstype] NVARCHAR(255) NULL,
    [Indholdsart] NVARCHAR(255) NULL,
    [Kapitalmidler] NVARCHAR(255) NULL,
    [Klient] NVARCHAR(255) NULL,
    [Kommune_kode] NVARCHAR(255) NULL,
    [Kredit_oprindelses_dato] DATE NULL,
    [Landenøgle] NVARCHAR(255) NULL,
    [Nettoforfald] DATE NULL,
    [Original-FI-område] NVARCHAR(255) NULL,
    [Position] INT NULL,
    [Postnummer] NVARCHAR(255) NULL,
    [Referencebilagsnr] NVARCHAR(255) NULL,
    [Registreringsdato] DATE NULL,
    [Rykkeniveau] INT NULL,
    [Rykkeprocedure] NVARCHAR(255) NULL,
    [SBS_dokumentnummer] NVARCHAR(255) NULL,
    [Sorteringsbetegnelse] NVARCHAR(255) NULL,
    [Statistiknøgle] NVARCHAR(255) NULL,
    [Til] DATE NULL,
    [Tilbageført_via] NVARCHAR(255) NULL,
    [Udligning_kredit_oprindelse] NVARCHAR(255) NULL,
    [Udligning] DATE NULL,
    [Udligningsårsag] NVARCHAR(255) NULL,
    [Udligningsbeløb] DECIMAL(15,2) NULL,
    [Udligningsbilag] NVARCHAR(255) NULL,
    [Udligningsdato] DATE NULL,
    [Udligningsstatus] NVARCHAR(255) NULL,
    [Udligningsvaluta] NVARCHAR(255) NULL,
    [Underapplikation] NVARCHAR(255) NULL,
    [Valørdato_udligning] DATE NULL,
    [Valuta] NVARCHAR(255) NULL,
    [export_date] DATE NULL,
    [file_origin] NVARCHAR(255) NULL,
    [row_number] INT NULL,
    [etl_version] NVARCHAR(50) NULL
        );
    END
    
    
    IF OBJECT_ID('[ode].[Bilag-lukket]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[Bilag-lukket] (
        [Intervalnummer] INT NOT NULL,
    [Recordnummer] INT NOT NULL,
    [Afskrivningsårsag] NVARCHAR(255) NULL,
    [Afskrivningsdato] DATE NULL,
    [Aftaleindhold] NVARCHAR(255) NULL,
    [Aftalekonto] NVARCHAR(255) NULL,
    [Aftalekontotype] NVARCHAR(255) NULL,
    [Aftalenummer] NVARCHAR(255) NULL,
    [Aftalestatus] NVARCHAR(255) NULL,
    [Aftaletype] NVARCHAR(255) NULL,
    [Antal_poster] INT NULL,
    [Bankafregningskonto] NVARCHAR(255) NULL,
    [Beløb_intern_valuta] DECIMAL(15,2) NULL,
    [Beløb] DECIMAL(15,2) NULL,
    [BevillAnsvarssted] NVARCHAR(255) NULL,
    [Bevillingsposition] NVARCHAR(255) NULL,
    [Bevillingsprogram] NVARCHAR(255) NULL,
    [Bilagsdato] DATE NULL,
    [Bilagsnummer] NVARCHAR(255) NULL,
    [Bilagstype_markering] NVARCHAR(255) NULL,
    [BogfDato_udligning] DATE NULL,
    [Bogføringsdato] DATE NULL,
    [Bortposteringsårsag] NVARCHAR(255) NULL,
    [Dato-ID] DATE NOT NULL,
    [Deltransaktion] NVARCHAR(255) NULL,
    [Firmakode] NVARCHAR(255) NULL,
    [Forretningspartner] NVARCHAR(255) NULL,
    [Fra] DATE NULL,
    [Funktionsområde] NVARCHAR(255) NULL,
    [Henstand_til] DATE NULL,
    [Hovedtransaktion] NVARCHAR(255) NULL,
    [Identifikation] NVARCHAR(255) NOT NULL,
    [Indbetalingstype] NVARCHAR(255) NULL,
    [Indholdsart] NVARCHAR(255) NULL,
    [Kapitalmidler] NVARCHAR(255) NULL,
    [Klient] NVARCHAR(255) NULL,
    [Kommune_kode] NVARCHAR(255) NULL,
    [Kredit_oprindelses_dato] DATE NULL,
    [Landenøgle] NVARCHAR(255) NULL,
    [Nettoforfald] DATE NULL,
    [Original-FI-område] NVARCHAR(255) NULL,
    [Position] INT NULL,
    [Postnummer] NVARCHAR(255) NULL,
    [Referencebilagsnr] NVARCHAR(255) NULL,
    [Registreringsdato] DATE NULL,
    [Rykkeniveau] INT NULL,
    [Rykkeprocedure] NVARCHAR(255) NULL,
    [SBS_dokumentnummer] NVARCHAR(255) NULL,
    [Sorteringsbetegnelse] NVARCHAR(255) NULL,
    [Statistiknøgle] NVARCHAR(255) NULL,
    [Til] DATE NULL,
    [Tilbageført_via] NVARCHAR(255) NULL,
    [Udligning_kredit_oprindelse] NVARCHAR(255) NULL,
    [Udligning] DATE NULL,
    [Udligningsårsag] NVARCHAR(255) NULL,
    [Udligningsbeløb] DECIMAL(15,2) NULL,
    [Udligningsbilag] NVARCHAR(255) NULL,
    [Udligningsdato] DATE NULL,
    [Udligningsstatus] NVARCHAR(255) NULL,
    [Udligningsvaluta] NVARCHAR(255) NULL,
    [Underapplikation] NVARCHAR(255) NULL,
    [Valørdato_udligning] DATE NULL,
    [Valuta] NVARCHAR(255) NULL,
    [export_date] DATE NULL,
    [file_origin] NVARCHAR(255) NULL,
    [row_number] INT NULL,
    [etl_version] NVARCHAR(50) NULL,
    CONSTRAINT [PK_Bilag-lukket] PRIMARY KEY CLUSTERED ([Dato-ID], [Identifikation], [Intervalnummer], [Recordnummer])
        );
    END
    
    GO

    -- B. Execute Pipeline Steps
    ------------------------------------------------------------
    
    
    -- 1. BACKUP: Copy raw data from Staging to Backup
    INSERT INTO [ode].[Bilag-lukket_Delta_Backup] (
        [Intervalnummer],
    [Recordnummer],
    [Afskrivningsårsag],
    [Afskrivningsdato],
    [Aftaleindhold],
    [Aftalekonto],
    [Aftalekontotype],
    [Aftalenummer],
    [Aftalestatus],
    [Aftaletype],
    [Antal_poster],
    [Bankafregningskonto],
    [Beløb_intern_valuta],
    [Beløb],
    [BevillAnsvarssted],
    [Bevillingsposition],
    [Bevillingsprogram],
    [Bilagsdato],
    [Bilagsnummer],
    [Bilagstype_markering],
    [BogfDato_udligning],
    [Bogføringsdato],
    [Bortposteringsårsag],
    [Dato-ID],
    [Deltransaktion],
    [Firmakode],
    [Forretningspartner],
    [Fra],
    [Funktionsområde],
    [Henstand_til],
    [Hovedtransaktion],
    [Identifikation],
    [Indbetalingstype],
    [Indholdsart],
    [Kapitalmidler],
    [Klient],
    [Kommune_kode],
    [Kredit_oprindelses_dato],
    [Landenøgle],
    [Nettoforfald],
    [Original-FI-område],
    [Position],
    [Postnummer],
    [Referencebilagsnr],
    [Registreringsdato],
    [Rykkeniveau],
    [Rykkeprocedure],
    [SBS_dokumentnummer],
    [Sorteringsbetegnelse],
    [Statistiknøgle],
    [Til],
    [Tilbageført_via],
    [Udligning_kredit_oprindelse],
    [Udligning],
    [Udligningsårsag],
    [Udligningsbeløb],
    [Udligningsbilag],
    [Udligningsdato],
    [Udligningsstatus],
    [Udligningsvaluta],
    [Underapplikation],
    [Valørdato_udligning],
    [Valuta],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    )
    SELECT
        [Intervalnummer],
    [Recordnummer],
    [Afskrivningsårsag],
    [Afskrivningsdato],
    [Aftaleindhold],
    [Aftalekonto],
    [Aftalekontotype],
    [Aftalenummer],
    [Aftalestatus],
    [Aftaletype],
    [Antal_poster],
    [Bankafregningskonto],
    [Beløb_intern_valuta],
    [Beløb],
    [BevillAnsvarssted],
    [Bevillingsposition],
    [Bevillingsprogram],
    [Bilagsdato],
    [Bilagsnummer],
    [Bilagstype_markering],
    [BogfDato_udligning],
    [Bogføringsdato],
    [Bortposteringsårsag],
    [Dato-ID],
    [Deltransaktion],
    [Firmakode],
    [Forretningspartner],
    [Fra],
    [Funktionsområde],
    [Henstand_til],
    [Hovedtransaktion],
    [Identifikation],
    [Indbetalingstype],
    [Indholdsart],
    [Kapitalmidler],
    [Klient],
    [Kommune_kode],
    [Kredit_oprindelses_dato],
    [Landenøgle],
    [Nettoforfald],
    [Original-FI-område],
    [Position],
    [Postnummer],
    [Referencebilagsnr],
    [Registreringsdato],
    [Rykkeniveau],
    [Rykkeprocedure],
    [SBS_dokumentnummer],
    [Sorteringsbetegnelse],
    [Statistiknøgle],
    [Til],
    [Tilbageført_via],
    [Udligning_kredit_oprindelse],
    [Udligning],
    [Udligningsårsag],
    [Udligningsbeløb],
    [Udligningsbilag],
    [Udligningsdato],
    [Udligningsstatus],
    [Udligningsvaluta],
    [Underapplikation],
    [Valørdato_udligning],
    [Valuta],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    FROM [ode].[Bilag-lukket_Delta_Staging];
    
    GO
    
    
    -- 2. TYPED: Transform and insert into Typed history
    --    Note: Rows with invalid Primary Keys after conversion are skipped here but exist in Backup.
    WITH transformed_data AS (
        SELECT
        TRY_CAST(REPLACE([Intervalnummer], '.', '') AS INT) AS [Intervalnummer],
    TRY_CAST(REPLACE([Recordnummer], '.', '') AS INT) AS [Recordnummer],
    LTRIM(RTRIM([Afskrivningsårsag])) AS [Afskrivningsårsag],
    CASE
            WHEN [Afskrivningsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Afskrivningsdato]) = 8 AND [Afskrivningsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Afskrivningsdato], 112)
            WHEN [Afskrivningsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Afskrivningsdato], 104)
            ELSE TRY_CONVERT(DATE, [Afskrivningsdato], 23)
        END AS [Afskrivningsdato],
    LTRIM(RTRIM([Aftaleindhold])) AS [Aftaleindhold],
    LTRIM(RTRIM([Aftalekonto])) AS [Aftalekonto],
    LTRIM(RTRIM([Aftalekontotype])) AS [Aftalekontotype],
    LTRIM(RTRIM([Aftalenummer])) AS [Aftalenummer],
    LTRIM(RTRIM([Aftalestatus])) AS [Aftalestatus],
    LTRIM(RTRIM([Aftaletype])) AS [Aftaletype],
    TRY_CAST(REPLACE([Antal_poster], '.', '') AS INT) AS [Antal_poster],
    LTRIM(RTRIM([Bankafregningskonto])) AS [Bankafregningskonto],
    CASE
            WHEN [Beløb_intern_valuta] IS NULL OR [Beløb_intern_valuta] = '' OR [Beløb_intern_valuta] = '0' THEN NULL
            WHEN [Beløb_intern_valuta] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Beløb_intern_valuta], LEN([Beløb_intern_valuta])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Beløb_intern_valuta], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Beløb_intern_valuta],
    CASE
            WHEN [Beløb] IS NULL OR [Beløb] = '' OR [Beløb] = '0' THEN NULL
            WHEN [Beløb] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Beløb], LEN([Beløb])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Beløb], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Beløb],
    LTRIM(RTRIM([BevillAnsvarssted])) AS [BevillAnsvarssted],
    LTRIM(RTRIM([Bevillingsposition])) AS [Bevillingsposition],
    LTRIM(RTRIM([Bevillingsprogram])) AS [Bevillingsprogram],
    CASE
            WHEN [Bilagsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Bilagsdato]) = 8 AND [Bilagsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Bilagsdato], 112)
            WHEN [Bilagsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Bilagsdato], 104)
            ELSE TRY_CONVERT(DATE, [Bilagsdato], 23)
        END AS [Bilagsdato],
    LTRIM(RTRIM([Bilagsnummer])) AS [Bilagsnummer],
    LTRIM(RTRIM([Bilagstype_markering])) AS [Bilagstype_markering],
    CASE
            WHEN [BogfDato_udligning] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([BogfDato_udligning]) = 8 AND [BogfDato_udligning] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [BogfDato_udligning], 112)
            WHEN [BogfDato_udligning] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [BogfDato_udligning], 104)
            ELSE TRY_CONVERT(DATE, [BogfDato_udligning], 23)
        END AS [BogfDato_udligning],
    CASE
            WHEN [Bogføringsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Bogføringsdato]) = 8 AND [Bogføringsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Bogføringsdato], 112)
            WHEN [Bogføringsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Bogføringsdato], 104)
            ELSE TRY_CONVERT(DATE, [Bogføringsdato], 23)
        END AS [Bogføringsdato],
    LTRIM(RTRIM([Bortposteringsårsag])) AS [Bortposteringsårsag],
    CASE
            WHEN [Dato-ID] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Dato-ID]) = 8 AND [Dato-ID] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Dato-ID], 112)
            WHEN [Dato-ID] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Dato-ID], 104)
            ELSE TRY_CONVERT(DATE, [Dato-ID], 23)
        END AS [Dato-ID],
    LTRIM(RTRIM([Deltransaktion])) AS [Deltransaktion],
    LTRIM(RTRIM([Firmakode])) AS [Firmakode],
    LTRIM(RTRIM([Forretningspartner])) AS [Forretningspartner],
    CASE
            WHEN [Fra] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Fra]) = 8 AND [Fra] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Fra], 112)
            WHEN [Fra] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Fra], 104)
            ELSE TRY_CONVERT(DATE, [Fra], 23)
        END AS [Fra],
    LTRIM(RTRIM([Funktionsområde])) AS [Funktionsområde],
    CASE
            WHEN [Henstand_til] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Henstand_til]) = 8 AND [Henstand_til] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Henstand_til], 112)
            WHEN [Henstand_til] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Henstand_til], 104)
            ELSE TRY_CONVERT(DATE, [Henstand_til], 23)
        END AS [Henstand_til],
    LTRIM(RTRIM([Hovedtransaktion])) AS [Hovedtransaktion],
    LTRIM(RTRIM([Identifikation])) AS [Identifikation],
    LTRIM(RTRIM([Indbetalingstype])) AS [Indbetalingstype],
    LTRIM(RTRIM([Indholdsart])) AS [Indholdsart],
    LTRIM(RTRIM([Kapitalmidler])) AS [Kapitalmidler],
    LTRIM(RTRIM([Klient])) AS [Klient],
    LTRIM(RTRIM([Kommune_kode])) AS [Kommune_kode],
    CASE
            WHEN [Kredit_oprindelses_dato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Kredit_oprindelses_dato]) = 8 AND [Kredit_oprindelses_dato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Kredit_oprindelses_dato], 112)
            WHEN [Kredit_oprindelses_dato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Kredit_oprindelses_dato], 104)
            ELSE TRY_CONVERT(DATE, [Kredit_oprindelses_dato], 23)
        END AS [Kredit_oprindelses_dato],
    LTRIM(RTRIM([Landenøgle])) AS [Landenøgle],
    CASE
            WHEN [Nettoforfald] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Nettoforfald]) = 8 AND [Nettoforfald] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Nettoforfald], 112)
            WHEN [Nettoforfald] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Nettoforfald], 104)
            ELSE TRY_CONVERT(DATE, [Nettoforfald], 23)
        END AS [Nettoforfald],
    LTRIM(RTRIM([Original-FI-område])) AS [Original-FI-område],
    TRY_CAST(REPLACE([Position], '.', '') AS INT) AS [Position],
    LTRIM(RTRIM([Postnummer])) AS [Postnummer],
    LTRIM(RTRIM([Referencebilagsnr])) AS [Referencebilagsnr],
    CASE
            WHEN [Registreringsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Registreringsdato]) = 8 AND [Registreringsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Registreringsdato], 112)
            WHEN [Registreringsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Registreringsdato], 104)
            ELSE TRY_CONVERT(DATE, [Registreringsdato], 23)
        END AS [Registreringsdato],
    TRY_CAST(REPLACE([Rykkeniveau], '.', '') AS INT) AS [Rykkeniveau],
    LTRIM(RTRIM([Rykkeprocedure])) AS [Rykkeprocedure],
    LTRIM(RTRIM([SBS_dokumentnummer])) AS [SBS_dokumentnummer],
    LTRIM(RTRIM([Sorteringsbetegnelse])) AS [Sorteringsbetegnelse],
    LTRIM(RTRIM([Statistiknøgle])) AS [Statistiknøgle],
    CASE
            WHEN [Til] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Til]) = 8 AND [Til] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Til], 112)
            WHEN [Til] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Til], 104)
            ELSE TRY_CONVERT(DATE, [Til], 23)
        END AS [Til],
    LTRIM(RTRIM([Tilbageført_via])) AS [Tilbageført_via],
    LTRIM(RTRIM([Udligning_kredit_oprindelse])) AS [Udligning_kredit_oprindelse],
    CASE
            WHEN [Udligning] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Udligning]) = 8 AND [Udligning] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Udligning], 112)
            WHEN [Udligning] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Udligning], 104)
            ELSE TRY_CONVERT(DATE, [Udligning], 23)
        END AS [Udligning],
    LTRIM(RTRIM([Udligningsårsag])) AS [Udligningsårsag],
    CASE
            WHEN [Udligningsbeløb] IS NULL OR [Udligningsbeløb] = '' OR [Udligningsbeløb] = '0' THEN NULL
            WHEN [Udligningsbeløb] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Udligningsbeløb], LEN([Udligningsbeløb])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Udligningsbeløb], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Udligningsbeløb],
    LTRIM(RTRIM([Udligningsbilag])) AS [Udligningsbilag],
    CASE
            WHEN [Udligningsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Udligningsdato]) = 8 AND [Udligningsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Udligningsdato], 112)
            WHEN [Udligningsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Udligningsdato], 104)
            ELSE TRY_CONVERT(DATE, [Udligningsdato], 23)
        END AS [Udligningsdato],
    LTRIM(RTRIM([Udligningsstatus])) AS [Udligningsstatus],
    LTRIM(RTRIM([Udligningsvaluta])) AS [Udligningsvaluta],
    LTRIM(RTRIM([Underapplikation])) AS [Underapplikation],
    CASE
            WHEN [Valørdato_udligning] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Valørdato_udligning]) = 8 AND [Valørdato_udligning] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Valørdato_udligning], 112)
            WHEN [Valørdato_udligning] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Valørdato_udligning], 104)
            ELSE TRY_CONVERT(DATE, [Valørdato_udligning], 23)
        END AS [Valørdato_udligning],
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
        FROM [ode].[Bilag-lukket_Delta_Staging]
    ),
    valid_data AS (
        SELECT *,
            ROW_NUMBER() OVER (PARTITION BY [Dato-ID], [Identifikation], [Intervalnummer], [Recordnummer] ORDER BY (SELECT NULL)) as rn
        FROM transformed_data
        WHERE [Dato-ID] IS NOT NULL AND [Identifikation] IS NOT NULL AND [Intervalnummer] IS NOT NULL AND [Recordnummer] IS NOT NULL
    )
    INSERT INTO [ode].[Bilag-lukket_Delta_Typed] (
        [Intervalnummer],
    [Recordnummer],
    [Afskrivningsårsag],
    [Afskrivningsdato],
    [Aftaleindhold],
    [Aftalekonto],
    [Aftalekontotype],
    [Aftalenummer],
    [Aftalestatus],
    [Aftaletype],
    [Antal_poster],
    [Bankafregningskonto],
    [Beløb_intern_valuta],
    [Beløb],
    [BevillAnsvarssted],
    [Bevillingsposition],
    [Bevillingsprogram],
    [Bilagsdato],
    [Bilagsnummer],
    [Bilagstype_markering],
    [BogfDato_udligning],
    [Bogføringsdato],
    [Bortposteringsårsag],
    [Dato-ID],
    [Deltransaktion],
    [Firmakode],
    [Forretningspartner],
    [Fra],
    [Funktionsområde],
    [Henstand_til],
    [Hovedtransaktion],
    [Identifikation],
    [Indbetalingstype],
    [Indholdsart],
    [Kapitalmidler],
    [Klient],
    [Kommune_kode],
    [Kredit_oprindelses_dato],
    [Landenøgle],
    [Nettoforfald],
    [Original-FI-område],
    [Position],
    [Postnummer],
    [Referencebilagsnr],
    [Registreringsdato],
    [Rykkeniveau],
    [Rykkeprocedure],
    [SBS_dokumentnummer],
    [Sorteringsbetegnelse],
    [Statistiknøgle],
    [Til],
    [Tilbageført_via],
    [Udligning_kredit_oprindelse],
    [Udligning],
    [Udligningsårsag],
    [Udligningsbeløb],
    [Udligningsbilag],
    [Udligningsdato],
    [Udligningsstatus],
    [Udligningsvaluta],
    [Underapplikation],
    [Valørdato_udligning],
    [Valuta],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    )
    SELECT
        [Intervalnummer],
    [Recordnummer],
    [Afskrivningsårsag],
    [Afskrivningsdato],
    [Aftaleindhold],
    [Aftalekonto],
    [Aftalekontotype],
    [Aftalenummer],
    [Aftalestatus],
    [Aftaletype],
    [Antal_poster],
    [Bankafregningskonto],
    [Beløb_intern_valuta],
    [Beløb],
    [BevillAnsvarssted],
    [Bevillingsposition],
    [Bevillingsprogram],
    [Bilagsdato],
    [Bilagsnummer],
    [Bilagstype_markering],
    [BogfDato_udligning],
    [Bogføringsdato],
    [Bortposteringsårsag],
    [Dato-ID],
    [Deltransaktion],
    [Firmakode],
    [Forretningspartner],
    [Fra],
    [Funktionsområde],
    [Henstand_til],
    [Hovedtransaktion],
    [Identifikation],
    [Indbetalingstype],
    [Indholdsart],
    [Kapitalmidler],
    [Klient],
    [Kommune_kode],
    [Kredit_oprindelses_dato],
    [Landenøgle],
    [Nettoforfald],
    [Original-FI-område],
    [Position],
    [Postnummer],
    [Referencebilagsnr],
    [Registreringsdato],
    [Rykkeniveau],
    [Rykkeprocedure],
    [SBS_dokumentnummer],
    [Sorteringsbetegnelse],
    [Statistiknøgle],
    [Til],
    [Tilbageført_via],
    [Udligning_kredit_oprindelse],
    [Udligning],
    [Udligningsårsag],
    [Udligningsbeløb],
    [Udligningsbilag],
    [Udligningsdato],
    [Udligningsstatus],
    [Udligningsvaluta],
    [Underapplikation],
    [Valørdato_udligning],
    [Valuta],
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
        TRY_CAST(REPLACE([Intervalnummer], '.', '') AS INT) AS [Intervalnummer],
    TRY_CAST(REPLACE([Recordnummer], '.', '') AS INT) AS [Recordnummer],
    LTRIM(RTRIM([Afskrivningsårsag])) AS [Afskrivningsårsag],
    CASE
            WHEN [Afskrivningsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Afskrivningsdato]) = 8 AND [Afskrivningsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Afskrivningsdato], 112)
            WHEN [Afskrivningsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Afskrivningsdato], 104)
            ELSE TRY_CONVERT(DATE, [Afskrivningsdato], 23)
        END AS [Afskrivningsdato],
    LTRIM(RTRIM([Aftaleindhold])) AS [Aftaleindhold],
    LTRIM(RTRIM([Aftalekonto])) AS [Aftalekonto],
    LTRIM(RTRIM([Aftalekontotype])) AS [Aftalekontotype],
    LTRIM(RTRIM([Aftalenummer])) AS [Aftalenummer],
    LTRIM(RTRIM([Aftalestatus])) AS [Aftalestatus],
    LTRIM(RTRIM([Aftaletype])) AS [Aftaletype],
    TRY_CAST(REPLACE([Antal_poster], '.', '') AS INT) AS [Antal_poster],
    LTRIM(RTRIM([Bankafregningskonto])) AS [Bankafregningskonto],
    CASE
            WHEN [Beløb_intern_valuta] IS NULL OR [Beløb_intern_valuta] = '' OR [Beløb_intern_valuta] = '0' THEN NULL
            WHEN [Beløb_intern_valuta] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Beløb_intern_valuta], LEN([Beløb_intern_valuta])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Beløb_intern_valuta], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Beløb_intern_valuta],
    CASE
            WHEN [Beløb] IS NULL OR [Beløb] = '' OR [Beløb] = '0' THEN NULL
            WHEN [Beløb] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Beløb], LEN([Beløb])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Beløb], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Beløb],
    LTRIM(RTRIM([BevillAnsvarssted])) AS [BevillAnsvarssted],
    LTRIM(RTRIM([Bevillingsposition])) AS [Bevillingsposition],
    LTRIM(RTRIM([Bevillingsprogram])) AS [Bevillingsprogram],
    CASE
            WHEN [Bilagsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Bilagsdato]) = 8 AND [Bilagsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Bilagsdato], 112)
            WHEN [Bilagsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Bilagsdato], 104)
            ELSE TRY_CONVERT(DATE, [Bilagsdato], 23)
        END AS [Bilagsdato],
    LTRIM(RTRIM([Bilagsnummer])) AS [Bilagsnummer],
    LTRIM(RTRIM([Bilagstype_markering])) AS [Bilagstype_markering],
    CASE
            WHEN [BogfDato_udligning] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([BogfDato_udligning]) = 8 AND [BogfDato_udligning] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [BogfDato_udligning], 112)
            WHEN [BogfDato_udligning] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [BogfDato_udligning], 104)
            ELSE TRY_CONVERT(DATE, [BogfDato_udligning], 23)
        END AS [BogfDato_udligning],
    CASE
            WHEN [Bogføringsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Bogføringsdato]) = 8 AND [Bogføringsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Bogføringsdato], 112)
            WHEN [Bogføringsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Bogføringsdato], 104)
            ELSE TRY_CONVERT(DATE, [Bogføringsdato], 23)
        END AS [Bogføringsdato],
    LTRIM(RTRIM([Bortposteringsårsag])) AS [Bortposteringsårsag],
    CASE
            WHEN [Dato-ID] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Dato-ID]) = 8 AND [Dato-ID] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Dato-ID], 112)
            WHEN [Dato-ID] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Dato-ID], 104)
            ELSE TRY_CONVERT(DATE, [Dato-ID], 23)
        END AS [Dato-ID],
    LTRIM(RTRIM([Deltransaktion])) AS [Deltransaktion],
    LTRIM(RTRIM([Firmakode])) AS [Firmakode],
    LTRIM(RTRIM([Forretningspartner])) AS [Forretningspartner],
    CASE
            WHEN [Fra] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Fra]) = 8 AND [Fra] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Fra], 112)
            WHEN [Fra] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Fra], 104)
            ELSE TRY_CONVERT(DATE, [Fra], 23)
        END AS [Fra],
    LTRIM(RTRIM([Funktionsområde])) AS [Funktionsområde],
    CASE
            WHEN [Henstand_til] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Henstand_til]) = 8 AND [Henstand_til] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Henstand_til], 112)
            WHEN [Henstand_til] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Henstand_til], 104)
            ELSE TRY_CONVERT(DATE, [Henstand_til], 23)
        END AS [Henstand_til],
    LTRIM(RTRIM([Hovedtransaktion])) AS [Hovedtransaktion],
    LTRIM(RTRIM([Identifikation])) AS [Identifikation],
    LTRIM(RTRIM([Indbetalingstype])) AS [Indbetalingstype],
    LTRIM(RTRIM([Indholdsart])) AS [Indholdsart],
    LTRIM(RTRIM([Kapitalmidler])) AS [Kapitalmidler],
    LTRIM(RTRIM([Klient])) AS [Klient],
    LTRIM(RTRIM([Kommune_kode])) AS [Kommune_kode],
    CASE
            WHEN [Kredit_oprindelses_dato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Kredit_oprindelses_dato]) = 8 AND [Kredit_oprindelses_dato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Kredit_oprindelses_dato], 112)
            WHEN [Kredit_oprindelses_dato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Kredit_oprindelses_dato], 104)
            ELSE TRY_CONVERT(DATE, [Kredit_oprindelses_dato], 23)
        END AS [Kredit_oprindelses_dato],
    LTRIM(RTRIM([Landenøgle])) AS [Landenøgle],
    CASE
            WHEN [Nettoforfald] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Nettoforfald]) = 8 AND [Nettoforfald] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Nettoforfald], 112)
            WHEN [Nettoforfald] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Nettoforfald], 104)
            ELSE TRY_CONVERT(DATE, [Nettoforfald], 23)
        END AS [Nettoforfald],
    LTRIM(RTRIM([Original-FI-område])) AS [Original-FI-område],
    TRY_CAST(REPLACE([Position], '.', '') AS INT) AS [Position],
    LTRIM(RTRIM([Postnummer])) AS [Postnummer],
    LTRIM(RTRIM([Referencebilagsnr])) AS [Referencebilagsnr],
    CASE
            WHEN [Registreringsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Registreringsdato]) = 8 AND [Registreringsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Registreringsdato], 112)
            WHEN [Registreringsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Registreringsdato], 104)
            ELSE TRY_CONVERT(DATE, [Registreringsdato], 23)
        END AS [Registreringsdato],
    TRY_CAST(REPLACE([Rykkeniveau], '.', '') AS INT) AS [Rykkeniveau],
    LTRIM(RTRIM([Rykkeprocedure])) AS [Rykkeprocedure],
    LTRIM(RTRIM([SBS_dokumentnummer])) AS [SBS_dokumentnummer],
    LTRIM(RTRIM([Sorteringsbetegnelse])) AS [Sorteringsbetegnelse],
    LTRIM(RTRIM([Statistiknøgle])) AS [Statistiknøgle],
    CASE
            WHEN [Til] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Til]) = 8 AND [Til] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Til], 112)
            WHEN [Til] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Til], 104)
            ELSE TRY_CONVERT(DATE, [Til], 23)
        END AS [Til],
    LTRIM(RTRIM([Tilbageført_via])) AS [Tilbageført_via],
    LTRIM(RTRIM([Udligning_kredit_oprindelse])) AS [Udligning_kredit_oprindelse],
    CASE
            WHEN [Udligning] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Udligning]) = 8 AND [Udligning] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Udligning], 112)
            WHEN [Udligning] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Udligning], 104)
            ELSE TRY_CONVERT(DATE, [Udligning], 23)
        END AS [Udligning],
    LTRIM(RTRIM([Udligningsårsag])) AS [Udligningsårsag],
    CASE
            WHEN [Udligningsbeløb] IS NULL OR [Udligningsbeløb] = '' OR [Udligningsbeløb] = '0' THEN NULL
            WHEN [Udligningsbeløb] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Udligningsbeløb], LEN([Udligningsbeløb])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Udligningsbeløb], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Udligningsbeløb],
    LTRIM(RTRIM([Udligningsbilag])) AS [Udligningsbilag],
    CASE
            WHEN [Udligningsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Udligningsdato]) = 8 AND [Udligningsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Udligningsdato], 112)
            WHEN [Udligningsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Udligningsdato], 104)
            ELSE TRY_CONVERT(DATE, [Udligningsdato], 23)
        END AS [Udligningsdato],
    LTRIM(RTRIM([Udligningsstatus])) AS [Udligningsstatus],
    LTRIM(RTRIM([Udligningsvaluta])) AS [Udligningsvaluta],
    LTRIM(RTRIM([Underapplikation])) AS [Underapplikation],
    CASE
            WHEN [Valørdato_udligning] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Valørdato_udligning]) = 8 AND [Valørdato_udligning] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Valørdato_udligning], 112)
            WHEN [Valørdato_udligning] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Valørdato_udligning], 104)
            ELSE TRY_CONVERT(DATE, [Valørdato_udligning], 23)
        END AS [Valørdato_udligning],
    LTRIM(RTRIM([Valuta])) AS [Valuta],
    CASE
            WHEN [export_date] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([export_date]) = 8 AND [export_date] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [export_date], 112)
            WHEN [export_date] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [export_date], 104)
            ELSE TRY_CONVERT(DATE, [export_date], 23)
        END AS [export_date],
    LTRIM(RTRIM([file_origin])) AS [file_origin],
    TRY_CAST(REPLACE([row_number], '.', '') AS INT) AS [row_number],
    LTRIM(RTRIM([etl_version])) AS [etl_version],
                ROW_NUMBER() OVER (PARTITION BY [Dato-ID], [Identifikation], [Intervalnummer], [Recordnummer] ORDER BY (SELECT NULL)) as rn
            FROM [ode].[Bilag-lukket_Delta_Staging]
        ) t WHERE rn = 1 AND [Dato-ID] IS NOT NULL AND [Identifikation] IS NOT NULL AND [Intervalnummer] IS NOT NULL AND [Recordnummer] IS NOT NULL
    )
    MERGE INTO [ode].[Bilag-lukket] AS target
    USING new_data AS source
    ON target.[Dato-ID] = source.[Dato-ID] AND target.[Identifikation] = source.[Identifikation] AND target.[Intervalnummer] = source.[Intervalnummer] AND target.[Recordnummer] = source.[Recordnummer]
    WHEN MATCHED THEN
        UPDATE SET target.[Afskrivningsårsag] = source.[Afskrivningsårsag], target.[Afskrivningsdato] = source.[Afskrivningsdato], target.[Aftaleindhold] = source.[Aftaleindhold], target.[Aftalekonto] = source.[Aftalekonto], target.[Aftalekontotype] = source.[Aftalekontotype], target.[Aftalenummer] = source.[Aftalenummer], target.[Aftalestatus] = source.[Aftalestatus], target.[Aftaletype] = source.[Aftaletype], target.[Antal_poster] = source.[Antal_poster], target.[Bankafregningskonto] = source.[Bankafregningskonto], target.[Beløb_intern_valuta] = source.[Beløb_intern_valuta], target.[Beløb] = source.[Beløb], target.[BevillAnsvarssted] = source.[BevillAnsvarssted], target.[Bevillingsposition] = source.[Bevillingsposition], target.[Bevillingsprogram] = source.[Bevillingsprogram], target.[Bilagsdato] = source.[Bilagsdato], target.[Bilagsnummer] = source.[Bilagsnummer], target.[Bilagstype_markering] = source.[Bilagstype_markering], target.[BogfDato_udligning] = source.[BogfDato_udligning], target.[Bogføringsdato] = source.[Bogføringsdato], target.[Bortposteringsårsag] = source.[Bortposteringsårsag], target.[Deltransaktion] = source.[Deltransaktion], target.[Firmakode] = source.[Firmakode], target.[Forretningspartner] = source.[Forretningspartner], target.[Fra] = source.[Fra], target.[Funktionsområde] = source.[Funktionsområde], target.[Henstand_til] = source.[Henstand_til], target.[Hovedtransaktion] = source.[Hovedtransaktion], target.[Indbetalingstype] = source.[Indbetalingstype], target.[Indholdsart] = source.[Indholdsart], target.[Kapitalmidler] = source.[Kapitalmidler], target.[Klient] = source.[Klient], target.[Kommune_kode] = source.[Kommune_kode], target.[Kredit_oprindelses_dato] = source.[Kredit_oprindelses_dato], target.[Landenøgle] = source.[Landenøgle], target.[Nettoforfald] = source.[Nettoforfald], target.[Original-FI-område] = source.[Original-FI-område], target.[Position] = source.[Position], target.[Postnummer] = source.[Postnummer], target.[Referencebilagsnr] = source.[Referencebilagsnr], target.[Registreringsdato] = source.[Registreringsdato], target.[Rykkeniveau] = source.[Rykkeniveau], target.[Rykkeprocedure] = source.[Rykkeprocedure], target.[SBS_dokumentnummer] = source.[SBS_dokumentnummer], target.[Sorteringsbetegnelse] = source.[Sorteringsbetegnelse], target.[Statistiknøgle] = source.[Statistiknøgle], target.[Til] = source.[Til], target.[Tilbageført_via] = source.[Tilbageført_via], target.[Udligning_kredit_oprindelse] = source.[Udligning_kredit_oprindelse], target.[Udligning] = source.[Udligning], target.[Udligningsårsag] = source.[Udligningsårsag], target.[Udligningsbeløb] = source.[Udligningsbeløb], target.[Udligningsbilag] = source.[Udligningsbilag], target.[Udligningsdato] = source.[Udligningsdato], target.[Udligningsstatus] = source.[Udligningsstatus], target.[Udligningsvaluta] = source.[Udligningsvaluta], target.[Underapplikation] = source.[Underapplikation], target.[Valørdato_udligning] = source.[Valørdato_udligning], target.[Valuta] = source.[Valuta], target.[export_date] = source.[export_date], target.[file_origin] = source.[file_origin], target.[row_number] = source.[row_number], target.[etl_version] = source.[etl_version]
    WHEN NOT MATCHED THEN
        INSERT ([Intervalnummer], [Recordnummer], [Afskrivningsårsag], [Afskrivningsdato], [Aftaleindhold], [Aftalekonto], [Aftalekontotype], [Aftalenummer], [Aftalestatus], [Aftaletype], [Antal_poster], [Bankafregningskonto], [Beløb_intern_valuta], [Beløb], [BevillAnsvarssted], [Bevillingsposition], [Bevillingsprogram], [Bilagsdato], [Bilagsnummer], [Bilagstype_markering], [BogfDato_udligning], [Bogføringsdato], [Bortposteringsårsag], [Dato-ID], [Deltransaktion], [Firmakode], [Forretningspartner], [Fra], [Funktionsområde], [Henstand_til], [Hovedtransaktion], [Identifikation], [Indbetalingstype], [Indholdsart], [Kapitalmidler], [Klient], [Kommune_kode], [Kredit_oprindelses_dato], [Landenøgle], [Nettoforfald], [Original-FI-område], [Position], [Postnummer], [Referencebilagsnr], [Registreringsdato], [Rykkeniveau], [Rykkeprocedure], [SBS_dokumentnummer], [Sorteringsbetegnelse], [Statistiknøgle], [Til], [Tilbageført_via], [Udligning_kredit_oprindelse], [Udligning], [Udligningsårsag], [Udligningsbeløb], [Udligningsbilag], [Udligningsdato], [Udligningsstatus], [Udligningsvaluta], [Underapplikation], [Valørdato_udligning], [Valuta], [export_date], [file_origin], [row_number], [etl_version])
        VALUES (source.[Intervalnummer], source.[Recordnummer], source.[Afskrivningsårsag], source.[Afskrivningsdato], source.[Aftaleindhold], source.[Aftalekonto], source.[Aftalekontotype], source.[Aftalenummer], source.[Aftalestatus], source.[Aftaletype], source.[Antal_poster], source.[Bankafregningskonto], source.[Beløb_intern_valuta], source.[Beløb], source.[BevillAnsvarssted], source.[Bevillingsposition], source.[Bevillingsprogram], source.[Bilagsdato], source.[Bilagsnummer], source.[Bilagstype_markering], source.[BogfDato_udligning], source.[Bogføringsdato], source.[Bortposteringsårsag], source.[Dato-ID], source.[Deltransaktion], source.[Firmakode], source.[Forretningspartner], source.[Fra], source.[Funktionsområde], source.[Henstand_til], source.[Hovedtransaktion], source.[Identifikation], source.[Indbetalingstype], source.[Indholdsart], source.[Kapitalmidler], source.[Klient], source.[Kommune_kode], source.[Kredit_oprindelses_dato], source.[Landenøgle], source.[Nettoforfald], source.[Original-FI-område], source.[Position], source.[Postnummer], source.[Referencebilagsnr], source.[Registreringsdato], source.[Rykkeniveau], source.[Rykkeprocedure], source.[SBS_dokumentnummer], source.[Sorteringsbetegnelse], source.[Statistiknøgle], source.[Til], source.[Tilbageført_via], source.[Udligning_kredit_oprindelse], source.[Udligning], source.[Udligningsårsag], source.[Udligningsbeløb], source.[Udligningsbilag], source.[Udligningsdato], source.[Udligningsstatus], source.[Udligningsvaluta], source.[Underapplikation], source.[Valørdato_udligning], source.[Valuta], source.[export_date], source.[file_origin], source.[row_number], source.[etl_version]);
    
    GO

    
    -- D. Validation Metrics
    ------------------------------------------------------------
    SELECT 
        'ROW_COUNTS' as metric,
        (SELECT COUNT(*) FROM [ode].[Bilag-lukket_Delta_Staging]) as source_rows,
        (SELECT COUNT(*) FROM [ode].[Bilag-lukket]) as target_rows;
    
    GO

    -- C. Cleanup (Optional - Staging table usually kept until file move is confirmed)
    DROP TABLE [ode].[Bilag-lukket_Delta_Staging];
    GO
    