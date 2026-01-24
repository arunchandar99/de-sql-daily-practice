-- ============================================================================
-- Problem: Top 3 Most Profitable Drugs (CVS Health)
-- Source: DataLemur / CVS Health
-- Date: 2025-01-22
-- Difficulty: Easy
-- Topics: SQL, Aggregation, SUM, GROUP BY, ORDER BY, LIMIT
-- ============================================================================

-- SCENARIO:
-- CVS Health is trying to better understand its pharmacy sales, and how well 
-- different products are selling. Each drug can only be produced by one manufacturer.
--
-- Write a query to find the top 3 most profitable drugs sold, and how much profit 
-- they made. Assume that there are no ties in the profits. Display the result from 
-- the highest to the lowest total profit.
--
-- DEFINITION:
-- - cogs = Cost of Goods Sold (direct cost associated with producing the drug)
-- - Total Profit = Total Sales - Cost of Goods Sold

-- TABLE: pharmacy_sales
--   product_id INTEGER
--   units_sold INTEGER
--   total_sales DECIMAL
--   cogs DECIMAL
--   manufacturer VARCHAR
--   drug VARCHAR

-- EXAMPLE INPUT:
-- product_id | units_sold | total_sales | cogs      | manufacturer | drug
-- -----------|------------|-------------|-----------|--------------|------------------
-- 9          | 37410      | 293452.54   | 208876.01 | Eli Lilly    | Zyprexa
-- 34         | 94698      | 600997.19   | 521182.16 | AstraZeneca  | Surmontil
-- 61         | 77023      | 500101.61   | 419174.97 | Biogen       | Varicose Relief
-- 136        | 144814     | 1084258     | 1006447.73| Biogen       | Burkhart

-- EXPECTED OUTPUT:
-- drug              | total_profit
-- ------------------|-------------
-- Zyprexa           | 84576.53
-- Varicose Relief   | 80926.64
-- Surmontil         | 79815.03

-- EXPLANATION:
-- Zyprexa: 293452.54 - 208876.01 = 84,576.53
-- Varicose Relief: 500101.61 - 419174.97 = 80,926.64
-- Surmontil: 600997.19 - 521182.16 = 79,815.03

-- MY SOLUTION:
SELECT 
    drug, 
    SUM(total_sales) - SUM(cogs) AS total_profit
FROM pharmacy_sales
GROUP BY drug 
ORDER BY total_profit DESC
LIMIT 3;

-- OPTIMIZED SOLUTION:
SELECT 
    drug, 
    SUM(total_sales) - SUM(cogs) AS total_profit
FROM pharmacy_sales
GROUP BY drug 
ORDER BY total_profit DESC
LIMIT 3;
