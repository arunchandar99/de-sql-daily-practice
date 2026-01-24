-- ============================================================================
-- Problem: Credit Card Issuance Disparity
-- Source: DataLemur / JPMorgan Chase
-- Date: 2025-01-22
-- Difficulty: Medium
-- Topics: SQL, Aggregation, MAX, MIN, GROUP BY, ORDER BY
-- ============================================================================

-- SCENARIO:
-- Your team at JPMorgan Chase is preparing to launch a new credit card, and to 
-- gain some insights, you're analyzing how many credit cards were issued each month.
--
-- Write a query that outputs the name of each credit card and the difference in 
-- the number of issued cards between the month with the highest issuance cards 
-- and the lowest issuance. Arrange the results based on the largest disparity.

-- TABLE: monthly_cards_issued
--   card_name VARCHAR
--   issued_amount INTEGER
--   issue_month INTEGER
--   issue_year INTEGER

-- EXAMPLE INPUT:
-- card_name                | issued_amount | issue_month | issue_year
-- -------------------------|---------------|-------------|------------
-- Chase Freedom Flex       | 55000         | 1           | 2021
-- Chase Freedom Flex       | 60000         | 2           | 2021
-- Chase Freedom Flex       | 65000         | 3           | 2021
-- Chase Freedom Flex       | 70000         | 4           | 2021
-- Chase Sapphire Reserve   | 170000        | 1           | 2021
-- Chase Sapphire Reserve   | 175000        | 2           | 2021
-- Chase Sapphire Reserve   | 180000        | 3           | 2021

-- EXPECTED OUTPUT:
-- card_name                | difference
-- -------------------------|------------
-- Chase Freedom Flex       | 15000
-- Chase Sapphire Reserve   | 10000

-- EXPLANATION:
-- - Chase Freedom Flex: max(70k) - min(55k) = 15k difference
-- - Chase Sapphire Reserve: max(180k) - min(170k) = 10k difference
-- - Results ordered by largest difference first

-- MY SOLUTION:
SELECT 
    card_name, 
    MAX(issued_amount) - MIN(issued_amount) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference DESC;

-- OPTIMIZED SOLUTION:
SELECT 
    card_name, 
    MAX(issued_amount) - MIN(issued_amount) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference DESC;

-- KEY CONCEPTS:
-- 1. MAX() and MIN() aggregate functions work across all rows in each group
-- 2. GROUP BY card_name creates one row per credit card
-- 3. Difference calculation happens at the SELECT level after aggregation
-- 4. ORDER BY difference DESC sorts by largest disparity first
