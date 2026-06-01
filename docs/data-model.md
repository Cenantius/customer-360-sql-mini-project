# Data Model

This project uses a small relational data model for customer and marketing analytics

The model is designed around five core tables:

- `customers`
- `orders`
- `website_sessions`
- `email_campaigns`
- `email_events`

## Entity overview

### customers

The `customers` table contains customer master data

Each row represents one customer.

Key columns:

| Column | Description |
|---|---|
| `customer_id` | Unique customer identifier |
| `first_name` | Customer first name |
| `last_name` | Customer last name |
| `email` | Customer email address |
| `city` | Customer city |
| `age_group` | Customer age group |
| `signup_date` | Date when the customer was created |
| `marketing_consent` | Whether the customer has given marketing consent |

### orders

The `orders` table contains customer purchase data.

Each row represents one order.

Key columns:

| Column | Description |
|---|---|
| `order_id` | Unique order identifier |
| `customer_id` | Customer who placed the order |
| `order_date` | Date of the order |
| `order_amount` | Order revenue |
| `order_status` | Order status, such as `completed` or `cancelled` |

Relationship:

- `order.customer_id` references `customers.customer_id`

### website_sessions

The `website_sessions` table contains website visit data.

Each row represents one website session.

Key columns:

| Column | Description |
|---|---|
| `session_id` | Unique website session identifier |
| `customer_id` | Linked customer, if known |
| `session_date` | Date of the website session |
| `channel` | Acquisition source of traffic |
| `landing_page` | First page visited |
| `device_type` | Device type |
| `converted` | Whether the session converted |

Relationship:

- `website_sessions.customer_id` references `customers.customer_id`

The `customer_id` can be `NULL` because not every website visitor is known.

### email_campaigns

The `email_campaigns` table contains email campaign metadata.

Each row represents one campaign.

Key columns:

| Column | Description |
|---|---|
| `campaign_id` | Unique campaign identifier |
| `campaign_name` | Campaign name |
| `campaign_type` | Campaign type |
| `send_date` | Date when the campaign was sent |

### email_events

The `email_events` table contains customer-level campaign events.

Each row represents one event, such as an open, click or purchase.

Key columns:

| Column | Description |
|---|---|
| `event_id` | Unique event identifier |
| `customer_id` | Customer linked to the event |
| `campaign_id` | Campaign linked to the event |
| `event_type` | Event type: `open`, `click` or `purchase` |
| `event_date` | Timestamp of the event |

Relationships:

- `email_events.customer_id` references `customers.customer_id`
- `email_events.campaign_id` references `email_campaigns.campaign_id`

## Analytics view

Thye project also includes reusable analytics views

| View | Description |
|---|---|
| `customer_360` | Customer-level analytics view with revenue and order metrics |
| `customer_segments` | Customer segmentation view based on value and purchase frequency |
| `channel_performance` | Website channel conversion performance |
| `campaign_performance` | Email campaign performance metrics |

## Design decisions

The data model separates customer, order, website and email campaign data into different tables.

This keeps the model flexible and avoids duplicating customer data across multiple tables.

The analytics views then combine the raw relational tables into business-friendly datasets.
