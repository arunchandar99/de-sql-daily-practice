-- ============================================================================
-- Problem 10: DENSE_RANK Window Function
-- Source: SQL Training Session
-- Difficulty: Easy
-- Topics: DENSE_RANK(), PARTITION BY
-- ============================================================================

-- Scenario: Rank each employee's salary within their department

-- MY SOLUTION:
SELECT 
    first_name, 
    salary, 
    department_id, 
    DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC)
FROM employees;

-- OPTIMIZED SOLUTION:
SELECT 
    first_name, 
    salary, 
    department_id, 
    DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS salary_rank
FROM employees;
