-- Problem: Histogram of Queries
-- Source: DataLemur
-- Difficulty: Medium
-- Topics: CTE, LEFT JOIN, COALESCE, GROUP BY, Histogram
-- Link: https://datalemur.com/questions/sql-histogram-queries

-- Build histogram of unique queries per employee in Q3 2023
-- Include employees with 0 queries

WITH step1 AS (
  SELECT
    employee_id, 
    COUNT(query_id) AS queries_count
  FROM queries
  WHERE EXTRACT(YEAR FROM query_starttime) = 2023
    AND EXTRACT(MONTH FROM query_starttime) IN (7, 8, 9)
  GROUP BY employee_id
), 

final AS (
  SELECT 
    e.employee_id, 
    COALESCE(queries_count, 0) AS unique_queries
  FROM employees AS e 
  LEFT JOIN step1 AS s
    ON e.employee_id = s.employee_id
) 

SELECT 
  unique_queries, 
  COUNT(employee_id) AS employee_count
FROM final
GROUP BY unique_queries
ORDER BY unique_queries ASC;
