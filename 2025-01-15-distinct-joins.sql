-- ============================================================================
-- Problem 2: DISTINCT and JOINs
-- Source: SQL Training Session
-- Difficulty: Easy
-- Topics: DISTINCT, INNER JOIN, LEFT JOIN, NULL filtering
-- ============================================================================

-- Scenario: Find which regions have customers assigned to them

-- MY SOLUTION:
SELECT 
    c.region_id, 
    r.region_name
FROM customers c
LEFT JOIN regions r ON c.region_id = r.region_id
WHERE c.region_id IS NOT NULL 
GROUP BY c.region_id, r.region_name
ORDER BY c.region_id ASC;

-- OPTIMIZED SOLUTION:
SELECT DISTINCT 
    c.region_id, 
    r.region_name
FROM customers c
INNER JOIN regions r ON c.region_id = r.region_id
ORDER BY r.region_name ASC;
