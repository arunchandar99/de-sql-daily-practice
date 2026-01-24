-- ============================================================================
-- Problem: Highest-Grossing Items (Amazon)
-- Source: DataLemur / Amazon / Ace the Data Science Interview #12
-- Date: 2025-01-24
-- Difficulty: Medium
-- Topics: SQL, DENSE_RANK(), Window Functions, EXTRACT, PARTITION BY
-- ============================================================================

-- SCENARIO:
-- Assume you're given a table containing data on Amazon customers and their 
-- spending on products in different category, write a query to identify the top 
-- two highest-grossing products within each category in the year 2022. 
-- The output should include the category, product, and total spend.

-- TABLE: product_spend
--   category STRING
--   product STRING
--   user_id INTEGER
--   spend DECIMAL
--   transaction_date TIMESTAMP

-- EXAMPLE INPUT:
-- category   | product            | user_id | spend  | transaction_date
-- -----------|--------------------|---------|--------|------------------
-- appliance  | refrigerator       | 165     | 246.00 | 12/26/2021 12:00:00
-- appliance  | refrigerator       | 123     | 299.99 | 03/02/2022 12:00:00
-- appliance  | washing machine    | 123     | 219.80 | 03/02/2022 12:00:00
-- electronics| vacuum             | 178     | 152.00 | 04/05/2022 12:00:00
-- electronics| wireless headset   | 156     | 249.90 | 07/08/2022 12:00:00
-- electronics| vacuum             | 145     | 189.00 | 07/15/2022 12:00:00

-- EXPECTED OUTPUT:
-- category   | product            | total_spend
-- -----------|--------------------|-------------
-- appliance  | refrigerator       | 299.99
-- appliance  | washing machine    | 219.80
-- electronics| vacuum             | 341.00
-- electronics| wireless headset   | 249.90

-- EXPLANATION:
-- Appliance category: refrigerator ($299.99) and washing machine ($219.80)
-- Electronics category: vacuum ($152 + $189 = $341) and wireless headset ($249.90)

-- MY SOLUTION:
WITH pre_final AS (
    SELECT
        category, 
        product, 
        SUM(spend) AS total_spending
    FROM product_spend
    WHERE EXTRACT(YEAR FROM transaction_date) = 2022
    GROUP BY category, product
),
final AS (
    SELECT
        category, 
        product, 
        total_spending, 
        DENSE_RANK() OVER (PARTITION BY category ORDER BY total_spending DESC) AS final_rank
    FROM pre_final
)
SELECT 
    category, 
    product, 
    total_spending
FROM final
WHERE final_rank < 3;

-- OPTIMIZED SOLUTION:
SELECT 
    category, 
    product, 
    total_spend
FROM (
    SELECT
        category, 
        product, 
        SUM(spend) AS total_spend,
        DENSE_RANK() OVER (PARTITION BY category ORDER BY SUM(spend) DESC) AS rank
    FROM product_spend
    WHERE EXTRACT(YEAR FROM transaction_date) = 2022
    GROUP BY category, product
) ranked_products
WHERE rank <= 2;
