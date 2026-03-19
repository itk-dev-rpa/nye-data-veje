
    -- ============================================================
    -- Pipeline Script for Bilag-master (Delta)
    -- Source:  Bilag-master_Delta_Staging
    -- Targets: Bilag-master_Delta_Backup, Bilag-master_Delta_Typed, Bilag-master
    -- Generated automatically
    -- ============================================================

    USE [BackDataLake-Test];
    GO

    -- A. Ensure Target Tables Exist
    ------------------------------------------------------------
    
    IF OBJECT_ID('[ode].[Bilag-master_Delta_Backup]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[Bilag-master_Delta_Backup] (
        [Gentagelsesposition] NVARCHAR(MAX) NULL,
    [AfregnPeriode_fra] NVARCHAR(MAX) NULL,
    [AfregnPeriode_til] NVARCHAR(MAX) NULL,
    [Afskrivningsårsag] NVARCHAR(MAX) NULL,
    [Aftale] NVARCHAR(MAX) NULL,
    [Aftalekonto] NVARCHAR(MAX) NULL,
    [Aftalekontotype] NVARCHAR(MAX) NULL,
    [Aftalenummer] NVARCHAR(MAX) NULL,
    [Aftalestatus] NVARCHAR(MAX) NULL,
    [Aftaletype] NVARCHAR(MAX) NULL,
    [Applikationsområde] NVARCHAR(MAX) NULL,
    [Artskonto] NVARCHAR(MAX) NULL,
    [Beløb_intern_valuta] NVARCHAR(MAX) NULL,
    [Beløb] NVARCHAR(MAX) NULL,
    [Betalingsordre] NVARCHAR(MAX) NULL,
    [Bilagsart] NVARCHAR(MAX) NULL,
    [Bilagsdato] NVARCHAR(MAX) NULL,
    [Bilagsnummer] NVARCHAR(MAX) NULL,
    [Bilagstype_markering] NVARCHAR(MAX) NULL,
    [BogfDato_udligning] NVARCHAR(MAX) NULL,
    [Bogføringsdato] NVARCHAR(MAX) NULL,
    [Bortposteringsårsag] NVARCHAR(MAX) NULL,
    [Delposition] NVARCHAR(MAX) NULL,
    [Deltransaktion] NVARCHAR(MAX) NULL,
    [Firmakode] NVARCHAR(MAX) NULL,
    [Forretningspartner] NVARCHAR(MAX) NULL,
    [Henstand_til] NVARCHAR(MAX) NULL,
    [Hovedtransaktion] NVARCHAR(MAX) NULL,
    [Indholdsart] NVARCHAR(MAX) NULL,
    [Kommune_kode] NVARCHAR(MAX) NULL,
    [KontofastsætKendet] NVARCHAR(MAX) NULL,
    [Momsindikator] NVARCHAR(MAX) NULL,
    [Nettoforfald] NVARCHAR(MAX) NULL,
    [Oprindelse] NVARCHAR(MAX) NULL,
    [Position] NVARCHAR(MAX) NULL,
    [Referencebilagsnr] NVARCHAR(MAX) NULL,
    [Referencenøgle] NVARCHAR(MAX) NULL,
    [Referenceoperation] NVARCHAR(MAX) NULL,
    [Registreringsdato] NVARCHAR(MAX) NULL,
    [Rentenøgle] NVARCHAR(MAX) NULL,
    [Rykkeprocedure] NVARCHAR(MAX) NULL,
    [SBS_dokumentnummer] NVARCHAR(MAX) NULL,
    [Skæringsdato] NVARCHAR(MAX) NULL,
    [Statistiknøgle] NVARCHAR(MAX) NULL,
    [Tilbageført_via] NVARCHAR(MAX) NULL,
    [Udligningsårsag] NVARCHAR(MAX) NULL,
    [Udligningsbeløb] NVARCHAR(MAX) NULL,
    [Udligningstype] NVARCHAR(MAX) NULL,
    [Udligningsbilag] NVARCHAR(MAX) NULL,
    [Udligningsdato] NVARCHAR(MAX) NULL,
    [Udligningsstatus] NVARCHAR(MAX) NULL,
    [Udligningsvaluta] NVARCHAR(MAX) NULL,
    [Valørdato_udligning] NVARCHAR(MAX) NULL,
    [Valuta] NVARCHAR(MAX) NULL,
    [export_date] NVARCHAR(MAX) NULL,
    [file_origin] NVARCHAR(MAX) NULL,
    [row_number] NVARCHAR(MAX) NULL,
    [etl_version] NVARCHAR(MAX) NULL
        );
    END
    
    
    IF OBJECT_ID('[ode].[Bilag-master_Delta_Typed]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[Bilag-master_Delta_Typed] (
        [Gentagelsesposition] INT NULL,
    [AfregnPeriode_fra] DATE NULL,
    [AfregnPeriode_til] DATE NULL,
    [Afskrivningsårsag] NVARCHAR(255) NULL,
    [Aftale] NVARCHAR(255) NULL,
    [Aftalekonto] NVARCHAR(255) NULL,
    [Aftalekontotype] NVARCHAR(255) NULL,
    [Aftalenummer] NVARCHAR(255) NULL,
    [Aftalestatus] NVARCHAR(255) NULL,
    [Aftaletype] NVARCHAR(255) NULL,
    [Applikationsområde] NVARCHAR(255) NULL,
    [Artskonto] NVARCHAR(255) NULL,
    [Beløb_intern_valuta] DECIMAL(15,2) NULL,
    [Beløb] DECIMAL(15,2) NULL,
    [Betalingsordre] NVARCHAR(255) NULL,
    [Bilagsart] NVARCHAR(255) NULL,
    [Bilagsdato] DATE NULL,
    [Bilagsnummer] NVARCHAR(255) NULL,
    [Bilagstype_markering] NVARCHAR(255) NULL,
    [BogfDato_udligning] DATE NULL,
    [Bogføringsdato] DATE NULL,
    [Bortposteringsårsag] NVARCHAR(255) NULL,
    [Delposition] INT NULL,
    [Deltransaktion] NVARCHAR(255) NULL,
    [Firmakode] NVARCHAR(255) NULL,
    [Forretningspartner] NVARCHAR(255) NULL,
    [Henstand_til] DATE NULL,
    [Hovedtransaktion] NVARCHAR(255) NULL,
    [Indholdsart] NVARCHAR(255) NULL,
    [Kommune_kode] NVARCHAR(255) NULL,
    [KontofastsætKendet] NVARCHAR(255) NULL,
    [Momsindikator] NVARCHAR(255) NULL,
    [Nettoforfald] DATE NULL,
    [Oprindelse] NVARCHAR(255) NULL,
    [Position] INT NULL,
    [Referencebilagsnr] NVARCHAR(255) NULL,
    [Referencenøgle] NVARCHAR(255) NULL,
    [Referenceoperation] NVARCHAR(255) NULL,
    [Registreringsdato] DATE NULL,
    [Rentenøgle] NVARCHAR(255) NULL,
    [Rykkeprocedure] NVARCHAR(255) NULL,
    [SBS_dokumentnummer] NVARCHAR(255) NULL,
    [Skæringsdato] DATE NULL,
    [Statistiknøgle] NVARCHAR(255) NULL,
    [Tilbageført_via] NVARCHAR(255) NULL,
    [Udligningsårsag] NVARCHAR(255) NULL,
    [Udligningsbeløb] DECIMAL(15,2) NULL,
    [Udligningstype] NVARCHAR(255) NULL,
    [Udligningsbilag] NVARCHAR(255) NULL,
    [Udligningsdato] DATE NULL,
    [Udligningsstatus] NVARCHAR(255) NULL,
    [Udligningsvaluta] NVARCHAR(255) NULL,
    [Valørdato_udligning] DATE NULL,
    [Valuta] NVARCHAR(255) NULL,
    [export_date] DATE NULL,
    [file_origin] NVARCHAR(255) NULL,
    [row_number] INT NULL,
    [etl_version] NVARCHAR(50) NULL
        );
    END
    
    
    IF OBJECT_ID('[ode].[Bilag-master]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[Bilag-master] (
        [Gentagelsesposition] INT NOT NULL,
    [AfregnPeriode_fra] DATE NULL,
    [AfregnPeriode_til] DATE NULL,
    [Afskrivningsårsag] NVARCHAR(255) NULL,
    [Aftale] NVARCHAR(255) NULL,
    [Aftalekonto] NVARCHAR(255) NULL,
    [Aftalekontotype] NVARCHAR(255) NULL,
    [Aftalenummer] NVARCHAR(255) NULL,
    [Aftalestatus] NVARCHAR(255) NULL,
    [Aftaletype] NVARCHAR(255) NULL,
    [Applikationsområde] NVARCHAR(255) NULL,
    [Artskonto] NVARCHAR(255) NULL,
    [Beløb_intern_valuta] DECIMAL(15,2) NULL,
    [Beløb] DECIMAL(15,2) NULL,
    [Betalingsordre] NVARCHAR(255) NULL,
    [Bilagsart] NVARCHAR(255) NULL,
    [Bilagsdato] DATE NULL,
    [Bilagsnummer] NVARCHAR(255) NOT NULL,
    [Bilagstype_markering] NVARCHAR(255) NULL,
    [BogfDato_udligning] DATE NULL,
    [Bogføringsdato] DATE NULL,
    [Bortposteringsårsag] NVARCHAR(255) NULL,
    [Delposition] INT NOT NULL,
    [Deltransaktion] NVARCHAR(255) NULL,
    [Firmakode] NVARCHAR(255) NULL,
    [Forretningspartner] NVARCHAR(255) NULL,
    [Henstand_til] DATE NULL,
    [Hovedtransaktion] NVARCHAR(255) NULL,
    [Indholdsart] NVARCHAR(255) NULL,
    [Kommune_kode] NVARCHAR(255) NULL,
    [KontofastsætKendet] NVARCHAR(255) NULL,
    [Momsindikator] NVARCHAR(255) NULL,
    [Nettoforfald] DATE NULL,
    [Oprindelse] NVARCHAR(255) NULL,
    [Position] INT NOT NULL,
    [Referencebilagsnr] NVARCHAR(255) NULL,
    [Referencenøgle] NVARCHAR(255) NULL,
    [Referenceoperation] NVARCHAR(255) NULL,
    [Registreringsdato] DATE NULL,
    [Rentenøgle] NVARCHAR(255) NULL,
    [Rykkeprocedure] NVARCHAR(255) NULL,
    [SBS_dokumentnummer] NVARCHAR(255) NULL,
    [Skæringsdato] DATE NULL,
    [Statistiknøgle] NVARCHAR(255) NULL,
    [Tilbageført_via] NVARCHAR(255) NULL,
    [Udligningsårsag] NVARCHAR(255) NULL,
    [Udligningsbeløb] DECIMAL(15,2) NULL,
    [Udligningstype] NVARCHAR(255) NULL,
    [Udligningsbilag] NVARCHAR(255) NULL,
    [Udligningsdato] DATE NULL,
    [Udligningsstatus] NVARCHAR(255) NULL,
    [Udligningsvaluta] NVARCHAR(255) NULL,
    [Valørdato_udligning] DATE NULL,
    [Valuta] NVARCHAR(255) NULL,
    [export_date] DATE NULL,
    [file_origin] NVARCHAR(255) NULL,
    [row_number] INT NULL,
    [etl_version] NVARCHAR(50) NULL,
    CONSTRAINT [PK_Bilag-master] PRIMARY KEY CLUSTERED ([Bilagsnummer], [Gentagelsesposition], [Position], [Delposition])
        );
    END
    
    GO

    -- B. Execute Pipeline Steps
    ------------------------------------------------------------
    
    
    -- 1. BACKUP: Copy raw data from Staging to Backup
    INSERT INTO [ode].[Bilag-master_Delta_Backup] (
        [Gentagelsesposition],
    [AfregnPeriode_fra],
    [AfregnPeriode_til],
    [Afskrivningsårsag],
    [Aftale],
    [Aftalekonto],
    [Aftalekontotype],
    [Aftalenummer],
    [Aftalestatus],
    [Aftaletype],
    [Applikationsområde],
    [Artskonto],
    [Beløb_intern_valuta],
    [Beløb],
    [Betalingsordre],
    [Bilagsart],
    [Bilagsdato],
    [Bilagsnummer],
    [Bilagstype_markering],
    [BogfDato_udligning],
    [Bogføringsdato],
    [Bortposteringsårsag],
    [Delposition],
    [Deltransaktion],
    [Firmakode],
    [Forretningspartner],
    [Henstand_til],
    [Hovedtransaktion],
    [Indholdsart],
    [Kommune_kode],
    [KontofastsætKendet],
    [Momsindikator],
    [Nettoforfald],
    [Oprindelse],
    [Position],
    [Referencebilagsnr],
    [Referencenøgle],
    [Referenceoperation],
    [Registreringsdato],
    [Rentenøgle],
    [Rykkeprocedure],
    [SBS_dokumentnummer],
    [Skæringsdato],
    [Statistiknøgle],
    [Tilbageført_via],
    [Udligningsårsag],
    [Udligningsbeløb],
    [Udligningstype],
    [Udligningsbilag],
    [Udligningsdato],
    [Udligningsstatus],
    [Udligningsvaluta],
    [Valørdato_udligning],
    [Valuta],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    )
    SELECT
        [Gentagelsesposition],
    [AfregnPeriode_fra],
    [AfregnPeriode_til],
    [Afskrivningsårsag],
    [Aftale],
    [Aftalekonto],
    [Aftalekontotype],
    [Aftalenummer],
    [Aftalestatus],
    [Aftaletype],
    [Applikationsområde],
    [Artskonto],
    [Beløb_intern_valuta],
    [Beløb],
    [Betalingsordre],
    [Bilagsart],
    [Bilagsdato],
    [Bilagsnummer],
    [Bilagstype_markering],
    [BogfDato_udligning],
    [Bogføringsdato],
    [Bortposteringsårsag],
    [Delposition],
    [Deltransaktion],
    [Firmakode],
    [Forretningspartner],
    [Henstand_til],
    [Hovedtransaktion],
    [Indholdsart],
    [Kommune_kode],
    [KontofastsætKendet],
    [Momsindikator],
    [Nettoforfald],
    [Oprindelse],
    [Position],
    [Referencebilagsnr],
    [Referencenøgle],
    [Referenceoperation],
    [Registreringsdato],
    [Rentenøgle],
    [Rykkeprocedure],
    [SBS_dokumentnummer],
    [Skæringsdato],
    [Statistiknøgle],
    [Tilbageført_via],
    [Udligningsårsag],
    [Udligningsbeløb],
    [Udligningstype],
    [Udligningsbilag],
    [Udligningsdato],
    [Udligningsstatus],
    [Udligningsvaluta],
    [Valørdato_udligning],
    [Valuta],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    FROM [ode].[Bilag-master_Delta_Staging];
    
    GO
    
    
    -- 2. TYPED: Transform and insert into Typed history
    --    Note: Rows with invalid Primary Keys after conversion are skipped here but exist in Backup.
    WITH transformed_data AS (
        SELECT
        TRY_CAST(REPLACE([Gentagelsesposition], '.', '') AS INT) AS [Gentagelsesposition],
    CASE
            WHEN [AfregnPeriode_fra] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([AfregnPeriode_fra]) = 8 AND [AfregnPeriode_fra] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [AfregnPeriode_fra], 112)
            WHEN [AfregnPeriode_fra] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [AfregnPeriode_fra], 104)
            ELSE TRY_CONVERT(DATE, [AfregnPeriode_fra], 23)
        END AS [AfregnPeriode_fra],
    CASE
            WHEN [AfregnPeriode_til] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([AfregnPeriode_til]) = 8 AND [AfregnPeriode_til] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [AfregnPeriode_til], 112)
            WHEN [AfregnPeriode_til] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [AfregnPeriode_til], 104)
            ELSE TRY_CONVERT(DATE, [AfregnPeriode_til], 23)
        END AS [AfregnPeriode_til],
    LTRIM(RTRIM([Afskrivningsårsag])) AS [Afskrivningsårsag],
    LTRIM(RTRIM([Aftale])) AS [Aftale],
    LTRIM(RTRIM([Aftalekonto])) AS [Aftalekonto],
    LTRIM(RTRIM([Aftalekontotype])) AS [Aftalekontotype],
    LTRIM(RTRIM([Aftalenummer])) AS [Aftalenummer],
    LTRIM(RTRIM([Aftalestatus])) AS [Aftalestatus],
    LTRIM(RTRIM([Aftaletype])) AS [Aftaletype],
    LTRIM(RTRIM([Applikationsområde])) AS [Applikationsområde],
    LTRIM(RTRIM([Artskonto])) AS [Artskonto],
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
    LTRIM(RTRIM([Betalingsordre])) AS [Betalingsordre],
    LTRIM(RTRIM([Bilagsart])) AS [Bilagsart],
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
    TRY_CAST(REPLACE([Delposition], '.', '') AS INT) AS [Delposition],
    LTRIM(RTRIM([Deltransaktion])) AS [Deltransaktion],
    LTRIM(RTRIM([Firmakode])) AS [Firmakode],
    LTRIM(RTRIM([Forretningspartner])) AS [Forretningspartner],
    CASE
            WHEN [Henstand_til] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Henstand_til]) = 8 AND [Henstand_til] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Henstand_til], 112)
            WHEN [Henstand_til] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Henstand_til], 104)
            ELSE TRY_CONVERT(DATE, [Henstand_til], 23)
        END AS [Henstand_til],
    LTRIM(RTRIM([Hovedtransaktion])) AS [Hovedtransaktion],
    LTRIM(RTRIM([Indholdsart])) AS [Indholdsart],
    LTRIM(RTRIM([Kommune_kode])) AS [Kommune_kode],
    LTRIM(RTRIM([KontofastsætKendet])) AS [KontofastsætKendet],
    LTRIM(RTRIM([Momsindikator])) AS [Momsindikator],
    CASE
            WHEN [Nettoforfald] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Nettoforfald]) = 8 AND [Nettoforfald] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Nettoforfald], 112)
            WHEN [Nettoforfald] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Nettoforfald], 104)
            ELSE TRY_CONVERT(DATE, [Nettoforfald], 23)
        END AS [Nettoforfald],
    LTRIM(RTRIM([Oprindelse])) AS [Oprindelse],
    TRY_CAST(REPLACE([Position], '.', '') AS INT) AS [Position],
    LTRIM(RTRIM([Referencebilagsnr])) AS [Referencebilagsnr],
    LTRIM(RTRIM([Referencenøgle])) AS [Referencenøgle],
    LTRIM(RTRIM([Referenceoperation])) AS [Referenceoperation],
    CASE
            WHEN [Registreringsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Registreringsdato]) = 8 AND [Registreringsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Registreringsdato], 112)
            WHEN [Registreringsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Registreringsdato], 104)
            ELSE TRY_CONVERT(DATE, [Registreringsdato], 23)
        END AS [Registreringsdato],
    LTRIM(RTRIM([Rentenøgle])) AS [Rentenøgle],
    LTRIM(RTRIM([Rykkeprocedure])) AS [Rykkeprocedure],
    LTRIM(RTRIM([SBS_dokumentnummer])) AS [SBS_dokumentnummer],
    CASE
            WHEN [Skæringsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Skæringsdato]) = 8 AND [Skæringsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Skæringsdato], 112)
            WHEN [Skæringsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Skæringsdato], 104)
            ELSE TRY_CONVERT(DATE, [Skæringsdato], 23)
        END AS [Skæringsdato],
    LTRIM(RTRIM([Statistiknøgle])) AS [Statistiknøgle],
    LTRIM(RTRIM([Tilbageført_via])) AS [Tilbageført_via],
    LTRIM(RTRIM([Udligningsårsag])) AS [Udligningsårsag],
    CASE
            WHEN [Udligningsbeløb] IS NULL OR [Udligningsbeløb] = '' OR [Udligningsbeløb] = '0' THEN NULL
            WHEN [Udligningsbeløb] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Udligningsbeløb], LEN([Udligningsbeløb])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Udligningsbeløb], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Udligningsbeløb],
    LTRIM(RTRIM([Udligningstype])) AS [Udligningstype],
    LTRIM(RTRIM([Udligningsbilag])) AS [Udligningsbilag],
    CASE
            WHEN [Udligningsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Udligningsdato]) = 8 AND [Udligningsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Udligningsdato], 112)
            WHEN [Udligningsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Udligningsdato], 104)
            ELSE TRY_CONVERT(DATE, [Udligningsdato], 23)
        END AS [Udligningsdato],
    LTRIM(RTRIM([Udligningsstatus])) AS [Udligningsstatus],
    LTRIM(RTRIM([Udligningsvaluta])) AS [Udligningsvaluta],
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
        FROM [ode].[Bilag-master_Delta_Staging]
    ),
    valid_data AS (
        SELECT *,
            ROW_NUMBER() OVER (PARTITION BY [Bilagsnummer], [Gentagelsesposition], [Position], [Delposition] ORDER BY (SELECT NULL)) as rn
        FROM transformed_data
        WHERE [Bilagsnummer] IS NOT NULL AND [Gentagelsesposition] IS NOT NULL AND [Position] IS NOT NULL AND [Delposition] IS NOT NULL
    )
    INSERT INTO [ode].[Bilag-master_Delta_Typed] (
        [Gentagelsesposition],
    [AfregnPeriode_fra],
    [AfregnPeriode_til],
    [Afskrivningsårsag],
    [Aftale],
    [Aftalekonto],
    [Aftalekontotype],
    [Aftalenummer],
    [Aftalestatus],
    [Aftaletype],
    [Applikationsområde],
    [Artskonto],
    [Beløb_intern_valuta],
    [Beløb],
    [Betalingsordre],
    [Bilagsart],
    [Bilagsdato],
    [Bilagsnummer],
    [Bilagstype_markering],
    [BogfDato_udligning],
    [Bogføringsdato],
    [Bortposteringsårsag],
    [Delposition],
    [Deltransaktion],
    [Firmakode],
    [Forretningspartner],
    [Henstand_til],
    [Hovedtransaktion],
    [Indholdsart],
    [Kommune_kode],
    [KontofastsætKendet],
    [Momsindikator],
    [Nettoforfald],
    [Oprindelse],
    [Position],
    [Referencebilagsnr],
    [Referencenøgle],
    [Referenceoperation],
    [Registreringsdato],
    [Rentenøgle],
    [Rykkeprocedure],
    [SBS_dokumentnummer],
    [Skæringsdato],
    [Statistiknøgle],
    [Tilbageført_via],
    [Udligningsårsag],
    [Udligningsbeløb],
    [Udligningstype],
    [Udligningsbilag],
    [Udligningsdato],
    [Udligningsstatus],
    [Udligningsvaluta],
    [Valørdato_udligning],
    [Valuta],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    )
    SELECT
        [Gentagelsesposition],
    [AfregnPeriode_fra],
    [AfregnPeriode_til],
    [Afskrivningsårsag],
    [Aftale],
    [Aftalekonto],
    [Aftalekontotype],
    [Aftalenummer],
    [Aftalestatus],
    [Aftaletype],
    [Applikationsområde],
    [Artskonto],
    [Beløb_intern_valuta],
    [Beløb],
    [Betalingsordre],
    [Bilagsart],
    [Bilagsdato],
    [Bilagsnummer],
    [Bilagstype_markering],
    [BogfDato_udligning],
    [Bogføringsdato],
    [Bortposteringsårsag],
    [Delposition],
    [Deltransaktion],
    [Firmakode],
    [Forretningspartner],
    [Henstand_til],
    [Hovedtransaktion],
    [Indholdsart],
    [Kommune_kode],
    [KontofastsætKendet],
    [Momsindikator],
    [Nettoforfald],
    [Oprindelse],
    [Position],
    [Referencebilagsnr],
    [Referencenøgle],
    [Referenceoperation],
    [Registreringsdato],
    [Rentenøgle],
    [Rykkeprocedure],
    [SBS_dokumentnummer],
    [Skæringsdato],
    [Statistiknøgle],
    [Tilbageført_via],
    [Udligningsårsag],
    [Udligningsbeløb],
    [Udligningstype],
    [Udligningsbilag],
    [Udligningsdato],
    [Udligningsstatus],
    [Udligningsvaluta],
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
        TRY_CAST(REPLACE([Gentagelsesposition], '.', '') AS INT) AS [Gentagelsesposition],
    CASE
            WHEN [AfregnPeriode_fra] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([AfregnPeriode_fra]) = 8 AND [AfregnPeriode_fra] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [AfregnPeriode_fra], 112)
            WHEN [AfregnPeriode_fra] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [AfregnPeriode_fra], 104)
            ELSE TRY_CONVERT(DATE, [AfregnPeriode_fra], 23)
        END AS [AfregnPeriode_fra],
    CASE
            WHEN [AfregnPeriode_til] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([AfregnPeriode_til]) = 8 AND [AfregnPeriode_til] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [AfregnPeriode_til], 112)
            WHEN [AfregnPeriode_til] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [AfregnPeriode_til], 104)
            ELSE TRY_CONVERT(DATE, [AfregnPeriode_til], 23)
        END AS [AfregnPeriode_til],
    LTRIM(RTRIM([Afskrivningsårsag])) AS [Afskrivningsårsag],
    LTRIM(RTRIM([Aftale])) AS [Aftale],
    LTRIM(RTRIM([Aftalekonto])) AS [Aftalekonto],
    LTRIM(RTRIM([Aftalekontotype])) AS [Aftalekontotype],
    LTRIM(RTRIM([Aftalenummer])) AS [Aftalenummer],
    LTRIM(RTRIM([Aftalestatus])) AS [Aftalestatus],
    LTRIM(RTRIM([Aftaletype])) AS [Aftaletype],
    LTRIM(RTRIM([Applikationsområde])) AS [Applikationsområde],
    LTRIM(RTRIM([Artskonto])) AS [Artskonto],
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
    LTRIM(RTRIM([Betalingsordre])) AS [Betalingsordre],
    LTRIM(RTRIM([Bilagsart])) AS [Bilagsart],
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
    TRY_CAST(REPLACE([Delposition], '.', '') AS INT) AS [Delposition],
    LTRIM(RTRIM([Deltransaktion])) AS [Deltransaktion],
    LTRIM(RTRIM([Firmakode])) AS [Firmakode],
    LTRIM(RTRIM([Forretningspartner])) AS [Forretningspartner],
    CASE
            WHEN [Henstand_til] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Henstand_til]) = 8 AND [Henstand_til] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Henstand_til], 112)
            WHEN [Henstand_til] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Henstand_til], 104)
            ELSE TRY_CONVERT(DATE, [Henstand_til], 23)
        END AS [Henstand_til],
    LTRIM(RTRIM([Hovedtransaktion])) AS [Hovedtransaktion],
    LTRIM(RTRIM([Indholdsart])) AS [Indholdsart],
    LTRIM(RTRIM([Kommune_kode])) AS [Kommune_kode],
    LTRIM(RTRIM([KontofastsætKendet])) AS [KontofastsætKendet],
    LTRIM(RTRIM([Momsindikator])) AS [Momsindikator],
    CASE
            WHEN [Nettoforfald] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Nettoforfald]) = 8 AND [Nettoforfald] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Nettoforfald], 112)
            WHEN [Nettoforfald] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Nettoforfald], 104)
            ELSE TRY_CONVERT(DATE, [Nettoforfald], 23)
        END AS [Nettoforfald],
    LTRIM(RTRIM([Oprindelse])) AS [Oprindelse],
    TRY_CAST(REPLACE([Position], '.', '') AS INT) AS [Position],
    LTRIM(RTRIM([Referencebilagsnr])) AS [Referencebilagsnr],
    LTRIM(RTRIM([Referencenøgle])) AS [Referencenøgle],
    LTRIM(RTRIM([Referenceoperation])) AS [Referenceoperation],
    CASE
            WHEN [Registreringsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Registreringsdato]) = 8 AND [Registreringsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Registreringsdato], 112)
            WHEN [Registreringsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Registreringsdato], 104)
            ELSE TRY_CONVERT(DATE, [Registreringsdato], 23)
        END AS [Registreringsdato],
    LTRIM(RTRIM([Rentenøgle])) AS [Rentenøgle],
    LTRIM(RTRIM([Rykkeprocedure])) AS [Rykkeprocedure],
    LTRIM(RTRIM([SBS_dokumentnummer])) AS [SBS_dokumentnummer],
    CASE
            WHEN [Skæringsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Skæringsdato]) = 8 AND [Skæringsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Skæringsdato], 112)
            WHEN [Skæringsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Skæringsdato], 104)
            ELSE TRY_CONVERT(DATE, [Skæringsdato], 23)
        END AS [Skæringsdato],
    LTRIM(RTRIM([Statistiknøgle])) AS [Statistiknøgle],
    LTRIM(RTRIM([Tilbageført_via])) AS [Tilbageført_via],
    LTRIM(RTRIM([Udligningsårsag])) AS [Udligningsårsag],
    CASE
            WHEN [Udligningsbeløb] IS NULL OR [Udligningsbeløb] = '' OR [Udligningsbeløb] = '0' THEN NULL
            WHEN [Udligningsbeløb] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Udligningsbeløb], LEN([Udligningsbeløb])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Udligningsbeløb], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Udligningsbeløb],
    LTRIM(RTRIM([Udligningstype])) AS [Udligningstype],
    LTRIM(RTRIM([Udligningsbilag])) AS [Udligningsbilag],
    CASE
            WHEN [Udligningsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Udligningsdato]) = 8 AND [Udligningsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Udligningsdato], 112)
            WHEN [Udligningsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Udligningsdato], 104)
            ELSE TRY_CONVERT(DATE, [Udligningsdato], 23)
        END AS [Udligningsdato],
    LTRIM(RTRIM([Udligningsstatus])) AS [Udligningsstatus],
    LTRIM(RTRIM([Udligningsvaluta])) AS [Udligningsvaluta],
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
                ROW_NUMBER() OVER (PARTITION BY [Bilagsnummer], [Gentagelsesposition], [Position], [Delposition] ORDER BY (SELECT NULL)) as rn
            FROM [ode].[Bilag-master_Delta_Staging]
        ) t WHERE rn = 1 AND [Bilagsnummer] IS NOT NULL AND [Gentagelsesposition] IS NOT NULL AND [Position] IS NOT NULL AND [Delposition] IS NOT NULL
    )
    MERGE INTO [ode].[Bilag-master] AS target
    USING new_data AS source
    ON target.[Bilagsnummer] = source.[Bilagsnummer] AND target.[Gentagelsesposition] = source.[Gentagelsesposition] AND target.[Position] = source.[Position] AND target.[Delposition] = source.[Delposition]
    WHEN MATCHED THEN
        UPDATE SET target.[AfregnPeriode_fra] = source.[AfregnPeriode_fra], target.[AfregnPeriode_til] = source.[AfregnPeriode_til], target.[Afskrivningsårsag] = source.[Afskrivningsårsag], target.[Aftale] = source.[Aftale], target.[Aftalekonto] = source.[Aftalekonto], target.[Aftalekontotype] = source.[Aftalekontotype], target.[Aftalenummer] = source.[Aftalenummer], target.[Aftalestatus] = source.[Aftalestatus], target.[Aftaletype] = source.[Aftaletype], target.[Applikationsområde] = source.[Applikationsområde], target.[Artskonto] = source.[Artskonto], target.[Beløb_intern_valuta] = source.[Beløb_intern_valuta], target.[Beløb] = source.[Beløb], target.[Betalingsordre] = source.[Betalingsordre], target.[Bilagsart] = source.[Bilagsart], target.[Bilagsdato] = source.[Bilagsdato], target.[Bilagstype_markering] = source.[Bilagstype_markering], target.[BogfDato_udligning] = source.[BogfDato_udligning], target.[Bogføringsdato] = source.[Bogføringsdato], target.[Bortposteringsårsag] = source.[Bortposteringsårsag], target.[Deltransaktion] = source.[Deltransaktion], target.[Firmakode] = source.[Firmakode], target.[Forretningspartner] = source.[Forretningspartner], target.[Henstand_til] = source.[Henstand_til], target.[Hovedtransaktion] = source.[Hovedtransaktion], target.[Indholdsart] = source.[Indholdsart], target.[Kommune_kode] = source.[Kommune_kode], target.[KontofastsætKendet] = source.[KontofastsætKendet], target.[Momsindikator] = source.[Momsindikator], target.[Nettoforfald] = source.[Nettoforfald], target.[Oprindelse] = source.[Oprindelse], target.[Referencebilagsnr] = source.[Referencebilagsnr], target.[Referencenøgle] = source.[Referencenøgle], target.[Referenceoperation] = source.[Referenceoperation], target.[Registreringsdato] = source.[Registreringsdato], target.[Rentenøgle] = source.[Rentenøgle], target.[Rykkeprocedure] = source.[Rykkeprocedure], target.[SBS_dokumentnummer] = source.[SBS_dokumentnummer], target.[Skæringsdato] = source.[Skæringsdato], target.[Statistiknøgle] = source.[Statistiknøgle], target.[Tilbageført_via] = source.[Tilbageført_via], target.[Udligningsårsag] = source.[Udligningsårsag], target.[Udligningsbeløb] = source.[Udligningsbeløb], target.[Udligningstype] = source.[Udligningstype], target.[Udligningsbilag] = source.[Udligningsbilag], target.[Udligningsdato] = source.[Udligningsdato], target.[Udligningsstatus] = source.[Udligningsstatus], target.[Udligningsvaluta] = source.[Udligningsvaluta], target.[Valørdato_udligning] = source.[Valørdato_udligning], target.[Valuta] = source.[Valuta], target.[export_date] = source.[export_date], target.[file_origin] = source.[file_origin], target.[row_number] = source.[row_number], target.[etl_version] = source.[etl_version]
    WHEN NOT MATCHED THEN
        INSERT ([Gentagelsesposition], [AfregnPeriode_fra], [AfregnPeriode_til], [Afskrivningsårsag], [Aftale], [Aftalekonto], [Aftalekontotype], [Aftalenummer], [Aftalestatus], [Aftaletype], [Applikationsområde], [Artskonto], [Beløb_intern_valuta], [Beløb], [Betalingsordre], [Bilagsart], [Bilagsdato], [Bilagsnummer], [Bilagstype_markering], [BogfDato_udligning], [Bogføringsdato], [Bortposteringsårsag], [Delposition], [Deltransaktion], [Firmakode], [Forretningspartner], [Henstand_til], [Hovedtransaktion], [Indholdsart], [Kommune_kode], [KontofastsætKendet], [Momsindikator], [Nettoforfald], [Oprindelse], [Position], [Referencebilagsnr], [Referencenøgle], [Referenceoperation], [Registreringsdato], [Rentenøgle], [Rykkeprocedure], [SBS_dokumentnummer], [Skæringsdato], [Statistiknøgle], [Tilbageført_via], [Udligningsårsag], [Udligningsbeløb], [Udligningstype], [Udligningsbilag], [Udligningsdato], [Udligningsstatus], [Udligningsvaluta], [Valørdato_udligning], [Valuta], [export_date], [file_origin], [row_number], [etl_version])
        VALUES (source.[Gentagelsesposition], source.[AfregnPeriode_fra], source.[AfregnPeriode_til], source.[Afskrivningsårsag], source.[Aftale], source.[Aftalekonto], source.[Aftalekontotype], source.[Aftalenummer], source.[Aftalestatus], source.[Aftaletype], source.[Applikationsområde], source.[Artskonto], source.[Beløb_intern_valuta], source.[Beløb], source.[Betalingsordre], source.[Bilagsart], source.[Bilagsdato], source.[Bilagsnummer], source.[Bilagstype_markering], source.[BogfDato_udligning], source.[Bogføringsdato], source.[Bortposteringsårsag], source.[Delposition], source.[Deltransaktion], source.[Firmakode], source.[Forretningspartner], source.[Henstand_til], source.[Hovedtransaktion], source.[Indholdsart], source.[Kommune_kode], source.[KontofastsætKendet], source.[Momsindikator], source.[Nettoforfald], source.[Oprindelse], source.[Position], source.[Referencebilagsnr], source.[Referencenøgle], source.[Referenceoperation], source.[Registreringsdato], source.[Rentenøgle], source.[Rykkeprocedure], source.[SBS_dokumentnummer], source.[Skæringsdato], source.[Statistiknøgle], source.[Tilbageført_via], source.[Udligningsårsag], source.[Udligningsbeløb], source.[Udligningstype], source.[Udligningsbilag], source.[Udligningsdato], source.[Udligningsstatus], source.[Udligningsvaluta], source.[Valørdato_udligning], source.[Valuta], source.[export_date], source.[file_origin], source.[row_number], source.[etl_version]);
    
    GO

    
    -- D. Validation Metrics
    ------------------------------------------------------------
    SELECT 
        'ROW_COUNTS' as metric,
        (SELECT COUNT(*) FROM [ode].[Bilag-master_Delta_Staging]) as source_rows,
        (SELECT COUNT(*) FROM [ode].[Bilag-master]) as target_rows;
    
    GO

    -- C. Cleanup (Optional - Staging table usually kept until file move is confirmed)
    DROP TABLE [ode].[Bilag-master_Delta_Staging];
    GO
    