-- Problem: Employees Earning More Than Managers
-- Source: DataLemur
-- Difficulty: Easy
-- Topics: Self JOIN, CTE
-- Link: https://datalemur.com/questions/sql-employees-earnings-more-than-managers

-- Find employees who earn more than their direct managers

-- Solution using CTE
WITH manager AS (
  SELECT 
    employee_id AS manager_employee_id, 
    name AS manager_name, 
    salary AS manager_salary
  FROM employee
  WHERE manager_id IS NULL
), 

final AS (
  SELECT * 
  FROM employee e 
  LEFT JOIN manager m 
    ON e.manager_id = m.manager_employee_id 
  WHERE e.manager_id IS NOT NULL
)

SELECT employee_id, name AS employee_name
FROM final 
WHERE salary > manager_salary;

-- Simpler alternative: Self JOIN
SELECT 
  e.employee_id, 
  e.name AS employee_name
FROM employee e
JOIN employee m 
  ON e.manager_id = m.employee_id
WHERE e.salary > m.salary;
