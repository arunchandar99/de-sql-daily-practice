-- Problem: Average Review Ratings
-- Source: DataLemur
-- Difficulty: Easy
-- Topics: EXTRACT, GROUP BY, AVG, ROUND
-- Link: https://datalemur.com/questions/sql-avg-review-ratings

-- Get average star rating per product per month

SELECT 
  EXTRACT(MONTH FROM submit_date) AS mth, 
  product_id, 
  ROUND(AVG(stars), 2) AS avg_stars
FROM reviews
GROUP BY mth, product_id
ORDER BY mth, product_id;
