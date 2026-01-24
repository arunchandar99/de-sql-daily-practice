-- ============================================================================
-- Problem: Patient Support Analysis (Part 1) - UHG Policy Holder Calls
-- Source: DataLemur / UnitedHealth Group
-- Date: 2025-01-24
-- Difficulty: Easy
-- Topics: SQL, Aggregation, HAVING, COUNT, Subquery
-- ============================================================================

-- SCENARIO:
-- UnitedHealth Group (UHG) has a program called Advocate4Me, which allows policy 
-- holders (or, members) to call an advocate and receive support for their health 
-- care needs – whether that's claims and benefits support, drug coverage, pre- and 
-- post-authorisation, medical records, emergency assistance, or member portal services.
--
-- Write a query to find how many UHG policy holders made three, or more calls, 
-- assuming each call is identified by the case_id column.

-- TABLE: callers
--   policy_holder_id INTEGER
--   case_id VARCHAR
--   call_category VARCHAR
--   call_date TIMESTAMP
--   call_duration_secs INTEGER

-- EXAMPLE INPUT:
-- policy_holder_id | case_id      | call_category         | call_date           | call_duration_secs
-- -----------------|--------------|----------------------|---------------------|-------------------
-- 1                | f1d012f9-... | emergency assistance | 2023-04-13 19:16:53 | 1441
-- 1                | 41ce8fb6-... | authorisation        | 2023-05-25 09:09:30 | 815
-- 2                | 9b1af84b-... | claims assistance    | 2023-01-26 01:21:27 | 992
-- 2                | 8471a3d4-... | emergency assistance | 2023-03-09 10:58:54 | 1282
-- 3                | 8208fae-...  | benefits             | 2023-06-05 07:35:43 | 619

-- EXPECTED OUTPUT:
-- policy_holder_count
-- -------------------
-- 1

-- EXPLANATION:
-- Policy holder ID 2 made 3 calls (case IDs: 9b1af84b, 8471a3d4, and one more not shown).
-- Only 1 policy holder meets the criteria of 3+ calls.

-- MY SOLUTION:
WITH final AS (
    SELECT 
        policy_holder_id, 
        COUNT(case_id)
    FROM callers
    GROUP BY policy_holder_id
    HAVING COUNT(case_id) >= 3
) 
SELECT 
    COUNT(policy_holder_id) AS policy_holder_count
FROM final;

-- OPTIMIZED SOLUTION:
SELECT 
    COUNT(*) AS policy_holder_count
FROM (
    SELECT policy_holder_id
    FROM callers
    GROUP BY policy_holder_id
    HAVING COUNT(case_id) >= 3
) AS holders_with_3plus_calls;
