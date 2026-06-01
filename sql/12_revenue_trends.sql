-- Monthly completed revenue

SELECT
    strftime('%Y-%m', order_date) AS order_month,

    COUNT(order_id) AS completed_orders,

    ROUND(SUM(order_amount), 2) AS completed_revenue

FROM orders

WHERE order_status = 'completed'

GROUP BY strftime('%Y-%m', order_date)

ORDER BY order_month;

-- Monthly revenue growth

WITH monthly_revenue AS (

    SELECT
        strftime('%Y-%m', order_date) AS order_month,

        ROUND(SUM(order_amount), 2) AS completed_revenue

    FROM orders

    WHERE order_status = 'completed'

    GROUP BY strftime('%Y-%m', order_date)
)

SELECT *
FROM monthly_revenue
ORDER BY order_month;

-- Monthly revenue growth with previous month comparison

WITH monthly_revenue AS (

    SELECT
        strftime('%Y-%m', order_date) AS order_month,
        ROUND(SUM(order_amount), 2) AS completed_revenue
    FROM orders
    WHERE order_status = 'completed'
    GROUP BY strftime('%Y-%m', order_date)
),

revenue_with_previous_month AS (

    SELECT
        order_month,
        completed_revenue,

        LAG(completed_revenue) OVER (
            ORDER BY order_month
        ) AS previous_month_revenue

    FROM monthly_revenue
)

SELECT
    order_month,
    completed_revenue,
    previous_month_revenue,

    ROUND(
        100.0 * (completed_revenue - previous_month_revenue)
        / previous_month_revenue,
        2
    ) AS revenue_growth_percent

FROM revenue_with_previous_month
ORDER BY order_month;

-- Completed revenue by customer city

SELECT
    c.city,
    COUNT(o.order_id) AS completed_orders,
    COALESCE(ROUND(SUM(o.order_amount), 2), 0) AS completed_revenue
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
    AND o.order_status = 'completed'
GROUP BY c.city
ORDER BY completed_revenue DESC;