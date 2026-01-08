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

- Python 3.x, pandas, mysql-connector-python
- MySQL 8.0 / PostgreSQL 14
- MongoDB 6.0

## Setup Instructions

### Database Setup

```bash
# Create databases
mysql -u root -p -e "CREATE DATABASE fleximart;"
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

mongosh < part2-nosql/mongodb_operations.js

## Key Learnings

[3-4 sentences on what you learned]

## Challenges Faced

1. [Challenge and solution]
2. [Challenge and solution]

