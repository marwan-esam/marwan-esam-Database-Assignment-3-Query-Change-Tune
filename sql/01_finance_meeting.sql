-- 1.1
DROP TABLE IF EXISTS #LateInvoices;
SELECT
    InvoiceNumber,
    StudentId,
    TotalAmount,
    PaidAmount,
    TotalAmount - PaidAmount AS AmountLeft,
    DATEDIFF(DAY, DueAtUtc, SYSUTCDATETIME()) AS DaysLate
INTO #LateInvoices
FROM finance.Invoices
WHERE DueAtUtc < SYSUTCDATETIME() AND PaidAmount < TotalAmount;

GO

-- 1.2

ALTER TABLE #LateInvoices
    ADD Priority VARCHAR(10);
GO

UPDATE #LateInvoices
    SET Priority = CASE
        WHEN DaysLate > 60 OR AmountLeft > 10000.0 THEN 'URGENT'
        WHEN DaysLate > 30 THEN 'MEDIUM'
        ELSE 'LOW'
    END;

-- 1.3
SELECT * FROM #LateInvoices
ORDER BY 
    (
        CASE
            WHEN Priority = 'URGENT' THEN 1
            WHEN Priority = 'MEDIUM' THEN 2
            WHEN Priority = 'LOW' THEN 3
            ELSE 4
        END
    ),  AmountLeft DESC;