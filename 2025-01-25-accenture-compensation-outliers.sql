-- ============================================================================
-- Problem: Compensation Outliers (Accenture)
-- Source: DataLemur / Accenture
-- Date: 2025-01-25
-- Difficulty: Medium
-- Topics: SQL, AVG() OVER, Window Functions, CASE, PARTITION BY
-- ============================================================================

-- SCENARIO:
-- Your team at Accenture is helping a Fortune 500 client revamp their compensation 
-- and benefits program. The first step in this analysis is to manually review 
-- employees who are potentially overpaid or underpaid.
--
-- An employee is considered to be potentially overpaid if they earn more than 2 times 
-- the average salary for people with the same title. Similarly, an employee might be 
-- underpaid if they earn less than half of the average for their title. We'll refer 
-- to employees who are both underpaid and overpaid as compensation outliers.
--
-- Write a query that shows the following data for each compensation outlier: 
-- employee ID, salary, and whether they are potentially overpaid or potentially 
-- underpaid.

-- TABLE: employee_pay
--   employee_id INTEGER
--   salary INTEGER
--   title VARCHAR

-- EXAMPLE INPUT:
-- employee_id | salary | title
-- ------------|--------|---------------
-- 101         | 80000  | Data Analyst
-- 102         | 90000  | Data Analyst
-- 103         | 100000 | Data Analyst
-- 104         | 30000  | Data Analyst
-- 105         | 120000 | Data Scientist
-- 106         | 100000 | Data Scientist
-- 107         | 80000  | Data Scientist
-- 108         | 310000 | Data Scientist

-- EXPECTED OUTPUT:
-- employee_id | salary | status
-- ------------|--------|------------
-- 104         | 30000  | Underpaid
-- 108         | 310000 | Overpaid

-- EXPLANATION:
-- Data Analyst average: (80000 + 90000 + 100000 + 30000) / 4 = 75,000
-- - Employee 104: $30,000 < $37,500 (half of avg) → Underpaid
--
-- Data Scientist average: (120000 + 100000 + 80000 + 310000) / 4 = 152,500
-- - Employee 108: $310,000 > $305,000 (2× avg) → Overpaid

-- MY SOLUTION:
WITH payout AS (
    SELECT 
        employee_id,
        salary,
        title,
        (AVG(salary) OVER (PARTITION BY title)) * 2 AS double_average,
        (AVG(salary) OVER (PARTITION BY title)) / 2 AS half_average
    FROM employee_pay
)
SELECT 
    employee_id,
    salary,
    CASE 
        WHEN salary > double_average THEN 'Overpaid'
        WHEN salary < half_average THEN 'Underpaid'
    END AS outlier_status
FROM payout
WHERE salary > double_average 
    OR salary < half_average;

-- OPTIMIZED SOLUTION:
WITH avg_salaries AS (
    SELECT 
        employee_id,
        salary,
        title,
        AVG(salary) OVER (PARTITION BY title) AS avg_salary
    FROM employee_pay
)
SELECT 
    employee_id,
    salary,
    CASE 
        WHEN salary > 2 * avg_salary THEN 'Overpaid'
        WHEN salary < avg_salary / 2 THEN 'Underpaid'
    END AS status
FROM avg_salaries
WHERE salary > 2 * avg_salary 
    OR salary < avg_salary / 2
ORDER BY employee_id;
