
    -- ============================================================
    -- Pipeline Script for Bilag-aaben (Delta)
    -- Source:  Bilag-aaben_Delta_Staging
    -- Targets: Bilag-aaben_Delta_Backup, Bilag-aaben_Delta_Typed, Bilag-aaben
    -- Generated automatically
    -- ============================================================

    USE [BackDataLake-Test];
    GO

    -- A. Ensure Target Tables Exist
    ------------------------------------------------------------
    
    IF OBJECT_ID('[ode].[Bilag-aaben_Delta_Backup]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[Bilag-aaben_Delta_Backup] (
        [Aftaleindhold] NVARCHAR(MAX) NULL,
    [Aftalekonto] NVARCHAR(MAX) NULL,
    [Aftalekontotype] NVARCHAR(MAX) NULL,
    [Aftalenummer] NVARCHAR(MAX) NULL,
    [Aftalestatus] NVARCHAR(MAX) NULL,
    [Aftaletype] NVARCHAR(MAX) NULL,
    [Antal_poster] NVARCHAR(MAX) NULL,
    [Beløb_intern_valuta] NVARCHAR(MAX) NULL,
    [Beløb] NVARCHAR(MAX) NULL,
    [BevillAnsvarssted] NVARCHAR(MAX) NULL,
    [Bevillingsposition] NVARCHAR(MAX) NULL,
    [Bevillingsprogram] NVARCHAR(MAX) NULL,
    [Bilagsdato] NVARCHAR(MAX) NULL,
    [Bilagsnummer] NVARCHAR(MAX) NULL,
    [Bogføringsdato] NVARCHAR(MAX) NULL,
    [Dato-ID] NVARCHAR(MAX) NULL,
    [Deltransaktion] NVARCHAR(MAX) NULL,
    [Firmakode] NVARCHAR(MAX) NULL,
    [Forretningspartner] NVARCHAR(MAX) NULL,
    [Funktionsområde] NVARCHAR(MAX) NULL,
    [Henstand_til] NVARCHAR(MAX) NULL,
    [Hovedtransaktion] NVARCHAR(MAX) NULL,
    [Identifikation] NVARCHAR(MAX) NULL,
    [Indholdsart] NVARCHAR(MAX) NULL,
    [Kapitalmidler] NVARCHAR(MAX) NULL,
    [Klient] NVARCHAR(MAX) NULL,
    [Kommune_kode] NVARCHAR(MAX) NULL,
    [Kredit_oprindelses_dato] NVARCHAR(MAX) NULL,
    [Landenøgle] NVARCHAR(MAX) NULL,
    [Nettoforfald] NVARCHAR(MAX) NULL,
    [Original-FI-område] NVARCHAR(MAX) NULL,
    [Periodenøgle] NVARCHAR(MAX) NULL,
    [Position] NVARCHAR(MAX) NULL,
    [Positionstekst] NVARCHAR(MAX) NULL,
    [Postnummer] NVARCHAR(MAX) NULL,
    [Referencebilagsnr] NVARCHAR(MAX) NULL,
    [Registreringsdato] NVARCHAR(MAX) NULL,
    [Rykkeniveau] NVARCHAR(MAX) NULL,
    [Rykkeniveautype] NVARCHAR(MAX) NULL,
    [Rykkeprocedure] NVARCHAR(MAX) NULL,
    [Rykkeproceduretype] NVARCHAR(MAX) NULL,
    [SBS_dokumentnummer] NVARCHAR(MAX) NULL,
    [Skæringsdato] NVARCHAR(MAX) NULL,
    [Sorteringsbetegnelse] NVARCHAR(MAX) NULL,
    [Statistiknøgle] NVARCHAR(MAX) NULL,
    [Udligning_kredit_oprindelse] NVARCHAR(MAX) NULL,
    [Udligningsstatus] NVARCHAR(MAX) NULL,
    [Valuta] NVARCHAR(MAX) NULL,
    [export_date] NVARCHAR(MAX) NULL,
    [file_origin] NVARCHAR(MAX) NULL,
    [row_number] NVARCHAR(MAX) NULL,
    [etl_version] NVARCHAR(MAX) NULL
        );
    END
    
    
    IF OBJECT_ID('[ode].[Bilag-aaben_Delta_Typed]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[Bilag-aaben_Delta_Typed] (
        [Aftaleindhold] NVARCHAR(255) NULL,
    [Aftalekonto] NVARCHAR(255) NULL,
    [Aftalekontotype] NVARCHAR(255) NULL,
    [Aftalenummer] NVARCHAR(255) NULL,
    [Aftalestatus] NVARCHAR(255) NULL,
    [Aftaletype] NVARCHAR(255) NULL,
    [Antal_poster] INT NULL,
    [Beløb_intern_valuta] DECIMAL(15,2) NULL,
    [Beløb] DECIMAL(15,2) NULL,
    [BevillAnsvarssted] NVARCHAR(255) NULL,
    [Bevillingsposition] NVARCHAR(255) NULL,
    [Bevillingsprogram] NVARCHAR(255) NULL,
    [Bilagsdato] DATE NULL,
    [Bilagsnummer] NVARCHAR(255) NULL,
    [Bogføringsdato] DATE NULL,
    [Dato-ID] DATE NULL,
    [Deltransaktion] NVARCHAR(255) NULL,
    [Firmakode] NVARCHAR(255) NULL,
    [Forretningspartner] NVARCHAR(255) NULL,
    [Funktionsområde] NVARCHAR(255) NULL,
    [Henstand_til] DATE NULL,
    [Hovedtransaktion] NVARCHAR(255) NULL,
    [Identifikation] NVARCHAR(255) NULL,
    [Indholdsart] NVARCHAR(255) NULL,
    [Kapitalmidler] NVARCHAR(255) NULL,
    [Klient] NVARCHAR(255) NULL,
    [Kommune_kode] NVARCHAR(255) NULL,
    [Kredit_oprindelses_dato] DATE NULL,
    [Landenøgle] NVARCHAR(255) NULL,
    [Nettoforfald] DATE NULL,
    [Original-FI-område] NVARCHAR(255) NULL,
    [Periodenøgle] NVARCHAR(255) NULL,
    [Position] INT NULL,
    [Positionstekst] NVARCHAR(255) NULL,
    [Postnummer] NVARCHAR(255) NULL,
    [Referencebilagsnr] NVARCHAR(255) NULL,
    [Registreringsdato] DATE NULL,
    [Rykkeniveau] INT NULL,
    [Rykkeniveautype] NVARCHAR(255) NULL,
    [Rykkeprocedure] NVARCHAR(255) NULL,
    [Rykkeproceduretype] NVARCHAR(255) NULL,
    [SBS_dokumentnummer] NVARCHAR(255) NULL,
    [Skæringsdato] DATE NULL,
    [Sorteringsbetegnelse] NVARCHAR(255) NULL,
    [Statistiknøgle] NVARCHAR(255) NULL,
    [Udligning_kredit_oprindelse] NVARCHAR(255) NULL,
    [Udligningsstatus] NVARCHAR(255) NULL,
    [Valuta] NVARCHAR(255) NULL,
    [export_date] DATE NULL,
    [file_origin] NVARCHAR(255) NULL,
    [row_number] INT NULL,
    [etl_version] NVARCHAR(50) NULL
        );
    END
    
    
    IF OBJECT_ID('[ode].[Bilag-aaben]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[Bilag-aaben] (
        [Aftaleindhold] NVARCHAR(255) NULL,
    [Aftalekonto] NVARCHAR(255) NULL,
    [Aftalekontotype] NVARCHAR(255) NULL,
    [Aftalenummer] NVARCHAR(255) NULL,
    [Aftalestatus] NVARCHAR(255) NULL,
    [Aftaletype] NVARCHAR(255) NULL,
    [Antal_poster] INT NULL,
    [Beløb_intern_valuta] DECIMAL(15,2) NULL,
    [Beløb] DECIMAL(15,2) NULL,
    [BevillAnsvarssted] NVARCHAR(255) NULL,
    [Bevillingsposition] NVARCHAR(255) NULL,
    [Bevillingsprogram] NVARCHAR(255) NULL,
    [Bilagsdato] DATE NULL,
    [Bilagsnummer] NVARCHAR(255) NULL,
    [Bogføringsdato] DATE NULL,
    [Dato-ID] DATE NULL,
    [Deltransaktion] NVARCHAR(255) NULL,
    [Firmakode] NVARCHAR(255) NULL,
    [Forretningspartner] NVARCHAR(255) NULL,
    [Funktionsområde] NVARCHAR(255) NULL,
    [Henstand_til] DATE NULL,
    [Hovedtransaktion] NVARCHAR(255) NULL,
    [Identifikation] NVARCHAR(255) NULL,
    [Indholdsart] NVARCHAR(255) NULL,
    [Kapitalmidler] NVARCHAR(255) NULL,
    [Klient] NVARCHAR(255) NULL,
    [Kommune_kode] NVARCHAR(255) NULL,
    [Kredit_oprindelses_dato] DATE NULL,
    [Landenøgle] NVARCHAR(255) NULL,
    [Nettoforfald] DATE NULL,
    [Original-FI-område] NVARCHAR(255) NULL,
    [Periodenøgle] NVARCHAR(255) NULL,
    [Position] INT NULL,
    [Positionstekst] NVARCHAR(255) NULL,
    [Postnummer] NVARCHAR(255) NULL,
    [Referencebilagsnr] NVARCHAR(255) NULL,
    [Registreringsdato] DATE NULL,
    [Rykkeniveau] INT NULL,
    [Rykkeniveautype] NVARCHAR(255) NULL,
    [Rykkeprocedure] NVARCHAR(255) NULL,
    [Rykkeproceduretype] NVARCHAR(255) NULL,
    [SBS_dokumentnummer] NVARCHAR(255) NULL,
    [Skæringsdato] DATE NULL,
    [Sorteringsbetegnelse] NVARCHAR(255) NULL,
    [Statistiknøgle] NVARCHAR(255) NULL,
    [Udligning_kredit_oprindelse] NVARCHAR(255) NULL,
    [Udligningsstatus] NVARCHAR(255) NULL,
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
    INSERT INTO [ode].[Bilag-aaben_Delta_Backup] (
        [Aftaleindhold],
    [Aftalekonto],
    [Aftalekontotype],
    [Aftalenummer],
    [Aftalestatus],
    [Aftaletype],
    [Antal_poster],
    [Beløb_intern_valuta],
    [Beløb],
    [BevillAnsvarssted],
    [Bevillingsposition],
    [Bevillingsprogram],
    [Bilagsdato],
    [Bilagsnummer],
    [Bogføringsdato],
    [Dato-ID],
    [Deltransaktion],
    [Firmakode],
    [Forretningspartner],
    [Funktionsområde],
    [Henstand_til],
    [Hovedtransaktion],
    [Identifikation],
    [Indholdsart],
    [Kapitalmidler],
    [Klient],
    [Kommune_kode],
    [Kredit_oprindelses_dato],
    [Landenøgle],
    [Nettoforfald],
    [Original-FI-område],
    [Periodenøgle],
    [Position],
    [Positionstekst],
    [Postnummer],
    [Referencebilagsnr],
    [Registreringsdato],
    [Rykkeniveau],
    [Rykkeniveautype],
    [Rykkeprocedure],
    [Rykkeproceduretype],
    [SBS_dokumentnummer],
    [Skæringsdato],
    [Sorteringsbetegnelse],
    [Statistiknøgle],
    [Udligning_kredit_oprindelse],
    [Udligningsstatus],
    [Valuta],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    )
    SELECT
        [Aftaleindhold],
    [Aftalekonto],
    [Aftalekontotype],
    [Aftalenummer],
    [Aftalestatus],
    [Aftaletype],
    [Antal_poster],
    [Beløb_intern_valuta],
    [Beløb],
    [BevillAnsvarssted],
    [Bevillingsposition],
    [Bevillingsprogram],
    [Bilagsdato],
    [Bilagsnummer],
    [Bogføringsdato],
    [Dato-ID],
    [Deltransaktion],
    [Firmakode],
    [Forretningspartner],
    [Funktionsområde],
    [Henstand_til],
    [Hovedtransaktion],
    [Identifikation],
    [Indholdsart],
    [Kapitalmidler],
    [Klient],
    [Kommune_kode],
    [Kredit_oprindelses_dato],
    [Landenøgle],
    [Nettoforfald],
    [Original-FI-område],
    [Periodenøgle],
    [Position],
    [Positionstekst],
    [Postnummer],
    [Referencebilagsnr],
    [Registreringsdato],
    [Rykkeniveau],
    [Rykkeniveautype],
    [Rykkeprocedure],
    [Rykkeproceduretype],
    [SBS_dokumentnummer],
    [Skæringsdato],
    [Sorteringsbetegnelse],
    [Statistiknøgle],
    [Udligning_kredit_oprindelse],
    [Udligningsstatus],
    [Valuta],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    FROM [ode].[Bilag-aaben_Delta_Staging];
    
    GO
    
    
    -- 2. TYPED: Transform and insert (No PK defined)
    INSERT INTO [ode].[Bilag-aaben_Delta_Typed] (
        [Aftaleindhold],
    [Aftalekonto],
    [Aftalekontotype],
    [Aftalenummer],
    [Aftalestatus],
    [Aftaletype],
    [Antal_poster],
    [Beløb_intern_valuta],
    [Beløb],
    [BevillAnsvarssted],
    [Bevillingsposition],
    [Bevillingsprogram],
    [Bilagsdato],
    [Bilagsnummer],
    [Bogføringsdato],
    [Dato-ID],
    [Deltransaktion],
    [Firmakode],
    [Forretningspartner],
    [Funktionsområde],
    [Henstand_til],
    [Hovedtransaktion],
    [Identifikation],
    [Indholdsart],
    [Kapitalmidler],
    [Klient],
    [Kommune_kode],
    [Kredit_oprindelses_dato],
    [Landenøgle],
    [Nettoforfald],
    [Original-FI-område],
    [Periodenøgle],
    [Position],
    [Positionstekst],
    [Postnummer],
    [Referencebilagsnr],
    [Registreringsdato],
    [Rykkeniveau],
    [Rykkeniveautype],
    [Rykkeprocedure],
    [Rykkeproceduretype],
    [SBS_dokumentnummer],
    [Skæringsdato],
    [Sorteringsbetegnelse],
    [Statistiknøgle],
    [Udligning_kredit_oprindelse],
    [Udligningsstatus],
    [Valuta],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    )
    SELECT
        LTRIM(RTRIM([Aftaleindhold])) AS [Aftaleindhold],
    LTRIM(RTRIM([Aftalekonto])) AS [Aftalekonto],
    LTRIM(RTRIM([Aftalekontotype])) AS [Aftalekontotype],
    LTRIM(RTRIM([Aftalenummer])) AS [Aftalenummer],
    LTRIM(RTRIM([Aftalestatus])) AS [Aftalestatus],
    LTRIM(RTRIM([Aftaletype])) AS [Aftaletype],
    TRY_CAST(REPLACE([Antal_poster], '.', '') AS INT) AS [Antal_poster],
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
    CASE
            WHEN [Bogføringsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Bogføringsdato]) = 8 AND [Bogføringsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Bogføringsdato], 112)
            WHEN [Bogføringsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Bogføringsdato], 104)
            ELSE TRY_CONVERT(DATE, [Bogføringsdato], 23)
        END AS [Bogføringsdato],
    CASE
            WHEN [Dato-ID] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Dato-ID]) = 8 AND [Dato-ID] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Dato-ID], 112)
            WHEN [Dato-ID] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Dato-ID], 104)
            ELSE TRY_CONVERT(DATE, [Dato-ID], 23)
        END AS [Dato-ID],
    LTRIM(RTRIM([Deltransaktion])) AS [Deltransaktion],
    LTRIM(RTRIM([Firmakode])) AS [Firmakode],
    LTRIM(RTRIM([Forretningspartner])) AS [Forretningspartner],
    LTRIM(RTRIM([Funktionsområde])) AS [Funktionsområde],
    CASE
            WHEN [Henstand_til] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Henstand_til]) = 8 AND [Henstand_til] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Henstand_til], 112)
            WHEN [Henstand_til] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Henstand_til], 104)
            ELSE TRY_CONVERT(DATE, [Henstand_til], 23)
        END AS [Henstand_til],
    LTRIM(RTRIM([Hovedtransaktion])) AS [Hovedtransaktion],
    LTRIM(RTRIM([Identifikation])) AS [Identifikation],
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
    LTRIM(RTRIM([Periodenøgle])) AS [Periodenøgle],
    TRY_CAST(REPLACE([Position], '.', '') AS INT) AS [Position],
    LTRIM(RTRIM([Positionstekst])) AS [Positionstekst],
    LTRIM(RTRIM([Postnummer])) AS [Postnummer],
    LTRIM(RTRIM([Referencebilagsnr])) AS [Referencebilagsnr],
    CASE
            WHEN [Registreringsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Registreringsdato]) = 8 AND [Registreringsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Registreringsdato], 112)
            WHEN [Registreringsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Registreringsdato], 104)
            ELSE TRY_CONVERT(DATE, [Registreringsdato], 23)
        END AS [Registreringsdato],
    TRY_CAST(REPLACE([Rykkeniveau], '.', '') AS INT) AS [Rykkeniveau],
    LTRIM(RTRIM([Rykkeniveautype])) AS [Rykkeniveautype],
    LTRIM(RTRIM([Rykkeprocedure])) AS [Rykkeprocedure],
    LTRIM(RTRIM([Rykkeproceduretype])) AS [Rykkeproceduretype],
    LTRIM(RTRIM([SBS_dokumentnummer])) AS [SBS_dokumentnummer],
    CASE
            WHEN [Skæringsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Skæringsdato]) = 8 AND [Skæringsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Skæringsdato], 112)
            WHEN [Skæringsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Skæringsdato], 104)
            ELSE TRY_CONVERT(DATE, [Skæringsdato], 23)
        END AS [Skæringsdato],
    LTRIM(RTRIM([Sorteringsbetegnelse])) AS [Sorteringsbetegnelse],
    LTRIM(RTRIM([Statistiknøgle])) AS [Statistiknøgle],
    LTRIM(RTRIM([Udligning_kredit_oprindelse])) AS [Udligning_kredit_oprindelse],
    LTRIM(RTRIM([Udligningsstatus])) AS [Udligningsstatus],
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
    FROM [ode].[Bilag-aaben_Delta_Staging];
    
    GO
    
    
    -- 3. SNAPSHOT: Delta Append (No PK)
    WITH new_data AS (
        SELECT
        LTRIM(RTRIM([Aftaleindhold])) AS [Aftaleindhold],
    LTRIM(RTRIM([Aftalekonto])) AS [Aftalekonto],
    LTRIM(RTRIM([Aftalekontotype])) AS [Aftalekontotype],
    LTRIM(RTRIM([Aftalenummer])) AS [Aftalenummer],
    LTRIM(RTRIM([Aftalestatus])) AS [Aftalestatus],
    LTRIM(RTRIM([Aftaletype])) AS [Aftaletype],
    TRY_CAST(REPLACE([Antal_poster], '.', '') AS INT) AS [Antal_poster],
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
    CASE
            WHEN [Bogføringsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Bogføringsdato]) = 8 AND [Bogføringsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Bogføringsdato], 112)
            WHEN [Bogføringsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Bogføringsdato], 104)
            ELSE TRY_CONVERT(DATE, [Bogføringsdato], 23)
        END AS [Bogføringsdato],
    CASE
            WHEN [Dato-ID] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Dato-ID]) = 8 AND [Dato-ID] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Dato-ID], 112)
            WHEN [Dato-ID] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Dato-ID], 104)
            ELSE TRY_CONVERT(DATE, [Dato-ID], 23)
        END AS [Dato-ID],
    LTRIM(RTRIM([Deltransaktion])) AS [Deltransaktion],
    LTRIM(RTRIM([Firmakode])) AS [Firmakode],
    LTRIM(RTRIM([Forretningspartner])) AS [Forretningspartner],
    LTRIM(RTRIM([Funktionsområde])) AS [Funktionsområde],
    CASE
            WHEN [Henstand_til] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Henstand_til]) = 8 AND [Henstand_til] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Henstand_til], 112)
            WHEN [Henstand_til] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Henstand_til], 104)
            ELSE TRY_CONVERT(DATE, [Henstand_til], 23)
        END AS [Henstand_til],
    LTRIM(RTRIM([Hovedtransaktion])) AS [Hovedtransaktion],
    LTRIM(RTRIM([Identifikation])) AS [Identifikation],
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
    LTRIM(RTRIM([Periodenøgle])) AS [Periodenøgle],
    TRY_CAST(REPLACE([Position], '.', '') AS INT) AS [Position],
    LTRIM(RTRIM([Positionstekst])) AS [Positionstekst],
    LTRIM(RTRIM([Postnummer])) AS [Postnummer],
    LTRIM(RTRIM([Referencebilagsnr])) AS [Referencebilagsnr],
    CASE
            WHEN [Registreringsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Registreringsdato]) = 8 AND [Registreringsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Registreringsdato], 112)
            WHEN [Registreringsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Registreringsdato], 104)
            ELSE TRY_CONVERT(DATE, [Registreringsdato], 23)
        END AS [Registreringsdato],
    TRY_CAST(REPLACE([Rykkeniveau], '.', '') AS INT) AS [Rykkeniveau],
    LTRIM(RTRIM([Rykkeniveautype])) AS [Rykkeniveautype],
    LTRIM(RTRIM([Rykkeprocedure])) AS [Rykkeprocedure],
    LTRIM(RTRIM([Rykkeproceduretype])) AS [Rykkeproceduretype],
    LTRIM(RTRIM([SBS_dokumentnummer])) AS [SBS_dokumentnummer],
    CASE
            WHEN [Skæringsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Skæringsdato]) = 8 AND [Skæringsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Skæringsdato], 112)
            WHEN [Skæringsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Skæringsdato], 104)
            ELSE TRY_CONVERT(DATE, [Skæringsdato], 23)
        END AS [Skæringsdato],
    LTRIM(RTRIM([Sorteringsbetegnelse])) AS [Sorteringsbetegnelse],
    LTRIM(RTRIM([Statistiknøgle])) AS [Statistiknøgle],
    LTRIM(RTRIM([Udligning_kredit_oprindelse])) AS [Udligning_kredit_oprindelse],
    LTRIM(RTRIM([Udligningsstatus])) AS [Udligningsstatus],
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
        FROM [ode].[Bilag-aaben_Delta_Staging]
    )
    INSERT INTO [ode].[Bilag-aaben] ([Aftaleindhold], [Aftalekonto], [Aftalekontotype], [Aftalenummer], [Aftalestatus], [Aftaletype], [Antal_poster], [Beløb_intern_valuta], [Beløb], [BevillAnsvarssted], [Bevillingsposition], [Bevillingsprogram], [Bilagsdato], [Bilagsnummer], [Bogføringsdato], [Dato-ID], [Deltransaktion], [Firmakode], [Forretningspartner], [Funktionsområde], [Henstand_til], [Hovedtransaktion], [Identifikation], [Indholdsart], [Kapitalmidler], [Klient], [Kommune_kode], [Kredit_oprindelses_dato], [Landenøgle], [Nettoforfald], [Original-FI-område], [Periodenøgle], [Position], [Positionstekst], [Postnummer], [Referencebilagsnr], [Registreringsdato], [Rykkeniveau], [Rykkeniveautype], [Rykkeprocedure], [Rykkeproceduretype], [SBS_dokumentnummer], [Skæringsdato], [Sorteringsbetegnelse], [Statistiknøgle], [Udligning_kredit_oprindelse], [Udligningsstatus], [Valuta], [export_date], [file_origin], [row_number], [etl_version])
    SELECT [Aftaleindhold], [Aftalekonto], [Aftalekontotype], [Aftalenummer], [Aftalestatus], [Aftaletype], [Antal_poster], [Beløb_intern_valuta], [Beløb], [BevillAnsvarssted], [Bevillingsposition], [Bevillingsprogram], [Bilagsdato], [Bilagsnummer], [Bogføringsdato], [Dato-ID], [Deltransaktion], [Firmakode], [Forretningspartner], [Funktionsområde], [Henstand_til], [Hovedtransaktion], [Identifikation], [Indholdsart], [Kapitalmidler], [Klient], [Kommune_kode], [Kredit_oprindelses_dato], [Landenøgle], [Nettoforfald], [Original-FI-område], [Periodenøgle], [Position], [Positionstekst], [Postnummer], [Referencebilagsnr], [Registreringsdato], [Rykkeniveau], [Rykkeniveautype], [Rykkeprocedure], [Rykkeproceduretype], [SBS_dokumentnummer], [Skæringsdato], [Sorteringsbetegnelse], [Statistiknøgle], [Udligning_kredit_oprindelse], [Udligningsstatus], [Valuta], [export_date], [file_origin], [row_number], [etl_version] FROM new_data;
    
    GO

    
    -- D. Validation Metrics
    ------------------------------------------------------------
    SELECT 
        'ROW_COUNTS' as metric,
        (SELECT COUNT(*) FROM [ode].[Bilag-aaben_Delta_Staging]) as source_rows,
        (SELECT COUNT(*) FROM [ode].[Bilag-aaben]) as target_rows;
    
    GO

    -- C. Cleanup (Optional - Staging table usually kept until file move is confirmed)
    DROP TABLE [ode].[Bilag-aaben_Delta_Staging];
    GO
    