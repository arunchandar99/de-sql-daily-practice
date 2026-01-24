-- ============================================================================
-- Problem: Second Highest Salary
-- Source: DataLemur
-- Date: 2025-01-24
-- Difficulty: Easy
-- Topics: SQL, DENSE_RANK(), Window Functions, ORDER BY
-- ============================================================================

-- SCENARIO:
-- Imagine you're an HR analyst at a tech company tasked with analyzing employee 
-- salaries. Your manager is keen on understanding the pay distribution and asks 
-- you to determine the second highest salary among all employees.
--
-- It's possible that multiple employees may share the same second highest salary. 
-- In case of duplicate, display the salary only once.

-- TABLE: employee
--   employee_id INTEGER
--   name STRING
--   salary INTEGER
--   department_id INTEGER
--   manager_id INTEGER

-- EXAMPLE INPUT:
-- employee_id | name             | salary | department_id | manager_id
-- ------------|------------------|--------|---------------|------------
-- 1           | Emma Thompson    | 3800   | 1             | 6
-- 2           | Daniel Rodriguez | 2230   | 1             | 7
-- 3           | Olivia Smith     | 2000   | 1             | 8

-- EXPECTED OUTPUT:
-- second_highest_salary
-- ---------------------
-- 2230

-- EXPLANATION:
-- The second highest salary is $2,230 (Daniel Rodriguez).
-- DENSE_RANK ensures if multiple employees have the same second-highest salary,
-- it still returns rank 2 (unlike RANK which would skip to rank 3).

-- MY SOLUTION:
WITH final AS (
    SELECT 
        salary, 
        DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_rank
    FROM employee
)
SELECT 
    salary AS second_highest_salary
FROM final 
WHERE dense_rank = 2;

-- OPTIMIZED SOLUTION:
SELECT DISTINCT salary AS second_highest_salary
FROM (
    SELECT 
        salary,
        DENSE_RANK() OVER (ORDER BY salary DESC) AS rank
    FROM employee
) ranked_salaries
WHERE rank = 2;
