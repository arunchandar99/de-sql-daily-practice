-- Problem: Days Between Posts
-- Source: DataLemur
-- Difficulty: Easy
-- Topics: MIN/MAX aggregation, DATEDIFF, HAVING clause, date filtering

-- Description:
-- For each user who posted at least twice in 2021, find the number of days 
-- between their first post and last post of the year.

SELECT 
    user_id, 
    DATEDIFF(MAX(DATE(post_date)), MIN(DATE(post_date))) AS days_between
FROM posts
WHERE YEAR(post_date) = 2021
GROUP BY user_id
HAVING COUNT(post_id) > 1;
