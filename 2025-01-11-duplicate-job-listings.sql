-- Problem: Duplicate Job Listings
-- Source: DataLemur
-- Difficulty: Easy
-- Topics: CTE, GROUP BY, HAVING, COUNT
-- Link: https://datalemur.com/questions/duplicate-job-listings

-- Find count of companies that have posted duplicate job listings
-- (same title and description within same company)

WITH duplicate_companies AS (
  SELECT 
    company_id, 
    title, 
    COUNT(title) AS duplicate_companies
  FROM job_listings
  GROUP BY company_id, title
  HAVING COUNT(title) > 1
)

SELECT COUNT(company_id) AS duplicate_companies
FROM duplicate_companies;
