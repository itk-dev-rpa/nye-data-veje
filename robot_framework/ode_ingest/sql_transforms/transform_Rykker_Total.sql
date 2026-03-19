
    -- ============================================================
    -- Pipeline Script for Rykker (Total)
    -- Source:  Rykker_Total_Staging
    -- Targets: Rykker_Total_Backup, Rykker_Total_Typed, Rykker
    -- Generated automatically
    -- ============================================================

    USE [BackDataLake-Test];
    GO

    -- A. Ensure Target Tables Exist
    ------------------------------------------------------------
    
    IF OBJECT_ID('[ode].[Rykker_Total_Backup]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[Rykker_Total_Backup] (
        [Aftale] NVARCHAR(MAX) NULL,
    [Aftalekonto_ikke_entydig] NVARCHAR(MAX) NULL,
    [Aftalekonto] NVARCHAR(MAX) NULL,
    [Bilagsnummer] NVARCHAR(MAX) NULL,
    [Dato-ID] NVARCHAR(MAX) NULL,
    [Delposition] NVARCHAR(MAX) NULL,
    [Firmakode] NVARCHAR(MAX) NULL,
    [Forretningspartner] NVARCHAR(MAX) NULL,
    [Gentagelsesposition] NVARCHAR(MAX) NULL,
    [Identifikation] NVARCHAR(MAX) NULL,
    [Kommune_kode] NVARCHAR(MAX) NULL,
    [Nettoforfald] NVARCHAR(MAX) NULL,
    [Nyt_rykkeniveau] NVARCHAR(MAX) NULL,
    [Position] NVARCHAR(MAX) NULL,
    [Printdato] NVARCHAR(MAX) NULL,
    [Rentebilag] NVARCHAR(MAX) NULL,
    [Rykkebeløb] NVARCHAR(MAX) NULL,
    [Rykkeniveau] NVARCHAR(MAX) NULL,
    [Rykkeniveautype] NVARCHAR(MAX) NULL,
    [Rykkeprocedure] NVARCHAR(MAX) NULL,
    [Rykker_annulleret] NVARCHAR(MAX) NULL,
    [Rykkerenter] NVARCHAR(MAX) NULL,
    [Rykkertæller] NVARCHAR(MAX) NULL,
    [Rykkespærreårsag] NVARCHAR(MAX) NULL,
    [Segment] NVARCHAR(MAX) NULL,
    [Skæringsdato] NVARCHAR(MAX) NULL,
    [Statistiknøgle] NVARCHAR(MAX) NULL,
    [Suspenderings-rykkeniv] NVARCHAR(MAX) NULL,
    [Udskrevet] NVARCHAR(MAX) NULL,
    [Udstedelsesdato] NVARCHAR(MAX) NULL,
    [Valuta] NVARCHAR(MAX) NULL,
    [export_date] NVARCHAR(MAX) NULL,
    [file_origin] NVARCHAR(MAX) NULL,
    [row_number] NVARCHAR(MAX) NULL,
    [etl_version] NVARCHAR(MAX) NULL
        );
    END
    
    
    IF OBJECT_ID('[ode].[Rykker_Total_Typed]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[Rykker_Total_Typed] (
        [Aftale] NVARCHAR(255) NULL,
    [Aftalekonto_ikke_entydig] NVARCHAR(255) NULL,
    [Aftalekonto] NVARCHAR(255) NULL,
    [Bilagsnummer] NVARCHAR(255) NULL,
    [Dato-ID] DATE NULL,
    [Delposition] INT NULL,
    [Firmakode] NVARCHAR(255) NULL,
    [Forretningspartner] NVARCHAR(255) NULL,
    [Gentagelsesposition] INT NULL,
    [Identifikation] NVARCHAR(255) NULL,
    [Kommune_kode] NVARCHAR(255) NULL,
    [Nettoforfald] DATE NULL,
    [Nyt_rykkeniveau] INT NULL,
    [Position] INT NULL,
    [Printdato] DATE NULL,
    [Rentebilag] NVARCHAR(255) NULL,
    [Rykkebeløb] DECIMAL(15,2) NULL,
    [Rykkeniveau] DECIMAL(15,2) NULL,
    [Rykkeniveautype] NVARCHAR(255) NULL,
    [Rykkeprocedure] NVARCHAR(255) NULL,
    [Rykker_annulleret] NVARCHAR(255) NULL,
    [Rykkerenter] DECIMAL(15,2) NULL,
    [Rykkertæller] INT NULL,
    [Rykkespærreårsag] NVARCHAR(255) NULL,
    [Segment] NVARCHAR(255) NULL,
    [Skæringsdato] DATE NULL,
    [Statistiknøgle] NVARCHAR(255) NULL,
    [Suspenderings-rykkeniv] NVARCHAR(255) NULL,
    [Udskrevet] NVARCHAR(255) NULL,
    [Udstedelsesdato] DATE NULL,
    [Valuta] NVARCHAR(255) NULL,
    [export_date] DATE NULL,
    [file_origin] NVARCHAR(255) NULL,
    [row_number] INT NULL,
    [etl_version] NVARCHAR(50) NULL
        );
    END
    
    
    IF OBJECT_ID('[ode].[Rykker]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[Rykker] (
        [Aftale] NVARCHAR(255) NULL,
    [Aftalekonto_ikke_entydig] NVARCHAR(255) NULL,
    [Aftalekonto] NVARCHAR(255) NOT NULL,
    [Bilagsnummer] NVARCHAR(255) NOT NULL,
    [Dato-ID] DATE NOT NULL,
    [Delposition] INT NOT NULL,
    [Firmakode] NVARCHAR(255) NULL,
    [Forretningspartner] NVARCHAR(255) NOT NULL,
    [Gentagelsesposition] INT NOT NULL,
    [Identifikation] NVARCHAR(255) NOT NULL,
    [Kommune_kode] NVARCHAR(255) NULL,
    [Nettoforfald] DATE NULL,
    [Nyt_rykkeniveau] INT NULL,
    [Position] INT NOT NULL,
    [Printdato] DATE NULL,
    [Rentebilag] NVARCHAR(255) NULL,
    [Rykkebeløb] DECIMAL(15,2) NULL,
    [Rykkeniveau] DECIMAL(15,2) NULL,
    [Rykkeniveautype] NVARCHAR(255) NULL,
    [Rykkeprocedure] NVARCHAR(255) NULL,
    [Rykker_annulleret] NVARCHAR(255) NULL,
    [Rykkerenter] DECIMAL(15,2) NULL,
    [Rykkertæller] INT NOT NULL,
    [Rykkespærreårsag] NVARCHAR(255) NULL,
    [Segment] NVARCHAR(255) NULL,
    [Skæringsdato] DATE NULL,
    [Statistiknøgle] NVARCHAR(255) NULL,
    [Suspenderings-rykkeniv] NVARCHAR(255) NULL,
    [Udskrevet] NVARCHAR(255) NULL,
    [Udstedelsesdato] DATE NULL,
    [Valuta] NVARCHAR(255) NULL,
    [export_date] DATE NULL,
    [file_origin] NVARCHAR(255) NULL,
    [row_number] INT NULL,
    [etl_version] NVARCHAR(50) NULL,
    CONSTRAINT [PK_Rykker] PRIMARY KEY CLUSTERED ([Dato-ID], [Identifikation], [Forretningspartner], [Aftalekonto], [Rykkertæller], [Bilagsnummer], [Gentagelsesposition], [Position], [Delposition])
        );
    END
    
    GO

    -- B. Execute Pipeline Steps
    ------------------------------------------------------------
    
    
    -- 1. BACKUP: Copy raw data from Staging to Backup
    INSERT INTO [ode].[Rykker_Total_Backup] (
        [Aftale],
    [Aftalekonto_ikke_entydig],
    [Aftalekonto],
    [Bilagsnummer],
    [Dato-ID],
    [Delposition],
    [Firmakode],
    [Forretningspartner],
    [Gentagelsesposition],
    [Identifikation],
    [Kommune_kode],
    [Nettoforfald],
    [Nyt_rykkeniveau],
    [Position],
    [Printdato],
    [Rentebilag],
    [Rykkebeløb],
    [Rykkeniveau],
    [Rykkeniveautype],
    [Rykkeprocedure],
    [Rykker_annulleret],
    [Rykkerenter],
    [Rykkertæller],
    [Rykkespærreårsag],
    [Segment],
    [Skæringsdato],
    [Statistiknøgle],
    [Suspenderings-rykkeniv],
    [Udskrevet],
    [Udstedelsesdato],
    [Valuta],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    )
    SELECT
        [Aftale],
    [Aftalekonto_ikke_entydig],
    [Aftalekonto],
    [Bilagsnummer],
    [Dato-ID],
    [Delposition],
    [Firmakode],
    [Forretningspartner],
    [Gentagelsesposition],
    [Identifikation],
    [Kommune_kode],
    [Nettoforfald],
    [Nyt_rykkeniveau],
    [Position],
    [Printdato],
    [Rentebilag],
    [Rykkebeløb],
    [Rykkeniveau],
    [Rykkeniveautype],
    [Rykkeprocedure],
    [Rykker_annulleret],
    [Rykkerenter],
    [Rykkertæller],
    [Rykkespærreårsag],
    [Segment],
    [Skæringsdato],
    [Statistiknøgle],
    [Suspenderings-rykkeniv],
    [Udskrevet],
    [Udstedelsesdato],
    [Valuta],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    FROM [ode].[Rykker_Total_Staging];
    
    GO
    
    
    -- 2. TYPED: Transform and insert into Typed history
    --    Note: Rows with invalid Primary Keys after conversion are skipped here but exist in Backup.
    WITH transformed_data AS (
        SELECT
        LTRIM(RTRIM([Aftale])) AS [Aftale],
    LTRIM(RTRIM([Aftalekonto_ikke_entydig])) AS [Aftalekonto_ikke_entydig],
    LTRIM(RTRIM([Aftalekonto])) AS [Aftalekonto],
    LTRIM(RTRIM([Bilagsnummer])) AS [Bilagsnummer],
    CASE
            WHEN [Dato-ID] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Dato-ID]) = 8 AND [Dato-ID] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Dato-ID], 112)
            WHEN [Dato-ID] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Dato-ID], 104)
            ELSE TRY_CONVERT(DATE, [Dato-ID], 23)
        END AS [Dato-ID],
    TRY_CAST(REPLACE([Delposition], '.', '') AS INT) AS [Delposition],
    LTRIM(RTRIM([Firmakode])) AS [Firmakode],
    LTRIM(RTRIM([Forretningspartner])) AS [Forretningspartner],
    TRY_CAST(REPLACE([Gentagelsesposition], '.', '') AS INT) AS [Gentagelsesposition],
    LTRIM(RTRIM([Identifikation])) AS [Identifikation],
    LTRIM(RTRIM([Kommune_kode])) AS [Kommune_kode],
    CASE
            WHEN [Nettoforfald] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Nettoforfald]) = 8 AND [Nettoforfald] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Nettoforfald], 112)
            WHEN [Nettoforfald] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Nettoforfald], 104)
            ELSE TRY_CONVERT(DATE, [Nettoforfald], 23)
        END AS [Nettoforfald],
    TRY_CAST(REPLACE([Nyt_rykkeniveau], '.', '') AS INT) AS [Nyt_rykkeniveau],
    TRY_CAST(REPLACE([Position], '.', '') AS INT) AS [Position],
    CASE
            WHEN [Printdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Printdato]) = 8 AND [Printdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Printdato], 112)
            WHEN [Printdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Printdato], 104)
            ELSE TRY_CONVERT(DATE, [Printdato], 23)
        END AS [Printdato],
    LTRIM(RTRIM([Rentebilag])) AS [Rentebilag],
    CASE
            WHEN [Rykkebeløb] IS NULL OR [Rykkebeløb] = '' OR [Rykkebeløb] = '0' THEN NULL
            WHEN [Rykkebeløb] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Rykkebeløb], LEN([Rykkebeløb])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Rykkebeløb], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Rykkebeløb],
    CASE
            WHEN [Rykkeniveau] IS NULL OR [Rykkeniveau] = '' OR [Rykkeniveau] = '0' THEN NULL
            WHEN [Rykkeniveau] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Rykkeniveau], LEN([Rykkeniveau])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Rykkeniveau], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Rykkeniveau],
    LTRIM(RTRIM([Rykkeniveautype])) AS [Rykkeniveautype],
    LTRIM(RTRIM([Rykkeprocedure])) AS [Rykkeprocedure],
    LTRIM(RTRIM([Rykker_annulleret])) AS [Rykker_annulleret],
    CASE
            WHEN [Rykkerenter] IS NULL OR [Rykkerenter] = '' OR [Rykkerenter] = '0' THEN NULL
            WHEN [Rykkerenter] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Rykkerenter], LEN([Rykkerenter])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Rykkerenter], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Rykkerenter],
    TRY_CAST(REPLACE([Rykkertæller], '.', '') AS INT) AS [Rykkertæller],
    LTRIM(RTRIM([Rykkespærreårsag])) AS [Rykkespærreårsag],
    LTRIM(RTRIM([Segment])) AS [Segment],
    CASE
            WHEN [Skæringsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Skæringsdato]) = 8 AND [Skæringsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Skæringsdato], 112)
            WHEN [Skæringsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Skæringsdato], 104)
            ELSE TRY_CONVERT(DATE, [Skæringsdato], 23)
        END AS [Skæringsdato],
    LTRIM(RTRIM([Statistiknøgle])) AS [Statistiknøgle],
    LTRIM(RTRIM([Suspenderings-rykkeniv])) AS [Suspenderings-rykkeniv],
    LTRIM(RTRIM([Udskrevet])) AS [Udskrevet],
    CASE
            WHEN [Udstedelsesdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Udstedelsesdato]) = 8 AND [Udstedelsesdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Udstedelsesdato], 112)
            WHEN [Udstedelsesdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Udstedelsesdato], 104)
            ELSE TRY_CONVERT(DATE, [Udstedelsesdato], 23)
        END AS [Udstedelsesdato],
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
        FROM [ode].[Rykker_Total_Staging]
    ),
    valid_data AS (
        SELECT *,
            ROW_NUMBER() OVER (PARTITION BY [Dato-ID], [Identifikation], [Forretningspartner], [Aftalekonto], [Rykkertæller], [Bilagsnummer], [Gentagelsesposition], [Position], [Delposition] ORDER BY (SELECT NULL)) as rn
        FROM transformed_data
        WHERE [Dato-ID] IS NOT NULL AND [Identifikation] IS NOT NULL AND [Forretningspartner] IS NOT NULL AND [Aftalekonto] IS NOT NULL AND [Rykkertæller] IS NOT NULL AND [Bilagsnummer] IS NOT NULL AND [Gentagelsesposition] IS NOT NULL AND [Position] IS NOT NULL AND [Delposition] IS NOT NULL
    )
    INSERT INTO [ode].[Rykker_Total_Typed] (
        [Aftale],
    [Aftalekonto_ikke_entydig],
    [Aftalekonto],
    [Bilagsnummer],
    [Dato-ID],
    [Delposition],
    [Firmakode],
    [Forretningspartner],
    [Gentagelsesposition],
    [Identifikation],
    [Kommune_kode],
    [Nettoforfald],
    [Nyt_rykkeniveau],
    [Position],
    [Printdato],
    [Rentebilag],
    [Rykkebeløb],
    [Rykkeniveau],
    [Rykkeniveautype],
    [Rykkeprocedure],
    [Rykker_annulleret],
    [Rykkerenter],
    [Rykkertæller],
    [Rykkespærreårsag],
    [Segment],
    [Skæringsdato],
    [Statistiknøgle],
    [Suspenderings-rykkeniv],
    [Udskrevet],
    [Udstedelsesdato],
    [Valuta],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    )
    SELECT
        [Aftale],
    [Aftalekonto_ikke_entydig],
    [Aftalekonto],
    [Bilagsnummer],
    [Dato-ID],
    [Delposition],
    [Firmakode],
    [Forretningspartner],
    [Gentagelsesposition],
    [Identifikation],
    [Kommune_kode],
    [Nettoforfald],
    [Nyt_rykkeniveau],
    [Position],
    [Printdato],
    [Rentebilag],
    [Rykkebeløb],
    [Rykkeniveau],
    [Rykkeniveautype],
    [Rykkeprocedure],
    [Rykker_annulleret],
    [Rykkerenter],
    [Rykkertæller],
    [Rykkespærreårsag],
    [Segment],
    [Skæringsdato],
    [Statistiknøgle],
    [Suspenderings-rykkeniv],
    [Udskrevet],
    [Udstedelsesdato],
    [Valuta],
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
        LTRIM(RTRIM([Aftale])) AS [Aftale],
    LTRIM(RTRIM([Aftalekonto_ikke_entydig])) AS [Aftalekonto_ikke_entydig],
    LTRIM(RTRIM([Aftalekonto])) AS [Aftalekonto],
    LTRIM(RTRIM([Bilagsnummer])) AS [Bilagsnummer],
    CASE
            WHEN [Dato-ID] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Dato-ID]) = 8 AND [Dato-ID] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Dato-ID], 112)
            WHEN [Dato-ID] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Dato-ID], 104)
            ELSE TRY_CONVERT(DATE, [Dato-ID], 23)
        END AS [Dato-ID],
    TRY_CAST(REPLACE([Delposition], '.', '') AS INT) AS [Delposition],
    LTRIM(RTRIM([Firmakode])) AS [Firmakode],
    LTRIM(RTRIM([Forretningspartner])) AS [Forretningspartner],
    TRY_CAST(REPLACE([Gentagelsesposition], '.', '') AS INT) AS [Gentagelsesposition],
    LTRIM(RTRIM([Identifikation])) AS [Identifikation],
    LTRIM(RTRIM([Kommune_kode])) AS [Kommune_kode],
    CASE
            WHEN [Nettoforfald] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Nettoforfald]) = 8 AND [Nettoforfald] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Nettoforfald], 112)
            WHEN [Nettoforfald] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Nettoforfald], 104)
            ELSE TRY_CONVERT(DATE, [Nettoforfald], 23)
        END AS [Nettoforfald],
    TRY_CAST(REPLACE([Nyt_rykkeniveau], '.', '') AS INT) AS [Nyt_rykkeniveau],
    TRY_CAST(REPLACE([Position], '.', '') AS INT) AS [Position],
    CASE
            WHEN [Printdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Printdato]) = 8 AND [Printdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Printdato], 112)
            WHEN [Printdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Printdato], 104)
            ELSE TRY_CONVERT(DATE, [Printdato], 23)
        END AS [Printdato],
    LTRIM(RTRIM([Rentebilag])) AS [Rentebilag],
    CASE
            WHEN [Rykkebeløb] IS NULL OR [Rykkebeløb] = '' OR [Rykkebeløb] = '0' THEN NULL
            WHEN [Rykkebeløb] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Rykkebeløb], LEN([Rykkebeløb])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Rykkebeløb], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Rykkebeløb],
    CASE
            WHEN [Rykkeniveau] IS NULL OR [Rykkeniveau] = '' OR [Rykkeniveau] = '0' THEN NULL
            WHEN [Rykkeniveau] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Rykkeniveau], LEN([Rykkeniveau])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Rykkeniveau], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Rykkeniveau],
    LTRIM(RTRIM([Rykkeniveautype])) AS [Rykkeniveautype],
    LTRIM(RTRIM([Rykkeprocedure])) AS [Rykkeprocedure],
    LTRIM(RTRIM([Rykker_annulleret])) AS [Rykker_annulleret],
    CASE
            WHEN [Rykkerenter] IS NULL OR [Rykkerenter] = '' OR [Rykkerenter] = '0' THEN NULL
            WHEN [Rykkerenter] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Rykkerenter], LEN([Rykkerenter])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Rykkerenter], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Rykkerenter],
    TRY_CAST(REPLACE([Rykkertæller], '.', '') AS INT) AS [Rykkertæller],
    LTRIM(RTRIM([Rykkespærreårsag])) AS [Rykkespærreårsag],
    LTRIM(RTRIM([Segment])) AS [Segment],
    CASE
            WHEN [Skæringsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Skæringsdato]) = 8 AND [Skæringsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Skæringsdato], 112)
            WHEN [Skæringsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Skæringsdato], 104)
            ELSE TRY_CONVERT(DATE, [Skæringsdato], 23)
        END AS [Skæringsdato],
    LTRIM(RTRIM([Statistiknøgle])) AS [Statistiknøgle],
    LTRIM(RTRIM([Suspenderings-rykkeniv])) AS [Suspenderings-rykkeniv],
    LTRIM(RTRIM([Udskrevet])) AS [Udskrevet],
    CASE
            WHEN [Udstedelsesdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Udstedelsesdato]) = 8 AND [Udstedelsesdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Udstedelsesdato], 112)
            WHEN [Udstedelsesdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Udstedelsesdato], 104)
            ELSE TRY_CONVERT(DATE, [Udstedelsesdato], 23)
        END AS [Udstedelsesdato],
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
                ROW_NUMBER() OVER (PARTITION BY [Dato-ID], [Identifikation], [Forretningspartner], [Aftalekonto], [Rykkertæller], [Bilagsnummer], [Gentagelsesposition], [Position], [Delposition] ORDER BY (SELECT NULL)) as rn
            FROM [ode].[Rykker_Total_Staging]
        ) t WHERE rn = 1 AND [Dato-ID] IS NOT NULL AND [Identifikation] IS NOT NULL AND [Forretningspartner] IS NOT NULL AND [Aftalekonto] IS NOT NULL AND [Rykkertæller] IS NOT NULL AND [Bilagsnummer] IS NOT NULL AND [Gentagelsesposition] IS NOT NULL AND [Position] IS NOT NULL AND [Delposition] IS NOT NULL
    )
    INSERT INTO [ode].[Rykker] ([Aftale], [Aftalekonto_ikke_entydig], [Aftalekonto], [Bilagsnummer], [Dato-ID], [Delposition], [Firmakode], [Forretningspartner], [Gentagelsesposition], [Identifikation], [Kommune_kode], [Nettoforfald], [Nyt_rykkeniveau], [Position], [Printdato], [Rentebilag], [Rykkebeløb], [Rykkeniveau], [Rykkeniveautype], [Rykkeprocedure], [Rykker_annulleret], [Rykkerenter], [Rykkertæller], [Rykkespærreårsag], [Segment], [Skæringsdato], [Statistiknøgle], [Suspenderings-rykkeniv], [Udskrevet], [Udstedelsesdato], [Valuta], [export_date], [file_origin], [row_number], [etl_version])
    SELECT [Aftale], [Aftalekonto_ikke_entydig], [Aftalekonto], [Bilagsnummer], [Dato-ID], [Delposition], [Firmakode], [Forretningspartner], [Gentagelsesposition], [Identifikation], [Kommune_kode], [Nettoforfald], [Nyt_rykkeniveau], [Position], [Printdato], [Rentebilag], [Rykkebeløb], [Rykkeniveau], [Rykkeniveautype], [Rykkeprocedure], [Rykker_annulleret], [Rykkerenter], [Rykkertæller], [Rykkespærreårsag], [Segment], [Skæringsdato], [Statistiknøgle], [Suspenderings-rykkeniv], [Udskrevet], [Udstedelsesdato], [Valuta], [export_date], [file_origin], [row_number], [etl_version] FROM new_data;
    
    GO

    
    -- D. Validation Metrics
    ------------------------------------------------------------
    SELECT 
        'ROW_COUNTS' as metric,
        (SELECT COUNT(*) FROM [ode].[Rykker_Total_Staging]) as source_rows,
        (SELECT COUNT(*) FROM [ode].[Rykker]) as target_rows;
    
    GO

    -- C. Cleanup (Optional - Staging table usually kept until file move is confirmed)
    DROP TABLE [ode].[Rykker_Total_Staging];
    GO
    