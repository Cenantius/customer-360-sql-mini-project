-- Customer cohort analysis

WITH customer_cohorts AS (

    SELECT
        customer_id,

        strftime('%Y-%m', signup_date) AS signup_month

    FROM customers
),

customer_revenue AS (

    SELECT
        c.customer_id,

        cc.signup_month,

        COUNT(o.order_id) AS completed_orders,

        COALESCE(
            ROUND(SUM(o.order_amount), 2),
            0
        ) AS total_revenue

    FROM customers c

    LEFT JOIN customer_cohorts cc
        ON c.customer_id = cc.customer_id

    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
        AND o.order_status = 'completed'

    GROUP BY
        c.customer_id,
        cc.signup_month
)

SELECT
    signup_month,

    COUNT(customer_id) AS customers,

    ROUND(AVG(completed_orders), 2) AS avg_completed_orders,

    ROUND(AVG(total_revenue), 2) AS avg_revenue_per_customer,

    ROUND(SUM(total_revenue), 2) AS total_cohort_revenue

FROM customer_revenue

GROUP BY signup_month

ORDER BY signup_month;