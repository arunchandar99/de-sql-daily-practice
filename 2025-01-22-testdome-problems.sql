-- ============================================================================
-- TESTDOME SQL PROBLEMS - SOLVED
-- Date: 2025-01-17
-- Source: https://www.testdome.com/tests/sql-online-test/12
-- ============================================================================

-- ============================================================================
-- Problem 1: Sessions
-- Difficulty: Easy | Time: 7 min
-- Topics: SQL, Aggregation, Group by, Select
-- ============================================================================

-- TABLE: sessions
--   id INTEGER PRIMARY KEY,
--   userId INTEGER NOT NULL,
--   duration DECIMAL NOT NULL

-- Write a query that returns, for each user who has more than one session:
-- - The userId
-- - The average session duration

-- SOLUTION:
SELECT 
    userId,
    AVG(duration) AS average_duration
FROM sessions
GROUP BY userId
HAVING COUNT(*) > 1;


-- ============================================================================
-- Problem 2: Workers
-- Difficulty: Hard | Time: 7 min
-- Topics: SQL, Conditions, Select, Subqueries
-- ============================================================================

-- TABLE: employees
--   id INTEGER NOT NULL PRIMARY KEY
--   managerId INTEGER
--   name VARCHAR(30) NOT NULL
--   FOREIGN KEY (managerId) REFERENCES employees(id)

-- An employee is a manager if any other employee has their managerId set to 
-- this employee's id.

-- Write a query that selects only the names of employees who are not managers.

-- SOLUTION:
SELECT name
FROM employees
WHERE id NOT IN (
    SELECT DISTINCT managerId 
    FROM employees 
    WHERE managerId IS NOT NULL
);

-- ALTERNATIVE SOLUTION (using LEFT JOIN):
SELECT e.name
FROM employees e
LEFT JOIN employees m ON e.id = m.managerId
WHERE m.id IS NULL;


-- ============================================================================
-- Problem 3: Student Name
-- Difficulty: Easy | Time: 3 min
-- Topics: SQL, Aggregation, Select
-- ============================================================================

-- TABLE: students
--   id INTEGER PRIMARY KEY,
--   firstName VARCHAR(30) NOT NULL,
--   lastName VARCHAR(30) NOT NULL

-- Write a query that returns the number of students whose first name is John.

-- SOLUTION:
SELECT COUNT(*) AS count
FROM students
WHERE firstName = 'John';


-- ============================================================================
-- Problem 4: Enrollment
-- Difficulty: Easy | Time: 5 min
-- Topics: SQL, Conditions, Update
-- ============================================================================

-- TABLE: enrollments
--   id INTEGER NOT NULL PRIMARY KEY
--   year INTEGER NOT NULL
--   studentId INTEGER NOT NULL

-- Records with IDs between 20 and 100 (inclusive) contain incorrect data.

-- Write a query that updates the 'year' field of every faulty record to 2015.

-- SOLUTION:
UPDATE enrollments
SET year = 2015
WHERE id BETWEEN 20 AND 100;

-- ALTERNATIVE (explicit range):
UPDATE enrollments
SET year = 2015
WHERE id >= 20 AND id <= 100;


-- ============================================================================
-- Problem 5: Dictionary Search
-- Difficulty: Easy | Time: 7 min
-- Topics: SQL, Conditions, Select
-- ============================================================================

-- TABLE: dictionary
--   id INTEGER NOT NULL PRIMARY KEY
--   word VARCHAR(100) NOT NULL

-- For an autocomplete feature in an app, English words are stored in a table.

-- For letters 'b', 'i' and 'd' typed in succession, write a query that returns 
-- the count of the suggestions.

-- SOLUTION:
SELECT COUNT(*) AS count
FROM dictionary
WHERE word LIKE 'bid%';

-- EXPLANATION:
-- The LIKE 'bid%' pattern matches any word that:
-- - Starts with 'bid'
-- - Followed by any number of characters (%)
-- Examples: 'bid', 'bide', 'biden', 'bidding', etc.
