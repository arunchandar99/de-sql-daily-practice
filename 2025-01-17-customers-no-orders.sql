-- ============================================================================
-- Problem 1: Customers with No Orders
-- Source: SQL Training Session
-- Difficulty: Easy
-- Topics: LEFT JOIN, FULL OUTER JOIN, NULL filtering
-- ============================================================================

-- Scenario: Find all customers who have never placed an order

-- MY SOLUTION:
SELECT 
    c.customer_id, 
    c.company_name
FROM customers c
FULL OUTER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;

-- OPTIMIZED SOLUTION:
SELECT 
    c.customer_id, 
    c.company_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;
