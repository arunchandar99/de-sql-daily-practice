-- Problem: Data Science Skills
-- Source: DataLemur
-- Difficulty: Easy
-- Topics: GROUP BY, HAVING, IN
-- Link: https://datalemur.com/questions/matching-skills

-- Find candidates who have all 3 required skills: Python, Tableau, PostgreSQL

SELECT candidate_id
FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(candidate_id) = 3;
