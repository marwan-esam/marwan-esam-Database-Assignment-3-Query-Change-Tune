-- 11.1
UPDATE academic.Courses
SET PassingScore = 65.00
WHERE DepartmentId = (
    SELECT Id
    FROM academic.Departments
    WHERE Code = 'DSAI'
);

SELECT Code, Title, PassingScore
FROM academic.Courses
WHERE DepartmentId = (
    SELECT Id
    FROM academic.Departments
    WHERE Code = 'DSAI'
);

-- 11.2
UPDATE delivery.Enrollments
SET FinalGrade = CASE
    WHEN FinalScore >= 90 THEN 'A'
    WHEN FinalScore >= 80 THEN 'B'
    WHEN FinalScore >= 70 THEN 'C'
    WHEN FinalScore >= 60 THEN 'D'
    ELSE 'F'
END
WHERE CompletedAtUtc IS NOT NULL
  AND FinalScore IS NOT NULL;

SELECT TOP (10) Id, FinalScore, FinalGrade, CompletedAtUtc
FROM delivery.Enrollments
WHERE CompletedAtUtc IS NOT NULL
  AND FinalScore IS NOT NULL;

-- 11.3
DELETE FROM [identity].Roles
WHERE Code = 'TEACHING_ASSISTANT';

SELECT * FROM [identity].Roles;

-- 11.4
DROP TABLE IF EXISTS finance.PaymentStaging;

CREATE TABLE finance.PaymentStaging
(
    Id              INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_PaymentStaging PRIMARY KEY,
    InvoiceId       BIGINT            NOT NULL,
    PaymentMethodId TINYINT           NOT NULL,
    Amount          DECIMAL(12,2)     NOT NULL,
    CurrencyCode    CHAR(3)           NOT NULL,
    PaidAtUtc       DATETIME2         NULL
);

INSERT INTO finance.PaymentStaging (InvoiceId, PaymentMethodId, Amount, CurrencyCode, PaidAtUtc)
SELECT TOP (3)
    InvoiceId,
    PaymentMethodId,
    Amount,
    CurrencyCode,
    PaidAtUtc
FROM finance.Payments
ORDER BY Id DESC;

SELECT * FROM finance.PaymentStaging;

TRUNCATE TABLE finance.PaymentStaging;

SELECT * FROM finance.PaymentStaging;

-- 11.5
DROP TABLE IF EXISTS finance.PaymentStaging;
DROP TABLE IF EXISTS dbo.SpillDemo;
