-- Problem: Unfinished Parts
-- Source: DataLemur
-- Difficulty: Easy
-- Topics: NULL check, WHERE
-- Link: https://datalemur.com/questions/tesla-unfinished-parts

-- Find parts that have started assembly but are not yet finished (no finish_date)

SELECT part, assembly_step
FROM parts_assembly
WHERE finish_date IS NULL;
