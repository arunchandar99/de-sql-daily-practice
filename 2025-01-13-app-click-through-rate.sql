-- Problem: App Click-through Rate (CTR)
-- Source: DataLemur
-- Difficulty: Easy
-- Topics: CASE, SUM, ROUND, Conditional Aggregation
-- Link: https://datalemur.com/questions/click-through-rate

-- Calculate CTR per app for 2022
-- CTR = 100.0 * clicks / impressions

SELECT
  app_id, 
  ROUND(100.0 *
    SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) /
    SUM(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END), 2) AS ctr
FROM events
WHERE EXTRACT(YEAR FROM timestamp) = 2022
GROUP BY app_id;
