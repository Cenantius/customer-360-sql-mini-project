# Customer 360 SQL Mini Project

This project demonstrates SQL skills through a realistic customer and marketing analytics database.

The goal is to build a small Customer 360 analytics database for a fictional e-commerce company and use SQL to answer business questions about customers, revenue, marketing channels, email campaigns and data quality.

## Business context

A fictional e-commerce company wants to understand:

- who their most valuable customers are
- which customers have given marketing consent
- how much revenue has been generated monthly
- which website channels convert best
- how email campaigns perform
- whether there are data quality issues in the dataset

## Database structure

The project contains five relational tables:

| Table | Description |
|---|---|
| `customers` | Customer master data such as name, email, city, age group and marketing consent |
| `orders` | Customer orders, revenue, order date and order status |
| `website_sessions` | Website visits, acquisition channels, landing pages, devices and conversions |
| `email_campaigns` | Email campaign metadata |
| `email_events` | Email opens, clicks and purchase events |

## SQL files

| File | Description |
|---|---|
| `01_create_tables.sql` | Creates the database tables |
| `02_insert_sample_data.sql` | Inserts sample customer, order, website and email data |
| `03_basic_analysis.sql` | Basic SQL analysis queries |
| `04_customer_segments.sql` | Customer segmentation analysis |
| `05_campaign_performance.sql` | Email campaign performance analysis |
| `06_data_quality_checks.sql` | Data quality validation queries |

## Skills demonstrated

This project demonstrates:

- SQL table creation
- primary keys and foreign keys
- relational data modeling
- `SELECT`
- `WHERE`
- `GROUP BY`
- `ORDER BY`
- `JOIN` and `LEFT JOIN`
- aggregate functions such as `COUNT`, `SUM` and `MAX`
- `CASE WHEN`
- Common Table Expressions
- data quality checks
- customer segmentation
- marketing analytics

## Example business questions answered

### 1. Who are the most valuable customers?

The customer lifetime value query combines customer and order data to calculate completed revenue per customer.

### 2. Which customers belong to each customer segment?

Customers are classified into segments:

- `high_value`
- `repeat_customer`
- `one_time_buyer`
- `no_purchase`

### 3. Which website channels convert best?

The channel performance query calculates sessions, conversions and conversion rate by acquisition channel.

### 4. How did email campaigns perform?

The campaign performance query calculates:

- opens
- clicks
- purchases
- click-to-open rate

### 5. Can the data be trusted?

The data quality checks look for:

- missing customer emails
- duplicate customer emails
- orders without matching customers
- negative order amounts
- unknown website channels
- invalid conversion values
- invalid order statuses
- invalid email event types

## Example results

### Customer segmentation

![Customer segmentation result](docs/images/customer-segments.png)

### Segment summary

![Segment summary result](docs/images/segment-summary.png)

### Campaign performance

![Campaign performance result](docs/images/campaign-performance.png)

### Data quality summary

![Data quality summary](docs/images/data-quality-summary.png)

### Channel conversion rate

![Channel conversion rate result](docs/images/channel-conversion-rate.png)

## How to run with DB Browser for SQLite

1. Open DB Browser for SQLite.
2. Create or open the database file:

   `data/customer360.db`

3. Open the `Execute SQL` tab.
4. Run the contents of:

   `sql/01_create_tables.sql`

5. Run the contents of:

   `sql/02_insert_sample_data.sql`

6. Run the analysis queries from:

   - `sql/03_basic_analysis.sql`
   - `sql/04_customer_segments.sql`
   - `sql/05_campaign_performance.sql`
   - `sql/06_data_quality_checks.sql`

## Project status

This is the first version of the project. Future improvements may include:

- larger generated sample data
- Python-based ETL pipeline
- Power BI or Streamlit dashboard
- Azure SQL version
- Databricks / PySpark version