-- ============================================================================
-- Problem 8: Running Total
-- Source: SQL Training Session
-- Difficulty: Medium
-- Topics: SUM() as Window Function, Running Total
-- ============================================================================

-- Scenario: Track cumulative revenue throughout 2024

-- MY SOLUTION:
WITH final AS (
    SELECT 
        order_date,
        SUM(total_amount) AS daily_revenue
    FROM orders
    WHERE YEAR(order_date) = 2024 
        AND status = 'Delivered'
    GROUP BY order_date
    ORDER BY order_date ASC
)
SELECT 
    order_date, 
    daily_revenue, 
    SUM(daily_revenue) OVER (ORDER BY order_date) AS running_total
FROM final;

-- OPTIMIZED SOLUTION:
WITH daily_revenue AS (
    SELECT 
        order_date,
        SUM(total_amount) AS daily_revenue
    FROM orders
    WHERE order_date >= '2024-01-01' 
        AND order_date < '2025-01-01'
        AND status = 'Delivered'
    GROUP BY order_date
)
SELECT 
    order_date, 
    daily_revenue, 
    SUM(daily_revenue) OVER (ORDER BY order_date) AS running_total
FROM daily_revenue
ORDER BY order_date;
