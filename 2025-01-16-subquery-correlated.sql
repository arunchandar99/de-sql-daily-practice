-- ============================================================================
-- Problem 20: Correlated Subquery
-- Source: SQL Training Session
-- Difficulty: Medium
-- Topics: Correlated Subquery, Department Comparison
-- ============================================================================

-- Scenario: Find employees who earn more than their department's average

-- MY SOLUTION (CTE approach):
WITH department_table AS (
    SELECT 
        department_id, 
        AVG(salary) AS avg_department_salary
    FROM employees
    GROUP BY department_id
)
SELECT 
    e.first_name, 
    e.last_name, 
    e.department_id, 
    e.salary
FROM employees e
LEFT JOIN department_table d ON e.department_id = d.department_id
WHERE e.salary > d.avg_department_salary;

-- OPTIMIZED SOLUTION (Correlated Subquery):
SELECT 
    e.first_name, 
    e.last_name, 
    e.department_id, 
    e.salary
FROM employees e
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department_id = e.department_id
);
