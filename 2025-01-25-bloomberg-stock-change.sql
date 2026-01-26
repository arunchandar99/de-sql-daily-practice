-- ============================================================================
-- Problem: FAANG Stock Inter-Month Percentage Change (Bloomberg)
-- Source: DataLemur / Bloomberg
-- Date: 2025-01-25
-- Difficulty: Medium
-- Topics: SQL, LAG(), Window Functions, Percentage Calculation, PARTITION BY
-- ============================================================================

-- SCENARIO:
-- The Bloomberg terminal is the go-to resource for financial professionals, offering 
-- convenient access to a wide array of financial datasets. As a Data Analyst at 
-- Bloomberg, you have access to historical data on stock performance for the FAANG stocks.
--
-- Your task is to analyze the inter-month change in percentage for each FAANG stock 
-- by month over the years. This involves calculating the percentage change in closing 
-- price from one month to the next using the following formula:
--
-- Inter-month change % = (Current month close - Previous month close) / Previous month close × 100
--
-- For each FAANG stock, display the ticker symbol, the last day of the month, closing 
-- price, and the inter-month value change in percentage rounded to two decimal places 
-- for each stock. Ensure that the results are sorted by ticker symbol and date in 
-- chronological order.

-- TABLE: stock_prices
--   date DATETIME
--   ticker VARCHAR
--   open DECIMAL
--   high DECIMAL
--   low DECIMAL
--   close DECIMAL

-- EXAMPLE INPUT (stock_prices):
-- date                | ticker | open   | high   | low   | close
-- --------------------|--------|--------|--------|-------|-------
-- 01/31/2020 00:00:00 | AAPL   | 74.06  | 81.96  | 73.19 | 77.38
-- 02/29/2020 00:00:00 | AAPL   | 76.07  | 81.81  | 64.09 | 68.34
-- 03/31/2020 00:00:00 | AAPL   | 70.57  | 76.00  | 53.15 | 63.57
-- 01/31/2020 00:00:00 | AMZN   | 93.75  | 102.79 | 90.77 | 100.44
-- 02/29/2020 00:00:00 | AMZN   | 100.53 | 109.30 | 90.56 | 94.19
-- 03/31/2020 00:00:00 | AMZN   | 95.32  | 99.82  | 81.30 | 97.49

-- EXPECTED OUTPUT:
-- ticker | date                | close  | intermth_change_pct
-- -------|---------------------|--------|--------------------
-- AAPL   | 01/31/2020 00:00:00 | 77.38  | NULL
-- AAPL   | 02/29/2020 00:00:00 | 68.34  | -11.68
-- AAPL   | 03/31/2020 00:00:00 | 63.57  | -6.98
-- AMZN   | 01/31/2020 00:00:00 | 100.44 | NULL
-- AMZN   | 02/29/2020 00:00:00 | 94.19  | -6.22
-- AMZN   | 03/31/2020 00:00:00 | 97.49  | 3.50

-- EXPLANATION:
-- AAPL Feb 2020: (68.34 - 77.38) / 77.38 × 100 = -11.68%
-- AAPL Mar 2020: (63.57 - 68.34) / 68.34 × 100 = -6.98%
-- AMZN Feb 2020: (94.19 - 100.44) / 100.44 × 100 = -6.22%
-- AMZN Mar 2020: (97.49 - 94.19) / 94.19 × 100 = 3.50%

-- MY SOLUTION:
WITH intermonth_prices AS (
    SELECT 
        ticker,
        date,
        close,
        LAG(close) OVER (PARTITION BY ticker ORDER BY date) AS prev_close
    FROM stock_prices
)
SELECT 
    ticker,
    date,
    close,
    ROUND((close - prev_close) / prev_close * 100, 2) AS intermth_change_pct
FROM intermonth_prices
ORDER BY ticker, date;

-- OPTIMIZED SOLUTION:
SELECT 
    ticker,
    date,
    close,
    ROUND(100.0 * (close - LAG(close) OVER (PARTITION BY ticker ORDER BY date)) 
          / LAG(close) OVER (PARTITION BY ticker ORDER BY date), 2) AS intermth_change_pct
FROM stock_prices
ORDER BY ticker, date;
