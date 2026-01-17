-- ============================================================================
-- Problem 17: HAVING Clause
-- Source: SQL Training Session
-- Difficulty: Easy
-- Topics: HAVING, GROUP BY, Aggregate Filtering
-- ============================================================================

-- Scenario: Find customers who placed more than 5 orders in 2024

-- MY SOLUTION:
SELECT 
    customer_id, 
    COUNT(order_id) AS no_of_orders, 
    SUM(total_amount)
FROM orders
WHERE YEAR(order_date) = 2024
GROUP BY customer_id
HAVING no_of_orders > 5;

-- OPTIMIZED SOLUTION:
SELECT 
    customer_id, 
    COUNT(order_id) AS no_of_orders, 
    SUM(total_amount) AS total_spent
FROM orders
WHERE order_date >= '2024-01-01' 
    AND order_date < '2025-01-01'
    AND status = 'Delivered'
GROUP BY customer_id
HAVING no_of_orders > 5;
