-- ============================================================================
-- Problem 13: Moving Average with Window Frame
-- Source: SQL Training Session
-- Difficulty: Medium
-- Topics: ROWS BETWEEN, Window Frames, Moving Average
-- ============================================================================

-- Scenario: Calculate 3-order moving average of order amounts

-- MY SOLUTION:
SELECT 
    order_id, 
    order_date, 
    total_amount, 
    LAG(total_amount, 1) OVER (ORDER BY order_date ASC) AS last_order, 
    LAG(total_amount, 2) OVER (ORDER BY order_date ASC) AS last_before_order, 
    ROUND((total_amount + LAG(total_amount, 1) OVER (ORDER BY order_date ASC) + 
           LAG(total_amount, 2) OVER (ORDER BY order_date ASC)) / 3, 2) AS three_days_moving_average
FROM orders
WHERE status = 'Delivered'
    AND YEAR(order_date) = 2024;

-- OPTIMIZED SOLUTION:
SELECT 
    order_id, 
    order_date, 
    total_amount,
    ROUND(AVG(total_amount) OVER (
        ORDER BY order_date, order_id 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS three_order_moving_avg
FROM orders
WHERE status = 'Delivered'
    AND order_date >= '2024-01-01' 
    AND order_date < '2025-01-01'
ORDER BY order_date, order_id;
