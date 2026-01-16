-- ============================================================================
-- Problem 5: CTEs with Multiple Tables
-- Source: SQL Training Session
-- Difficulty: Medium
-- Topics: CTEs, Multiple JOINs, Target vs Actual Comparison
-- ============================================================================

-- Scenario: Compare each sales rep's Q4 2024 actual performance vs targets

-- MY SOLUTION:
WITH total_revenue AS (
    SELECT
        employee_id,
        SUM(total_amount) AS actual_revenue
    FROM orders
    WHERE employee_id IN (8, 9, 10, 11)
        AND QUARTER(order_date) = 4 
        AND YEAR(order_date) = 2024
    GROUP BY employee_id
),
target_table AS (
    SELECT 
        employee_id, 
        SUM(target_amount) AS q4_2024_target_amount
    FROM sales_targets
    WHERE employee_id IN (8, 9, 10, 11)
        AND fiscal_year = 2024 
        AND fiscal_quarter = 4
    GROUP BY employee_id, fiscal_quarter, fiscal_year
), 
final_table AS (
    SELECT 
        CONCAT(e.first_name, e.last_name) AS employee_full_name, 
        t.q4_2024_target_amount, 
        r.actual_revenue, 
        (r.actual_revenue - t.q4_2024_target_amount) AS difference
    FROM total_revenue r 
    LEFT JOIN target_table t ON r.employee_id = t.employee_id 
    LEFT JOIN employees e ON r.employee_id = e.employee_id 
)
SELECT * FROM final_table;

-- OPTIMIZED SOLUTION:
WITH total_revenue AS (
    SELECT
        employee_id,
        SUM(total_amount) AS actual_revenue
    FROM orders
    WHERE employee_id IN (8, 9, 10, 11)
        AND order_date >= '2024-10-01' 
        AND order_date < '2025-01-01'
    GROUP BY employee_id
),
target_table AS (
    SELECT 
        employee_id, 
        SUM(target_amount) AS q4_2024_target_amount
    FROM sales_targets
    WHERE employee_id IN (8, 9, 10, 11)
        AND fiscal_year = 2024 
        AND fiscal_quarter = 4
    GROUP BY employee_id
)
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS employee_full_name, 
    t.q4_2024_target_amount, 
    r.actual_revenue, 
    r.actual_revenue - t.q4_2024_target_amount AS difference
FROM total_revenue r 
LEFT JOIN target_table t ON r.employee_id = t.employee_id 
LEFT JOIN employees e ON r.employee_id = e.employee_id
ORDER BY r.actual_revenue DESC;
