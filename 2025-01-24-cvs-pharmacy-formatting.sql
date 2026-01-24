-- ============================================================================
-- Problem: Pharmacy Analytics (Part 3) - Total Sales by Manufacturer (CVS Health)
-- Source: DataLemur / CVS Health
-- Date: 2025-01-24
-- Difficulty: Easy
-- Topics: SQL, Aggregation, CONCAT, ROUND, String Formatting
-- ============================================================================

-- SCENARIO:
-- CVS Health wants to gain a clearer understanding of its pharmacy sales and the 
-- performance of various products.
--
-- Write a query to calculate the total drug sales for each manufacturer. Round 
-- the answer to the nearest million and report your results in descending order 
-- of total sales. In case of any duplicates, sort them alphabetically by the 
-- manufacturer name.
--
-- Since this data will be displayed on a dashboard viewed by business stakeholders, 
-- please format your results as follows: "$36 million".

-- TABLE: pharmacy_sales
--   product_id INTEGER
--   units_sold INTEGER
--   total_sales DECIMAL
--   cogs DECIMAL
--   manufacturer VARCHAR
--   drug VARCHAR

-- EXAMPLE INPUT:
-- product_id | units_sold | total_sales | cogs       | manufacturer | drug
-- -----------|------------|-------------|------------|--------------|------------------
-- 94         | 132362     | 2041758.41  | 1373721.70 | Biogen       | UP and UP
-- 9          | 37410      | 293452.54   | 208876.01  | Eli Lilly    | Zyprexa
-- 50         | 90484      | 2521023.73  | 2742445.9  | Eli Lilly    | Dermasorb
-- 61         | 77023      | 500101.61   | 419174.97  | Biogen       | Varicose Relief
-- 136        | 144814     | 1084258.00  | 1006447.73 | Biogen       | Burkhart

-- EXPECTED OUTPUT:
-- manufacturer | sale
-- -------------|-------------
-- Biogen       | $4 million
-- Eli Lilly    | $3 million

-- EXPLANATION:
-- Biogen: $2,041,758.41 + $500,101.61 + $1,084,258.00 = $3,626,118.02 ≈ $4 million
-- Eli Lilly: $293,452.54 + $2,521,023.73 = $2,814,476.27 ≈ $3 million

-- MY SOLUTION:
SELECT
    manufacturer,
    CONCAT('$', ROUND(ROUND(SUM(total_sales), -6) / 1000000.0, 0), ' million') AS sale
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales) DESC;

-- OPTIMIZED SOLUTION:
SELECT
    manufacturer,
    CONCAT('$', ROUND(SUM(total_sales) / 1000000.0, 0), ' million') AS sale
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales) DESC, manufacturer ASC;
