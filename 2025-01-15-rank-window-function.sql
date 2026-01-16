-- ============================================================================
-- Problem 7: RANK Window Function
-- Source: SQL Training Session
-- Difficulty: Medium
-- Topics: RANK(), PARTITION BY, Window Functions
-- ============================================================================

-- Scenario: Rank sales reps against peers each month in 2024

-- MY SOLUTION:
WITH pre_final AS (
    SELECT
        DATE_TRUNC('month', order_date) AS order_date,
        employee_id, 
        SUM(total_amount) AS monthly_revenue
    FROM orders 
    WHERE employee_id IN (8, 9, 10, 11)
        AND YEAR(order_date) = 2024 
        AND status = 'Delivered'
    GROUP BY employee_id, order_date
    ORDER BY order_date ASC
), 
final AS (
    SELECT 
        order_date,
        employee_id, 
        monthly_revenue,
        RANK() OVER (PARTITION BY order_date ORDER BY monthly_revenue DESC) AS final_rank
    FROM pre_final
)
SELECT 
    MONTHNAME(f.order_date) AS month_name, 
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name, 
    f.monthly_revenue, 
    f.final_rank
FROM final f 
LEFT JOIN employees e ON f.employee_id = e.employee_id
ORDER BY f.order_date, final_rank ASC;

-- OPTIMIZED SOLUTION:
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        employee_id, 
        SUM(total_amount) AS monthly_revenue
    FROM orders 
    WHERE employee_id IN (8, 9, 10, 11)
        AND order_date >= '2024-01-01' 
        AND order_date < '2025-01-01'
        AND status = 'Delivered'
    GROUP BY employee_id, DATE_TRUNC('month', order_date)
)
SELECT 
    m.month,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    m.monthly_revenue,
    RANK() OVER (PARTITION BY m.month ORDER BY m.monthly_revenue DESC) AS rank
FROM monthly_revenue m
LEFT JOIN employees e ON m.employee_id = e.employee_id
ORDER BY m.month, rank;
