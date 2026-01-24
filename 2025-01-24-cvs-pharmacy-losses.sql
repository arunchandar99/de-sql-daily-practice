-- ============================================================================
-- Problem: Pharmacy Analytics (Part 2) - Drug Losses (CVS Health)
-- Source: DataLemur / CVS Health
-- Date: 2025-01-23
-- Difficulty: Easy
-- Topics: SQL, Aggregation, ABS, WHERE, GROUP BY, ORDER BY
-- ============================================================================

-- SCENARIO:
-- CVS Health is analyzing its pharmacy sales data, and how well different products 
-- are selling in the market. Each drug is exclusively manufactured by a single 
-- manufacturer.
--
-- Write a query to identify the manufacturers associated with the drugs that resulted 
-- in losses for CVS Health and calculate the total amount of losses incurred.
--
-- Output the manufacturer's name, the number of drugs associated with losses, and 
-- the total losses in absolute value. Display the results sorted in descending order 
-- with the highest losses displayed at the top.

-- TABLE: pharmacy_sales
--   product_id INTEGER
--   units_sold INTEGER
--   total_sales DECIMAL
--   cogs DECIMAL
--   manufacturer VARCHAR
--   drug VARCHAR

-- EXAMPLE INPUT:
-- product_id | units_sold | total_sales | cogs       | manufacturer | drug
-- -----------|------------|-------------|------------|--------------|---------------------------
-- 156        | 895143     | 130097.00   | 3427421.73 | Biogen       | Acyclovir
-- 25         | 222331     | 2753546.00  | 2974975.36 | AbbVie       | Lamivudine and Zidovudine
-- 50         | 90484      | 2521023.73  | 2742445.90 | Eli Lilly    | Dermasorb TA Complete Kit
-- 98         | 110746     | 813188.82   | 140422.87  | Biogen       | Medi-Chord

-- EXPECTED OUTPUT:
-- manufacturer | drug_count | total_loss
-- -------------|------------|------------
-- Biogen       | 1          | 3297324.73
-- AbbVie       | 1          | 221429.36
-- Eli Lilly    | 1          | 221422.17

-- EXPLANATION:
-- - Acyclovir (Biogen): 130097.00 - 3427421.73 = -3297324.73 (LOSS)
-- - Lamivudine (AbbVie): 2753546.00 - 2974975.36 = -221429.36 (LOSS)
-- - Dermasorb (Eli Lilly): 2521023.73 - 2742445.90 = -221422.17 (LOSS)
-- - Medi-Chord (Biogen): 813188.82 - 140422.87 = 672765.95 (PROFIT - excluded)

-- MY SOLUTION:
WITH final AS (
    SELECT 
        manufacturer, 
        drug, 
        total_sales - cogs AS losses
    FROM pharmacy_sales
    WHERE total_sales - cogs < 0 
) 
SELECT 
    manufacturer, 
    COUNT(drug) AS drug_count, 
    ABS(SUM(losses)) AS total_loss
FROM final 
GROUP BY manufacturer
ORDER BY total_loss DESC;

-- OPTIMIZED SOLUTION:
SELECT 
    manufacturer, 
    COUNT(drug) AS drug_count, 
    ABS(SUM(total_sales - cogs)) AS total_loss
FROM pharmacy_sales
WHERE total_sales - cogs < 0
GROUP BY manufacturer
ORDER BY total_loss DESC;
