-- ============================================================================
-- Problem 22: INTERSECT / EXCEPT
-- Source: SQL Training Session
-- Difficulty: Easy
-- Topics: INTERSECT, EXCEPT, Set Operations
-- ============================================================================

-- Scenario A: Find customers who ordered in BOTH 2023 AND 2024

-- MY SOLUTION:
SELECT customer_id FROM orders WHERE YEAR(order_date) = 2023 
INTERSECT
SELECT customer_id FROM orders WHERE YEAR(order_date) = 2024;

-- OPTIMIZED SOLUTION:
SELECT customer_id FROM orders 
WHERE order_date >= '2023-01-01' AND order_date < '2024-01-01'
    AND status = 'Delivered'
INTERSECT
SELECT customer_id FROM orders 
WHERE order_date >= '2024-01-01' AND order_date < '2025-01-01'
    AND status = 'Delivered';


-- Scenario B: Find customers who ordered in 2023 but NOT in 2024

-- MY SOLUTION:
SELECT customer_id FROM orders WHERE YEAR(order_date) = 2023 
EXCEPT 
SELECT customer_id FROM orders WHERE YEAR(order_date) = 2024;

-- OPTIMIZED SOLUTION:
SELECT customer_id FROM orders 
WHERE order_date >= '2023-01-01' AND order_date < '2024-01-01'
    AND status = 'Delivered'
EXCEPT
SELECT customer_id FROM orders 
WHERE order_date >= '2024-01-01' AND order_date < '2025-01-01'
    AND status = 'Delivered';
