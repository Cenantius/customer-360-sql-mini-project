-- 08_view_analysis.sql
-- Example analysis queries using reusable views.

-- 1. Top customers by lifetime value

SELECT
    customer_id,
    first_name,
    last_name,
    city,
    lifetime_value,
    completed_orders,
    customer_segment
FROM customer_segments
ORDER BY lifetime_value DESC;

-- 2. Customer count by segment

SELECT
    customer_segment,
    COUNT(*) AS customer_count
FROM customer_segments
GROUP BY customer_segment
ORDER BY customer_count DESC;

-- 3. Best converting website channels

SELECT
    channel,
    sessions,
    conversions,
    conversion_rate
FROM channel_performance
ORDER BY conversion_rate DESC;

-- 4. Email campaign performance ranking

SELECT
    campaign_name,
    campaign_type,
    opens,
    clicks,
    purchases,
    click_to_open_rate
FROM campaign_performance
ORDER BY purchases DESC, clicks DESC;