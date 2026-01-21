-- Problem: Revenue Trend with Month-over-Month Growth
-- Source: TPCH Practice
-- Difficulty: Medium
-- Topics: CTE, Window Functions, LAG, Date Formatting
-- Dataset: Snowflake TPCH

-- Show monthly revenue with MoM percentage change for fulfilled orders

WITH MONTHLY_REVENUE AS (
    SELECT 
        TO_CHAR(O_ORDERDATE, 'YYYY-MM') AS YEAR_MONTH,
        SUM(O_TOTALPRICE) AS TOTAL_REVENUE
    FROM ORDERS
    WHERE O_ORDERSTATUS = 'F'
    GROUP BY TO_CHAR(O_ORDERDATE, 'YYYY-MM')
)

SELECT 
    YEAR_MONTH,
    ROUND(TOTAL_REVENUE, 2) AS TOTAL_REVENUE,
    ROUND(LAG(TOTAL_REVENUE) OVER (ORDER BY YEAR_MONTH), 2) AS PREVIOUS_MONTH_REVENUE,
    ROUND(
        (TOTAL_REVENUE - LAG(TOTAL_REVENUE) OVER (ORDER BY YEAR_MONTH)) 
        / LAG(TOTAL_REVENUE) OVER (ORDER BY YEAR_MONTH) * 100, 
    2) AS MOM_CHANGE_PCT
FROM MONTHLY_REVENUE
ORDER BY YEAR_MONTH;
