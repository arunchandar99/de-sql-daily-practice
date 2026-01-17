-- ============================================================================
-- Problem 15: LAG with DATEDIFF
-- Source: SQL Training Session
-- Difficulty: Medium
-- Topics: LAG(), DATEDIFF(), Date Arithmetic
-- ============================================================================

-- Scenario: Show each order with days since that customer's previous order

-- MY SOLUTION:
WITH final AS (
    SELECT 
        customer_id, 
        order_id, 
        order_date, 
        total_amount, 
        LAG(order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date ASC) AS previous_date
    FROM orders 
    WHERE status = 'Delivered'
        AND YEAR(order_date) = 2024
)
SELECT 
    customer_id, 
    order_id, 
    order_date, 
    total_amount,
    previous_date, 
    DATEDIFF('day', previous_date, order_date) AS number_of_days_since_previous_order
FROM final;

-- OPTIMIZED SOLUTION:
WITH orders_with_previous AS (
    SELECT 
        customer_id, 
        order_id, 
        order_date, 
        total_amount, 
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS previous_date
    FROM orders 
    WHERE status = 'Delivered'
        AND order_date >= '2024-01-01' 
        AND order_date < '2025-01-01'
)
SELECT 
    customer_id, 
    order_id, 
    order_date, 
    total_amount,
    previous_date, 
    DATEDIFF('day', previous_date, order_date) AS days_since_previous_order
FROM orders_with_previous
ORDER BY customer_id, order_date;
