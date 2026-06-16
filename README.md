# Customer 360 SQL Mini Project

A portfolio project demonstrating SQL, Python, ETL and analytics engineering concepts using a fictional e-commerce Customer 360 dataset.

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
| `website_sessions` | Website visits, acquisition channels, landing pages, device types and conversions |
| `email_campaigns` | Email campaign metadata |
| `email_events` | Email opens, clicks and purchase events |

## Executive Dashboard

The project includes an interactive Power BI dashboard for customer segmentation, revenue analysis and marketing performance monitoring.

![Executive Dashboard](docs/images/customer360-dashboard-executive.png)

## Marketing Analytics Dashboard

![Marketing Dashboard](docs/images/customer360-dashboard-marketing.png)

## Documentation

Additional documentation:

- [Data model](docs/data-model.md)
- [Project architecture](docs/project-architecture.md)

## SQL files

| File | Description |
|---|---|
| `01_create_tables.sql` | Creates the database tables |
| `02_insert_sample_data.sql` | Inserts sample customer, order, website and email data |
| `03_basic_analysis.sql` | Basic SQL analysis queries |
| `04_customer_segments.sql` | Customer segmentation analysis |
| `05_campaign_performance.sql` | Email campaign performance analysis |
| `06_data_quality_checks.sql` | Data quality validation queries |
| `07_create_views.sql` | Creates reusable analytics views |
| `08_view_analysis.sql` | Example analysis queries using the views |
| `09_generated_data_analysis.sql` | Analysis on revenue, completed orders, channel conversion and channel performance |
| `10_create_analytics_views.sql` | Customer lifetime value and channel conversion performance views |
| `11_data_quality_checks.sql` | Data quality checks |
| `12_revenue_trends.sql` | Analysis on revenue trends |
| `13_rfm_analysis.sql` | Customer analysis on the recency, frequency and monetary metrics |
| `14_cohort_analysis.sql` | Average completed orders, revenue per customer and total cohort |

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
- reusable SQL views
- analytics layer design
- data model documentation
- data quality validation

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

### Revenue trends

![Revenue trends](docs/images/revenue-trends.png)

## How to run with DB Browser for SQLite

1. Create and activate virtual environment
2. Install requirements
3. Generate synthetic datasets
4. Load datasets into SQLite
5. Run analysis queries
6. Run the analysis queries from

## Azure SQL Migration

As part of this project, the local SQLite-based Customer 360 dataset was migrated to Microsoft Azure SQL Database.

### Azure Resources

- Azure SQL Database (Serverless)
- Azure SQL Server
- Azure Resource Group
- SQL Server Management Studio (SSMS)

### Migration Steps

1. Created an Azure SQL Database using Azure for Students.
2. Configured firewall rules to allow client access.
3. Connected to the database using SQL Server Management Studio (SSMS).
4. Recreated the Customer 360 database schema in Azure SQL.
5. Developed a Python ETL script using:
   - pandas
   - pyodbc
   - python-dotenv
6. Loaded CSV datasets into Azure SQL tables.

### Data Loaded

| Table | Rows |
|---------|---------:|
| customers | 100 |
| email_campaigns | 10 |
| orders | 577 |
| website_sessions | 842 |
| email_events | 1379 |

### Technologies Used

- Microsoft Azure SQL Database
- SQL Server Management Studio (SSMS)
- Python
- pandas
- pyodbc
- python-dotenv

### Validation

After loading the data, table contents were validated directly in Azure SQL using SSMS queries.

Example:

```sql
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM website_sessions;
SELECT COUNT(*) FROM email_campaigns;
SELECT COUNT(*) FROM email_events;
```

### Skills Demonstrated

- Cloud database deployment
- Azure SQL configuration
- SQL schema creation
- ETL pipeline development
- Python database connectivity
- Data migration from flat files to cloud database
- Cloud data validation

## Project status

This is the first version of the project. Future improvements may include:

- larger generated sample data
- Python-based ETL pipeline
- Power BI or Streamlit dashboard
- Azure SQL version
- Databricks / PySpark version

## Current Features

- Python-based synthetic data generation
- SQLite analytics database
- customer segmentation analysis
- campaign performance analytics
- cohort analysis
- revenue trend analysis
- analytics views
- data quality validation queries
- ETL-style CSV loading pipeline

## Future Improvements