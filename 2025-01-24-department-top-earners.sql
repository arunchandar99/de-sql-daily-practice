-- ============================================================================
-- Problem: Department Top Three Salaries
-- Source: DataLemur
-- Date: 2025-01-24
-- Difficulty: Medium
-- Topics: SQL, DENSE_RANK(), Window Functions, JOIN, Multiple Sorting
-- ============================================================================

-- SCENARIO:
-- As part of an ongoing analysis of salary distribution within the company, your 
-- manager has requested a report identifying high earners in each department. 
-- A 'high earner' within a department is defined as an employee with a salary 
-- ranking among the top three salaries within that department.
--
-- You're tasked with identifying these high earners across all departments. Write 
-- a query to display the employee's name along with their department name and salary. 
-- In case of duplicates, sort the results of department name in ascending order, 
-- then by salary in descending order. If multiple employees have the same salary, 
-- then order them alphabetically.

-- TABLE: employee
--   employee_id INTEGER
--   name STRING
--   salary INTEGER
--   department_id INTEGER
--   manager_id INTEGER

-- TABLE: department
--   department_id INTEGER
--   department_name STRING

-- EXAMPLE INPUT (employee):
-- employee_id | name             | salary | department_id | manager_id
-- ------------|------------------|--------|---------------|------------
-- 1           | Emma Thompson    | 3800   | 1             | 6
-- 2           | Daniel Rodriguez | 2230   | 1             | 7
-- 3           | Olivia Smith     | 2000   | 1             | 8
-- 4           | Noah Johnson     | 6800   | 2             | 9
-- 5           | Sophia Martinez  | 1750   | 1             | 11
-- 6           | Liam Brown       | 1300   | 0             | 3
-- 7           | Ava Garcia       | 1250   | 0             | 3
-- 8           | William Davis    | 6800   | 2             | 9
-- 9           | Isabella Wilson  | 11000  | 3             | 10
-- 10          | James Anderson   | 4000   | 1             | 11

-- EXAMPLE INPUT (department):
-- department_id | department_name
-- --------------|------------------
-- 1             | Data Analytics
-- 2             | Data Science

-- EXPECTED OUTPUT:
-- department_name | name             | salary
-- ----------------|------------------|--------
-- Data Analytics  | James Anderson   | 4000
-- Data Analytics  | Emma Thompson    | 3800
-- Data Analytics  | Daniel Rodriguez | 2230
-- Data Science    | Noah Johnson     | 6800
-- Data Science    | William Davis    | 6800

-- EXPLANATION:
-- Data Analytics: Top 3 salaries are $4000, $3800, $2230
-- Data Science: Top 2 salaries (both $6800), alphabetically Noah before William

-- MY SOLUTION:
WITH pre_final AS (
    SELECT 
        d.department_name, 
        e.name, 
        SUM(e.salary) AS salary
    FROM employee e 
    LEFT JOIN department d ON e.department_id = d.department_id
    GROUP BY d.department_name, e.name 
), 
final AS (
    SELECT 
        department_name, 
        name, 
        salary, 
        DENSE_RANK() OVER (PARTITION BY department_name ORDER BY salary DESC) AS final_rank
    FROM pre_final
)
SELECT 
    department_name, 
    name,
    salary
FROM final 
WHERE final_rank < 4
ORDER BY department_name, salary DESC, name;

-- OPTIMIZED SOLUTION:
SELECT 
    d.department_name, 
    e.name,
    e.salary
FROM (
    SELECT 
        e.name,
        e.salary,
        e.department_id,
        DENSE_RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS rank
    FROM employee e
) ranked_employees e
JOIN department d ON e.department_id = d.department_id
WHERE e.rank <= 3
ORDER BY d.department_name ASC, e.salary DESC, e.name ASC;
