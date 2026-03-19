
    -- ============================================================
    -- Pipeline Script for BO-aftale-haendelse (Total)
    -- Source:  BO-aftale-haendelse_Total_Staging
    -- Targets: BO-aftale-haendelse_Total_Backup, BO-aftale-haendelse_Total_Typed, BO-aftale-haendelse
    -- Generated automatically
    -- ============================================================

    USE [BackDataLake-Test];
    GO

    -- A. Ensure Target Tables Exist
    ------------------------------------------------------------
    
    IF OBJECT_ID('[ode].[BO-aftale-haendelse_Total_Backup]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[BO-aftale-haendelse_Total_Backup] (
        [Klient] NVARCHAR(MAX) NULL,
    [Aftalenummer] NVARCHAR(MAX) NULL,
    [Bobehandling] NVARCHAR(MAX) NULL,
    [Ekstern_reference_nøgle] NVARCHAR(MAX) NULL,
    [Udtrækstype] NVARCHAR(MAX) NULL,
    [Korrespondanceart] NVARCHAR(MAX) NULL,
    [Printdato] NVARCHAR(MAX) NULL,
    [Afskrevet] NVARCHAR(MAX) NULL,
    [Afskrivnings_dato] NVARCHAR(MAX) NULL,
    [Betalingsdato] NVARCHAR(MAX) NULL,
    [Valuta] NVARCHAR(MAX) NULL,
    [Kommune_kode] NVARCHAR(MAX) NULL,
    [Beløb] NVARCHAR(MAX) NULL,
    [Indbetalt_af_bobestyrer] NVARCHAR(MAX) NULL,
    [export_date] NVARCHAR(MAX) NULL,
    [file_origin] NVARCHAR(MAX) NULL,
    [row_number] NVARCHAR(MAX) NULL,
    [etl_version] NVARCHAR(MAX) NULL
        );
    END
    
    
    IF OBJECT_ID('[ode].[BO-aftale-haendelse_Total_Typed]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[BO-aftale-haendelse_Total_Typed] (
        [Klient] NVARCHAR(255) NULL,
    [Aftalenummer] NVARCHAR(255) NULL,
    [Bobehandling] NVARCHAR(255) NULL,
    [Ekstern_reference_nøgle] NVARCHAR(255) NULL,
    [Udtrækstype] NVARCHAR(255) NULL,
    [Korrespondanceart] NVARCHAR(255) NULL,
    [Printdato] DATE NULL,
    [Afskrevet] DECIMAL(15,2) NULL,
    [Afskrivnings_dato] DATE NULL,
    [Betalingsdato] DATE NULL,
    [Valuta] NVARCHAR(255) NULL,
    [Kommune_kode] NVARCHAR(255) NULL,
    [Beløb] DECIMAL(15,2) NULL,
    [Indbetalt_af_bobestyrer] NVARCHAR(255) NULL,
    [export_date] DATE NULL,
    [file_origin] NVARCHAR(255) NULL,
    [row_number] INT NULL,
    [etl_version] NVARCHAR(50) NULL
        );
    END
    
    
    IF OBJECT_ID('[ode].[BO-aftale-haendelse]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[BO-aftale-haendelse] (
        [Klient] NVARCHAR(255) NULL,
    [Aftalenummer] NVARCHAR(255) NULL,
    [Bobehandling] NVARCHAR(255) NULL,
    [Ekstern_reference_nøgle] NVARCHAR(255) NOT NULL,
    [Udtrækstype] NVARCHAR(255) NULL,
    [Korrespondanceart] NVARCHAR(255) NULL,
    [Printdato] DATE NULL,
    [Afskrevet] DECIMAL(15,2) NULL,
    [Afskrivnings_dato] DATE NULL,
    [Betalingsdato] DATE NULL,
    [Valuta] NVARCHAR(255) NULL,
    [Kommune_kode] NVARCHAR(255) NULL,
    [Beløb] DECIMAL(15,2) NULL,
    [Indbetalt_af_bobestyrer] NVARCHAR(255) NULL,
    [export_date] DATE NULL,
    [file_origin] NVARCHAR(255) NULL,
    [row_number] INT NULL,
    [etl_version] NVARCHAR(50) NULL,
    CONSTRAINT [PK_BO-aftale-haendelse] PRIMARY KEY CLUSTERED ([Ekstern_reference_nøgle])
        );
    END
    
    GO

    -- B. Execute Pipeline Steps
    ------------------------------------------------------------
    
    
    -- 1. BACKUP: Copy raw data from Staging to Backup
    INSERT INTO [ode].[BO-aftale-haendelse_Total_Backup] (
        [Klient],
    [Aftalenummer],
    [Bobehandling],
    [Ekstern_reference_nøgle],
    [Udtrækstype],
    [Korrespondanceart],
    [Printdato],
    [Afskrevet],
    [Afskrivnings_dato],
    [Betalingsdato],
    [Valuta],
    [Kommune_kode],
    [Beløb],
    [Indbetalt_af_bobestyrer],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    )
    SELECT
        [Klient],
    [Aftalenummer],
    [Bobehandling],
    [Ekstern_reference_nøgle],
    [Udtrækstype],
    [Korrespondanceart],
    [Printdato],
    [Afskrevet],
    [Afskrivnings_dato],
    [Betalingsdato],
    [Valuta],
    [Kommune_kode],
    [Beløb],
    [Indbetalt_af_bobestyrer],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    FROM [ode].[BO-aftale-haendelse_Total_Staging];
    
    GO
    
    
    -- 2. TYPED: Transform and insert into Typed history
    --    Note: Rows with invalid Primary Keys after conversion are skipped here but exist in Backup.
    WITH transformed_data AS (
        SELECT
        LTRIM(RTRIM([Klient])) AS [Klient],
    LTRIM(RTRIM([Aftalenummer])) AS [Aftalenummer],
    LTRIM(RTRIM([Bobehandling])) AS [Bobehandling],
    LTRIM(RTRIM([Ekstern_reference_nøgle])) AS [Ekstern_reference_nøgle],
    LTRIM(RTRIM([Udtrækstype])) AS [Udtrækstype],
    LTRIM(RTRIM([Korrespondanceart])) AS [Korrespondanceart],
    CASE
            WHEN [Printdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Printdato]) = 8 AND [Printdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Printdato], 112)
            WHEN [Printdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Printdato], 104)
            ELSE TRY_CONVERT(DATE, [Printdato], 23)
        END AS [Printdato],
    CASE
            WHEN [Afskrevet] IS NULL OR [Afskrevet] = '' OR [Afskrevet] = '0' THEN NULL
            WHEN [Afskrevet] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Afskrevet], LEN([Afskrevet])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Afskrevet], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Afskrevet],
    CASE
            WHEN [Afskrivnings_dato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Afskrivnings_dato]) = 8 AND [Afskrivnings_dato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Afskrivnings_dato], 112)
            WHEN [Afskrivnings_dato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Afskrivnings_dato], 104)
            ELSE TRY_CONVERT(DATE, [Afskrivnings_dato], 23)
        END AS [Afskrivnings_dato],
    CASE
            WHEN [Betalingsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Betalingsdato]) = 8 AND [Betalingsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Betalingsdato], 112)
            WHEN [Betalingsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Betalingsdato], 104)
            ELSE TRY_CONVERT(DATE, [Betalingsdato], 23)
        END AS [Betalingsdato],
    LTRIM(RTRIM([Valuta])) AS [Valuta],
    LTRIM(RTRIM([Kommune_kode])) AS [Kommune_kode],
    CASE
            WHEN [Beløb] IS NULL OR [Beløb] = '' OR [Beløb] = '0' THEN NULL
            WHEN [Beløb] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Beløb], LEN([Beløb])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Beløb], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Beløb],
    LTRIM(RTRIM([Indbetalt_af_bobestyrer])) AS [Indbetalt_af_bobestyrer],
    CASE
            WHEN [export_date] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([export_date]) = 8 AND [export_date] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [export_date], 112)
            WHEN [export_date] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [export_date], 104)
            ELSE TRY_CONVERT(DATE, [export_date], 23)
        END AS [export_date],
    LTRIM(RTRIM([file_origin])) AS [file_origin],
    TRY_CAST(REPLACE([row_number], '.', '') AS INT) AS [row_number],
    LTRIM(RTRIM([etl_version])) AS [etl_version]
        FROM [ode].[BO-aftale-haendelse_Total_Staging]
    ),
    valid_data AS (
        SELECT *,
            ROW_NUMBER() OVER (PARTITION BY [Ekstern_reference_nøgle] ORDER BY (SELECT NULL)) as rn
        FROM transformed_data
        WHERE [Ekstern_reference_nøgle] IS NOT NULL
    )
    INSERT INTO [ode].[BO-aftale-haendelse_Total_Typed] (
        [Klient],
    [Aftalenummer],
    [Bobehandling],
    [Ekstern_reference_nøgle],
    [Udtrækstype],
    [Korrespondanceart],
    [Printdato],
    [Afskrevet],
    [Afskrivnings_dato],
    [Betalingsdato],
    [Valuta],
    [Kommune_kode],
    [Beløb],
    [Indbetalt_af_bobestyrer],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    )
    SELECT
        [Klient],
    [Aftalenummer],
    [Bobehandling],
    [Ekstern_reference_nøgle],
    [Udtrækstype],
    [Korrespondanceart],
    [Printdato],
    [Afskrevet],
    [Afskrivnings_dato],
    [Betalingsdato],
    [Valuta],
    [Kommune_kode],
    [Beløb],
    [Indbetalt_af_bobestyrer],
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
        LTRIM(RTRIM([Klient])) AS [Klient],
    LTRIM(RTRIM([Aftalenummer])) AS [Aftalenummer],
    LTRIM(RTRIM([Bobehandling])) AS [Bobehandling],
    LTRIM(RTRIM([Ekstern_reference_nøgle])) AS [Ekstern_reference_nøgle],
    LTRIM(RTRIM([Udtrækstype])) AS [Udtrækstype],
    LTRIM(RTRIM([Korrespondanceart])) AS [Korrespondanceart],
    CASE
            WHEN [Printdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Printdato]) = 8 AND [Printdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Printdato], 112)
            WHEN [Printdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Printdato], 104)
            ELSE TRY_CONVERT(DATE, [Printdato], 23)
        END AS [Printdato],
    CASE
            WHEN [Afskrevet] IS NULL OR [Afskrevet] = '' OR [Afskrevet] = '0' THEN NULL
            WHEN [Afskrevet] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Afskrevet], LEN([Afskrevet])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Afskrevet], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Afskrevet],
    CASE
            WHEN [Afskrivnings_dato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Afskrivnings_dato]) = 8 AND [Afskrivnings_dato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Afskrivnings_dato], 112)
            WHEN [Afskrivnings_dato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Afskrivnings_dato], 104)
            ELSE TRY_CONVERT(DATE, [Afskrivnings_dato], 23)
        END AS [Afskrivnings_dato],
    CASE
            WHEN [Betalingsdato] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Betalingsdato]) = 8 AND [Betalingsdato] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Betalingsdato], 112)
            WHEN [Betalingsdato] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Betalingsdato], 104)
            ELSE TRY_CONVERT(DATE, [Betalingsdato], 23)
        END AS [Betalingsdato],
    LTRIM(RTRIM([Valuta])) AS [Valuta],
    LTRIM(RTRIM([Kommune_kode])) AS [Kommune_kode],
    CASE
            WHEN [Beløb] IS NULL OR [Beløb] = '' OR [Beløb] = '0' THEN NULL
            WHEN [Beløb] LIKE '%-' THEN
                TRY_CAST(REPLACE(REPLACE(LEFT([Beløb], LEN([Beløb])-1), '.', ''), ',', '.') AS DECIMAL(18,2)) * -1
            ELSE
                TRY_CAST(REPLACE(REPLACE([Beløb], '.', ''), ',', '.') AS DECIMAL(18,2))
        END AS [Beløb],
    LTRIM(RTRIM([Indbetalt_af_bobestyrer])) AS [Indbetalt_af_bobestyrer],
    CASE
            WHEN [export_date] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([export_date]) = 8 AND [export_date] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [export_date], 112)
            WHEN [export_date] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [export_date], 104)
            ELSE TRY_CONVERT(DATE, [export_date], 23)
        END AS [export_date],
    LTRIM(RTRIM([file_origin])) AS [file_origin],
    TRY_CAST(REPLACE([row_number], '.', '') AS INT) AS [row_number],
    LTRIM(RTRIM([etl_version])) AS [etl_version],
                ROW_NUMBER() OVER (PARTITION BY [Ekstern_reference_nøgle] ORDER BY (SELECT NULL)) as rn
            FROM [ode].[BO-aftale-haendelse_Total_Staging]
        ) t WHERE rn = 1 AND [Ekstern_reference_nøgle] IS NOT NULL
    )
    INSERT INTO [ode].[BO-aftale-haendelse] ([Klient], [Aftalenummer], [Bobehandling], [Ekstern_reference_nøgle], [Udtrækstype], [Korrespondanceart], [Printdato], [Afskrevet], [Afskrivnings_dato], [Betalingsdato], [Valuta], [Kommune_kode], [Beløb], [Indbetalt_af_bobestyrer], [export_date], [file_origin], [row_number], [etl_version])
    SELECT [Klient], [Aftalenummer], [Bobehandling], [Ekstern_reference_nøgle], [Udtrækstype], [Korrespondanceart], [Printdato], [Afskrevet], [Afskrivnings_dato], [Betalingsdato], [Valuta], [Kommune_kode], [Beløb], [Indbetalt_af_bobestyrer], [export_date], [file_origin], [row_number], [etl_version] FROM new_data;
    
    GO

    
    -- D. Validation Metrics
    ------------------------------------------------------------
    SELECT 
        'ROW_COUNTS' as metric,
        (SELECT COUNT(*) FROM [ode].[BO-aftale-haendelse_Total_Staging]) as source_rows,
        (SELECT COUNT(*) FROM [ode].[BO-aftale-haendelse]) as target_rows;
    
    GO

    -- C. Cleanup (Optional - Staging table usually kept until file move is confirmed)
    DROP TABLE [ode].[BO-aftale-haendelse_Total_Staging];
    GO
    