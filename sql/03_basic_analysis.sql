-- 03_basic_analysis.sql
-- Basic SQL analysis queries for the Customer 360 SQL Mini Project.
-- These queries answer simple business questions about customers, revenue,
-- marketing consent, customer value and website channel performance.

-- 1. Show all customers
-- Business question:
-- What customer data do we currently have?

SELECT *
FROM customers;

-- 2. Select key customer columns
-- Business question:
-- Which customers do we have and where are they located?

SELECT
    customer_id,
    first_name,
    last_name,
    city
FROM customers;

-- 3. Customers with marketing consent (1 == consent)
-- Business question:
-- Which customers can receive marketing messages?

SELECT
    customer_id,
    first_name,
    last_name,
    email,
    city,
    marketing_consent
FROM customers
WHERE marketing_consent = 1;

-- 4. Customer count by city
-- Business question:
-- How many customers are loacted in each city?

SELECT
    city,
    COUNT(*) AS customer_count
FROM customers
GROUP BY city
ORDER BY customer_count DESC;

-- 5. Total completed revenue
-- Business question:
-- How much revenue has the company generated from completed orders?

SELECT
    SUM(total_amount) AS total_revenue
FROM orders
WHERE status = 'completed';

-- 6. Monthly revenue
-- Business question:
-- How much completed revenue did the company generate each month?

SELECT
    strftime('%Y-%m', order_date) AS month,
    SUM(total_amount) AS monthly_revenue,
    COUNT(*) AS order_count
FROM orders
WHERE status = 'completed'
GROUP BY strftime('%Y-%m', order_date)
ORDER BY month;

-- 7. Customer lifetime value
-- Business question:
-- Who are the most valuable customers based on completed order revenue?

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    COALESCE(SUM(o.total_amount), 0) AS lifetime_value,
    COUNT(o.order_id) AS order_count
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
    AND o.status = 'completed'
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email
ORDER BY lifetime_value DESC;

-- 8. Conversion rate by channel
-- Business question:
-- Which website acquisition channels convert best?

SELECT
    channel,
    COUNT(*) AS sessions,
    SUM(converted) AS conversions,
    ROUND(1.0 * SUM(converted) / COUNT(*), 2) AS conversion_rate
FROM website_sessions
GROUP BY channel
ORDER BY conversion_rate DESC;