# Customer 360 Project Architecture

## Overview

This project simulates a small-scale modern analytics workflow for a fictional e-commerce company.

This project combines:

- Python-based synthetic data generation
- CSV raw data storage
- SQLite relational database storage
- SQL analytics queries
- Analytics views
- Customer segmentation
- Data quality validation

The goal is to demonstrate practical SQL, Python and analytics engineering skills using realistic business scenarios.

---

# Architecture Layers

## 1. Data Generation Layer

Python scripts generate realistic synthetic business data using:

- pandas
- faker
- random

Generated datasets include:

- customers
- orders
- website-sessions
- email-campaigns
- email-events

Generated files are stored as CSV files in:

data/raw

---

## 2. Storage Layer

CSV data is loaded into a SQLite database:

data/customer360.db

The database contains relational tables connected through customer and campaign identifiers.

---

## 3. Analytics Layer

SQL queries are used to create:

- customer lifetime value analysis
- revenue trends
- customer segmentation
- campaign performance analysis
- cohort analysis
- channel conversion analysis

Reusable analytics views are created for common business metrics.

---

## 4. Data Quality Layer

SQL validation queries check for:

- missing emails
- duplicate customers
- orphaned orders
- invalid statuses
- invalid event values

This simulates real-world analytics engineering validation workflows.

---

# Data Flow

Python scripts
    ↓
CSV raw data
    ↓
SQLite database
    ↓
SQL analytics queries
    ↓
Analytics views
    ↓
Business insights

---

# Technologies Used

| Technology | Purpose |
| --- | --- |
| Python | Data generation and ETL |
| pandas | DataFrame processing |
| Faker | Synthetic data generation |
| SQLite | Relational database |
| SQL | Analytics and transformations |
| DB Browser for SQLite | Local database management |

---

# Future Improvements

Potential future improvements include:

- automated ETL pipeline
- Power BI dashboard
- Streamlit dashboard
- Azure SQL migration
- Databricks / PySpark version
- orchestration workflows
- Docker support
- dbt-style transformations