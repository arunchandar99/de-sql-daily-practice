-- ============================================================================
-- Problem 19: Non-Correlated Subquery
-- Source: SQL Training Session
-- Difficulty: Easy
-- Topics: Subqueries, Scalar Subquery
-- ============================================================================

-- Scenario: Find employees whose salary is above the company average

-- MY SOLUTION:
SELECT 
    first_name, 
    last_name, 
    salary, 
    job_title
FROM employees 
WHERE salary > (SELECT AVG(salary) FROM employees);

-- OPTIMIZED SOLUTION:
SELECT 
    first_name, 
    last_name, 
    salary, 
    job_title
FROM employees 
WHERE salary > (SELECT AVG(salary) FROM employees);
