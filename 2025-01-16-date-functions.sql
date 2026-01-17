-- ============================================================================
-- Problem 25: Date Functions
-- Source: SQL Training Session
-- Difficulty: Easy
-- Topics: YEAR(), MONTHNAME(), DAYNAME(), DATEDIFF(), CURRENT_DATE()
-- ============================================================================

-- Scenario: Order report with date breakdowns

-- MY SOLUTION:
SELECT 
    order_id, 
    order_date, 
    YEAR(order_date), 
    MONTHNAME(order_date), 
    DAYOFWEEK(order_date), 
    DATEDIFF('days', order_date, CURRENT_DATE())
FROM orders;

-- OPTIMIZED SOLUTION:
SELECT 
    order_id, 
    order_date, 
    YEAR(order_date) AS year,
    MONTHNAME(order_date) AS month_name,
    DAYNAME(order_date) AS day_of_week,
    DATEDIFF('day', order_date, CURRENT_DATE()) AS days_since_order
FROM orders
WHERE status = 'Delivered'
    AND order_date >= '2024-01-01' 
    AND order_date < '2025-01-01';
