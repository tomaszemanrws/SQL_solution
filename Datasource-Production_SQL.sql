
SELECT--Select all columns that are needed
	Base.JobSK,
    Job.JobID,
    Job.ProjectNo,
    Base.SourceLanguageCode,
    Base.JobStateName,
    Base.Job,
    Base.CreatedDate,
    Base.CompletedDate,
    SUM(Tasks.Wordcount) AS Wordcount,--SUM with GROUP BY is needed to show Wordcount per job
 CASE--CASE statement added to determine the Priority based on Classification
    	WHEN Base.Classification = 'H' THEN '0'
        WHEN Base.Classification = 'M' THEN '1'
        WHEN Base.Classification = 'L' THEN '2'
        ELSE '3'
     END as 'Priority'
FROM Base
LEFT JOIN Job ON Base.JobSK = Job.JobSK--LEFT JOIN Base and Job tables first via JobSK column
LEFT JOIN Tasks ON Job.JobID = Tasks.JobID--LEFT JOIN Job and Tasks tables via JobID, now all 3 tables are joined
WHERE Base.JobStateName <> 'Canceled'--Adding WHERE statement to exclude all Jobs with JobStateName status Canceled
GROUP BY Job.JobSK, Job.JobID--Both GROUP BY are needed to show the desired outcome - Wordcount per Job


--BONUS Task 1
/*
SELECT--All data are in Base table, selecting only SourceLanguageCode column and desired calculated column
	SourceLanguageCode,
    COUNT(SourceLanguageCode) * 100.00/(SELECT COUNT(*) from Base) AS Percentage_of_Jobs
    --Counting language codes and multiplying by 100 to get the percentage, then deviding by all rows in Base table
from Base
WHERE SourceLanguageCode = 'EN-US'--Only this language is needed
group BY SourceLanguageCode--This can be removed as only EN-US language is required already defined in WHERE statement
order BY Percentage_of_Jobs DESC--This can be removed, I only used it for validation percentages without the WHERE statement
*/

--BONUS Task 2
/*
SELECT--Selecting JobID column from Job table and returning only non-current rcords
	JobID,
    SUM(isCurrent) AS Valid_records--When SUM of isCurrent values for each job is 0, then no valid records exists
FROM Job
GROUP BY JobID
HAVING Valid_records = 0--SQL will return desired JobIDs only
*/

--BONUS Task 3

/*UPDATE Tasks
SET completeddate = NULL
WHERE completeddate = ''*/

--PRAGMA table_info(Base) -- Date values in date type
--PRAGMA table_info(Tasks) -- Date values in nvarchar

/*Firstly I was trying to calculate the difference between two dates, function DATEDIFF is not built-in SQL lite,
used julianday instead
Result was NULL in all rows, firstly thought it is caused by empty cells in Tasks table, so replaced them with NULL
Then found out that type of date columns is not date but nvarchar, so it has to be updated to date type firstlyBase
All 3 tables have to be joined, after that I would probably create a temporary table with one CASE statement and
then would create another CASE statement to query the temporary table to get the desired resuts
*/
