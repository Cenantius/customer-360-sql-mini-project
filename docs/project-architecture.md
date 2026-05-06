# Project arhcitecture

This project is a small SQL-based 360 analytics project.

It demonstrates how raw customer, order, website and email marketing data can be modeled, queried and transformed into reusable analytics views.

## Current architecture

Sample SQL data
      ↓
Raw relational tables
      ↓
Analysis SQL queries
      ↓
Reusable analytics views
      ↓
Business insights

## Layers

### 1. Raw data layer

The raw data layer consists of the base database tables:

- `customers`
- `orders`
- `website_sessions`
- `email_campaigns`
- `email_events`

These tables represent the source data.

### 2. Analysis query layer

The analysis query layer contains standalone SQL files that answer specific business questions.

Files:

| File | Purpose |
|---|---|
| `03_basic_analysis.sql` | Basic customer, revenue and channels analysis |
| `04_customer_segments.sql` | Customer segmentation queries |
| `05_campaign_performance.sql` | Email campaign performance queries |
| `06_data_quality_checks.sql` | Data quality validation queries |

### 3. Analytics view layer

The analytics view layer contains reusable SQL views.

Files:

| File | Purpose |
|---|---|
| `07_create_views.sql` | Creates reusable analytics views |
| `08_view_analysis.sql` | Runs analysis queries against the views |

Views:

| View | Purpose |
|---|---|
| `customer_360` | Customer-level revenue and order metrics |
| `customer_segments` | Customer segmentation |
| `channel_performance` | Website acquisition channel performance |
| `campaign_performance` | Email campaign performance |

## Why views are used?

Views make the project easier to use and maintain.

Instead of repeating long SQL queries every time, the project stores common transformation logic as reusable views.

For example:

SELECT *
FROM customer_segments
ORDER BY lifetime_value DESC;

This is easier to use than rewriting the full customer segmentation logic every time.

## Data quality approach

The project includes data quality checks for:
- `missing customer emails`
- `duplicate customer emails`
- `orders without matching customers`
- `negative order amounts`
- `unknown website channels`
- `invalid conversion values`
- `invalid order statuses`
- `invalid email event types`

The goal is to demonstrate that analytics should not only produce insights, but also validate wether the underlying data can be trusted.

## Future architecture

The next planned version of the project could add a Python ETL layer:

Generated CSV data
      ↓
Python ETL scripts
      ↓
SQLite / PostgreSQL database
      ↓
SQL analytics views
      ↓
Dashboard / BI layer

Potential future tools:
- `Python`
- `pandas`
- `SQLAlchemy`
- `PostgreSQL`
- `Power BI or Streamlit`
- `Azure SQL`
- `Databricks / PySpark`

