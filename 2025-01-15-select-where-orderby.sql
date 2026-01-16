-- ============================================================================
-- Problem 1: Basic SELECT, WHERE, ORDER BY
-- Source: SQL Training Session
-- Difficulty: Easy
-- Topics: SELECT, WHERE, AND, ORDER BY
-- ============================================================================

-- Scenario: The Sales VP wants a list of all active sales representatives

-- MY SOLUTION:
SELECT 
    first_name, 
    last_name, 
    email, 
    salary, 
    hire_date
FROM employees
WHERE job_title = 'Sales Representative'
    AND is_active = TRUE
ORDER BY hire_date DESC;

-- OPTIMIZED SOLUTION:
SELECT 
    first_name, 
    last_name, 
    email, 
    salary, 
    hire_date
FROM employees
WHERE job_title = 'Sales Representative'
    AND is_active = TRUE
ORDER BY hire_date DESC;
