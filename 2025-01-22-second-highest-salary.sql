-- ============================================================================
-- Problem 2: Second Highest Salary
-- Source: SQL Training Session
-- Difficulty: Medium
-- Topics: RANK(), DENSE_RANK(), QUALIFY, Subquery
-- ============================================================================

-- Scenario: Find the second highest salary in the company

-- MY SOLUTION:
SELECT 
    SALARY
FROM EMPLOYEES
QUALIFY RANK() OVER (ORDER BY SALARY DESC) = 2;

-- OPTIMIZED SOLUTION (handles ties):
SELECT SALARY
FROM EMPLOYEES
QUALIFY DENSE_RANK() OVER (ORDER BY SALARY DESC) = 2
LIMIT 1;

-- ALTERNATIVE (subquery approach):
SELECT MAX(salary)
FROM employees
WHERE salary < (SELECT MAX(salary) FROM employees);
