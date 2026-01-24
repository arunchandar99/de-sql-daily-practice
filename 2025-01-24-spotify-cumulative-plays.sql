-- ============================================================================
-- Problem: Spotify Streaming History (Spotify)
-- Source: DataLemur / Spotify
-- Date: 2025-01-24
-- Difficulty: Medium
-- Topics: SQL, UNION ALL, Aggregation, Date Filtering, Multiple Tables
-- ============================================================================

-- SCENARIO:
-- You're given two tables containing data on Spotify users' streaming activity: 
-- songs_history which has historical streaming data, and songs_weekly which has 
-- data from the current week.
--
-- Write a query that outputs the user ID, song ID, and cumulative count of song 
-- plays up to August 4th, 2022, sorted in descending order.
--
-- Assume that there may be new users or songs in the songs_weekly table that are 
-- not present in the songs_history table.
--
-- DEFINITIONS:
-- - songs_weekly: Contains data for the week of August 1-7, 2022
-- - songs_history: Contains data up to July 31, 2022
-- - Query should include cumulative count up to August 4, 2022

-- TABLE: songs_history
--   history_id INTEGER
--   user_id INTEGER
--   song_id INTEGER
--   song_plays INTEGER

-- TABLE: songs_weekly
--   user_id INTEGER
--   song_id INTEGER
--   listen_time DATETIME

-- EXAMPLE INPUT (songs_history):
-- history_id | user_id | song_id | song_plays
-- -----------|---------|---------|------------
-- 10011      | 777     | 1238    | 11
-- 12452      | 695     | 4520    | 1

-- EXAMPLE INPUT (songs_weekly):
-- user_id | song_id | listen_time
-- --------|---------|------------------
-- 777     | 1238    | 08/01/2022 12:00:00
-- 695     | 4520    | 08/04/2022 08:00:00
-- 125     | 9630    | 08/04/2022 16:00:00
-- 695     | 9852    | 08/07/2022 12:00:00

-- EXPECTED OUTPUT:
-- user_id | song_id | song_plays
-- --------|---------|------------
-- 777     | 1238    | 12
-- 695     | 4520    | 2
-- 125     | 9630    | 1

-- EXPLANATION:
-- User 777, Song 1238: 11 (historical) + 1 (week) = 12
-- User 695, Song 4520: 1 (historical) + 1 (week) = 2
-- User 125, Song 9630: 0 (historical) + 1 (week) = 1
-- User 695, Song 9852: Excluded (listen date 08/07 is after 08/04)

-- MY SOLUTION:
WITH historical AS (
    SELECT
        user_id, 
        song_id, 
        SUM(song_plays) AS song_plays
    FROM songs_history
    GROUP BY user_id, song_id
), 
current_week AS (
    SELECT 
        user_id, 
        song_id, 
        COUNT(song_id) AS song_plays
    FROM songs_weekly
    WHERE listen_time <= '08/04/2022 23:59:59'
    GROUP BY user_id, song_id
), 
final AS (
    SELECT * FROM historical 
    UNION ALL
    SELECT * FROM current_week
)
SELECT 
    user_id, 
    song_id, 
    SUM(song_plays) AS song_count
FROM final
GROUP BY user_id, song_id
ORDER BY song_count DESC;

-- OPTIMIZED SOLUTION:
SELECT 
    user_id, 
    song_id, 
    SUM(song_plays) AS song_plays
FROM (
    SELECT user_id, song_id, SUM(song_plays) AS song_plays
    FROM songs_history
    GROUP BY user_id, song_id
    
    UNION ALL
    
    SELECT user_id, song_id, COUNT(*) AS song_plays
    FROM songs_weekly
    WHERE listen_time <= '2022-08-04 23:59:59'
    GROUP BY user_id, song_id
) combined
GROUP BY user_id, song_id
ORDER BY song_plays DESC;
