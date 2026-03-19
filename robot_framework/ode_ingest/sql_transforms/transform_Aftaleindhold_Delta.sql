
    -- ============================================================
    -- Pipeline Script for Aftaleindhold (Delta)
    -- Source:  Aftaleindhold_Delta_Staging
    -- Targets: Aftaleindhold_Delta_Backup, Aftaleindhold_Delta_Typed, Aftaleindhold
    -- Generated automatically
    -- ============================================================

    USE [BackDataLake-Test];
    GO

    -- A. Ensure Target Tables Exist
    ------------------------------------------------------------
    
    IF OBJECT_ID('[ode].[Aftaleindhold_Delta_Backup]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[Aftaleindhold_Delta_Backup] (
        [Aftaleindhold] NVARCHAR(MAX) NULL,
    [Oprettet_af] NVARCHAR(MAX) NULL,
    [Oprettet_den] NVARCHAR(MAX) NULL,
    [Ændret_af] NVARCHAR(MAX) NULL,
    [Ændret_den] NVARCHAR(MAX) NULL,
    [Indholdsart] NVARCHAR(MAX) NULL,
    [Bet_aftaleindhold] NVARCHAR(MAX) NULL,
    [Nummer_i_basissystem] NVARCHAR(MAX) NULL,
    [Kommune_kode] NVARCHAR(MAX) NULL,
    [export_date] NVARCHAR(MAX) NULL,
    [file_origin] NVARCHAR(MAX) NULL,
    [row_number] NVARCHAR(MAX) NULL,
    [etl_version] NVARCHAR(MAX) NULL
        );
    END
    
    
    IF OBJECT_ID('[ode].[Aftaleindhold_Delta_Typed]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[Aftaleindhold_Delta_Typed] (
        [Aftaleindhold] NVARCHAR(255) NULL,
    [Oprettet_af] NVARCHAR(255) NULL,
    [Oprettet_den] DATE NULL,
    [Ændret_af] NVARCHAR(255) NULL,
    [Ændret_den] DATE NULL,
    [Indholdsart] NVARCHAR(255) NULL,
    [Bet_aftaleindhold] NVARCHAR(255) NULL,
    [Nummer_i_basissystem] NVARCHAR(255) NULL,
    [Kommune_kode] NVARCHAR(255) NULL,
    [export_date] DATE NULL,
    [file_origin] NVARCHAR(255) NULL,
    [row_number] INT NULL,
    [etl_version] NVARCHAR(50) NULL
        );
    END
    
    
    IF OBJECT_ID('[ode].[Aftaleindhold]', 'U') IS NULL
    BEGIN
        CREATE TABLE [ode].[Aftaleindhold] (
        [Aftaleindhold] NVARCHAR(255) NOT NULL,
    [Oprettet_af] NVARCHAR(255) NULL,
    [Oprettet_den] DATE NULL,
    [Ændret_af] NVARCHAR(255) NULL,
    [Ændret_den] DATE NULL,
    [Indholdsart] NVARCHAR(255) NULL,
    [Bet_aftaleindhold] NVARCHAR(255) NULL,
    [Nummer_i_basissystem] NVARCHAR(255) NULL,
    [Kommune_kode] NVARCHAR(255) NULL,
    [export_date] DATE NULL,
    [file_origin] NVARCHAR(255) NULL,
    [row_number] INT NULL,
    [etl_version] NVARCHAR(50) NULL,
    CONSTRAINT [PK_Aftaleindhold] PRIMARY KEY CLUSTERED ([Aftaleindhold])
        );
    END
    
    GO

    -- B. Execute Pipeline Steps
    ------------------------------------------------------------
    
    
    -- 1. BACKUP: Copy raw data from Staging to Backup
    INSERT INTO [ode].[Aftaleindhold_Delta_Backup] (
        [Aftaleindhold],
    [Oprettet_af],
    [Oprettet_den],
    [Ændret_af],
    [Ændret_den],
    [Indholdsart],
    [Bet_aftaleindhold],
    [Nummer_i_basissystem],
    [Kommune_kode],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    )
    SELECT
        [Aftaleindhold],
    [Oprettet_af],
    [Oprettet_den],
    [Ændret_af],
    [Ændret_den],
    [Indholdsart],
    [Bet_aftaleindhold],
    [Nummer_i_basissystem],
    [Kommune_kode],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    FROM [ode].[Aftaleindhold_Delta_Staging];
    
    GO
    
    
    -- 2. TYPED: Transform and insert into Typed history
    --    Note: Rows with invalid Primary Keys after conversion are skipped here but exist in Backup.
    WITH transformed_data AS (
        SELECT
        LTRIM(RTRIM([Aftaleindhold])) AS [Aftaleindhold],
    LTRIM(RTRIM([Oprettet_af])) AS [Oprettet_af],
    CASE
            WHEN [Oprettet_den] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Oprettet_den]) = 8 AND [Oprettet_den] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Oprettet_den], 112)
            WHEN [Oprettet_den] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Oprettet_den], 104)
            ELSE TRY_CONVERT(DATE, [Oprettet_den], 23)
        END AS [Oprettet_den],
    LTRIM(RTRIM([Ændret_af])) AS [Ændret_af],
    CASE
            WHEN [Ændret_den] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Ændret_den]) = 8 AND [Ændret_den] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Ændret_den], 112)
            WHEN [Ændret_den] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Ændret_den], 104)
            ELSE TRY_CONVERT(DATE, [Ændret_den], 23)
        END AS [Ændret_den],
    LTRIM(RTRIM([Indholdsart])) AS [Indholdsart],
    LTRIM(RTRIM([Bet_aftaleindhold])) AS [Bet_aftaleindhold],
    LTRIM(RTRIM([Nummer_i_basissystem])) AS [Nummer_i_basissystem],
    LTRIM(RTRIM([Kommune_kode])) AS [Kommune_kode],
    CASE
            WHEN [export_date] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([export_date]) = 8 AND [export_date] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [export_date], 112)
            WHEN [export_date] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [export_date], 104)
            ELSE TRY_CONVERT(DATE, [export_date], 23)
        END AS [export_date],
    LTRIM(RTRIM([file_origin])) AS [file_origin],
    TRY_CAST(REPLACE([row_number], '.', '') AS INT) AS [row_number],
    LTRIM(RTRIM([etl_version])) AS [etl_version]
        FROM [ode].[Aftaleindhold_Delta_Staging]
    ),
    valid_data AS (
        SELECT *,
            ROW_NUMBER() OVER (PARTITION BY [Aftaleindhold] ORDER BY (SELECT NULL)) as rn
        FROM transformed_data
        WHERE [Aftaleindhold] IS NOT NULL
    )
    INSERT INTO [ode].[Aftaleindhold_Delta_Typed] (
        [Aftaleindhold],
    [Oprettet_af],
    [Oprettet_den],
    [Ændret_af],
    [Ændret_den],
    [Indholdsart],
    [Bet_aftaleindhold],
    [Nummer_i_basissystem],
    [Kommune_kode],
    [export_date],
    [file_origin],
    [row_number],
    [etl_version]
    )
    SELECT
        [Aftaleindhold],
    [Oprettet_af],
    [Oprettet_den],
    [Ændret_af],
    [Ændret_den],
    [Indholdsart],
    [Bet_aftaleindhold],
    [Nummer_i_basissystem],
    [Kommune_kode],
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
        LTRIM(RTRIM([Aftaleindhold])) AS [Aftaleindhold],
    LTRIM(RTRIM([Oprettet_af])) AS [Oprettet_af],
    CASE
            WHEN [Oprettet_den] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Oprettet_den]) = 8 AND [Oprettet_den] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Oprettet_den], 112)
            WHEN [Oprettet_den] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Oprettet_den], 104)
            ELSE TRY_CONVERT(DATE, [Oprettet_den], 23)
        END AS [Oprettet_den],
    LTRIM(RTRIM([Ændret_af])) AS [Ændret_af],
    CASE
            WHEN [Ændret_den] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([Ændret_den]) = 8 AND [Ændret_den] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [Ændret_den], 112)
            WHEN [Ændret_den] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [Ændret_den], 104)
            ELSE TRY_CONVERT(DATE, [Ændret_den], 23)
        END AS [Ændret_den],
    LTRIM(RTRIM([Indholdsart])) AS [Indholdsart],
    LTRIM(RTRIM([Bet_aftaleindhold])) AS [Bet_aftaleindhold],
    LTRIM(RTRIM([Nummer_i_basissystem])) AS [Nummer_i_basissystem],
    LTRIM(RTRIM([Kommune_kode])) AS [Kommune_kode],
    CASE
            WHEN [export_date] IN ('00000000', '00.00.0000', '', '0', '0000-00-00') THEN NULL
            WHEN LEN([export_date]) = 8 AND [export_date] NOT LIKE '%[^0-9]%' THEN TRY_CONVERT(DATE, [export_date], 112)
            WHEN [export_date] LIKE '__[./]__[./]____' THEN TRY_CONVERT(DATE, [export_date], 104)
            ELSE TRY_CONVERT(DATE, [export_date], 23)
        END AS [export_date],
    LTRIM(RTRIM([file_origin])) AS [file_origin],
    TRY_CAST(REPLACE([row_number], '.', '') AS INT) AS [row_number],
    LTRIM(RTRIM([etl_version])) AS [etl_version],
                ROW_NUMBER() OVER (PARTITION BY [Aftaleindhold] ORDER BY (SELECT NULL)) as rn
            FROM [ode].[Aftaleindhold_Delta_Staging]
        ) t WHERE rn = 1 AND [Aftaleindhold] IS NOT NULL
    )
    MERGE INTO [ode].[Aftaleindhold] AS target
    USING new_data AS source
    ON target.[Aftaleindhold] = source.[Aftaleindhold]
    WHEN MATCHED THEN
        UPDATE SET target.[Oprettet_af] = source.[Oprettet_af], target.[Oprettet_den] = source.[Oprettet_den], target.[Ændret_af] = source.[Ændret_af], target.[Ændret_den] = source.[Ændret_den], target.[Indholdsart] = source.[Indholdsart], target.[Bet_aftaleindhold] = source.[Bet_aftaleindhold], target.[Nummer_i_basissystem] = source.[Nummer_i_basissystem], target.[Kommune_kode] = source.[Kommune_kode], target.[export_date] = source.[export_date], target.[file_origin] = source.[file_origin], target.[row_number] = source.[row_number], target.[etl_version] = source.[etl_version]
    WHEN NOT MATCHED THEN
        INSERT ([Aftaleindhold], [Oprettet_af], [Oprettet_den], [Ændret_af], [Ændret_den], [Indholdsart], [Bet_aftaleindhold], [Nummer_i_basissystem], [Kommune_kode], [export_date], [file_origin], [row_number], [etl_version])
        VALUES (source.[Aftaleindhold], source.[Oprettet_af], source.[Oprettet_den], source.[Ændret_af], source.[Ændret_den], source.[Indholdsart], source.[Bet_aftaleindhold], source.[Nummer_i_basissystem], source.[Kommune_kode], source.[export_date], source.[file_origin], source.[row_number], source.[etl_version]);
    
    GO

    
    -- D. Validation Metrics
    ------------------------------------------------------------
    SELECT 
        'ROW_COUNTS' as metric,
        (SELECT COUNT(*) FROM [ode].[Aftaleindhold_Delta_Staging]) as source_rows,
        (SELECT COUNT(*) FROM [ode].[Aftaleindhold]) as target_rows;
    
    GO

    -- C. Cleanup (Optional - Staging table usually kept until file move is confirmed)
    DROP TABLE [ode].[Aftaleindhold_Delta_Staging];
    GO
    