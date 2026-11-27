-- 8
DROP TABLE IF EXISTS dbo.SpillDemo;
GO

CREATE TABLE dbo.SpillDemo
(
    Id       INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_SpillDemo PRIMARY KEY,
    Category NVARCHAR(50)      NOT NULL,
    SortKey  INT               NOT NULL,
    Payload  CHAR(80)          NOT NULL
);
GO

INSERT INTO dbo.SpillDemo (Category, SortKey, Payload)
SELECT TOP (1000)
    CONCAT(N'Category_', Id % 50),
    CASE WHEN Id = (SELECT MIN(Id) FROM operations.AuditLogs) THEN 1 ELSE 0 END,
    REPLICATE('X', 80)
FROM operations.AuditLogs;

CREATE STATISTICS ST_SpillDemo_SortKey ON dbo.SpillDemo (SortKey) WITH FULLSCAN, NORECOMPUTE;
UPDATE STATISTICS dbo.SpillDemo WITH FULLSCAN, NORECOMPUTE;
GO

INSERT INTO dbo.SpillDemo (Category, SortKey, Payload)
SELECT TOP (80000)
    CONCAT(N'Category_', Id % 50),
    1,
    CONCAT(REPLICATE('A', 72), RIGHT(CONCAT('00000000', Id), 8))
FROM operations.AuditLogs;
GO

-- Before fix
SET STATISTICS IO, TIME ON;

SELECT Id, Category, Payload
FROM dbo.SpillDemo
WHERE SortKey = 1
ORDER BY Payload DESC, Id DESC
OPTION (MAXDOP 1);

SET STATISTICS IO, TIME OFF;
GO

-- Fix
UPDATE STATISTICS dbo.SpillDemo WITH FULLSCAN;
GO

-- After fix
SET STATISTICS IO, TIME ON;

SELECT Id, Category, Payload
FROM dbo.SpillDemo
WHERE SortKey = 1
ORDER BY Payload DESC, Id DESC
OPTION (MAXDOP 1, RECOMPILE);

SET STATISTICS IO, TIME OFF;
