-- Problem: Laptop vs Mobile Viewership
-- Source: DataLemur
-- Difficulty: Easy
-- Topics: CASE, SUM, Conditional Aggregation
-- Link: https://datalemur.com/questions/laptop-mobile-viewership

-- Calculate total viewership for laptops vs mobile (tablet + phone)

SELECT 
  SUM(CASE WHEN device_type = 'laptop' THEN 1 ELSE 0 END) AS laptop_views, 
  SUM(CASE WHEN device_type IN ('phone', 'tablet') THEN 1 ELSE 0 END) AS mobile_views
FROM viewership;
