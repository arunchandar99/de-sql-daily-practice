-- ============================================================================
-- Problem 6: CASE Statements
-- Source: SQL Training Session
-- Difficulty: Medium
-- Topics: CASE WHEN, Customer Segmentation
-- ============================================================================

-- Scenario: Group customers by spending level in 2024

-- MY SOLUTION:
WITH total_spendings AS (
    SELECT
        customer_id, 
        SUM(total_amount) AS total_spendings
    FROM orders
    WHERE status = 'Delivered'
        AND YEAR(order_date) = 2024
    GROUP BY customer_id
), 
customer_tier AS (
    SELECT 
        customer_id, 
        total_spendings,
        CASE
            WHEN total_spendings >= 100000 THEN 'High Value'
            WHEN total_spendings >= 50000 THEN 'Medium Value'
            ELSE 'Low Value' 
        END AS customer_tier
    FROM total_spendings 
), 
final AS (
    SELECT
        customer_tier, 
        COUNT(customer_id) AS number_of_customers,
        SUM(total_spendings) AS total_revenue
    FROM customer_tier
    GROUP BY customer_tier
)
SELECT * FROM final
ORDER BY total_revenue DESC;

-- OPTIMIZED SOLUTION:
WITH total_spendings AS (
    SELECT
        customer_id, 
        SUM(total_amount) AS total_spendings
    FROM orders
    WHERE status = 'Delivered'
        AND order_date >= '2024-01-01' 
        AND order_date < '2025-01-01'
    GROUP BY customer_id
)
SELECT
    CASE
        WHEN total_spendings >= 100000 THEN 'High Value'
        WHEN total_spendings >= 50000 THEN 'Medium Value'
        ELSE 'Low Value' 
    END AS customer_tier,
    COUNT(customer_id) AS number_of_customers,
    SUM(total_spendings) AS total_revenue
FROM total_spendings
GROUP BY customer_tier
ORDER BY total_revenue DESC;
