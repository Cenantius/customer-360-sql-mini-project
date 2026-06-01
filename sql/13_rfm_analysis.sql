-- RFM customer analysis
-- Recency, Frequency, Monetary

WITH customer_metrics AS (

    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email,
        c.city,

        MAX(o.order_date) AS most_recent_order_date,

        COUNT(o.order_id) AS completed_orders,

        COALESCE(
            ROUND(SUM(o.order_amount), 2),
            0
        ) AS total_revenue

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

    most_recent_order_date,

    completed_orders,

    total_revenue,

    CASE
        WHEN total_revenue >= 1500 THEN 'vip_customer'
        WHEN total_revenue >= 750 THEN 'high_value'
        WHEN completed_orders >= 3 THEN 'loyal_customer'
        WHEN completed_orders >= 1 THEN 'active_customer'
        ELSE 'inactive_customer'
    END AS customer_segment

FROM customer_metrics

ORDER BY total_revenue DESC;