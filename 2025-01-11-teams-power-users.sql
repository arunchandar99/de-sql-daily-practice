-- Problem: Teams Power Users
-- Source: DataLemur
-- Difficulty: Easy
-- Topics: GROUP BY, ORDER BY, LIMIT, EXTRACT
-- Link: https://datalemur.com/questions/teams-power-users

-- Find top 2 users who sent the most messages in August 2022

SELECT 
  sender_id, 
  COUNT(message_id) AS message_count
FROM messages
WHERE EXTRACT(MONTH FROM sent_date) = 8
  AND EXTRACT(YEAR FROM sent_date) = 2022
GROUP BY sender_id
ORDER BY message_count DESC
LIMIT 2;
