CREATE TABLE [ode].[Data_Ingest_Log] (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    TableName NVARCHAR(100),
    FileName NVARCHAR(255),
    IngestDate DATETIME DEFAULT GETDATE(),
    SourceRowCount INT,
    LoadedRowCount INT,
    DroppedColumns NVARCHAR(MAX), -- Gemmer en liste af ignorerede kolonner
    Status NVARCHAR(50),
    ErrorMessage NVARCHAR(MAX)
);