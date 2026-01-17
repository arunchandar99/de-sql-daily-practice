-- ============================================================================
-- Problem 23: LAST_VALUE / FIRST_VALUE Window Function
-- Source: SQL Training Session
-- Difficulty: Medium
-- Topics: LAST_VALUE(), FIRST_VALUE(), Window Frames
-- ============================================================================

-- Scenario: For each customer, show all orders with the amount of their most recent order

-- MY SOLUTION:
SELECT 
    customer_id, 
    order_id, 
    order_date, 
    FIRST_VALUE(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS last_order_amount
FROM orders;

-- OPTIMIZED SOLUTION:
SELECT 
    customer_id, 
    order_id, 
    order_date, 
    total_amount,
    FIRST_VALUE(total_amount) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date DESC
    ) AS last_order_amount
FROM orders
WHERE status = 'Delivered';

-- ALTERNATIVE using LAST_VALUE (requires explicit frame):
SELECT 
    customer_id, 
    order_id, 
    order_date, 
    total_amount,
    LAST_VALUE(total_amount) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS last_order_amount
FROM orders
WHERE status = 'Delivered';
