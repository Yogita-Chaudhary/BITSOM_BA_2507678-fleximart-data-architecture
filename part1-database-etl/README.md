# Part 1 – ETL Pipeline

**Project**: FlexiMart Data Architecture
**Module**: Part 1 – Database & ETL Pipeline

---

## Overview

This part of the project implements an ETL (Extract, Transform, Load) pipeline for FlexiMart.
The pipeline reads raw CSV data, cleans and standardizes it, and loads it into a MySQL database.

The main objective is to ensure that the data is clean, consistent, and ready for analysis and reporting in later stages of the project.

---

## Files in this Folder
1. **etl_pipeline.py** - Python script for extracting, cleaning, transforming, and loading data
2. **schema_documentation.md** - Description of database tables and columns
3. **business_queries.sql**- SQL queries for business analysis
4. **data_quality_report.txt**- Summary of data quality issues and resolutions
5. **requirements.txt**- List of required Python packages

---

## Setup Instructions

```bash

# Create a Virtual Environment
## 1. On Windows:
python -m venv venv
venv\Scripts\activate

## 2. On macOS / Linux:
python3 -m venv venv
source venv/bin/activate

# Install dependencies
python -m pip install -r requirements.txt

# Setup Environment Variables

#Create a .env file in this folder with the database credentials:

HOST_URL='localhost'
USER_NAME='root'
PASSWORD='your_password'
DATABASE_NAME='fleximart_db'

# Run the ETL Pipeline
python etl_pipeline.py
```
This process will:
- Read CSV files
- Clean and standardize the data
- Remove duplicates and invalid values
- Load cleaned data into MySQL tables

```bash
# After execution, check for:
# - Cleaned data loaded into your database
# - A summary report generated as data_quality_report.txt
```
---

## ETL Process

**Extract**
Reads CSV files containing customers, products, and orders.

**Transform** 
- Removes duplicate records
- Handles missing values (drop or fill based on rules)
- Standardize phone formats (e.g., +91-9876543210).
- Standardize category names (e.g., "electronics", "Electronics", "ELECTRONICS" → "Electronics").
- Convert date formats to YYYY-MM-DD.
- Add surrogate keys (auto-incrementing IDs).

**Load**
Inserts the cleaned data into MySQL tables (customers, products, orders, order_items) using python.

**Report**
Generate a data quality report summarizing the ETL process.

---

## Business Queries

The business_queries.sql file contains queries to answer questions such as:
- Which customers spend the most?
- Which product categories generate the highest revenue?
- What are the monthly sales trends?

These queries convert transactional data into useful business insights.

---

## Key Learnings

- Learned how to design and implement an ETL pipeline using Python and SQL.
- Understood the importance of data cleaning before analysis.
- Practiced using joins, aggregations, and window functions in SQL.
- Learned how to integrate Python, MySQL, and MongoDB in one data system.

---

## Challenges Faced
- **MySQL insert and syntax errors**
Solved by carefully checking column names, data types, and GROUP BY clauses.
- **CTE and recursive query errors in MySQL 8**
Fixed by understanding MySQL's CTE limitations and correct syntax placement.
- **Handling missing or inconsistent data**
Resolved by defining clear rules for filling or removing values.
- **Foreign key mismatches during loading**
Solved by loading dimension/master tables before transactional data.
- **Phone number and category standardization**
Required custom Python logic using libraries.

---

## Outcome

A complete analytical data warehouse was created that supports:
- Business reporting
- Trend analysis
- Decision-making insights