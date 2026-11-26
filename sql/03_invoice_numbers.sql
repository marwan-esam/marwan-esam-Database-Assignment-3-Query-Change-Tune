-- 3.1
ALTER TABLE finance.Invoices
  DROP CONSTRAINT IF EXISTS DF_Invoices_InvoiceNumber;

DROP SEQUENCE IF EXISTS finance.Seq_InvoiceNumber;

CREATE SEQUENCE finance.Seq_InvoiceNumber
  AS INT START WITH 1 INCREMENT BY 1;

GO

ALTER TABLE finance.Invoices
  ADD CONSTRAINT  DF_Invoices_InvoiceNumber DEFAULT 
  (
    'LAB-INV-2026-' + 
    RIGHT('000000' + CAST(NEXT VALUE FOR finance.Seq_InvoiceNumber AS VARCHAR(10)), 6)
  ) FOR InvoiceNumber;

GO

-- 3.2
INSERT INTO finance.Invoices (StudentId, TermId, CurrencyCode, IssuedAtUtc, DueAtUtc, TotalAmount, PaidAmount)
VALUES 
  ( (SELECT TOP (1) Id FROM [identity].StudentProfiles ORDER BY Id),
    (SELECT TOP (1) Id FROM delivery.AcademicTerms ORDER BY Id),
    'EGP',
    SYSUTCDATETIME(),
    DATEADD(DAY, 30, SYSUTCDATETIME()),
    4500.00,
    0.00
  );

SELECT TOP(2) * FROM finance.Invoices ORDER BY Id DESC;

-- 3.3
BEGIN TRANSACTION;

INSERT INTO finance.Invoices (StudentId, TermId, DueAtUtc)
VALUES 
  ( (SELECT TOP (1) Id FROM [identity].StudentProfiles ORDER BY Id),
    (SELECT TOP (1) Id FROM delivery.AcademicTerms ORDER BY Id),
    DATEADD(DAY, 30, SYSUTCDATETIME())
  );

SELECT TOP(5) * FROM finance.Invoices ORDER BY Id DESC;

ROLLBACK TRANSACTION;

SELECT NEXT VALUE FOR finance.Seq_InvoiceNumber AS NextNumberAfterRollBack;