-- ============================================================================
-- Query Optimization Cheat Sheet
-- Source: SQL Training Session
-- Topics: Performance, Sargable Filters, Best Practices
-- ============================================================================

-- ============================================================================
-- 1. SARGABLE FILTERS (Index-Friendly)
-- ============================================================================

-- BAD: Function on column
WHERE YEAR(order_date) = 2024

-- GOOD: Direct comparison
WHERE order_date >= '2024-01-01' AND order_date < '2025-01-01'


-- BAD: Function on column
WHERE UPPER(name) = 'JOHN'

-- GOOD: Case-insensitive comparison
WHERE name ILIKE 'john'


-- ============================================================================
-- 2. FILTER EARLY (WHERE vs HAVING)
-- ============================================================================

-- GOOD: Filter before aggregation
SELECT department_id, SUM(salary)
FROM employees
WHERE is_active = TRUE
GROUP BY department_id;

-- BAD: Process all rows then filter
SELECT department_id, SUM(salary)
FROM employees
GROUP BY department_id
HAVING some_non_aggregate_condition;


-- ============================================================================
-- 3. SELECT ONLY WHAT YOU NEED
-- ============================================================================

-- BAD
SELECT * FROM orders;

-- GOOD
SELECT order_id, customer_id, total_amount FROM orders;


-- ============================================================================
-- 4. EXISTS vs IN (Large Subqueries)
-- ============================================================================

-- BAD for large subqueries
SELECT * FROM customers 
WHERE customer_id IN (SELECT customer_id FROM orders);

-- GOOD: Stops at first match
SELECT * FROM customers c
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id);


-- ============================================================================
-- 5. UNION vs UNION ALL
-- ============================================================================

-- SLOWER: Checks for duplicates
SELECT customer_id FROM orders_2023
UNION
SELECT customer_id FROM orders_2024;

-- FASTER: No duplicate check
SELECT customer_id FROM orders_2023
UNION ALL
SELECT customer_id FROM orders_2024;


-- ============================================================================
-- 6. COUNT(*) vs COUNT(column)
-- ============================================================================

-- FASTER: Just counts rows
COUNT(*)

-- SLOWER: Checks for NULLs
COUNT(column_name)


-- ============================================================================
-- 7. AVOID CORRELATED SUBQUERIES
-- ============================================================================

-- BAD: Runs subquery for EACH row
SELECT e.name, 
    (SELECT AVG(salary) FROM employees e2 WHERE e2.department_id = e.department_id)
FROM employees e;

-- GOOD: Single aggregation, then join
WITH dept_avg AS (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
)
SELECT e.name, d.avg_salary
FROM employees e
JOIN dept_avg d ON e.department_id = d.department_id;


-- ============================================================================
-- 8. FILTER BEFORE JOIN
-- ============================================================================

-- BAD: Join then filter
SELECT *
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.status = 'Delivered';

-- BETTER: Filter first, then join
WITH delivered_orders AS (
    SELECT * FROM orders WHERE status = 'Delivered'
)
SELECT *
FROM delivered_orders o
JOIN customers c ON o.customer_id = c.customer_id;


-- ============================================================================
-- QUICK REFERENCE
-- ============================================================================
-- | Do This                          | Not This                        |
-- |----------------------------------|----------------------------------|
-- | WHERE date >= '2024-01-01'       | WHERE YEAR(date) = 2024         |
-- | SELECT col1, col2                | SELECT *                        |
-- | EXISTS                           | IN (for large subqueries)       |
-- | UNION ALL                        | UNION (if no duplicates)        |
-- | COUNT(*)                         | COUNT(column) (unless needed)   |
-- | Filter before JOIN               | Filter after JOIN               |
-- | CTE + JOIN                       | Correlated subquery             |
-- ============================================================================
