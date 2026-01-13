-- Problem: Final Account Balance
-- Source: DataLemur
-- Difficulty: Easy
-- Topics: CASE, SUM, Conditional Aggregation
-- Link: https://datalemur.com/questions/final-account-balance

-- Calculate final balance per account (deposits minus withdrawals)

SELECT 
  account_id, 
  SUM(CASE WHEN transaction_type = 'Withdrawal' THEN amount * -1 ELSE amount END) AS final_balance 
FROM transactions 
GROUP BY account_id;
