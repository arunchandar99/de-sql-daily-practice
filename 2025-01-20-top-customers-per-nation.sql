-- Problem: Top 3 Customers per Nation by Lifetime Spend
-- Source: TPCH Practice
-- Difficulty: Medium
-- Topics: CTE, Window Functions, DENSE_RANK, Multiple JOINs
-- Dataset: Snowflake TPCH

-- Find top 3 customers by total spend within each nation (include ties)

WITH CUSTOMER_SPEND AS (
    SELECT 
        N.N_NAME AS NATION_NAME,
        C.C_NAME AS CUSTOMER_NAME,
        SUM(O.O_TOTALPRICE) AS LIFETIME_SPEND
    FROM ORDERS O
    INNER JOIN CUSTOMER C ON O.O_CUSTKEY = C.C_CUSTKEY
    INNER JOIN NATION N ON C.C_NATIONKEY = N.N_NATIONKEY
    GROUP BY N.N_NAME, C.C_NAME
),

RANKED AS (
    SELECT 
        NATION_NAME,
        CUSTOMER_NAME,
        LIFETIME_SPEND,
        DENSE_RANK() OVER (PARTITION BY NATION_NAME ORDER BY LIFETIME_SPEND DESC) AS NATION_RANK
    FROM CUSTOMER_SPEND
)

SELECT *
FROM RANKED
WHERE NATION_RANK <= 3
ORDER BY NATION_NAME, NATION_RANK;
