# FlexiMart Data Architecture Project

**Student Name:** Yogita Chaudhary
**Student ID:** 
**Email:** yogita442@gmail.com
**Date:** 08.01.2026

## Project Overview

The FlexiMart Data Architecture Project focuses on building a complete data architechure for the FlexiMart retail system. It includes an ETL pipeline that helps in extracting, transforming and loading the data into MySQL. The project also includes NoSQL analysis for product catalog management using MongoDB and creation of a data warehouse using a star schema for reporting and business analytics. 
The main objective of this project is to convert raw operational data into clean, reliable, and analysis-ready data that can be used to answer important business questions and support decision-making.

## Repository Structure
├── part1-database-etl/
│   ├── etl_pipeline.py
│   ├── schema_documentation.md
│   ├── business_queries.sql
│   └── data_quality_report.txt
├── part2-nosql/
│   ├── nosql_analysis.md
│   ├── mongodb_operations.js
│   └── products_catalog.json
├── part3-datawarehouse/
│   ├── star_schema_design.md
│   ├── warehouse_schema.sql
│   ├── warehouse_data.sql
│   └── analytics_queries.sql
└── README.md

## Technologies Used

- Python 3.13.5, pandas, mysql-connector-python
- MySQL 8.0
- MongoDB 8.2.3

## Setup Instructions

### Project Setup
```bash
# Clone the repository
# Create Virtual Environment on Windows
python -m venv venv
venv\Scripts\activate

# Create Virtual Environment on Windows
python3 -m venv venv
source venv/bin/activate

# Install Dependencies
python -m pip install -r requirements.txt

# Deactivate Virtual Enviornment
deactivate
```

### Database Setup

```bash
# Create databases
mysql -u root -p -e "CREATE DATABASE fleximart_db;"
mysql -u root -p -e "CREATE DATABASE fleximart_dw;"

# Run Part 1 - ETL Pipeline
python part1-database-etl/etl_pipeline.py

# Run Part 1 - Business Queries
mysql -u root -p fleximart < part1-database-etl/business_queries.sql

# Run Part 3 - Data Warehouse
mysql -u root -p fleximart_dw < part3-datawarehouse/warehouse_schema.sql
mysql -u root -p fleximart_dw < part3-datawarehouse/warehouse_data.sql
mysql -u root -p fleximart_dw < part3-datawarehouse/analytics_queries.sql


### MongoDB Setup

python part2-nosql/mongodb_operations.py
```

## Key Learnings

- Designed and built a complete data pipeline, starting from raw transactional data and ending with an analytics-ready data warehouse.
- Gained hands-on experience with data cleaning, handling missing values, standardizing formats, and validating data quality using Python and SQL.
- Understood how to model data using a star schema and how dimension and fact tables improve reporting and query performance.
- Learned how to write business-focused SQL queries that answer real analytical questions and support decision-making.

## Challenges Faced

1. **Handling inconsistent and missing data**  
   - **Challenge** - Some fields in the raw data were missing or inconsistent.
   - **Solution** - Solved by applying cleaning rules, default values and standardization logic during the ETL process.

2. **Writing complex SQL queries with joins and aggregates**  
   - **Challenge** - Queries involving multiple joins, GROUP BY, HAVING, and window functions were initially difficult. 
   - **Solution** - Overcame this by breaking queries into smaller parts, testing each step, and validating intermediate results.

3. **Debugging SQL and environment issues**  
   - **Challenge** - Faced errors related to SQL syntax, data types, and environment setup (such as package installation and database connections).
   - **Solution** - Solved these by reading error messages carefully, checking documentation, and testing commands incrementally.

