-- 13
DROP TABLE IF EXISTS dbo.WebsiteCourseCatalog;

CREATE TABLE dbo.WebsiteCourseCatalog
(
    CourseId        INT           NOT NULL CONSTRAINT PK_WebsiteCourseCatalog PRIMARY KEY,
    Code            VARCHAR(30)   NOT NULL,
    Title           NVARCHAR(400) NOT NULL,
    CreditHours     DECIMAL(4,2)  NOT NULL,
    IsVisible       BIT           NOT NULL CONSTRAINT DF_WebsiteCourseCatalog_IsVisible DEFAULT (1),
    LastSyncedAtUtc DATETIME2     NOT NULL CONSTRAINT DF_WebsiteCourseCatalog_LastSyncedAtUtc DEFAULT (SYSUTCDATETIME())
);

-- Run 1
MERGE INTO dbo.WebsiteCourseCatalog AS tgt
USING academic.Courses AS src
    ON tgt.CourseId = src.Id
WHEN NOT MATCHED BY TARGET AND src.IsActive = 1 THEN
    INSERT (CourseId, Code, Title, CreditHours, IsVisible, LastSyncedAtUtc)
    VALUES (src.Id, src.Code, src.Title, src.CreditHours, 1, SYSUTCDATETIME())
WHEN MATCHED AND (
    (src.IsActive = 1 AND (tgt.Code <> src.Code OR tgt.Title <> src.Title OR tgt.CreditHours <> src.CreditHours OR tgt.IsVisible = 0))
    OR (src.IsActive = 0 AND tgt.IsVisible = 1)
) THEN
    UPDATE SET
        tgt.Code            = CASE WHEN src.IsActive = 1 THEN src.Code ELSE tgt.Code END,
        tgt.Title           = CASE WHEN src.IsActive = 1 THEN src.Title ELSE tgt.Title END,
        tgt.CreditHours     = CASE WHEN src.IsActive = 1 THEN src.CreditHours ELSE tgt.CreditHours END,
        tgt.IsVisible       = src.IsActive,
        tgt.LastSyncedAtUtc = SYSUTCDATETIME()
WHEN NOT MATCHED BY SOURCE AND tgt.IsVisible = 1 THEN
    UPDATE SET
        tgt.IsVisible       = 0,
        tgt.LastSyncedAtUtc = SYSUTCDATETIME()
OUTPUT
    $action AS SyncAction,
    COALESCE(INSERTED.CourseId, DELETED.CourseId) AS CourseId,
    DELETED.Title AS OldTitle,
    INSERTED.Title AS NewTitle,
    DELETED.IsVisible AS OldVisible,
    INSERTED.IsVisible AS NewVisible;

UPDATE academic.Courses
SET Title = N'Introduction to Data Analysis (Updated)'
WHERE Code = 'DSAI-101';

UPDATE academic.Courses
SET IsActive = 0
WHERE Id = (
    SELECT TOP (1) Id
    FROM academic.Courses
    WHERE IsActive = 1
      AND Code <> 'DSAI-101'
    ORDER BY Id
);

-- Run 2
MERGE INTO dbo.WebsiteCourseCatalog AS tgt
USING academic.Courses AS src
    ON tgt.CourseId = src.Id
WHEN NOT MATCHED BY TARGET AND src.IsActive = 1 THEN
    INSERT (CourseId, Code, Title, CreditHours, IsVisible, LastSyncedAtUtc)
    VALUES (src.Id, src.Code, src.Title, src.CreditHours, 1, SYSUTCDATETIME())
WHEN MATCHED AND (
    (src.IsActive = 1 AND (tgt.Code <> src.Code OR tgt.Title <> src.Title OR tgt.CreditHours <> src.CreditHours OR tgt.IsVisible = 0))
    OR (src.IsActive = 0 AND tgt.IsVisible = 1)
) THEN
    UPDATE SET
        tgt.Code            = CASE WHEN src.IsActive = 1 THEN src.Code ELSE tgt.Code END,
        tgt.Title           = CASE WHEN src.IsActive = 1 THEN src.Title ELSE tgt.Title END,
        tgt.CreditHours     = CASE WHEN src.IsActive = 1 THEN src.CreditHours ELSE tgt.CreditHours END,
        tgt.IsVisible       = src.IsActive,
        tgt.LastSyncedAtUtc = SYSUTCDATETIME()
WHEN NOT MATCHED BY SOURCE AND tgt.IsVisible = 1 THEN
    UPDATE SET
        tgt.IsVisible       = 0,
        tgt.LastSyncedAtUtc = SYSUTCDATETIME()
OUTPUT
    $action AS SyncAction,
    COALESCE(INSERTED.CourseId, DELETED.CourseId) AS CourseId,
    DELETED.Title AS OldTitle,
    INSERTED.Title AS NewTitle,
    DELETED.IsVisible AS OldVisible,
    INSERTED.IsVisible AS NewVisible;

-- Run 3
MERGE INTO dbo.WebsiteCourseCatalog AS tgt
USING academic.Courses AS src
    ON tgt.CourseId = src.Id
WHEN NOT MATCHED BY TARGET AND src.IsActive = 1 THEN
    INSERT (CourseId, Code, Title, CreditHours, IsVisible, LastSyncedAtUtc)
    VALUES (src.Id, src.Code, src.Title, src.CreditHours, 1, SYSUTCDATETIME())
WHEN MATCHED AND (
    (src.IsActive = 1 AND (tgt.Code <> src.Code OR tgt.Title <> src.Title OR tgt.CreditHours <> src.CreditHours OR tgt.IsVisible = 0))
    OR (src.IsActive = 0 AND tgt.IsVisible = 1)
) THEN
    UPDATE SET
        tgt.Code            = CASE WHEN src.IsActive = 1 THEN src.Code ELSE tgt.Code END,
        tgt.Title           = CASE WHEN src.IsActive = 1 THEN src.Title ELSE tgt.Title END,
        tgt.CreditHours     = CASE WHEN src.IsActive = 1 THEN src.CreditHours ELSE tgt.CreditHours END,
        tgt.IsVisible       = src.IsActive,
        tgt.LastSyncedAtUtc = SYSUTCDATETIME()
WHEN NOT MATCHED BY SOURCE AND tgt.IsVisible = 1 THEN
    UPDATE SET
        tgt.IsVisible       = 0,
        tgt.LastSyncedAtUtc = SYSUTCDATETIME()
OUTPUT
    $action AS SyncAction,
    COALESCE(INSERTED.CourseId, DELETED.CourseId) AS CourseId,
    DELETED.Title AS OldTitle,
    INSERTED.Title AS NewTitle,
    DELETED.IsVisible AS OldVisible,
    INSERTED.IsVisible AS NewVisible;
