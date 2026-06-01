-- Customers with missing emails

SELECT *
FROM customers
WHERE email IS NULL
   OR TRIM(email) = '';

-- Duplicate customer emails

SELECT
    email,
    COUNT(*) AS duplicate_count
FROM customers
GROUP BY email
HAVING COUNT(*) > 1;

-- Orders without matching customers

SELECT o.*
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Negative order amounts

SELECT *
FROM orders
WHERE order_amount < 0;

-- Invalid conversion values

SELECT *
FROM website_sessions
WHERE converted NOT IN (0, 1);

-- Invalid order statuses

SELECT *
FROM orders
WHERE order_status NOT IN (
    'completed',
    'cancelled',
    'refunded'
);

-- Invalid email event types

SELECT *
FROM email_events
WHERE event_type NOT IN (
    'sent',
    'open',
    'click',
    'purchase'
);

-- Data quality summary

SELECT
    'missing_customer_emails' AS check_name,
    COUNT(*) AS issue_count
FROM customers
WHERE email IS NULL
   OR TRIM(email) = ''

UNION ALL

SELECT
    'duplicate_customer_emails',
    COUNT(*)
FROM (
    SELECT email
    FROM customers
    GROUP BY email
    HAVING COUNT(*) > 1
)

UNION ALL

SELECT
    'orders_without_matching_customers',
    COUNT(*)
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL

UNION ALL

SELECT
    'negative_order_amounts',
    COUNT(*)
FROM orders
WHERE order_amount < 0

UNION ALL

SELECT
    'invalid_conversion_values',
    COUNT(*)
FROM website_sessions
WHERE converted NOT IN (0, 1)

UNION ALL

SELECT
    'invalid_order_statuses',
    COUNT(*)
FROM orders
WHERE order_status NOT IN (
    'completed',
    'cancelled',
    'refunded'
)

UNION ALL

SELECT
    'invalid_email_event_types',
    COUNT(*)
FROM email_events
WHERE event_type NOT IN (
    'sent',
    'open',
    'click',
    'purchase'
);