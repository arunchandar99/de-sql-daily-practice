-- ============================================================================
-- Problem 3: GROUP BY and Aggregations
-- Source: SQL Training Session
-- Difficulty: Easy
-- Topics: GROUP BY, COUNT, SUM, AVG
-- ============================================================================

-- Scenario: Finance needs order activity summary by payment method for 2024

-- MY SOLUTION:
SELECT 
    payment_method, 
    COUNT(order_id) AS total_number_of_orders, 
    SUM(total_amount) AS total_revenue,
    SUM(total_amount) / COUNT(order_id) AS average_order_value
FROM orders
WHERE YEAR(order_date) = 2024 
    AND status != 'Cancelled'
GROUP BY payment_method;

-- OPTIMIZED SOLUTION:
SELECT 
    payment_method, 
    COUNT(order_id) AS total_number_of_orders, 
    SUM(total_amount) AS total_revenue,
    AVG(total_amount) AS average_order_value
FROM orders
WHERE order_date >= '2024-01-01' 
    AND order_date < '2025-01-01'
    AND status != 'Cancelled'
GROUP BY payment_method
ORDER BY total_revenue DESC;
