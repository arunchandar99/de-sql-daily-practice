-- ============================================================================
-- SQL TRAINING DATASET FOR SNOWFLAKE
-- Covers: SELECT, JOINs, CTEs, Subqueries, Window Functions, CASE, NULLs,
--         String/Date/Aggregate Functions, Query Optimization, and more
-- ============================================================================
-- Run this entire script in Snowflake to create your practice environment
-- ============================================================================

-- Create a dedicated schema for practice
CREATE OR REPLACE SCHEMA SQL_TRAINING;
USE SCHEMA SQL_TRAINING;

-- ============================================================================
-- TABLE 1: EMPLOYEES (Self-joins, hierarchies, NULLs)
-- ============================================================================
CREATE OR REPLACE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    hire_date DATE,
    job_title VARCHAR(100),
    department_id INT,
    manager_id INT,  -- Self-reference for org hierarchy
    salary DECIMAL(12,2),
    commission_pct DECIMAL(5,4),  -- Some NULLs for NULL handling practice
    is_active BOOLEAN DEFAULT TRUE
);

INSERT INTO employees VALUES
-- Executive Level (no manager)
(1, 'Sarah', 'Chen', 'sarah.chen@company.com', '407-555-0101', '2018-03-15', 'CEO', 1, NULL, 250000.00, NULL, TRUE),

-- Department Heads (report to CEO)
(2, 'Michael', 'Rodriguez', 'michael.r@company.com', '407-555-0102', '2019-01-10', 'VP Sales', 2, 1, 175000.00, 0.05, TRUE),
(3, 'Jennifer', 'Patel', 'jennifer.p@company.com', '407-555-0103', '2019-06-20', 'VP Operations', 3, 1, 165000.00, NULL, TRUE),
(4, 'David', 'Kim', 'david.kim@company.com', '407-555-0104', '2020-02-01', 'VP Finance', 4, 1, 160000.00, NULL, TRUE),
(5, 'Amanda', 'Johnson', 'amanda.j@company.com', '407-555-0105', '2020-08-15', 'VP Technology', 5, 1, 170000.00, NULL, TRUE),

-- Sales Team (report to VP Sales)
(6, 'Robert', 'Williams', 'robert.w@company.com', '407-555-0106', '2021-03-01', 'Regional Sales Manager', 2, 2, 95000.00, 0.04, TRUE),
(7, 'Lisa', 'Martinez', 'lisa.m@company.com', '407-555-0107', '2021-04-15', 'Regional Sales Manager', 2, 2, 92000.00, 0.04, TRUE),
(8, 'James', 'Brown', 'james.b@company.com', '407-555-0108', '2021-09-01', 'Sales Representative', 2, 6, 65000.00, 0.03, TRUE),
(9, 'Emily', 'Davis', 'emily.d@company.com', '407-555-0109', '2022-01-15', 'Sales Representative', 2, 6, 62000.00, 0.03, TRUE),
(10, 'Chris', 'Garcia', 'chris.g@company.com', '407-555-0110', '2022-03-01', 'Sales Representative', 2, 7, 60000.00, 0.03, TRUE),
(11, 'Ashley', 'Wilson', 'ashley.w@company.com', '407-555-0111', '2022-06-15', 'Sales Representative', 2, 7, 58000.00, 0.025, TRUE),
(12, 'Daniel', 'Lee', 'daniel.l@company.com', '407-555-0112', '2023-02-01', 'Sales Representative', 2, 6, 55000.00, 0.025, FALSE),  -- Inactive

-- Operations Team (report to VP Operations)
(13, 'Michelle', 'Taylor', 'michelle.t@company.com', '407-555-0113', '2021-05-01', 'Operations Manager', 3, 3, 85000.00, NULL, TRUE),
(14, 'Kevin', 'Anderson', 'kevin.a@company.com', '407-555-0114', '2021-07-15', 'Operations Analyst', 3, 13, 62000.00, NULL, TRUE),
(15, 'Rachel', 'Thomas', 'rachel.t@company.com', '407-555-0115', '2022-02-01', 'Operations Analyst', 3, 13, 58000.00, NULL, TRUE),
(16, 'Brian', 'Jackson', 'brian.j@company.com', '407-555-0116', '2022-08-01', 'Operations Coordinator', 3, 13, 48000.00, NULL, TRUE),

-- Finance Team (report to VP Finance)
(17, 'Nicole', 'White', 'nicole.w@company.com', '407-555-0117', '2020-11-01', 'Finance Manager', 4, 4, 90000.00, NULL, TRUE),
(18, 'Steven', 'Harris', 'steven.h@company.com', '407-555-0118', '2021-02-15', 'Senior Accountant', 4, 17, 72000.00, NULL, TRUE),
(19, 'Laura', 'Clark', 'laura.c@company.com', '407-555-0119', '2022-04-01', 'Staff Accountant', 4, 17, 55000.00, NULL, TRUE),
(20, 'Mark', 'Lewis', 'mark.l@company.com', '407-555-0120', '2023-01-15', 'Staff Accountant', 4, 17, 52000.00, NULL, TRUE),

-- Technology Team (report to VP Technology)
(21, 'Jessica', 'Robinson', 'jessica.r@company.com', '407-555-0121', '2021-01-01', 'Engineering Manager', 5, 5, 120000.00, NULL, TRUE),
(22, 'Andrew', 'Walker', 'andrew.w@company.com', '407-555-0122', '2021-06-01', 'Senior Developer', 5, 21, 105000.00, NULL, TRUE),
(23, 'Megan', 'Hall', 'megan.h@company.com', '407-555-0123', '2022-01-15', 'Developer', 5, 21, 85000.00, NULL, TRUE),
(24, 'Ryan', 'Allen', 'ryan.a@company.com', '407-555-0124', '2022-09-01', 'Junior Developer', 5, 21, 65000.00, NULL, TRUE),
(25, 'Samantha', 'Young', 'samantha.y@company.com', '407-555-0125', '2023-03-01', 'Data Analyst', 5, 21, 70000.00, NULL, TRUE),

-- Additional employees with various data patterns
(26, 'Thomas', 'King', NULL, '407-555-0126', '2023-06-01', 'Intern', 2, 6, 35000.00, NULL, TRUE),  -- NULL email
(27, 'Patricia', 'Wright', 'patricia.w@company.com', NULL, '2023-07-15', 'Intern', 3, 13, 35000.00, NULL, TRUE),  -- NULL phone
(28, 'Christopher', 'Scott', 'chris.scott@company.com', '407-555-0128', '2024-01-02', 'Sales Representative', 2, 7, 58000.00, 0.02, TRUE),
(29, 'Elizabeth', 'Green', 'elizabeth.g@company.com', '407-555-0129', '2024-02-15', 'Operations Analyst', 3, 13, 56000.00, NULL, TRUE),
(30, 'Joseph', 'Adams', 'joseph.a@company.com', '407-555-0130', '2024-03-01', 'Staff Accountant', 4, 17, 50000.00, NULL, TRUE);


-- ============================================================================
-- TABLE 2: DEPARTMENTS (Basic joins, aggregations)
-- ============================================================================
CREATE OR REPLACE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100),
    location VARCHAR(100),
    budget DECIMAL(15,2),
    created_date DATE
);

INSERT INTO departments VALUES
(1, 'Executive', 'Orlando HQ - Floor 10', 500000.00, '2018-01-01'),
(2, 'Sales', 'Orlando HQ - Floor 5', 1200000.00, '2018-01-01'),
(3, 'Operations', 'Orlando HQ - Floor 3', 800000.00, '2018-01-01'),
(4, 'Finance', 'Orlando HQ - Floor 4', 600000.00, '2018-01-01'),
(5, 'Technology', 'Orlando HQ - Floor 6', 1500000.00, '2018-01-01'),
(6, 'Marketing', 'Orlando HQ - Floor 2', 750000.00, '2019-06-01'),  -- No employees yet (for OUTER JOIN practice)
(7, 'Human Resources', 'Orlando HQ - Floor 1', 400000.00, '2020-01-01');  -- No employees yet


-- ============================================================================
-- TABLE 3: REGIONS (Geographic hierarchy)
-- ============================================================================
CREATE OR REPLACE TABLE regions (
    region_id INT PRIMARY KEY,
    region_name VARCHAR(50),
    country VARCHAR(50),
    timezone VARCHAR(50)
);

INSERT INTO regions VALUES
(1, 'Northeast', 'USA', 'America/New_York'),
(2, 'Southeast', 'USA', 'America/New_York'),
(3, 'Midwest', 'USA', 'America/Chicago'),
(4, 'Southwest', 'USA', 'America/Denver'),
(5, 'West', 'USA', 'America/Los_Angeles'),
(6, 'Canada East', 'Canada', 'America/Toronto'),
(7, 'Canada West', 'Canada', 'America/Vancouver'),
(8, 'UK', 'United Kingdom', 'Europe/London'),
(9, 'Europe', 'Germany', 'Europe/Berlin');


-- ============================================================================
-- TABLE 4: CUSTOMERS (String functions, NULLs, varied data quality)
-- ============================================================================
CREATE OR REPLACE TABLE customers (
    customer_id INT PRIMARY KEY,
    company_name VARCHAR(200),
    contact_first_name VARCHAR(50),
    contact_last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(30),
    address_line1 VARCHAR(200),
    address_line2 VARCHAR(200),  -- Often NULL
    city VARCHAR(100),
    state_province VARCHAR(50),
    postal_code VARCHAR(20),
    country VARCHAR(50),
    region_id INT,
    customer_tier VARCHAR(20),  -- Gold, Silver, Bronze, NULL
    credit_limit DECIMAL(12,2),
    created_date DATE,
    last_order_date DATE,  -- NULL if never ordered
    notes TEXT  -- For string function practice
);

INSERT INTO customers VALUES
-- Northeast Region
(1001, 'Acme Corporation', 'John', 'Smith', 'jsmith@acme.com', '(212) 555-1001', '123 Broadway', 'Suite 500', 'New York', 'NY', '10001', 'USA', 1, 'Gold', 500000.00, '2020-01-15', '2024-11-15', 'Long-term customer; prefers email contact'),
(1002, 'Global Industries Inc', 'Mary', 'Johnson', 'mjohnson@globalind.com', '617-555-1002', '456 State Street', NULL, 'Boston', 'MA', '02101', 'USA', 1, 'Gold', 750000.00, '2020-03-20', '2024-12-01', 'VIP treatment required'),
(1003, 'Tech Solutions LLC', 'Robert', 'Williams', 'rwilliams@techsol.com', '215.555.1003', '789 Market St', 'Floor 3', 'Philadelphia', 'PA', '19101', 'USA', 1, 'Silver', 250000.00, '2021-02-10', '2024-10-20', NULL),

-- Southeast Region  
(1004, 'Sunshine Enterprises', 'Patricia', 'Brown', 'pbrown@sunshine.com', '305-555-1004', '321 Ocean Drive', NULL, 'Miami', 'FL', '33101', 'USA', 2, 'Gold', 600000.00, '2020-06-01', '2024-12-10', 'Seasonal ordering pattern; Q4 heavy'),
(1005, 'Southern Trading Co', 'Michael', 'Davis', 'mdavis@southtrade.com', '(404) 555-1005', '654 Peachtree St', 'Building B', 'Atlanta', 'GA', '30301', 'USA', 2, 'Silver', 300000.00, '2021-04-15', '2024-09-30', 'Payment terms: Net 45'),
(1006, 'Orlando Business Group', 'Jennifer', 'Miller', 'jmiller@obg.com', '407-555-1006', '987 Colonial Dr', NULL, 'Orlando', 'FL', '32801', 'USA', 2, 'Bronze', 100000.00, '2022-01-20', '2024-08-15', NULL),

-- Midwest Region
(1007, 'Midwest Manufacturing', 'William', 'Wilson', 'wwilson@mwmfg.com', '312 555 1007', '147 Michigan Ave', 'Suite 200', 'Chicago', 'IL', '60601', 'USA', 3, 'Gold', 450000.00, '2020-08-10', '2024-11-20', 'Large volume orders; quarterly'),
(1008, 'Great Lakes Supply', 'Elizabeth', 'Moore', 'emoore@greatlakes.com', '(313)555-1008', '258 Woodward Ave', NULL, 'Detroit', 'MI', '48201', 'USA', 3, 'Silver', 200000.00, '2021-07-01', '2024-07-10', NULL),
(1009, 'Heartland Corp', 'David', 'Taylor', 'dtaylor@heartland.com', '614-555-1009', '369 High Street', NULL, 'Columbus', 'OH', '43201', 'USA', 3, 'Bronze', 150000.00, '2022-03-15', NULL, 'New customer; no orders yet'),

-- Southwest Region
(1010, 'Desert Holdings', 'Barbara', 'Anderson', 'banderson@deserthold.com', '602.555.1010', '741 Camelback Rd', 'Suite 100', 'Phoenix', 'AZ', '85001', 'USA', 4, 'Gold', 550000.00, '2020-02-28', '2024-12-05', 'Prefers phone calls'),
(1011, 'Texas Global Trade', 'Richard', 'Thomas', 'rthomas@txglobal.com', '214-555-1011', '852 Commerce St', NULL, 'Dallas', 'TX', '75201', 'USA', 4, 'Silver', 350000.00, '2021-05-20', '2024-10-30', NULL),
(1012, 'Mountain West Inc', 'Susan', 'Jackson', 'sjackson@mtnwest.com', '(303) 555-1012', '963 16th Street', 'Floor 5', 'Denver', 'CO', '80201', 'USA', 4, 'Bronze', 125000.00, '2022-09-01', '2024-06-15', 'High growth potential'),

-- West Region
(1013, 'Pacific Rim Industries', 'Joseph', 'White', 'jwhite@pacrim.com', '415-555-1013', '159 Market Street', NULL, 'San Francisco', 'CA', '94101', 'USA', 5, 'Gold', 800000.00, '2019-11-15', '2024-12-12', 'Largest West coast customer'),
(1014, 'Silicon Valley Tech', 'Margaret', 'Harris', 'mharris@svtech.com', '(408) 555-1014', '357 Innovation Way', 'Building C', 'San Jose', 'CA', '95101', 'USA', 5, 'Gold', 650000.00, '2020-04-01', '2024-11-28', 'Tech sector; fast payment'),
(1015, 'LA Entertainment Group', 'Charles', 'Martin', 'cmartin@laent.com', '310.555.1015', '753 Sunset Blvd', NULL, 'Los Angeles', 'CA', '90001', 'USA', 5, 'Silver', 400000.00, '2021-01-10', '2024-09-15', NULL),
(1016, 'Seattle Dynamics', 'Dorothy', 'Garcia', 'dgarcia@seattledyn.com', '206-555-1016', '951 Pike Street', 'Suite 300', 'Seattle', 'WA', '98101', 'USA', 5, 'Silver', 275000.00, '2021-08-20', '2024-10-05', 'Growing account'),

-- Canada
(1017, 'Toronto Financial Services', 'Daniel', 'Martinez', 'dmartinez@torfinserv.ca', '+1-416-555-1017', '123 Bay Street', 'Floor 20', 'Toronto', 'ON', 'M5H 2Y4', 'Canada', 6, 'Gold', 500000.00, '2020-07-01', '2024-11-10', 'Canadian HQ for North America'),
(1018, 'Vancouver Tech Hub', 'Nancy', 'Robinson', 'nrobinson@vantechhub.ca', '+1 (604) 555-1018', '456 Burrard St', NULL, 'Vancouver', 'BC', 'V6C 2T6', 'Canada', 7, 'Silver', 225000.00, '2021-10-15', '2024-08-20', NULL),
(1019, 'Montreal Exports', 'Paul', 'Clark', 'pclark@mtlexports.ca', '+1-514-555-1019', '789 St. Catherine', 'Bureau 400', 'Montreal', 'QC', 'H3B 4G7', 'Canada', 6, 'Bronze', 175000.00, '2022-05-01', '2024-07-30', 'Bilingual communications preferred'),

-- UK / Europe
(1020, 'London Trading Ltd', 'Andrew', 'Lewis', 'alewis@londontrade.co.uk', '+44 20 7555 1020', '10 Downing Business Park', NULL, 'London', NULL, 'SW1A 2AA', 'United Kingdom', 8, 'Gold', 450000.00, '2020-09-01', '2024-12-08', 'European operations hub'),
(1021, 'Berlin Innovations GmbH', 'Maria', 'Walker', 'mwalker@berlininno.de', '+49 30 555 1021', 'Friedrichstraße 123', NULL, 'Berlin', NULL, '10117', 'Germany', 9, 'Silver', 300000.00, '2021-11-01', '2024-10-15', 'Wire transfer preferred'),

-- Edge cases for practice
(1022, 'Startup XYZ', 'Test', 'User', NULL, NULL, '999 New St', NULL, 'Austin', 'TX', '78701', 'USA', 4, NULL, 50000.00, '2024-01-01', NULL, NULL),  -- New, no tier, no email/phone, no orders
(1023, 'LEGACY CORP', 'OLD', 'DATA', 'LEGACY@OLD.COM', '000-000-0000', 'unknown', NULL, 'Unknown', 'XX', '00000', 'USA', NULL, 'Bronze', 10000.00, '2015-01-01', '2020-01-01', 'INACTIVE - DO NOT CONTACT'),  -- Old data, NULL region
(1024, 'Test & Demo Company', 'Jane', 'O''Brien', 'jane.obrien@test-demo.com', '555-TEST-123', '100 Main St.', 'Apt. #5', 'San Diego', 'CA', '92101', 'USA', 5, 'Silver', 200000.00, '2023-06-15', '2024-11-01', 'Name has apostrophe; special chars in address');


-- ============================================================================
-- TABLE 5: PRODUCTS (For order details, aggregations)
-- ============================================================================
CREATE OR REPLACE TABLE products (
    product_id INT PRIMARY KEY,
    product_code VARCHAR(20),
    product_name VARCHAR(200),
    category VARCHAR(50),
    subcategory VARCHAR(50),
    unit_price DECIMAL(10,2),
    cost DECIMAL(10,2),
    is_active BOOLEAN DEFAULT TRUE,
    launch_date DATE,
    discontinued_date DATE  -- NULL if still active
);

INSERT INTO products VALUES
-- Currency Exchange Products
(101, 'FX-USD-EUR', 'USD to EUR Exchange', 'Currency Exchange', 'Major Pairs', 5.00, 1.50, TRUE, '2018-01-01', NULL),
(102, 'FX-USD-GBP', 'USD to GBP Exchange', 'Currency Exchange', 'Major Pairs', 5.00, 1.50, TRUE, '2018-01-01', NULL),
(103, 'FX-USD-CAD', 'USD to CAD Exchange', 'Currency Exchange', 'Major Pairs', 4.00, 1.25, TRUE, '2018-01-01', NULL),
(104, 'FX-USD-MXN', 'USD to MXN Exchange', 'Currency Exchange', 'Emerging', 6.00, 2.00, TRUE, '2018-06-01', NULL),
(105, 'FX-USD-JPY', 'USD to JPY Exchange', 'Currency Exchange', 'Major Pairs', 5.50, 1.75, TRUE, '2018-01-01', NULL),
(106, 'FX-EUR-GBP', 'EUR to GBP Exchange', 'Currency Exchange', 'Cross Rates', 4.50, 1.40, TRUE, '2019-01-01', NULL),
(107, 'FX-EXOTIC', 'Exotic Currency Bundle', 'Currency Exchange', 'Exotic', 15.00, 5.00, TRUE, '2020-01-01', NULL),

-- Payment Products
(201, 'WIRE-DOM', 'Domestic Wire Transfer', 'Payments', 'Wire', 25.00, 8.00, TRUE, '2018-01-01', NULL),
(202, 'WIRE-INTL', 'International Wire Transfer', 'Payments', 'Wire', 45.00, 15.00, TRUE, '2018-01-01', NULL),
(203, 'ACH-STD', 'Standard ACH Transfer', 'Payments', 'ACH', 3.00, 0.50, TRUE, '2018-01-01', NULL),
(204, 'ACH-SAMEDAY', 'Same Day ACH Transfer', 'Payments', 'ACH', 10.00, 2.50, TRUE, '2019-06-01', NULL),
(205, 'DRAFT-BANK', 'Bank Draft', 'Payments', 'Draft', 15.00, 4.00, TRUE, '2018-01-01', NULL),
(206, 'DRAFT-INTL', 'International Bank Draft', 'Payments', 'Draft', 35.00, 12.00, TRUE, '2018-01-01', NULL),

-- Value Added Services
(301, 'HEDGE-FWD', 'Forward Contract Hedge', 'Hedging', 'Forwards', 100.00, 25.00, TRUE, '2019-01-01', NULL),
(302, 'HEDGE-OPT', 'Currency Option', 'Hedging', 'Options', 150.00, 40.00, TRUE, '2020-01-01', NULL),
(303, 'CONSULT-FX', 'FX Consultation (hourly)', 'Services', 'Consulting', 200.00, 50.00, TRUE, '2019-06-01', NULL),
(304, 'REPORT-CUSTOM', 'Custom Reporting Package', 'Services', 'Reporting', 500.00, 100.00, TRUE, '2020-06-01', NULL),

-- Discontinued products (for filtering practice)
(401, 'FX-LEGACY', 'Legacy Exchange Product', 'Currency Exchange', 'Legacy', 10.00, 5.00, FALSE, '2018-01-01', '2022-06-30'),
(402, 'WIRE-OLD', 'Old Wire System', 'Payments', 'Legacy', 30.00, 12.00, FALSE, '2018-01-01', '2021-12-31');


-- ============================================================================
-- TABLE 6: ORDERS (Main transaction table)
-- ============================================================================
CREATE OR REPLACE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    employee_id INT,  -- Sales rep
    order_date DATE,
    required_date DATE,
    shipped_date DATE,  -- NULL if not shipped
    status VARCHAR(20),  -- Pending, Processing, Shipped, Delivered, Cancelled
    payment_method VARCHAR(30),
    subtotal DECIMAL(12,2),
    tax_amount DECIMAL(10,2),
    shipping_cost DECIMAL(10,2),
    discount_amount DECIMAL(10,2),
    total_amount DECIMAL(12,2),
    notes TEXT
);

-- Generate realistic order data spanning 2022-2024
-- I'll create orders with various patterns for analysis practice

INSERT INTO orders VALUES
-- 2022 Orders
(10001, 1001, 8, '2022-01-15', '2022-01-22', '2022-01-20', 'Delivered', 'Wire Transfer', 15000.00, 1200.00, 50.00, 0.00, 16250.00, NULL),
(10002, 1004, 9, '2022-01-28', '2022-02-04', '2022-02-02', 'Delivered', 'ACH', 8500.00, 680.00, 25.00, 425.00, 8780.00, 'Repeat customer discount'),
(10003, 1007, 10, '2022-02-10', '2022-02-17', '2022-02-15', 'Delivered', 'Wire Transfer', 22000.00, 1760.00, 75.00, 0.00, 23835.00, NULL),
(10004, 1013, 11, '2022-02-22', '2022-03-01', '2022-02-28', 'Delivered', 'Credit Card', 5200.00, 416.00, 25.00, 0.00, 5641.00, NULL),
(10005, 1002, 8, '2022-03-05', '2022-03-12', '2022-03-10', 'Delivered', 'Wire Transfer', 45000.00, 3600.00, 100.00, 2250.00, 46450.00, 'VIP discount applied'),
(10006, 1010, 9, '2022-03-18', '2022-03-25', '2022-03-23', 'Delivered', 'ACH', 12500.00, 1000.00, 50.00, 0.00, 13550.00, NULL),
(10007, 1005, 10, '2022-04-02', '2022-04-09', '2022-04-07', 'Delivered', 'Wire Transfer', 18000.00, 1440.00, 50.00, 900.00, 18590.00, NULL),
(10008, 1014, 11, '2022-04-15', '2022-04-22', '2022-04-20', 'Delivered', 'Credit Card', 9800.00, 784.00, 35.00, 0.00, 10619.00, NULL),
(10009, 1017, 8, '2022-05-01', '2022-05-08', '2022-05-06', 'Delivered', 'Wire Transfer', 32000.00, 2560.00, 150.00, 1600.00, 33110.00, 'International shipping'),
(10010, 1003, 9, '2022-05-20', '2022-05-27', '2022-05-25', 'Delivered', 'ACH', 7500.00, 600.00, 25.00, 0.00, 8125.00, NULL),
(10011, 1020, 10, '2022-06-08', '2022-06-15', '2022-06-14', 'Delivered', 'Wire Transfer', 28000.00, 2240.00, 200.00, 1400.00, 29040.00, 'UK customer'),
(10012, 1001, 11, '2022-06-25', '2022-07-02', '2022-06-30', 'Delivered', 'Wire Transfer', 19500.00, 1560.00, 50.00, 975.00, 20135.00, NULL),
(10013, 1008, 8, '2022-07-10', '2022-07-17', '2022-07-15', 'Delivered', 'ACH', 6200.00, 496.00, 25.00, 0.00, 6721.00, NULL),
(10014, 1011, 9, '2022-07-28', '2022-08-04', '2022-08-02', 'Delivered', 'Credit Card', 14000.00, 1120.00, 50.00, 700.00, 14470.00, NULL),
(10015, 1004, 10, '2022-08-12', '2022-08-19', '2022-08-17', 'Delivered', 'Wire Transfer', 25000.00, 2000.00, 75.00, 1250.00, 25825.00, NULL),
(10016, 1015, 11, '2022-08-30', '2022-09-06', '2022-09-05', 'Delivered', 'ACH', 11000.00, 880.00, 35.00, 0.00, 11915.00, NULL),
(10017, 1007, 8, '2022-09-15', '2022-09-22', '2022-09-20', 'Delivered', 'Wire Transfer', 38000.00, 3040.00, 100.00, 1900.00, 39240.00, 'Quarterly order'),
(10018, 1002, 9, '2022-10-01', '2022-10-08', '2022-10-06', 'Delivered', 'Wire Transfer', 52000.00, 4160.00, 125.00, 2600.00, 53685.00, NULL),
(10019, 1013, 10, '2022-10-20', '2022-10-27', '2022-10-25', 'Delivered', 'Credit Card', 8900.00, 712.00, 35.00, 0.00, 9647.00, NULL),
(10020, 1006, 11, '2022-11-05', '2022-11-12', '2022-11-10', 'Delivered', 'ACH', 4500.00, 360.00, 25.00, 0.00, 4885.00, NULL),
(10021, 1010, 8, '2022-11-22', '2022-11-29', '2022-11-28', 'Delivered', 'Wire Transfer', 21000.00, 1680.00, 50.00, 1050.00, 21680.00, NULL),
(10022, 1001, 9, '2022-12-05', '2022-12-12', '2022-12-10', 'Delivered', 'Wire Transfer', 35000.00, 2800.00, 75.00, 1750.00, 36125.00, 'Year-end order'),
(10023, 1014, 10, '2022-12-18', '2022-12-25', NULL, 'Cancelled', 'Credit Card', 15000.00, 1200.00, 50.00, 0.00, 16250.00, 'Customer requested cancellation'),

-- 2023 Orders (more volume)
(10024, 1002, 8, '2023-01-10', '2023-01-17', '2023-01-15', 'Delivered', 'Wire Transfer', 48000.00, 3840.00, 100.00, 2400.00, 49540.00, NULL),
(10025, 1004, 9, '2023-01-22', '2023-01-29', '2023-01-27', 'Delivered', 'ACH', 16500.00, 1320.00, 50.00, 825.00, 17045.00, NULL),
(10026, 1017, 10, '2023-02-05', '2023-02-12', '2023-02-10', 'Delivered', 'Wire Transfer', 42000.00, 3360.00, 175.00, 2100.00, 43435.00, NULL),
(10027, 1007, 11, '2023-02-18', '2023-02-25', '2023-02-23', 'Delivered', 'Wire Transfer', 29000.00, 2320.00, 75.00, 1450.00, 29945.00, NULL),
(10028, 1013, 8, '2023-03-02', '2023-03-09', '2023-03-07', 'Delivered', 'Credit Card', 12000.00, 960.00, 50.00, 600.00, 12410.00, NULL),
(10029, 1001, 9, '2023-03-15', '2023-03-22', '2023-03-20', 'Delivered', 'Wire Transfer', 55000.00, 4400.00, 125.00, 2750.00, 56775.00, 'Large order - VIP'),
(10030, 1020, 10, '2023-03-28', '2023-04-04', '2023-04-03', 'Delivered', 'Wire Transfer', 31000.00, 2480.00, 225.00, 1550.00, 32155.00, NULL),
(10031, 1005, 11, '2023-04-10', '2023-04-17', '2023-04-15', 'Delivered', 'ACH', 14500.00, 1160.00, 50.00, 725.00, 14985.00, NULL),
(10032, 1011, 8, '2023-04-25', '2023-05-02', '2023-04-30', 'Delivered', 'Wire Transfer', 23000.00, 1840.00, 75.00, 1150.00, 23765.00, NULL),
(10033, 1014, 9, '2023-05-08', '2023-05-15', '2023-05-12', 'Delivered', 'Credit Card', 18500.00, 1480.00, 50.00, 925.00, 19105.00, NULL),
(10034, 1003, 10, '2023-05-22', '2023-05-29', '2023-05-26', 'Delivered', 'ACH', 9200.00, 736.00, 35.00, 0.00, 9971.00, NULL),
(10035, 1010, 11, '2023-06-05', '2023-06-12', '2023-06-09', 'Delivered', 'Wire Transfer', 27500.00, 2200.00, 75.00, 1375.00, 28400.00, NULL),
(10036, 1002, 8, '2023-06-20', '2023-06-27', '2023-06-25', 'Delivered', 'Wire Transfer', 62000.00, 4960.00, 150.00, 3100.00, 64010.00, 'Mid-year large order'),
(10037, 1016, 9, '2023-07-03', '2023-07-10', '2023-07-08', 'Delivered', 'ACH', 8800.00, 704.00, 35.00, 0.00, 9539.00, NULL),
(10038, 1004, 10, '2023-07-18', '2023-07-25', '2023-07-22', 'Delivered', 'Wire Transfer', 33000.00, 2640.00, 75.00, 1650.00, 34065.00, NULL),
(10039, 1007, 11, '2023-08-01', '2023-08-08', '2023-08-06', 'Delivered', 'Wire Transfer', 41000.00, 3280.00, 100.00, 2050.00, 42330.00, NULL),
(10040, 1013, 8, '2023-08-15', '2023-08-22', '2023-08-20', 'Delivered', 'Credit Card', 15500.00, 1240.00, 50.00, 775.00, 16015.00, NULL),
(10041, 1021, 9, '2023-08-28', '2023-09-04', '2023-09-02', 'Delivered', 'Wire Transfer', 19000.00, 1520.00, 200.00, 950.00, 19770.00, 'Germany'),
(10042, 1001, 10, '2023-09-10', '2023-09-17', '2023-09-15', 'Delivered', 'Wire Transfer', 47000.00, 3760.00, 100.00, 2350.00, 48510.00, NULL),
(10043, 1018, 11, '2023-09-25', '2023-10-02', '2023-09-30', 'Delivered', 'ACH', 7200.00, 576.00, 75.00, 0.00, 7851.00, 'Vancouver'),
(10044, 1005, 8, '2023-10-08', '2023-10-15', '2023-10-13', 'Delivered', 'Wire Transfer', 16000.00, 1280.00, 50.00, 800.00, 16530.00, NULL),
(10045, 1014, 9, '2023-10-22', '2023-10-29', '2023-10-27', 'Delivered', 'Credit Card', 24500.00, 1960.00, 75.00, 1225.00, 25310.00, NULL),
(10046, 1010, 10, '2023-11-05', '2023-11-12', '2023-11-10', 'Delivered', 'Wire Transfer', 36000.00, 2880.00, 100.00, 1800.00, 37180.00, NULL),
(10047, 1002, 11, '2023-11-18', '2023-11-25', '2023-11-23', 'Delivered', 'Wire Transfer', 71000.00, 5680.00, 175.00, 3550.00, 73305.00, 'Holiday season'),
(10048, 1017, 8, '2023-12-02', '2023-12-09', '2023-12-07', 'Delivered', 'Wire Transfer', 38500.00, 3080.00, 175.00, 1925.00, 39830.00, NULL),
(10049, 1004, 9, '2023-12-15', '2023-12-22', '2023-12-20', 'Delivered', 'ACH', 28000.00, 2240.00, 75.00, 1400.00, 28915.00, 'Q4 push'),
(10050, 1013, 10, '2023-12-28', '2024-01-04', '2024-01-03', 'Delivered', 'Credit Card', 21000.00, 1680.00, 75.00, 1050.00, 21705.00, NULL),

-- 2024 Orders (current year - mix of statuses)
(10051, 1001, 8, '2024-01-08', '2024-01-15', '2024-01-12', 'Delivered', 'Wire Transfer', 58000.00, 4640.00, 125.00, 2900.00, 59865.00, NULL),
(10052, 1007, 9, '2024-01-20', '2024-01-27', '2024-01-25', 'Delivered', 'Wire Transfer', 44000.00, 3520.00, 100.00, 2200.00, 45420.00, NULL),
(10053, 1020, 10, '2024-02-03', '2024-02-10', '2024-02-08', 'Delivered', 'Wire Transfer', 35500.00, 2840.00, 225.00, 1775.00, 36790.00, NULL),
(10054, 1002, 11, '2024-02-15', '2024-02-22', '2024-02-20', 'Delivered', 'Wire Transfer', 82000.00, 6560.00, 200.00, 4100.00, 84660.00, 'Largest Q1 order'),
(10055, 1014, 8, '2024-03-01', '2024-03-08', '2024-03-06', 'Delivered', 'Credit Card', 19500.00, 1560.00, 50.00, 975.00, 20135.00, NULL),
(10056, 1010, 9, '2024-03-15', '2024-03-22', '2024-03-20', 'Delivered', 'Wire Transfer', 31000.00, 2480.00, 75.00, 1550.00, 32005.00, NULL),
(10057, 1004, 10, '2024-03-28', '2024-04-04', '2024-04-02', 'Delivered', 'ACH', 26000.00, 2080.00, 75.00, 1300.00, 26855.00, NULL),
(10058, 1017, 11, '2024-04-10', '2024-04-17', '2024-04-15', 'Delivered', 'Wire Transfer', 49000.00, 3920.00, 175.00, 2450.00, 50645.00, NULL),
(10059, 1001, 8, '2024-04-25', '2024-05-02', '2024-04-30', 'Delivered', 'Wire Transfer', 43000.00, 3440.00, 100.00, 2150.00, 44390.00, NULL),
(10060, 1013, 9, '2024-05-08', '2024-05-15', '2024-05-13', 'Delivered', 'Credit Card', 17500.00, 1400.00, 50.00, 875.00, 18075.00, NULL),
(10061, 1005, 10, '2024-05-22', '2024-05-29', '2024-05-27', 'Delivered', 'ACH', 13000.00, 1040.00, 50.00, 650.00, 13440.00, NULL),
(10062, 1011, 11, '2024-06-05', '2024-06-12', '2024-06-10', 'Delivered', 'Wire Transfer', 28500.00, 2280.00, 75.00, 1425.00, 29430.00, NULL),
(10063, 1002, 8, '2024-06-18', '2024-06-25', '2024-06-23', 'Delivered', 'Wire Transfer', 76000.00, 6080.00, 175.00, 3800.00, 78455.00, NULL),
(10064, 1016, 9, '2024-07-02', '2024-07-09', '2024-07-07', 'Delivered', 'ACH', 11500.00, 920.00, 50.00, 0.00, 12470.00, NULL),
(10065, 1007, 10, '2024-07-15', '2024-07-22', '2024-07-19', 'Delivered', 'Wire Transfer', 52000.00, 4160.00, 125.00, 2600.00, 53685.00, NULL),
(10066, 1014, 11, '2024-07-28', '2024-08-04', '2024-08-02', 'Delivered', 'Credit Card', 23000.00, 1840.00, 75.00, 1150.00, 23765.00, NULL),
(10067, 1010, 8, '2024-08-10', '2024-08-17', '2024-08-15', 'Delivered', 'Wire Transfer', 39000.00, 3120.00, 100.00, 1950.00, 40270.00, NULL),
(10068, 1020, 9, '2024-08-25', '2024-09-01', '2024-08-30', 'Delivered', 'Wire Transfer', 42000.00, 3360.00, 250.00, 2100.00, 43510.00, NULL),
(10069, 1004, 10, '2024-09-08', '2024-09-15', '2024-09-12', 'Delivered', 'ACH', 34000.00, 2720.00, 100.00, 1700.00, 35120.00, NULL),
(10070, 1001, 11, '2024-09-22', '2024-09-29', '2024-09-27', 'Delivered', 'Wire Transfer', 61000.00, 4880.00, 150.00, 3050.00, 62980.00, NULL),
(10071, 1017, 8, '2024-10-05', '2024-10-12', '2024-10-10', 'Delivered', 'Wire Transfer', 55000.00, 4400.00, 200.00, 2750.00, 56850.00, NULL),
(10072, 1013, 9, '2024-10-18', '2024-10-25', '2024-10-23', 'Delivered', 'Credit Card', 26500.00, 2120.00, 75.00, 1325.00, 27370.00, NULL),
(10073, 1002, 10, '2024-11-01', '2024-11-08', '2024-11-06', 'Delivered', 'Wire Transfer', 89000.00, 7120.00, 200.00, 4450.00, 91870.00, 'Record order'),
(10074, 1005, 11, '2024-11-15', '2024-11-22', '2024-11-20', 'Delivered', 'ACH', 15500.00, 1240.00, 50.00, 775.00, 16015.00, NULL),
(10075, 1024, 8, '2024-11-20', '2024-11-27', '2024-11-25', 'Delivered', 'Wire Transfer', 12000.00, 960.00, 50.00, 600.00, 12410.00, 'New customer'),

-- Recent/Current orders with various statuses
(10076, 1014, 9, '2024-12-01', '2024-12-08', '2024-12-05', 'Delivered', 'Credit Card', 31000.00, 2480.00, 75.00, 1550.00, 32005.00, NULL),
(10077, 1007, 10, '2024-12-05', '2024-12-12', '2024-12-10', 'Delivered', 'Wire Transfer', 48000.00, 3840.00, 125.00, 2400.00, 49565.00, NULL),
(10078, 1010, 11, '2024-12-08', '2024-12-15', '2024-12-12', 'Shipped', 'Wire Transfer', 37500.00, 3000.00, 100.00, 1875.00, 38725.00, 'In transit'),
(10079, 1001, 8, '2024-12-10', '2024-12-17', NULL, 'Processing', 'Wire Transfer', 65000.00, 5200.00, 150.00, 3250.00, 67100.00, 'Awaiting shipment'),
(10080, 1020, 9, '2024-12-12', '2024-12-19', NULL, 'Pending', 'Wire Transfer', 44000.00, 3520.00, 275.00, 2200.00, 45595.00, 'Payment verification'),
(10081, 1004, 10, '2024-12-14', '2024-12-21', NULL, 'Pending', 'ACH', 29000.00, 2320.00, 75.00, 1450.00, 29945.00, 'New order');


-- ============================================================================
-- TABLE 7: ORDER_DETAILS (Line items - many-to-many relationship)
-- ============================================================================
CREATE OR REPLACE TABLE order_details (
    order_detail_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),  -- Price at time of order (may differ from current)
    discount_pct DECIMAL(5,4),
    line_total DECIMAL(12,2)
);

-- Generate order details (multiple products per order)
INSERT INTO order_details VALUES
-- Order 10001
(1, 10001, 101, 500, 5.00, 0.00, 2500.00),
(2, 10001, 201, 200, 25.00, 0.00, 5000.00),
(3, 10001, 301, 50, 100.00, 0.00, 5000.00),
(4, 10001, 203, 500, 3.00, 0.00, 1500.00),
(5, 10001, 106, 200, 4.50, 0.00, 900.00),

-- Order 10002
(6, 10002, 102, 300, 5.00, 0.05, 1425.00),
(7, 10002, 103, 400, 4.00, 0.05, 1520.00),
(8, 10002, 202, 100, 45.00, 0.05, 4275.00),
(9, 10002, 205, 60, 15.00, 0.05, 855.00),

-- Order 10003
(10, 10003, 101, 800, 5.00, 0.00, 4000.00),
(11, 10003, 105, 600, 5.50, 0.00, 3300.00),
(12, 10003, 201, 300, 25.00, 0.00, 7500.00),
(13, 10003, 202, 100, 45.00, 0.00, 4500.00),
(14, 10003, 301, 25, 100.00, 0.00, 2500.00),

-- Order 10004
(15, 10004, 101, 400, 5.00, 0.00, 2000.00),
(16, 10004, 102, 300, 5.00, 0.00, 1500.00),
(17, 10004, 203, 400, 3.00, 0.00, 1200.00),

-- Order 10005
(18, 10005, 101, 1500, 5.00, 0.05, 7125.00),
(19, 10005, 102, 1200, 5.00, 0.05, 5700.00),
(20, 10005, 103, 1000, 4.00, 0.05, 3800.00),
(21, 10005, 201, 500, 25.00, 0.05, 11875.00),
(22, 10005, 301, 100, 100.00, 0.05, 9500.00),
(23, 10005, 302, 50, 150.00, 0.05, 7125.00),

-- Order 10006
(24, 10006, 104, 400, 6.00, 0.00, 2400.00),
(25, 10006, 105, 500, 5.50, 0.00, 2750.00),
(26, 10006, 202, 120, 45.00, 0.00, 5400.00),
(27, 10006, 204, 150, 10.00, 0.00, 1500.00),

-- Order 10007
(28, 10007, 101, 600, 5.00, 0.05, 2850.00),
(29, 10007, 103, 700, 4.00, 0.05, 2660.00),
(30, 10007, 201, 250, 25.00, 0.05, 5937.50),
(31, 10007, 206, 150, 35.00, 0.05, 4987.50),

-- Continue with more orders...
(32, 10008, 102, 400, 5.00, 0.00, 2000.00),
(33, 10008, 105, 350, 5.50, 0.00, 1925.00),
(34, 10008, 203, 600, 3.00, 0.00, 1800.00),
(35, 10008, 301, 40, 100.00, 0.00, 4000.00),

(36, 10009, 101, 1200, 5.00, 0.05, 5700.00),
(37, 10009, 102, 1000, 5.00, 0.05, 4750.00),
(38, 10009, 201, 400, 25.00, 0.05, 9500.00),
(39, 10009, 202, 200, 45.00, 0.05, 8550.00),
(40, 10009, 304, 6, 500.00, 0.05, 2850.00),

(41, 10010, 103, 500, 4.00, 0.00, 2000.00),
(42, 10010, 104, 300, 6.00, 0.00, 1800.00),
(43, 10010, 203, 800, 3.00, 0.00, 2400.00),
(44, 10010, 205, 80, 15.00, 0.00, 1200.00),

-- More orders with varied product mix
(45, 10011, 101, 900, 5.00, 0.05, 4275.00),
(46, 10011, 102, 800, 5.00, 0.05, 3800.00),
(47, 10011, 106, 700, 4.50, 0.05, 2992.50),
(48, 10011, 201, 350, 25.00, 0.05, 8312.50),
(49, 10011, 302, 60, 150.00, 0.05, 8550.00),

(50, 10012, 101, 700, 5.00, 0.05, 3325.00),
(51, 10012, 103, 600, 4.00, 0.05, 2280.00),
(52, 10012, 201, 280, 25.00, 0.05, 6650.00),
(53, 10012, 301, 70, 100.00, 0.05, 6650.00),

-- Orders 10013-10020
(54, 10013, 102, 250, 5.00, 0.00, 1250.00),
(55, 10013, 104, 200, 6.00, 0.00, 1200.00),
(56, 10013, 203, 500, 3.00, 0.00, 1500.00),
(57, 10013, 205, 150, 15.00, 0.00, 2250.00),

(58, 10014, 101, 500, 5.00, 0.05, 2375.00),
(59, 10014, 105, 450, 5.50, 0.05, 2351.25),
(60, 10014, 201, 200, 25.00, 0.05, 4750.00),
(61, 10014, 301, 45, 100.00, 0.05, 4275.00),

(62, 10015, 101, 1000, 5.00, 0.05, 4750.00),
(63, 10015, 102, 900, 5.00, 0.05, 4275.00),
(64, 10015, 103, 800, 4.00, 0.05, 3040.00),
(65, 10015, 201, 350, 25.00, 0.05, 8312.50),
(66, 10015, 301, 45, 100.00, 0.05, 4275.00),

(67, 10016, 104, 350, 6.00, 0.00, 2100.00),
(68, 10016, 105, 400, 5.50, 0.00, 2200.00),
(69, 10016, 202, 100, 45.00, 0.00, 4500.00),
(70, 10016, 204, 200, 10.00, 0.00, 2000.00),

(71, 10017, 101, 1500, 5.00, 0.05, 7125.00),
(72, 10017, 102, 1200, 5.00, 0.05, 5700.00),
(73, 10017, 201, 500, 25.00, 0.05, 11875.00),
(74, 10017, 202, 200, 45.00, 0.05, 8550.00),
(75, 10017, 301, 45, 100.00, 0.05, 4275.00),

(76, 10018, 101, 2000, 5.00, 0.05, 9500.00),
(77, 10018, 102, 1800, 5.00, 0.05, 8550.00),
(78, 10018, 103, 1500, 4.00, 0.05, 5700.00),
(79, 10018, 201, 600, 25.00, 0.05, 14250.00),
(80, 10018, 301, 120, 100.00, 0.05, 11400.00),

(81, 10019, 101, 350, 5.00, 0.00, 1750.00),
(82, 10019, 102, 300, 5.00, 0.00, 1500.00),
(83, 10019, 105, 400, 5.50, 0.00, 2200.00),
(84, 10019, 203, 700, 3.00, 0.00, 2100.00),
(85, 10019, 205, 90, 15.00, 0.00, 1350.00),

(86, 10020, 103, 300, 4.00, 0.00, 1200.00),
(87, 10020, 104, 200, 6.00, 0.00, 1200.00),
(88, 10020, 203, 400, 3.00, 0.00, 1200.00),
(89, 10020, 205, 60, 15.00, 0.00, 900.00),

-- Continue with 2022-2023 orders (sampling key ones)
(90, 10021, 101, 800, 5.00, 0.05, 3800.00),
(91, 10021, 102, 700, 5.00, 0.05, 3325.00),
(92, 10021, 201, 300, 25.00, 0.05, 7125.00),
(93, 10021, 301, 70, 100.00, 0.05, 6650.00),

(94, 10022, 101, 1400, 5.00, 0.05, 6650.00),
(95, 10022, 102, 1200, 5.00, 0.05, 5700.00),
(96, 10022, 201, 450, 25.00, 0.05, 10687.50),
(97, 10022, 301, 100, 100.00, 0.05, 9500.00),
(98, 10022, 304, 5, 500.00, 0.05, 2375.00),

-- 2023 Orders (sample)
(99, 10024, 101, 1800, 5.00, 0.05, 8550.00),
(100, 10024, 102, 1600, 5.00, 0.05, 7600.00),
(101, 10024, 103, 1400, 4.00, 0.05, 5320.00),
(102, 10024, 201, 550, 25.00, 0.05, 13062.50),
(103, 10024, 301, 110, 100.00, 0.05, 10450.00),

(104, 10029, 101, 2200, 5.00, 0.05, 10450.00),
(105, 10029, 102, 2000, 5.00, 0.05, 9500.00),
(106, 10029, 103, 1800, 4.00, 0.05, 6840.00),
(107, 10029, 201, 700, 25.00, 0.05, 16625.00),
(108, 10029, 301, 100, 100.00, 0.05, 9500.00),
(109, 10029, 304, 5, 500.00, 0.05, 2375.00),

(110, 10036, 101, 2500, 5.00, 0.05, 11875.00),
(111, 10036, 102, 2300, 5.00, 0.05, 10925.00),
(112, 10036, 103, 2000, 4.00, 0.05, 7600.00),
(113, 10036, 201, 800, 25.00, 0.05, 19000.00),
(114, 10036, 301, 120, 100.00, 0.05, 11400.00),

(115, 10047, 101, 2800, 5.00, 0.05, 13300.00),
(116, 10047, 102, 2600, 5.00, 0.05, 12350.00),
(117, 10047, 103, 2400, 4.00, 0.05, 9120.00),
(118, 10047, 201, 900, 25.00, 0.05, 21375.00),
(119, 10047, 301, 140, 100.00, 0.05, 13300.00),

-- 2024 Orders (sample)
(120, 10051, 101, 2200, 5.00, 0.05, 10450.00),
(121, 10051, 102, 2000, 5.00, 0.05, 9500.00),
(122, 10051, 103, 1800, 4.00, 0.05, 6840.00),
(123, 10051, 201, 700, 25.00, 0.05, 16625.00),
(124, 10051, 301, 120, 100.00, 0.05, 11400.00),
(125, 10051, 304, 6, 500.00, 0.05, 2850.00),

(126, 10054, 101, 3200, 5.00, 0.05, 15200.00),
(127, 10054, 102, 3000, 5.00, 0.05, 14250.00),
(128, 10054, 103, 2800, 4.00, 0.05, 10640.00),
(129, 10054, 201, 1000, 25.00, 0.05, 23750.00),
(130, 10054, 301, 150, 100.00, 0.05, 14250.00),
(131, 10054, 302, 30, 150.00, 0.05, 4275.00),

(132, 10063, 101, 3000, 5.00, 0.05, 14250.00),
(133, 10063, 102, 2800, 5.00, 0.05, 13300.00),
(134, 10063, 103, 2600, 4.00, 0.05, 9880.00),
(135, 10063, 201, 950, 25.00, 0.05, 22562.50),
(136, 10063, 301, 140, 100.00, 0.05, 13300.00),
(137, 10063, 304, 5, 500.00, 0.05, 2375.00),

(138, 10073, 101, 3500, 5.00, 0.05, 16625.00),
(139, 10073, 102, 3300, 5.00, 0.05, 15675.00),
(140, 10073, 103, 3000, 4.00, 0.05, 11400.00),
(141, 10073, 201, 1100, 25.00, 0.05, 26125.00),
(142, 10073, 301, 170, 100.00, 0.05, 16150.00),
(143, 10073, 302, 25, 150.00, 0.05, 3562.50),

-- Recent orders
(144, 10079, 101, 2600, 5.00, 0.05, 12350.00),
(145, 10079, 102, 2400, 5.00, 0.05, 11400.00),
(146, 10079, 103, 2200, 4.00, 0.05, 8360.00),
(147, 10079, 201, 850, 25.00, 0.05, 20187.50),
(148, 10079, 301, 120, 100.00, 0.05, 11400.00),

(149, 10080, 101, 1700, 5.00, 0.05, 8075.00),
(150, 10080, 102, 1500, 5.00, 0.05, 7125.00),
(151, 10080, 106, 1200, 4.50, 0.05, 5130.00),
(152, 10080, 201, 600, 25.00, 0.05, 14250.00),
(153, 10080, 301, 90, 100.00, 0.05, 8550.00),

(154, 10081, 101, 1100, 5.00, 0.05, 5225.00),
(155, 10081, 103, 1000, 4.00, 0.05, 3800.00),
(156, 10081, 104, 800, 6.00, 0.05, 4560.00),
(157, 10081, 201, 450, 25.00, 0.05, 10687.50),
(158, 10081, 301, 45, 100.00, 0.05, 4275.00);


-- ============================================================================
-- TABLE 8: SALES_TARGETS (For comparison queries, window functions)
-- ============================================================================
CREATE OR REPLACE TABLE sales_targets (
    target_id INT PRIMARY KEY,
    employee_id INT,
    fiscal_year INT,
    fiscal_quarter INT,
    target_amount DECIMAL(12,2),
    target_type VARCHAR(20)  -- Revenue, Units, NewCustomers
);

INSERT INTO sales_targets VALUES
-- 2022 Targets
(1, 8, 2022, 1, 75000.00, 'Revenue'),
(2, 8, 2022, 2, 80000.00, 'Revenue'),
(3, 8, 2022, 3, 85000.00, 'Revenue'),
(4, 8, 2022, 4, 100000.00, 'Revenue'),
(5, 9, 2022, 1, 70000.00, 'Revenue'),
(6, 9, 2022, 2, 75000.00, 'Revenue'),
(7, 9, 2022, 3, 80000.00, 'Revenue'),
(8, 9, 2022, 4, 95000.00, 'Revenue'),
(9, 10, 2022, 1, 65000.00, 'Revenue'),
(10, 10, 2022, 2, 70000.00, 'Revenue'),
(11, 10, 2022, 3, 75000.00, 'Revenue'),
(12, 10, 2022, 4, 90000.00, 'Revenue'),
(13, 11, 2022, 1, 60000.00, 'Revenue'),
(14, 11, 2022, 2, 65000.00, 'Revenue'),
(15, 11, 2022, 3, 70000.00, 'Revenue'),
(16, 11, 2022, 4, 85000.00, 'Revenue'),

-- 2023 Targets (higher)
(17, 8, 2023, 1, 90000.00, 'Revenue'),
(18, 8, 2023, 2, 95000.00, 'Revenue'),
(19, 8, 2023, 3, 100000.00, 'Revenue'),
(20, 8, 2023, 4, 120000.00, 'Revenue'),
(21, 9, 2023, 1, 85000.00, 'Revenue'),
(22, 9, 2023, 2, 90000.00, 'Revenue'),
(23, 9, 2023, 3, 95000.00, 'Revenue'),
(24, 9, 2023, 4, 115000.00, 'Revenue'),
(25, 10, 2023, 1, 80000.00, 'Revenue'),
(26, 10, 2023, 2, 85000.00, 'Revenue'),
(27, 10, 2023, 3, 90000.00, 'Revenue'),
(28, 10, 2023, 4, 110000.00, 'Revenue'),
(29, 11, 2023, 1, 75000.00, 'Revenue'),
(30, 11, 2023, 2, 80000.00, 'Revenue'),
(31, 11, 2023, 3, 85000.00, 'Revenue'),
(32, 11, 2023, 4, 105000.00, 'Revenue'),

-- 2024 Targets (even higher)
(33, 8, 2024, 1, 110000.00, 'Revenue'),
(34, 8, 2024, 2, 115000.00, 'Revenue'),
(35, 8, 2024, 3, 120000.00, 'Revenue'),
(36, 8, 2024, 4, 140000.00, 'Revenue'),
(37, 9, 2024, 1, 105000.00, 'Revenue'),
(38, 9, 2024, 2, 110000.00, 'Revenue'),
(39, 9, 2024, 3, 115000.00, 'Revenue'),
(40, 9, 2024, 4, 135000.00, 'Revenue'),
(41, 10, 2024, 1, 100000.00, 'Revenue'),
(42, 10, 2024, 2, 105000.00, 'Revenue'),
(43, 10, 2024, 3, 110000.00, 'Revenue'),
(44, 10, 2024, 4, 130000.00, 'Revenue'),
(45, 11, 2024, 1, 95000.00, 'Revenue'),
(46, 11, 2024, 2, 100000.00, 'Revenue'),
(47, 11, 2024, 3, 105000.00, 'Revenue'),
(48, 11, 2024, 4, 125000.00, 'Revenue');


-- ============================================================================
-- TABLE 9: DATE_DIM (Date dimension for time-series, date functions)
-- ============================================================================
CREATE OR REPLACE TABLE date_dim AS
SELECT 
    date_value AS date_key,
    date_value,
    YEAR(date_value) AS year,
    QUARTER(date_value) AS quarter,
    MONTH(date_value) AS month,
    MONTHNAME(date_value) AS month_name,
    DAY(date_value) AS day,
    DAYOFWEEK(date_value) AS day_of_week,
    DAYNAME(date_value) AS day_name,
    WEEKOFYEAR(date_value) AS week_of_year,
    DATE_TRUNC('month', date_value) AS month_start,
    LAST_DAY(date_value) AS month_end,
    DATE_TRUNC('quarter', date_value) AS quarter_start,
    DATE_TRUNC('year', date_value) AS year_start,
    CASE WHEN DAYOFWEEK(date_value) IN (0, 6) THEN TRUE ELSE FALSE END AS is_weekend,
    -- Fiscal year (assuming July start)
    CASE WHEN MONTH(date_value) >= 7 THEN YEAR(date_value) + 1 ELSE YEAR(date_value) END AS fiscal_year,
    CASE 
        WHEN MONTH(date_value) IN (7,8,9) THEN 1
        WHEN MONTH(date_value) IN (10,11,12) THEN 2
        WHEN MONTH(date_value) IN (1,2,3) THEN 3
        ELSE 4 
    END AS fiscal_quarter
FROM (
    SELECT DATEADD(day, seq4(), '2020-01-01'::date) AS date_value
    FROM TABLE(GENERATOR(ROWCOUNT => 2192))  -- ~6 years of dates
) dates;


-- ============================================================================
-- TABLE 10: EXCHANGE_RATES (For currency/financial calculations)
-- ============================================================================
CREATE OR REPLACE TABLE exchange_rates (
    rate_id INT PRIMARY KEY,
    rate_date DATE,
    from_currency VARCHAR(3),
    to_currency VARCHAR(3),
    exchange_rate DECIMAL(12,6),
    source VARCHAR(50)
);

-- Sample exchange rates (simplified)
INSERT INTO exchange_rates VALUES
-- USD to EUR (sample dates)
(1, '2024-01-02', 'USD', 'EUR', 0.9150, 'Reuters'),
(2, '2024-02-01', 'USD', 'EUR', 0.9200, 'Reuters'),
(3, '2024-03-01', 'USD', 'EUR', 0.9180, 'Reuters'),
(4, '2024-04-01', 'USD', 'EUR', 0.9250, 'Reuters'),
(5, '2024-05-01', 'USD', 'EUR', 0.9300, 'Reuters'),
(6, '2024-06-03', 'USD', 'EUR', 0.9280, 'Reuters'),
(7, '2024-07-01', 'USD', 'EUR', 0.9320, 'Reuters'),
(8, '2024-08-01', 'USD', 'EUR', 0.9100, 'Reuters'),
(9, '2024-09-03', 'USD', 'EUR', 0.9050, 'Reuters'),
(10, '2024-10-01', 'USD', 'EUR', 0.9000, 'Reuters'),
(11, '2024-11-01', 'USD', 'EUR', 0.9150, 'Reuters'),
(12, '2024-12-02', 'USD', 'EUR', 0.9200, 'Reuters'),

-- USD to GBP
(13, '2024-01-02', 'USD', 'GBP', 0.7850, 'Reuters'),
(14, '2024-02-01', 'USD', 'GBP', 0.7900, 'Reuters'),
(15, '2024-03-01', 'USD', 'GBP', 0.7880, 'Reuters'),
(16, '2024-04-01', 'USD', 'GBP', 0.7950, 'Reuters'),
(17, '2024-05-01', 'USD', 'GBP', 0.8000, 'Reuters'),
(18, '2024-06-03', 'USD', 'GBP', 0.7920, 'Reuters'),
(19, '2024-07-01', 'USD', 'GBP', 0.7800, 'Reuters'),
(20, '2024-08-01', 'USD', 'GBP', 0.7750, 'Reuters'),
(21, '2024-09-03', 'USD', 'GBP', 0.7650, 'Reuters'),
(22, '2024-10-01', 'USD', 'GBP', 0.7700, 'Reuters'),
(23, '2024-11-01', 'USD', 'GBP', 0.7850, 'Reuters'),
(24, '2024-12-02', 'USD', 'GBP', 0.7900, 'Reuters'),

-- USD to CAD
(25, '2024-01-02', 'USD', 'CAD', 1.3250, 'Reuters'),
(26, '2024-02-01', 'USD', 'CAD', 1.3400, 'Reuters'),
(27, '2024-03-01', 'USD', 'CAD', 1.3550, 'Reuters'),
(28, '2024-04-01', 'USD', 'CAD', 1.3600, 'Reuters'),
(29, '2024-05-01', 'USD', 'CAD', 1.3700, 'Reuters'),
(30, '2024-06-03', 'USD', 'CAD', 1.3650, 'Reuters'),
(31, '2024-07-01', 'USD', 'CAD', 1.3750, 'Reuters'),
(32, '2024-08-01', 'USD', 'CAD', 1.3800, 'Reuters'),
(33, '2024-09-03', 'USD', 'CAD', 1.3550, 'Reuters'),
(34, '2024-10-01', 'USD', 'CAD', 1.3500, 'Reuters'),
(35, '2024-11-01', 'USD', 'CAD', 1.3900, 'Reuters'),
(36, '2024-12-02', 'USD', 'CAD', 1.4000, 'Reuters');


-- ============================================================================
-- TABLE 11: AUDIT_LOG (For advanced queries, timestamps)
-- ============================================================================
CREATE OR REPLACE TABLE audit_log (
    log_id INT PRIMARY KEY,
    table_name VARCHAR(50),
    record_id INT,
    action VARCHAR(20),  -- INSERT, UPDATE, DELETE
    changed_by INT,  -- employee_id
    changed_at TIMESTAMP_NTZ,
    old_values VARIANT,  -- JSON of old values
    new_values VARIANT   -- JSON of new values
);

INSERT INTO audit_log 
SELECT 
    ROW_NUMBER() OVER (ORDER BY log_time) as log_id,
    table_name,
    record_id,
    action,
    changed_by,
    log_time as changed_at,
    old_values,
    new_values
FROM (
    SELECT 'orders' as table_name, 10001 as record_id, 'INSERT' as action, 8 as changed_by, 
           '2022-01-15 09:30:00'::timestamp as log_time, NULL as old_values, 
           PARSE_JSON('{"status": "Pending", "total": 16250}') as new_values
    UNION ALL
    SELECT 'orders', 10001, 'UPDATE', 8, '2022-01-16 10:00:00', 
           PARSE_JSON('{"status": "Pending"}'), PARSE_JSON('{"status": "Processing"}')
    UNION ALL
    SELECT 'orders', 10001, 'UPDATE', 13, '2022-01-20 14:30:00', 
           PARSE_JSON('{"status": "Processing"}'), PARSE_JSON('{"status": "Shipped"}')
    UNION ALL
    SELECT 'orders', 10001, 'UPDATE', 13, '2022-01-20 16:00:00', 
           PARSE_JSON('{"status": "Shipped"}'), PARSE_JSON('{"status": "Delivered"}')
    UNION ALL
    SELECT 'customers', 1001, 'UPDATE', 9, '2022-02-01 11:00:00', 
           PARSE_JSON('{"credit_limit": 400000}'), PARSE_JSON('{"credit_limit": 500000}')
    UNION ALL
    SELECT 'employees', 8, 'UPDATE', 2, '2022-06-01 09:00:00', 
           PARSE_JSON('{"salary": 60000}'), PARSE_JSON('{"salary": 65000}')
    UNION ALL
    SELECT 'products', 107, 'INSERT', 5, '2020-01-15 08:00:00', 
           NULL, PARSE_JSON('{"product_name": "Exotic Currency Bundle", "unit_price": 15.00}')
) logs;


-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================

-- Verify table counts
SELECT 'employees' as table_name, COUNT(*) as row_count FROM employees
UNION ALL SELECT 'departments', COUNT(*) FROM departments
UNION ALL SELECT 'regions', COUNT(*) FROM regions
UNION ALL SELECT 'customers', COUNT(*) FROM customers
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_details', COUNT(*) FROM order_details
UNION ALL SELECT 'sales_targets', COUNT(*) FROM sales_targets
UNION ALL SELECT 'date_dim', COUNT(*) FROM date_dim
UNION ALL SELECT 'exchange_rates', COUNT(*) FROM exchange_rates
UNION ALL SELECT 'audit_log', COUNT(*) FROM audit_log
ORDER BY table_name;


-- ============================================================================
-- QUICK REFERENCE: TABLE RELATIONSHIPS
-- ============================================================================
/*
ENTITY RELATIONSHIP DIAGRAM (Text version):

employees ----< orders >---- customers
    |               |
    |               |
    v               v
departments    order_details >---- products
                    
employees (self-join via manager_id)
customers ----< regions
sales_targets ----< employees
date_dim (standalone for joins)
exchange_rates (standalone for calculations)
audit_log (standalone for JSON/timestamp practice)


KEY RELATIONSHIPS:
- employees.department_id -> departments.department_id
- employees.manager_id -> employees.employee_id (self-reference)
- orders.customer_id -> customers.customer_id
- orders.employee_id -> employees.employee_id
- order_details.order_id -> orders.order_id
- order_details.product_id -> products.product_id
- customers.region_id -> regions.region_id
- sales_targets.employee_id -> employees.employee_id

DATA CHARACTERISTICS FOR PRACTICE:
- employees: Contains NULLs in manager_id, email, phone, commission_pct
- departments: Has departments with no employees (for OUTER JOIN practice)
- customers: Varied phone formats, NULLs, special characters, missing regions
- orders: Various statuses including cancelled, NULL shipped_dates
- products: Active and discontinued products
- date_dim: Full date dimension with fiscal calendar
- audit_log: JSON data in VARIANT columns

RECOMMENDED PRACTICE ORDER:
1. Basic SELECT/WHERE/ORDER BY with employees, customers
2. JOINs with employees-departments, orders-customers-employees
3. Aggregations with orders, order_details
4. CTEs and Subqueries with sales analysis
5. Window functions with orders (running totals, rankings)
6. String functions with customers (phone/address cleanup)
7. Date functions with orders, date_dim
8. NULL handling throughout
9. CASE statements for tiering/categorization
10. Advanced: JSON parsing with audit_log, set operations
*/

-- End of dataset creation script
