-- Row counts for generated data

SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'website_sessions', COUNT(*) FROM website_sessions
UNION ALL
SELECT 'email_campaigns', COUNT(*) FROM email_campaigns
UNION ALL
SELECT 'email_events', COUNT(*) FROM email_events;

-- Completed revenue by customer

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.city,
    COUNT(o.order_id) AS completed_orders,
    ROUND(SUM(o.order_amount), 2) AS total_completed_revenue
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
    AND o.order_status = 'completed'
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.city
ORDER BY total_completed_revenue DESC;

-- Website channel conversion rate

SELECT
    traffic_source,
    COUNT(*) AS sessions,
    SUM(CASE WHEN converted = 1 THEN 1 ELSE 0 END) AS conversions,
    ROUND(
        100.0 * SUM(CASE WHEN converted = 1 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS conversion_rate_percent
FROM website_sessions
GROUP BY traffic_source
ORDER BY conversion_rate_percent DESC;

-- Email campaign performance

SELECT
    ec.campaign_id,
    ec.campaign_name,
    ec.campaign_type,
    ec.send_date,
    
    SUM(CASE WHEN ee.event_type = 'sent' THEN 1 ELSE 0 END) AS emails_sent,
    SUM(CASE WHEN ee.event_type = 'open' THEN 1 ELSE 0 END) AS opens,
    SUM(CASE WHEN ee.event_type = 'click' THEN 1 ELSE 0 END) AS clicks,
    SUM(CASE WHEN ee.event_type = 'purchase' THEN 1 ELSE 0 END) AS purchases,

    ROUND(
        100.0 * SUM(CASE WHEN ee.event_type = 'open' THEN 1 ELSE 0 END)
        / NULLIF(SUM(CASE WHEN ee.event_type = 'sent' THEN 1 ELSE 0 END), 0),
        2
    ) AS open_rate_percent,

    ROUND(
        100.0 * SUM(CASE WHEN ee.event_type = 'click' THEN 1 ELSE 0 END)
        / NULLIF(SUM(CASE WHEN ee.event_type = 'open' THEN 1 ELSE 0 END), 0),
        2
    ) AS click_to_open_rate_percent,

    ROUND(
        100.0 * SUM(CASE WHEN ee.event_type = 'purchase' THEN 1 ELSE 0 END)
        / NULLIF(SUM(CASE WHEN ee.event_type = 'click' THEN 1 ELSE 0 END), 0),
        2
    ) AS purchase_after_click_rate_percent

FROM email_campaigns ec
LEFT JOIN email_events ee
    ON ec.campaign_id = ee.campaign_id
GROUP BY
    ec.campaign_id,
    ec.campaign_name,
    ec.campaign_type,
    ec.send_date
ORDER BY open_rate_percent DESC;

-- Customer segmentation based on completed orders and revenue

WITH customer_order_summary AS (
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
        c.city
)

SELECT
    customer_id,
    first_name,
    last_name,
    email,
    city,
    completed_orders,
    total_completed_revenue,
    CASE
        WHEN total_completed_revenue >= 1000 THEN 'high_value'
        WHEN completed_orders >= 2 THEN 'repeat_customer'
        WHEN completed_orders = 1 THEN 'one_time_buyer'
        ELSE 'no_purchase'
    END AS customer_segment
FROM customer_order_summary
ORDER BY total_completed_revenue DESC;