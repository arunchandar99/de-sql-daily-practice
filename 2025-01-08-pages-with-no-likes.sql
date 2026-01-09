-- Problem: Pages With No Likes
-- Source: DataLemur
-- Difficulty: Easy
-- Topics: LEFT JOIN, NULL check
-- Link: https://datalemur.com/questions/sql-page-with-no-likes

-- Solution: LEFT JOIN with NULL check
SELECT p.page_id
FROM pages p 
LEFT JOIN page_likes l 
  ON p.page_id = l.page_id
WHERE l.user_id IS NULL
ORDER BY p.page_id;

-- Alternative: NOT EXISTS
SELECT page_id
FROM pages p
WHERE NOT EXISTS (
  SELECT 1 
  FROM page_likes l 
  WHERE l.page_id = p.page_id
)
ORDER BY page_id;

-- Alternative: NOT IN
SELECT page_id
FROM pages
WHERE page_id NOT IN (
  SELECT page_id 
  FROM page_likes
)
ORDER BY page_id;