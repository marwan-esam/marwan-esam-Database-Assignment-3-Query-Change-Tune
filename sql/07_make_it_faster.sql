-- 7

CREATE INDEX IX_Users_Email        ON [identity].Users (Email)        INCLUDE (FirstName, LastName);
CREATE INDEX IX_Users_LastName     ON [identity].Users (LastName)     INCLUDE (FirstName, Email);
CREATE INDEX IX_Users_CreatedAtUtc ON [identity].Users (CreatedAtUtc) INCLUDE (Email);
CREATE INDEX IX_Payments_PaidAtUtc ON finance.Payments (PaidAtUtc)    INCLUDE (InvoiceId, Amount);
CREATE INDEX IX_Invoices_Number    ON finance.Invoices (InvoiceNumber);
GO

SET STATISTICS IO, TIME ON;

-- 7.1
-- Slow
SELECT Id, Email
FROM [identity].Users
WHERE YEAR(CreatedAtUtc) = 2026
  AND MONTH(CreatedAtUtc) = 3;

-- Fast
SELECT Id, Email
FROM [identity].Users
WHERE CreatedAtUtc >= '2026-03-01'
  AND CreatedAtUtc <  '2026-04-01';


-- 7.2
-- Slow 
SELECT Id, InvoiceId, Amount
FROM finance.Payments
WHERE DATEDIFF(DAY, PaidAtUtc, SYSUTCDATETIME()) <= 30;

-- Fast 
SELECT Id, InvoiceId, Amount
FROM finance.Payments
WHERE PaidAtUtc >= CAST(DATEADD(DAY, -30, CAST(SYSUTCDATETIME() AS DATE)) AS DATETIME2);


-- 7.3
-- Slow
SELECT Id, FirstName, LastName
FROM [identity].Users
WHERE LEFT(LastName, 3) = N'Abd';

-- Fast 
SELECT Id, FirstName, LastName
FROM [identity].Users
WHERE LastName LIKE N'Abd%';


-- 7.4
-- Slow
SELECT *
FROM operations.AuditLogs
WHERE Id + 1 = 50001;

-- Fast
SELECT *
FROM operations.AuditLogs
WHERE Id = 50000;


-- 7.5
-- Slow
SELECT Id, TotalAmount, PaidAmount
FROM finance.Invoices
WHERE InvoiceNumber = N'LAB-INV-2026-000001';

-- Fast 
SELECT Id, TotalAmount, PaidAmount
FROM finance.Invoices
WHERE InvoiceNumber = 'LAB-INV-2026-000001';


-- 7.6
-- Slow 
DECLARE @Email NVARCHAR(320) = (SELECT TOP (1) Email FROM [identity].Users);
SELECT Id, FirstName, LastName
FROM [identity].Users
WHERE UPPER(Email) = UPPER(@Email);

-- Fast
SELECT Id, FirstName, LastName
FROM [identity].Users
WHERE Email = @Email;


-- 7.7
-- Slow
DECLARE @LastName NVARCHAR(100) = N'Hassan';
SELECT Id, FirstName, Email
FROM [identity].Users
WHERE (@LastName IS NULL OR LastName = @LastName);

-- Fast
SELECT Id, FirstName, Email
FROM [identity].Users
WHERE (@LastName IS NULL OR LastName = @LastName)
OPTION (RECOMPILE);


-- 7.8
-- Slow (wrapping nullable PaidAtUtc in ISNULL() prevents seeking IX_Payments_PaidAtUtc)
SELECT Id, InvoiceId, Amount
FROM finance.Payments
WHERE ISNULL(PaidAtUtc, '1900-01-01') >= '2026-10-01'
  AND ISNULL(PaidAtUtc, '1900-01-01') <  '2026-11-01';

-- Fast (direct half-open range excludes NULLs and uses an Index Seek on IX_Payments_PaidAtUtc)
SELECT Id, InvoiceId, Amount
FROM finance.Payments
WHERE PaidAtUtc >= '2026-10-01'
  AND PaidAtUtc <  '2026-11-01';

SET STATISTICS IO, TIME OFF;
