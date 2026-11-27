-- 12.1
DROP TABLE IF EXISTS academic.CoursePassMarkHistory;

CREATE TABLE academic.CoursePassMarkHistory
(
    Id              INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_CoursePassMarkHistory PRIMARY KEY,
    CourseId        INT               NOT NULL,
    CourseCode      VARCHAR(30)       NOT NULL,
    OldPassingScore DECIMAL(5,2)      NOT NULL,
    NewPassingScore DECIMAL(5,2)      NOT NULL,
    ChangedAtUtc    DATETIME2         NOT NULL,
    ChangedBy       NVARCHAR(128)     NOT NULL
);

UPDATE academic.Courses
SET PassingScore = 65.00
OUTPUT
    INSERTED.Id,
    INSERTED.Code,
    DELETED.PassingScore,
    INSERTED.PassingScore,
    SYSUTCDATETIME(),
    SUSER_SNAME()
INTO academic.CoursePassMarkHistory
    (CourseId, CourseCode, OldPassingScore, NewPassingScore, ChangedAtUtc, ChangedBy)
WHERE DepartmentId = (
    SELECT TOP (1) Id
    FROM academic.Departments
    ORDER BY Id
);

SELECT * FROM academic.CoursePassMarkHistory;

-- 12.2
DROP TABLE IF EXISTS communication.AnnouncementsArchive;

CREATE TABLE communication.AnnouncementsArchive
(
    Id              BIGINT        NOT NULL CONSTRAINT PK_AnnouncementsArchive PRIMARY KEY,
    SectionId       BIGINT        NULL,
    Title           NVARCHAR(400) NOT NULL,
    Body            NVARCHAR(MAX) NOT NULL,
    PublishedAtUtc  DATETIME2     NULL,
    ExpiresAtUtc    DATETIME2     NULL,
    CreatedByUserId BIGINT        NOT NULL,
    CreatedAtUtc    DATETIME2     NOT NULL,
    UpdatedAtUtc    DATETIME2     NOT NULL,
    [Status]        TINYINT       NOT NULL,
    ArchivedAtUtc   DATETIME2     NOT NULL CONSTRAINT DF_AnnouncementsArchive_ArchivedAtUtc DEFAULT (SYSUTCDATETIME())
);

DELETE FROM communication.Announcements
OUTPUT
    DELETED.Id,
    DELETED.SectionId,
    DELETED.Title,
    DELETED.Body,
    DELETED.PublishedAtUtc,
    DELETED.ExpiresAtUtc,
    DELETED.CreatedByUserId,
    DELETED.CreatedAtUtc,
    DELETED.UpdatedAtUtc,
    DELETED.[Status],
    SYSUTCDATETIME()
INTO communication.AnnouncementsArchive
    (Id, SectionId, Title, Body, PublishedAtUtc, ExpiresAtUtc, CreatedByUserId, CreatedAtUtc, UpdatedAtUtc, [Status], ArchivedAtUtc)
WHERE ExpiresAtUtc < DATEADD(MONTH, -6, SYSUTCDATETIME());

SELECT TOP (10) * FROM communication.AnnouncementsArchive ORDER BY ArchivedAtUtc DESC;
