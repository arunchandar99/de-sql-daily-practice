-- ============================================================================
-- Problem: Sending vs. Opening Snaps (Snapchat)
-- Source: DataLemur / Snapchat / Ace the Data Science Interview #25
-- Date: 2025-01-24
-- Difficulty: Medium
-- Topics: SQL, CASE, Percentage Calculation, JOIN, GROUP BY
-- ============================================================================

-- SCENARIO:
-- Assume you're given tables with information on Snapchat users, including their 
-- ages and time spent sending and opening snaps.
--
-- Write a query to obtain a breakdown of the time spent sending vs. opening snaps 
-- as a percentage of total time spent on these activities grouped by age group. 
-- Round the percentage to 2 decimal places in the output.
--
-- NOTES:
-- - Calculate: time spent sending / (time spent sending + time spent opening)
-- - Calculate: time spent opening / (time spent sending + time spent opening)
-- - Multiply by 100.0 (not 100) to avoid integer division

-- TABLE: activities
--   activity_id INTEGER
--   user_id INTEGER
--   activity_type STRING ('send', 'open', 'chat')
--   time_spent FLOAT
--   activity_date DATETIME

-- TABLE: age_breakdown
--   user_id INTEGER
--   age_bucket STRING ('21-25', '26-30', '31-35')

-- EXAMPLE INPUT (activities):
-- activity_id | user_id | activity_type | time_spent | activity_date
-- ------------|---------|---------------|------------|------------------
-- 7274        | 123     | open          | 4.50       | 06/22/2022 12:00:00
-- 2425        | 123     | send          | 3.50       | 06/22/2022 12:00:00
-- 1413        | 456     | send          | 5.67       | 06/23/2022 12:00:00
-- 1414        | 789     | chat          | 11.00      | 06/25/2022 12:00:00
-- 2536        | 456     | open          | 3.00       | 06/25/2022 12:00:00

-- EXAMPLE INPUT (age_breakdown):
-- user_id | age_bucket
-- --------|------------
-- 123     | 31-35
-- 456     | 26-30
-- 789     | 21-25

-- EXPECTED OUTPUT:
-- age_bucket | send_perc | open_perc
-- -----------|-----------|----------
-- 26-30      | 65.40     | 34.60
-- 31-35      | 43.75     | 56.25

-- EXPLANATION:
-- Age bucket 26-30 (user 456):
-- - Time sending: 5.67
-- - Time opening: 3.00
-- - Total: 8.67
-- - Send %: 5.67 / 8.67 * 100 = 65.40%
-- - Open %: 3.00 / 8.67 * 100 = 34.60%

-- MY SOLUTION:
WITH final AS (
    SELECT
        b.age_bucket, 
        CASE WHEN activity_type = 'open' THEN time_spent ELSE NULL END AS time_spent_opening, 
        CASE WHEN activity_type = 'send' THEN time_spent ELSE NULL END AS time_spent_sending
    FROM activities a
    LEFT JOIN age_breakdown b ON a.user_id = b.user_id
)
SELECT 
    age_bucket,
    ROUND((SUM(time_spent_sending) / (SUM(time_spent_opening) + SUM(time_spent_sending))) * 100.0, 2) AS send_perc, 
    ROUND((SUM(time_spent_opening) / (SUM(time_spent_opening) + SUM(time_spent_sending))) * 100.0, 2) AS open_perc
FROM final
GROUP BY age_bucket;

-- OPTIMIZED SOLUTION:
SELECT 
    b.age_bucket,
    ROUND(100.0 * SUM(CASE WHEN a.activity_type = 'send' THEN a.time_spent ELSE 0 END) / 
          SUM(CASE WHEN a.activity_type IN ('send', 'open') THEN a.time_spent ELSE 0 END), 2) AS send_perc,
    ROUND(100.0 * SUM(CASE WHEN a.activity_type = 'open' THEN a.time_spent ELSE 0 END) / 
          SUM(CASE WHEN a.activity_type IN ('send', 'open') THEN a.time_spent ELSE 0 END), 2) AS open_perc
FROM activities a
INNER JOIN age_breakdown b ON a.user_id = b.user_id
WHERE a.activity_type IN ('send', 'open')
GROUP BY b.age_bucket;
