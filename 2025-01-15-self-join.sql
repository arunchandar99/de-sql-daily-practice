-- ============================================================================
-- Problem 4: Self JOIN
-- Source: SQL Training Session
-- Difficulty: Medium
-- Topics: Self JOIN, CONCAT, IFNULL/COALESCE
-- ============================================================================

-- Scenario: HR wants to see org structure - each employee and their manager

-- MY SOLUTION:
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name, 
    e.job_title AS employee_job_title,
    IFNULL(CONCAT(m.first_name, ' ', m.last_name), 'No Manager') AS manager_name, 
    IFNULL(m.job_title, 'No Manager') AS manager_job_title
FROM employees e 
LEFT JOIN employees m ON e.manager_id = m.employee_id
ORDER BY e.last_name ASC;

-- OPTIMIZED SOLUTION:
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name, 
    e.job_title AS employee_job_title,
    COALESCE(CONCAT(m.first_name, ' ', m.last_name), 'No Manager') AS manager_name, 
    COALESCE(m.job_title, 'No Manager') AS manager_job_title
FROM employees e 
LEFT JOIN employees m ON e.manager_id = m.employee_id
ORDER BY e.last_name ASC;
