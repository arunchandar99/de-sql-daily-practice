-- Problem: Cities With Completed Trades
-- Source: DataLemur
-- Difficulty: Easy
-- Topics: JOIN, GROUP BY, ORDER BY, LIMIT
-- Link: https://datalemur.com/questions/completed-trades

-- Find top 3 cities with the highest number of completed trade orders

SELECT 
  city, 
  COUNT(order_id) AS total_orders
FROM trades 
LEFT JOIN users USING (user_id)
WHERE status = 'Completed'
GROUP BY city
ORDER BY total_orders DESC 
LIMIT 3;
