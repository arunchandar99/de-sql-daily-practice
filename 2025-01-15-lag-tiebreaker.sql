-- ============================================================================
-- Problem 11: LAG with Tiebreaker
-- Source: SQL Training Session
-- Difficulty: Easy
-- Topics: LAG(), ORDER BY with Tiebreaker
-- ============================================================================

-- Scenario: Show each order with the previous order's amount

-- MY SOLUTION:
SELECT 
    order_id, 
    order_date, 
    total_amount, 
    LAG(total_amount, 1) OVER (ORDER BY order_id ASC)
FROM orders
WHERE status = 'Delivered' 
    AND YEAR(order_date) = 2024;

-- OPTIMIZED SOLUTION:
SELECT 
    order_id, 
    order_date, 
    total_amount, 
    LAG(total_amount) OVER (ORDER BY order_date, order_id) AS prev_order_amount
FROM orders
WHERE status = 'Delivered' 
    AND order_date >= '2024-01-01' 
    AND order_date < '2025-01-01';
