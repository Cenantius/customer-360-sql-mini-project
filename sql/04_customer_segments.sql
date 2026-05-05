-- 04_customer_segments.sql
-- Customer segmentation analysis for the Customer 360 SQL Mini Project.
-- This query classifies customers based on completed order revenue and purchase frequency.

-- Customer segmentation
-- Business question:
-- Which customers are high-value, repeat buyers, one-time buyers or no-purchase customers?

-- "WITH xxx_xxxx AS ( ... )" is known as CTE = Common Table Expression
-- CTE is a "temporary table", which exists only during this one questionnaire
WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email,
        c.city,
        c.age_group,
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
    -- Select all customers and add in their orders, if there are any
    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email,
        c.city,
        c.age_group
)

SELECT
    customer_id,
    first_name,
    last_name,
    email,
    city,
    age_group,
    lifetime_value,
    completed_orders,
    last_order_date,
    -- The order of CASE WHEN here matters. There must always be a priority
    CASE
        WHEN lifetime_value >= 200 THEN 'high_value'
        WHEN completed_orders >= 2 THEN 'repeat_customer'
        WHEN completed_orders = 1 THEN 'one_time_buyer'
        ELSE 'no_purchase'
    END AS customer_segment
FROM customer_revenue
ORDER BY lifetime_value DESC;

-- Segment summary
-- Business question:
-- How many customers belong to each segment?

WITH customer_revenue AS (
    SELECT
        c.customer_id,
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
        ) AS completed_orders
    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_id
),

customer_segments AS (
    SELECT
        customer_id,
        CASE
            WHEN lifetime_value >= 200 THEN 'high_value'
            WHEN completed_orders >= 2 THEN 'repeat_customer'
            WHEN completed_orders = 1 THEN 'one_time_buyer'
            ELSE 'no_purchase'
        END AS customer_segment
    FROM customer_revenue
)

SELECT
    customer_segment,
    COUNT(*) AS customer_count
FROM customer_segments
GROUP BY customer_segment
ORDER BY customer_count DESC;