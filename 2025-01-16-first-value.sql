-- ============================================================================
-- Problem 14: FIRST_VALUE Window Function
-- Source: SQL Training Session
-- Difficulty: Medium
-- Topics: FIRST_VALUE(), MIN() OVER, Window Functions
-- ============================================================================

-- Scenario: For each customer, show each order with the date of their first order

-- MY SOLUTION:
SELECT 
    customer_id, 
    order_id, 
    order_date, 
    total_amount, 
    MIN(order_date) OVER (PARTITION BY customer_id ORDER BY order_date ASC) AS date_of_first_order
FROM orders 
WHERE status = 'Delivered';

-- OPTIMIZED SOLUTION:
SELECT 
    customer_id, 
    order_id, 
    order_date, 
    total_amount, 
    MIN(order_date) OVER (PARTITION BY customer_id) AS first_order_date
FROM orders 
WHERE status = 'Delivered';
