-- 5.1
SELECT 
  Code AS [Course Code],
  Title AS [Course Title],
  CreditHours AS [Credit Hours]
FROM academic.Courses
ORDER BY CreditHours DESC, Title ASC;

-- 5.2
SELECT TOP(5) *
FROM [identity].StudentProfiles
ORDER BY NEWID();

-- 5.3
SELECT *
FROM [identity].Users
WHERE DATALENGTH(Email) <> DATALENGTH(TRIM(Email));
-- WHERE Email LIKE '% ' OR Email LIKE ' %'

-- 5.4
SELECT *
FROM [identity].Users
WHERE Email COLLATE Latin1_General_CS_AS <> LOWER(Email);

-- 5.5
SELECT *
FROM [identity].Users
WHERE Email NOT LIKE '_%@_%._%'
 OR Email LIKE '% %' 
 OR Email LIKE '%@%@%';

-- 5.6
SELECT DISTINCT 
  LOWER(
    TRIM(
      SUBSTRING(
        Email,
        (CHARINDEX('@', Email) + 1),
        (LEN(Email))
  ))) AS Provider
FROM [identity].Users
WHERE Email LIKE '_%@_%._%'
ORDER BY Provider;

-- 5.7
SELECT *
FROM [identity].Users
ORDER BY LastLoginAtUtc DESC;

-- 5.8
SELECT *
FROM finance.Payments
WHERE PaidAtUtc >= '2026-10-01' AND PaidAtUtc < '2026-11-01';

-- 5.9
SELECT
  Id,
  PaidAtUtc AT TIME ZONE 'UTC' AT TIME ZONE 'Egypt Standard Time' AS PaidAtCairo
FROM finance.Payments
WHERE DATEPART(HOUR, PaidAtUtc AT TIME ZONE 'UTC' AT TIME ZONE 'Egypt Standard Time') < 5;

-- 5.10
SET DATEFIRST 1; -- should set monday as day 1
SELECT *
FROM attendance.AttendanceSessions
WHERE DATEPART(WEEKDAY, SessionDate) = 5; -- friday is always 5

-- 5.11
SELECT *
FROM [identity].Users
WHERE PhoneNumber LIKE '+201[0125][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]';

-- 5.12
SELECT 
  FirstName + ' ' + LastName AS Name,
  LEFT(PhoneNumber, 3) + REPLICATE('*', LEN(PhoneNumber) - 5) + RIGHT(PhoneNumber, 2) AS [Phone Number]
FROM [identity].Users
WHERE LEN(PhoneNumber) > 5;

-- 5.13
SELECT 
  InvoiceNumber,
  TRY_CAST(RIGHT(InvoiceNumber, CHARINDEX('-', REVERSE(InvoiceNumber)) - 1) AS BIGINT) AS RunningNumber
FROM finance.Invoices
WHERE InvoiceNumber LIKE '%-%'
ORDER BY 
  CASE WHEN TRY_CAST(RIGHT(InvoiceNumber, CHARINDEX('-', REVERSE(InvoiceNumber)) - 1) AS BIGINT) IS NULL THEN 1 ELSE 0 END ASC,
  RunningNumber ASC;

-- 5.14
SELECT 
  Id,
  Title,
ISNULL(
  CAST(EstimatedMinutes / 60 AS VARCHAR(10)) + ' h ' + 
  CAST(EstimatedMinutes % 60 AS VARCHAR(10)) + ' min'
  ,'Not set') AS [Estimated Minutes]
FROM content.Lessons;

-- 5.15
SELECT *
FROM communication.Announcements
WHERE Title LIKE '%[%]%' OR Body LIKE '%[%]%';

-- 5.16
SELECT TOP(5) WITH TIES *
FROM finance.Invoices
ORDER BY TotalAmount DESC;

-- 5.17
SELECT TOP(10) PERCENT *
FROM finance.Payments
ORDER BY Amount DESC;

-- 5.18
SELECT *
FROM delivery.Sections
WHERE Location != N'Hall A' OR Location IS NULL;

-- 5.19
SELECT 
  Id,
  InvoiceNumber,
  TotalAmount,
  PaidAmount,
  CAST (100.0 * PaidAmount / NULLIF(TotalAmount, 0) AS DECIMAL(5,1)) AS [Paid Percentage],
  CASE
    WHEN PaidAmount = 0.0 AND TotalAmount > 0.0 THEN 'Not Paid'
    WHEN PaidAmount < TotalAmount THEN 'Partially Paid'
  END AS PaidStatus,
  CASE
    WHEN DueAtUtc < SYSUTCDATETIME() THEN 'Yes' ELSE 'No' END AS IsOverDue
FROM finance.Invoices
WHERE PaidAmount < TotalAmount
ORDER BY (TotalAmount - PaidAmount) DESC;

-- 5.20
DECLARE @PageNumber INT = 3;
DECLARE @PageSize INT = 20;
SELECT *
FROM [identity].Users
ORDER BY CreatedAtUtc DESC, Id DESC
OFFSET (@PageNumber - 1) * @PageSize ROWS
FETCH NEXT @PageSize ROWS ONLY;

-- 5.21
DECLARE @LastId BIGINT = 20;
SELECT TOP (50) *
FROM operations.AuditLogs
WHERE Id > @LastId
ORDER BY Id ASC;

-- 5.22
SELECT TOP(10) *
FROM finance.Payments
ORDER BY PaidAtUtc DESC, Id DESC; 
-- it won't be correct without ORDER BY. SQL SERVER returns rows in arbitrary order  

-- 5.23
SELECT DISTINCT TOP(10)
  UPPER(TRIM(Title)) AS Title,
  LEN(TRIM(Title)) AS [Title Length],
  CASE 
    WHEN EstimatedMinutes IS NULL THEN 'NOT SET'
    WHEN EstimatedMinutes <= 15 THEN 'QUICK'
    WHEN EstimatedMinutes <= 45 THEN 'STANDARD'
    ELSE 'LONG'
  END AS [Lesson Length Status]
FROM content.Lessons
WHERE IsPublished = 1 AND LEN(TRIM(Title)) > 40
ORDER BY [Title Length] DESC;

-- 5.24
SELECT DISTINCT TOP(12) 
  CONVERT(VARCHAR(7), DueAtUtc, 120) AS DueMonth, -- 120 style converts dates to yyyy-mm-dd hh:mi:ss
  CurrencyCode,
  CASE 
    WHEN PaidAmount = 0 AND TotalAmount != 0 THEN 'Not Paid' ELSE 'Partially Paid'
  END AS PaymentState
FROM finance.Invoices
WHERE DueAtUtc < SYSUTCDATETIME() AND PaidAmount < TotalAmount 
ORDER BY DueMonth DESC;