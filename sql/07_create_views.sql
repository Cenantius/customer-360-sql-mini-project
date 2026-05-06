-- 07_create_views.sql
-- Reusable analytics views for the Customer 360 SQL Mini Project.
-- These views transform raw relational tables into analysis-ready datasets.

-- 1. Customer 360 view
-- Business purpose:
-- Create one analysis-ready customer table with revenue, order count and latest order date.

DROP VIEW IF EXISTS customer_360;

CREATE VIEW customer_360 AS
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.city,
    c.age_group,
    c.marketing_consent,
    c.created_at,
    COALESCE(SUM(
        CASE
            WHEN o.status = 'completed' THEN o.total_amount
            ELSE 0
        END
    ), 0) AS lifetime_value,
    COUNT(
        CASE
            WHEN o.status = 'completed' THEN o.order_id
        END
    ) AS completed_orders,
    MAX(
        CASE
            WHEN o.status = 'completed' THEN o.order_date
        END
    ) AS last_order_date
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.city,
    c.age_group,
    c.marketing_consent,
    c.created_at;

-- 2. Customer segments view
-- Business purpose:
-- Classify customers into business-friendly segments based on value and purchase frequency.

DROP VIEW IF EXISTS customer_segments;

CREATE VIEW customer_segments AS
SELECT
    customer_id,
    first_name,
    last_name,
    email,
    city,
    age_group,
    marketing_consent,
    lifetime_value,
    completed_orders,
    last_order_date,
    CASE
        WHEN lifetime_value >= 200 THEN 'high_value'
        WHEN completed_orders >= 2 THEN 'repeat_customer'
        WHEN completed_orders = 1 THEN 'one_time_buyer'
        ELSE 'no_purchase'
    END AS customer_segment
FROM customer_360;

-- 3. Channel performance view
-- Business purpose:
-- Calculate sessions, conversions and conversion rate by website acquisition channel.

DROP VIEW IF EXISTS channel_performance;

CREATE VIEW channel_performance AS
SELECT
    channel,
    COUNT(*) AS sessions,
    SUM(converted) AS conversions,
    ROUND(1.0 * SUM(converted) / COUNT(*), 2) AS conversion_rate
FROM website_sessions
GROUP BY channel;

-- 4. Campaign performance view
-- Business purpose:
-- Calculate email campaign opens, clicks, purchases and click-to-open rate.

DROP VIEW IF EXISTS campaign_performance;

CREATE VIEW campaign_performance AS
SELECT
    ec.campaign_id,
    ec.campaign_name,
    ec.campaign_type,
    ec.sent_date,
    COUNT(CASE WHEN ee.event_type = 'open' THEN 1 END) AS opens,
    COUNT(CASE WHEN ee.event_type = 'click' THEN 1 END) AS clicks,
    COUNT(CASE WHEN ee.event_type = 'purchase' THEN 1 END) AS purchases,
    ROUND(
        1.0 * COUNT(CASE WHEN ee.event_type = 'click' THEN 1 END)
        / NULLIF(COUNT(CASE WHEN ee.event_type = 'open' THEN 1 END), 0),
        2
    ) AS click_to_open_rate
FROM email_campaigns ec
LEFT JOIN email_events ee
    ON ec.campaign_id = ee.campaign_id
GROUP BY
    ec.campaign_id,
    ec.campaign_name,
    ec.campaign_type,
    ec.sent_date;