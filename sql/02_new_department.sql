-- 2.1
INSERT INTO academic.Departments (Code, Name)
VALUES 
  ('DSAI', N'Data Science & Artificial Intelligence');

SELECT * FROM academic.Departments;

-- 2.2
INSERT INTO academic.Courses (DepartmentId, Code, Title, CreditHours, PassingScore)
VALUES
  (
    SCOPE_IDENTITY(),
    'DSAI-101', 
    N'Introduction to Data Analysis',
    3.00,
    60.00
  );
  
SELECT TOP(5) * FROM academic.Courses ORDER BY Id DESC

-- 2.3
INSERT INTO delivery.AcademicTerms 
  (
    AcademicYear,
    TermCode,
    Name,
    StartDate,
    EndDate,
    RegistrationStartDate,
    RegistrationEndDate
  )
VALUES
  (
    2027,
    'SUMMER',
    N'SUMMER 2027',
    '2027-06-15',
    '2027-08-31',
    '2027-05-01',
    '2027-06-10'
  );

SELECT * FROM delivery.AcademicTerms;

-- 2.4
INSERT INTO communication.Announcements 
  (
    Title,
    Body,
    [Status],
    PublishedAtUtc,
    ExpiresAtUtc,
    CreatedByUserId
  )
VALUES 
  (
    N'Summer 2027 Registration',
    N'Summer 2027 registration opens on 1 May 2027 and closes on 10 June 2027.',
    2,
    SYSUTCDATETIME(),
    '2027-06-11',
    (
      SELECT TOP(1) Id FROM [identity].Users ORDER BY Id ASC
    )
  );

SELECT TOP(5) * FROM communication.Announcements ORDER BY Id DESC;

-- 2.5
INSERT INTO [identity].Roles (Code, Name, Description)
VALUES 
  (
    'TEACHING_ASSISTANT',
    N'Teaching Assistant',
    N'Assists instructors with labs, grading, and student support.'
  );

SELECT * FROM [identity].Roles