-- ============================================================================
-- Problem 21: UNION / UNION ALL
-- Source: SQL Training Session
-- Difficulty: Easy
-- Topics: UNION, UNION ALL, Set Operations
-- ============================================================================

-- Scenario: Create a list of all people - employees and customer contacts

-- MY SOLUTION:
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name, 
    email,
    'employee table' AS source_table
FROM employees 
UNION 
SELECT 
    company_name,
    email, 
    'customer table' AS source_table
FROM customers;

-- OPTIMIZED SOLUTION:
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name, 
    email,
    'Employee' AS source
FROM employees 
UNION 
SELECT 
    CONCAT(contact_first_name, ' ', contact_last_name) AS full_name,
    email, 
    'Customer' AS source
FROM customers;
