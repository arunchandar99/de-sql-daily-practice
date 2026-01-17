-- ============================================================================
-- Problem 24: String Functions (REGEXP_REPLACE)
-- Source: SQL Training Session
-- Difficulty: Easy
-- Topics: REGEXP_REPLACE, String Cleaning
-- ============================================================================

-- Scenario: Clean phone numbers to show digits only

-- MY SOLUTION:
SELECT 
    phone, 
    REGEXP_REPLACE(phone, '[\\D]', '') AS cleaned_phone
FROM customers;

-- OPTIMIZED SOLUTION:
SELECT 
    customer_id,
    company_name,
    phone AS original_phone,
    REGEXP_REPLACE(phone, '\\D', '') AS cleaned_phone
FROM customers;
