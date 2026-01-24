-- ============================================================================
-- Problem: Third Transaction (Uber)
-- Source: DataLemur / Uber / Ace the Data Science Interview #11
-- Date: 2025-01-24
-- Difficulty: Medium
-- Topics: SQL, ROW_NUMBER(), Window Functions, PARTITION BY
-- ============================================================================

-- SCENARIO:
-- Assume you are given the table below on Uber transactions made by users. 
-- Write a query to obtain the third transaction of every user. 
-- Output the user id, spend and transaction date.

-- TABLE: transactions
--   user_id INTEGER
--   spend DECIMAL
--   transaction_date TIMESTAMP

-- EXAMPLE INPUT:
-- user_id | spend  | transaction_date
-- --------|--------|------------------
-- 111     | 100.50 | 01/08/2022 12:00:00
-- 111     | 55.00  | 01/10/2022 12:00:00
-- 121     | 36.00  | 01/18/2022 12:00:00
-- 145     | 24.99  | 01/26/2022 12:00:00
-- 111     | 89.60  | 02/05/2022 12:00:00

-- EXPECTED OUTPUT:
-- user_id | spend | transaction_date
-- --------|-------|------------------
-- 111     | 89.60 | 02/05/2022 12:00:00

-- EXPLANATION:
-- User 111 has 3 transactions. The third one (ordered by date) is $89.60 on 02/05/2022.

-- MY SOLUTION:
WITH final AS (
    SELECT 
        user_id, 
        spend, 
        transaction_date, 
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY transaction_date) AS transaction_rank
    FROM transactions
)
SELECT 
    user_id, 
    spend, 
    transaction_date 
FROM final 
WHERE transaction_rank = 3;

-- OPTIMIZED SOLUTION:
SELECT 
    user_id, 
    spend, 
    transaction_date
FROM (
    SELECT 
        user_id, 
        spend, 
        transaction_date, 
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY transaction_date) AS rn
    FROM transactions
) ranked_transactions
WHERE rn = 3;
