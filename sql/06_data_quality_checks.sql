-- 06_data_quality_checks.sql
-- Data quality checks for the Customer 360 SQL Mini Project
-- These queries check for missing values, duplicates, invalid references and unexpected values.

-- 1. Missing customer emails
-- Business question:
-- Are there customers without an email address?

SELECT
    COUNT(*) AS missing_email_count
FROM customers
WHERE email IS NULL
    OR email = '';

-- 2. Duplicate customer emails
-- Business question:
-- Are there multiple customers using the same email address?

SELECT
    email,
    COUNT(*) AS duplicate_count
FROM customers
GROUP BY email
-- HAVING filters groups after the grouping
HAVING COUNT(*) > 1;

-- 3. Orders without a matching customer
-- Business question:
-- Are these orders that cannot be linked to a known customer?

SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    o.total_amount,
    o.status
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- 4. Negative order amounts
-- Business question:
-- Are there orders with invalid negative revenue values?

SELECT
    order_id,
    customer_id,
    order_date,
    total_amount,
    status
FROM orders
WHERE total_amount < 0;

-- 5. Website sessions with unknown channels
-- Business question:
-- Are there website sessions from unexpected acquisition channels?

SELECT
    session_id,
    customer_id,
    session_date,
    channel,
    landing_page,
    device,
    converted
FROM website_sessions
-- List of allowed sessions
WHERE channel NOT IN (
    'organic_search',
    'paid_search',
    'email',
    'social',
    'direct'
);

-- 6. Invalid converted values
-- Business question:
-- Are there website sessions where converted is not 0 or 1?

SELECT
    session_id,
    customer_id,
    session_date,
    channel,
    converted
FROM website_sessions
WHERE converted NOT IN (0, 1);

-- 7. Invalid order status values
-- Business question:
-- Are there orders with unexpected status values?

SELECT
    order_id,
    customer_id,
    order_date,
    total_amount,
    status
FROM Orders
WHERE status NOT IN (
    'completed',
    'cancelled'
);

-- 8. Invalid email event types
-- Business question:
-- Are there email events with unexpected event types?

SELECT
    event_id,
    customer_id,
    campaign_id,
    event_type,
    event_time
FROM email_events
WHERE event_type NOT IN (
    'open',
    'click',
    'purchase'
);

-- 9. Email events without a matching customer
-- Business question:
-- Are there email events that cannot be linked to a known customer?

SELECT
    ee.event_id,
    ee.customer_id,
    ee.campaign_id,
    ee.event_type,
    ee.event_time
FROM email_events ee
LEFT JOIN customers c
    ON ee.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- 10. Email events without a matching campaign
-- Business question:
-- Are there email events that cannot be linked to a known campaign?

SELECT
    ee.event_id,
    ee.customer_id,
    ee.campaign_id,
    ee.event_type,
    ee.event_time
FROM email_events ee
LEFT JOIN email_campaigns ec
    ON ee.campaign_id = ec.campaign_id
WHERE ec.campaign_id IS NULL;

-- 11. Data quality summary
-- Business question:
-- How many issues does each data quality check find?

SELECT
    'missing_customer_emails' AS check_name,
    COUNT(*) AS issue_count
FROM customers
WHERE email IS NULL
   OR email = ''

UNION ALL

SELECT
    'duplicate_customer_emails' AS check_name,
    COUNT(*) AS issue_count
FROM (
    SELECT
        email
    FROM customers
    GROUP BY email
    HAVING COUNT(*) > 1
) duplicate_emails

UNION ALL

SELECT
    'orders_without_customer' AS check_name,
    COUNT(*) AS issue_count
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL

UNION ALL

SELECT
    'negative_order_amounts' AS check_name,
    COUNT(*) AS issue_count
FROM orders
WHERE total_amount < 0

UNION ALL

SELECT
    'unknown_website_channels' AS check_name,
    COUNT(*) AS issue_count
FROM website_sessions
WHERE channel NOT IN (
    'organic_search',
    'paid_search',
    'email',
    'social',
    'direct'
)

UNION ALL

SELECT
    'invalid_converted_values' AS check_name,
    COUNT(*) AS issue_count
FROM website_sessions
WHERE converted NOT IN (0, 1)

UNION ALL

SELECT
    'invalid_order_statuses' AS check_name,
    COUNT(*) AS issue_count
FROM orders
WHERE status NOT IN (
    'completed',
    'cancelled'
)

UNION ALL

SELECT
    'invalid_email_event_types' AS check_name,
    COUNT(*) AS issue_count
FROM email_events
WHERE event_type NOT IN (
    'open',
    'click',
    'purchase'
);