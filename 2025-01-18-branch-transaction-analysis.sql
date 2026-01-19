-- Problem: Branch Transaction Analysis (dbt practice)
-- Source: Self-practice
-- Topics: Window Functions, Running Total, LAG, DENSE_RANK, dbt ref()

-- Analyze branch transactions with:
-- - Running total of transactions per branch
-- - Previous day comparison
-- - Daily ranking by transaction volume

WITH transactions AS (
  SELECT * FROM {{ ref('fct_transactions') }}
), 

branches AS (
  SELECT * FROM {{ ref('dim_branches') }}
), 

final AS (
  SELECT 
    t.branch_id, 
    b.branch_name, 
    DATE(t.transaction_timestamp) AS transaction_date,  
    COUNT(t.transaction_id) AS transaction_count, 
    SUM(source_currency_amount) AS total_amount, 
    SUM(fee_amount) AS total_fees
  FROM transactions t 
  LEFT JOIN branches b 
    ON t.branch_key = b.branch_key
  GROUP BY t.branch_id, b.branch_name, DATE(t.transaction_timestamp)
)

SELECT 
  branch_id, 
  branch_name, 
  transaction_date, 
  transaction_count,
  SUM(transaction_count) OVER (PARTITION BY branch_id ORDER BY transaction_date ASC) AS running_total_transaction_count,  
  LAG(transaction_count) OVER (PARTITION BY branch_id ORDER BY transaction_date ASC) AS prev_day_transaction_count,
  DENSE_RANK() OVER (PARTITION BY transaction_date ORDER BY transaction_count DESC) AS daily_rank_transaction_count, 
  total_amount, 
  total_fees
FROM final
ORDER BY transaction_date ASC;
