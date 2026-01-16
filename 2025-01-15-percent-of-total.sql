-- ============================================================================
-- Problem 12: Percentage of Total with Window Function
-- Source: SQL Training Session
-- Difficulty: Medium
-- Topics: SUM() OVER (PARTITION BY), Percentage Calculation
-- ============================================================================

-- Scenario: Calculate what percentage each order contributes to customer's total

-- MY SOLUTION:
SELECT 
    order_id, 
    customer_id, 
    total_amount, 
    SUM(total_amount) OVER (PARTITION BY customer_id) AS total_spendings, 
    total_amount / (SUM(total_amount) OVER (PARTITION BY customer_id)) AS percent_of_total
FROM orders;

-- OPTIMIZED SOLUTION:
SELECT 
    order_id, 
    customer_id, 
    total_amount, 
    SUM(total_amount) OVER (PARTITION BY customer_id) AS customer_total,
    ROUND(total_amount / SUM(total_amount) OVER (PARTITION BY customer_id) * 100, 2) AS percent_of_total
FROM orders
WHERE status = 'Delivered';
