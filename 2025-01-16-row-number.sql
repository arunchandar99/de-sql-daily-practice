-- ============================================================================
-- Problem 18: ROW_NUMBER Window Function
-- Source: SQL Training Session
-- Difficulty: Medium
-- Topics: ROW_NUMBER(), PARTITION BY, QUALIFY
-- ============================================================================

-- Scenario: For each customer, find their most recent order

-- MY SOLUTION:
SELECT 
    customer_id, 
    order_id, 
    order_date, 
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS row_rank
FROM orders
QUALIFY row_rank = 1
ORDER BY customer_id;

-- OPTIMIZED SOLUTION:
SELECT 
    customer_id, 
    order_id, 
    order_date, 
    total_amount,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS row_rank
FROM orders
WHERE status = 'Delivered'
QUALIFY row_rank = 1
ORDER BY customer_id;
