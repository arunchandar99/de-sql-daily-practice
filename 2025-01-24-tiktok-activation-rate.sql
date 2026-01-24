-- ============================================================================
-- Problem: User Activation Rate (TikTok)
-- Source: DataLemur / TikTok
-- Date: 2025-01-24
-- Difficulty: Easy
-- Topics: SQL, LEFT JOIN, Percentage Calculation, CAST, COUNT
-- ============================================================================

-- SCENARIO:
-- New TikTok users sign up with their emails. They confirmed their signup by 
-- replying to the text confirmation to activate their accounts. Users may receive 
-- multiple text messages for account confirmation until they have confirmed their 
-- new account.
--
-- A senior analyst is interested to know the activation rate of specified users 
-- in the emails table. Write a query to find the activation rate. Round the 
-- percentage to 2 decimal places.
--
-- DEFINITIONS:
-- - emails table: user signup details
-- - texts table: users' activation information
-- - 'Confirmed' in signup_action means account is activated
--
-- ASSUMPTIONS:
-- - The analyst is interested in activation rate of users in the emails table only
-- - Not all users in emails may be in texts, and vice versa

-- TABLE: emails
--   email_id INTEGER
--   user_id INTEGER
--   signup_date DATETIME

-- TABLE: texts
--   text_id INTEGER
--   email_id INTEGER
--   signup_action VARCHAR ('Confirmed', 'Not Confirmed')

-- EXAMPLE INPUT (emails):
-- email_id | user_id | signup_date
-- ---------|---------|------------------
-- 125      | 7771    | 06/14/2022 00:00:00
-- 236      | 6950    | 07/01/2022 00:00:00
-- 433      | 1052    | 07/09/2022 00:00:00

-- EXAMPLE INPUT (texts):
-- text_id | email_id | signup_action
-- --------|----------|---------------
-- 6878    | 125      | Confirmed
-- 6920    | 236      | Not Confirmed
-- 6994    | 236      | Confirmed

-- EXPECTED OUTPUT:
-- confirm_rate
-- -------------
-- 0.67

-- EXPLANATION:
-- - Total emails: 3
-- - Confirmed emails: 2 (email_id 125 and 236)
-- - Activation rate: 2/3 = 0.67 (67%)

-- MY SOLUTION:
SELECT 
    ROUND(COUNT(texts.email_id)::DECIMAL / COUNT(DISTINCT emails.email_id), 2) AS activation_rate
FROM emails
LEFT JOIN texts ON emails.email_id = texts.email_id
    AND texts.signup_action = 'Confirmed';

-- OPTIMIZED SOLUTION:
SELECT 
    ROUND(
        COUNT(DISTINCT CASE WHEN texts.signup_action = 'Confirmed' THEN emails.email_id END)::DECIMAL 
        / COUNT(DISTINCT emails.email_id), 
        2
    ) AS confirm_rate
FROM emails
LEFT JOIN texts ON emails.email_id = texts.email_id;
