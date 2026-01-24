-- ============================================================================
-- Problem: Tweets' Rolling Averages (Twitter)
-- Source: DataLemur / Twitter / Ace the Data Science Interview #10
-- Date: 2025-01-24
-- Difficulty: Medium
-- Topics: SQL, Window Functions, AVG, ROWS BETWEEN, Moving Average
-- ============================================================================

-- SCENARIO:
-- Given a table of tweet data over a specified time period, calculate the 3-day 
-- rolling average of tweets for each user. Output the user ID, tweet date, and 
-- rolling averages rounded to 2 decimal places.
--
-- NOTES:
-- - A rolling average (moving average) examines trends over a specified period
-- - We want to determine how tweet count changes over a 3-day period for each user

-- TABLE: tweets
--   user_id INTEGER
--   tweet_date TIMESTAMP
--   tweet_count INTEGER

-- EXAMPLE INPUT:
-- user_id | tweet_date          | tweet_count
-- --------|---------------------|-------------
-- 111     | 06/01/2022 00:00:00 | 2
-- 111     | 06/02/2022 00:00:00 | 1
-- 111     | 06/03/2022 00:00:00 | 3
-- 111     | 06/04/2022 00:00:00 | 4
-- 111     | 06/05/2022 00:00:00 | 5

-- EXPECTED OUTPUT:
-- user_id | tweet_date          | rolling_avg_3d
-- --------|---------------------|----------------
-- 111     | 06/01/2022 00:00:00 | 2.00
-- 111     | 06/02/2022 00:00:00 | 1.50
-- 111     | 06/03/2022 00:00:00 | 2.00
-- 111     | 06/04/2022 00:00:00 | 2.67
-- 111     | 06/05/2022 00:00:00 | 4.00

-- EXPLANATION:
-- Day 1: 2 (only one day)
-- Day 2: (2 + 1) / 2 = 1.50
-- Day 3: (2 + 1 + 3) / 3 = 2.00
-- Day 4: (1 + 3 + 4) / 3 = 2.67
-- Day 5: (3 + 4 + 5) / 3 = 4.00

-- MY SOLUTION:
SELECT 
    user_id, 
    tweet_date, 
    ROUND(AVG(tweet_count) OVER (
        PARTITION BY user_id 
        ORDER BY tweet_date ASC 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS rolling_avg_3d
FROM tweets
ORDER BY user_id, tweet_date;

-- OPTIMIZED SOLUTION:
SELECT 
    user_id, 
    tweet_date, 
    ROUND(AVG(tweet_count) OVER (
        PARTITION BY user_id 
        ORDER BY tweet_date 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS rolling_avg_3d
FROM tweets;
