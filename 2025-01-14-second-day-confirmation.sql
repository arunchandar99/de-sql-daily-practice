-- Problem: Second Day Confirmation
-- Source: DataLemur
-- Difficulty: Easy
-- Topics: JOIN, DATE functions, CTE
-- Link: https://datalemur.com/questions/second-day-confirmation

-- Find users who confirmed on the second day (not first day)

-- My solution (checks for 2 text entries)
WITH final AS (
  SELECT email_id
  FROM texts
  GROUP BY email_id
  HAVING COUNT(text_id) = 2
)

SELECT e.user_id
FROM final AS f 
LEFT JOIN emails e 
  ON f.email_id = e.email_id;

-- More robust solution (actually checks dates)
SELECT e.user_id
FROM emails e
JOIN texts t 
  ON e.email_id = t.email_id
WHERE t.signup_action = 'Confirmed'
  AND t.action_date = e.signup_date + INTERVAL '1 day';
