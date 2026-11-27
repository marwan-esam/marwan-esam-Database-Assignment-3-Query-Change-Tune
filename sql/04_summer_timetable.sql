-- 4
DECLARE @Summer2027TermId INT = (
  SELECT Id 
  FROM delivery.AcademicTerms
  WHERE AcademicYear = 2027 AND TermCode = 'SUMMER'
);

DECLARE @MostRecentTermId INT = (
  SELECT TOP(1) TermId
  FROM delivery.Sections
  WHERE TermId < @Summer2027TermId
  ORDER BY TermId DESC
);

INSERT INTO delivery.Sections (CourseId, TermId, SectionCode, Capacity, Location, DeliveryMode, Status)
SELECT  
  CourseId,
  @Summer2027TermId,
  SectionCode,
  Capacity,
  Location,
  DeliveryMode,
  Status
FROM delivery.Sections
WHERE TermId = @MostRecentTermId;

SELECT *
FROM delivery.Sections
WHERE TermId = @Summer2027TermId;