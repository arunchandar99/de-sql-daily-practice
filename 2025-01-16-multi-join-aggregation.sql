-- ============================================================================
-- Problem 16: Multi-table JOIN with Aggregation
-- Source: SQL Training Session
-- Difficulty: Medium
-- Topics: Multiple JOINs, GROUP BY, LIMIT, DENSE_RANK, QUALIFY
-- ============================================================================

-- Scenario: Find top 3 products by total quantity sold in 2024

-- MY SOLUTION:
WITH orders_table AS (
    SELECT 
        order_id, 
        order_date
    FROM orders
), 
order_details_table AS (
    SELECT 
        order_id, 
        product_id, 
        SUM(quantity) AS total_quantity
    FROM order_details
    GROUP BY order_id, product_id
),
final_table AS (
    SELECT 
        d.product_id, 
        SUM(d.total_quantity) AS total_quantity_sold
    FROM order_details_table d
    LEFT JOIN orders_table t ON d.order_id = t.order_id
    WHERE YEAR(t.order_date) = 2024
    GROUP BY d.product_id
),
product_table AS (
    SELECT 
        p.category, 
        p.product_name, 
        f.total_quantity_sold
    FROM final_table f 
    LEFT JOIN products p ON f.product_id = p.product_id 
)
SELECT
    product_name, 
    category, 
    total_quantity_sold, 
    DENSE_RANK() OVER (ORDER BY total_quantity_sold DESC) AS top_rank
FROM product_table
QUALIFY top_rank < 4;

-- OPTIMIZED SOLUTION:
SELECT 
    p.product_name,
    p.category,
    SUM(od.quantity) AS total_quantity_sold
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
JOIN products p ON od.product_id = p.product_id
WHERE o.order_date >= '2024-01-01' 
    AND o.order_date < '2025-01-01'
GROUP BY p.product_name, p.category
ORDER BY total_quantity_sold DESC
LIMIT 3;
