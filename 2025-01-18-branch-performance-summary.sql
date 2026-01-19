-- Problem: Branch Performance Summary (dbt practice)
-- Source: Self-practice
-- Topics: CASE, CTE, HAVING, Filtering with JOIN

-- Categorize branch days by performance and summarize
-- Only include branches with > 30,000 total transactions

WITH final AS (
  SELECT
    branch_id,
    branch_name,
    transaction_count,
    total_amount,
    total_fees,
    CASE 
      WHEN transaction_count > 100 THEN 'busy day'
      WHEN transaction_count > 50 THEN 'normal day'
      ELSE 'slow day'
    END AS day_type
  FROM {{ ref('int_daily_branch_summary') }}
),

branch_totals AS (
  SELECT
    branch_id,
    SUM(transaction_count) AS branch_total_transactions
  FROM final
  GROUP BY branch_id
  HAVING SUM(transaction_count) > 30000
)

SELECT 
  f.branch_id, 
  f.branch_name,
  f.day_type,
  SUM(f.transaction_count) AS total_transactions,
  SUM(f.total_amount) AS final_total_amount, 
  SUM(f.total_fees) AS final_total_fees,
  COUNT(f.day_type) AS count_days_by_performance
FROM final f
INNER JOIN branch_totals bt 
  ON f.branch_id = bt.branch_id
GROUP BY f.branch_id, f.branch_name, f.day_type
ORDER BY f.branch_name;
