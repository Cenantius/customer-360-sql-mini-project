-- 05_campaign_performance.sql
-- Email campaign performance analysis for the Customer 360 SQL Mini Project.
-- These queries analyze email opens, clicks, purchases and campaign-level engagement.

-- Campaign performance overview
-- Business question:
-- How many opens, clicks and purchases did each email campaign generate?

SELECT
    ec.campaign_id,
    ec.campaign_name,
    ec.campaign_type,
    ec.send_date,
    -- Count the rows where the event_type is open and return 1
    COUNT(CASE WHEN ee.event_type = 'open' THEN 1 END) AS opens,
    COUNT(CASE WHEN ee.event_type = 'click' THEN 1 END) AS clicks,
    COUNT(CASE WHEN ee.event_type = 'purchase' THEN 1 END) AS purchases,
    -- click to open ratio = clicks / opens aka how many opens resulted in a click
    -- NULLIF, because we can't have the possibility that something would be divided by zero
    ROUND(
        1.0 * COUNT(CASE WHEN ee.event_type = 'click' THEN 1 END)
        / NULLIF(COUNT(CASE WHEN ee.event_type = 'open' THEN 1 END), 0),
        2
    ) AS click_to_open_rate
FROM email_campaigns ec
-- LEFT JOIN = Show all the rows from the table on the left, 
-- EVEN THOUGH the right one doesn't have the corresponding rows
LEFT JOIN email_events ee
    ON ec.campaign_id = ee.campaign_id
GROUP BY
    ec.campaign_id,
    ec.campaign_name,
    ec.campaign_type,
    ec.send_date
ORDER BY purchases DESC, clicks DESC;

-- Event breakdown by campaign
-- Business question:
-- What types of events did each campaign generate?

SELECT
    ec.campaign_name,
    ee.event_type,
    COUNT(*) AS event_count
FROM email_campaigns ec
LEFT JOIN email_events ee
    ON ec.campaign_id = ee.campaign_id
GROUP BY
    ec.campaign_name,
    ee.event_type
ORDER BY
    ec.campaign_name,
    event_count DESC;