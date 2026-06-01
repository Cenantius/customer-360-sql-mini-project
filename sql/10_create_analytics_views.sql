-- Customer lifetime value view

DROP VIEW IF EXISTS customer_lifetime_value;

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

-- Website channel conversion performance view

DROP VIEW IF EXISTS channel_conversion_performance;

CREATE VIEW channel_conversion_performance AS

SELECT
    traffic_source,
    COUNT(*) AS sessions,
    SUM(
        CASE
            WHEN converted = 1 THEN 1
            ELSE 0
        END
    ) AS conversions,
    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN converted = 1 THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS conversion_rate_percent
FROM website_sessions
GROUP BY traffic_source;