-- Customer lifetime value view

DROP VIEW IF EXISTS customer_lifetime_value;
GO

CREATE VIEW customer_lifetime_value AS

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.city,
    COUNT(o.order_id) AS completed_orders,
    COALESCE(ROUND(SUM(o.order_amount), 2), 0) AS total_completed_revenue
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
    AND o.order_status = 'completed'
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.city;
GO

-- Website channel conversion performance view

DROP VIEW IF EXISTS channel_conversion_performance;
GO

CREATE VIEW channel_conversion_performance AS

SELECT
    channel,
    COUNT(*) AS sessions,
    SUM(
        CASE
            WHEN converted = 1 THEN 1
            ELSE 0
        END
    ) AS conversions,
    CAST(
        ROUND(
            100.0 *
            SUM(
                CASE
                    WHEN converted = 1 THEN 1
                    ELSE 0
                END
            ) / COUNT(*),
            2
        )
        AS DECIMAL(5,2)
    ) AS conversion_rate_percent
FROM website_sessions
GROUP BY channel;
GO

-- Email campaign performance view

DROP VIEW IF EXISTS campaign_performance;
GO

CREATE VIEW campaign_performance AS

SELECT
    ec.campaign_id,
    ec.campaign_name,
    ec.campaign_type,
    ec.send_date,

    SUM(CASE WHEN ee.event_type = 'sent' THEN 1 ELSE 0 END) AS emails_sent,
    SUM(CASE WHEN ee.event_type = 'open' THEN 1 ELSE 0 END) AS opens,
    SUM(CASE WHEN ee.event_type = 'click' THEN 1 ELSE 0 END) AS clicks,
    SUM(CASE WHEN ee.event_type = 'purchase' THEN 1 ELSE 0 END) AS purchases,

    CAST(
        ROUND(
            100.0 * SUM(CASE WHEN ee.event_type = 'open' THEN 1 ELSE 0 END)
            / NULLIF(SUM(CASE WHEN ee.event_type = 'sent' THEN 1 ELSE 0 END), 0),
            2
        )
        AS DECIMAL(5,2)
    ) AS open_rate_percent,

    CAST(
        ROUND(
            100.0 * SUM(CASE WHEN ee.event_type = 'click' THEN 1 ELSE 0 END)
            / NULLIF(SUM(CASE WHEN ee.event_type = 'open' THEN 1 ELSE 0 END), 0),
            2
        )
        AS DECIMAL(5,2)
    ) AS click_to_open_rate_percent

FROM email_campaigns ec

LEFT JOIN email_events ee
    ON ec.campaign_id = ee.campaign_id

GROUP BY
    ec.campaign_id,
    ec.campaign_name,
    ec.campaign_type,
    ec.send_date;
GO

-- Monthly revenue trends view

DROP VIEW IF EXISTS monthly_revenue_trends;
GO

CREATE VIEW monthly_revenue_trends AS

SELECT
    FORMAT(order_date, 'yyyy-MM') AS order_month,
    COUNT(order_id) AS completed_orders,
    CAST(
        ROUND(SUM(order_amount), 2)
        AS DECIMAL(10,2)
    ) AS completed_revenue
FROM orders
WHERE order_status = 'completed'
GROUP BY FORMAT(order_date, 'yyyy-MM');
GO

-- Customer segment summary view

DROP VIEW IF EXISTS customer_segment_summary;
GO

CREATE VIEW customer_segment_summary AS

WITH customer_segments AS (

    SELECT
        customer_id,
        CASE
            WHEN total_completed_revenue >= 1000 THEN 'high_value'
            WHEN completed_orders >= 2 THEN 'repeat_customer'
            WHEN completed_orders = 1 THEN 'one_time_buyer'
            ELSE 'no_purchase'
        END AS customer_segment
    FROM customer_lifetime_value
)

SELECT
    customer_segment,
    COUNT(customer_id) AS customers
FROM customer_segments
GROUP BY customer_segment;
GO

-- Data quality summary view

DROP VIEW IF EXISTS data_quality_summary;
GO

CREATE VIEW data_quality_summary AS

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
) duplicate_emails

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
GO