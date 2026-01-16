-- ============================================================================
-- Problem 9: LAG Window Function
-- Source: SQL Training Session
-- Difficulty: Medium
-- Topics: LAG(), Month-over-Month Comparison
-- ============================================================================

-- Scenario: Compare each month's revenue to previous month in 2024

-- MY SOLUTION:
WITH initial AS (
    SELECT 
        DATE_TRUNC('month', order_date) AS month_name, 
        SUM(total_amount) AS monthly_revenue
    FROM orders
    WHERE YEAR(order_date) = 2024
        AND status = 'Delivered'
    GROUP BY DATE_TRUNC('month', order_date)
    ORDER BY DATE_TRUNC('month', order_date) ASC
)
SELECT
    month_name, 
    monthly_revenue, 
    LAG(monthly_revenue, 1) OVER (ORDER BY month_name) AS previous_month_revenue,  
    ROUND(((monthly_revenue - LAG(monthly_revenue, 1) OVER (ORDER BY month_name)) / 
           ABS(LAG(monthly_revenue, 1) OVER (ORDER BY month_name))) * 100, 2) AS pct_change
FROM initial;

-- OPTIMIZED SOLUTION:
WITH monthly_revenue AS (
    SELECT 
        DATE_TRUNC('month', order_date) AS month, 
        SUM(total_amount) AS monthly_revenue
    FROM orders
    WHERE order_date >= '2024-01-01' 
        AND order_date < '2025-01-01'
        AND status = 'Delivered'
    GROUP BY DATE_TRUNC('month', order_date)
),
with_previous AS (
    SELECT
        month, 
        monthly_revenue, 
        LAG(monthly_revenue) OVER (ORDER BY month) AS previous_month_revenue
    FROM monthly_revenue
)
SELECT 
    month,
    monthly_revenue,
    previous_month_revenue,
    monthly_revenue - previous_month_revenue AS change,
    ROUND((monthly_revenue - previous_month_revenue) / NULLIF(previous_month_revenue, 0) * 100, 2) AS pct_change
FROM with_previous
ORDER BY month;
