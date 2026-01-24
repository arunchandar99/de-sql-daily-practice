-- ============================================================================
-- Problem: Mean Number of Items Per Order (Alibaba)
-- Source: DataLemur / Alibaba
-- Date: 2025-01-22
-- Difficulty: Easy
-- Topics: SQL, Aggregation, Weighted Average, ROUND, PostgreSQL
-- ============================================================================

-- SCENARIO:
-- You're trying to find the mean number of items per order on Alibaba, rounded 
-- to 1 decimal place using tables which includes information on the count of 
-- items in each order (item_count table) and the corresponding number of orders 
-- for each item count (order_occurrences table).

-- TABLE: items_per_order
--   item_count INTEGER
--   order_occurrences INTEGER

-- EXAMPLE INPUT:
-- item_count | order_occurrences
-- -----------|------------------
-- 1          | 500
-- 2          | 1000
-- 3          | 800
-- 4          | 1000

-- EXPECTED OUTPUT:
-- mean
-- -----
-- 2.7

-- EXPLANATION:
-- This is a weighted average calculation:
-- Total items = (1*500) + (2*1000) + (3*800) + (4*1000) = 8900
-- Total orders = 500 + 1000 + 800 + 1000 = 3300
-- Mean = 8900 / 3300 = 2.7

-- MY INITIAL SOLUTION (caused error):
SELECT
    ROUND(SUM(order_occurrences * item_count) / SUM(order_occurrences), 1)
FROM items_per_order;

-- ERROR: function round(double precision, integer) does not exist (LINE: 2)
-- CAUSE: PostgreSQL's ROUND() expects NUMERIC type, not double precision

-- CORRECTED SOLUTION (PostgreSQL):
SELECT
    ROUND((SUM(order_occurrences * item_count) * 1.0 / SUM(order_occurrences))::NUMERIC, 1) AS mean
FROM items_per_order;

-- ALTERNATIVE (using CAST):
SELECT
    ROUND(CAST(SUM(order_occurrences * item_count) * 1.0 / SUM(order_occurrences) AS NUMERIC), 1) AS mean
FROM items_per_order;

-- KEY CONCEPTS:
-- 1. Weighted Average: SUM(value * weight) / SUM(weight)
-- 2. PostgreSQL requires casting to NUMERIC before ROUND()
-- 3. The * 1.0 forces decimal division (not integer division)
-- 4. ::NUMERIC is PostgreSQL shorthand for CAST(... AS NUMERIC)

-- DATABASE DIFFERENCES:
-- MySQL/Snowflake: ROUND() works directly on division result
-- PostgreSQL: Requires explicit CAST to NUMERIC before ROUND()
