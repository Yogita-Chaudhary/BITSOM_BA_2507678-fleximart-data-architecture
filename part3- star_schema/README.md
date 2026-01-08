# Part 3 — Data Warehouse & Analytics (Star Schema)

**Project:** FlexiMart Data Architecture  
**Module:** Part 3 – Data Warehouse and Analytics  

---

## Overview

This part of the project focuses on building a data warehouse using a star schema design.  
The warehouse stores historical sales data in a structured way to support reporting and analytics.

Dimension tables are created for date, product, and customer data. A fact table stores sales transactions.  
SQL analytical queries are then used to generate business insights such as sales trends, top products, and customer segments.

---

## Files in this Folder

| File | Purpose |
|------|----------|
| `star_schema_design.md` | Star schema documentation and design explanation |
| `warehouse_schema.sql` | SQL script to create dimension and fact tables |
| `warehouse_data.sql` | SQL script to populate tables with data |
| `analytics_queries.sql` | Business analytics SQL queries |

---

## Setup Instructions

```bash
# 1. Create Data Warehouse Database

mysql -u root -p -e "CREATE DATABASE fleximart_dw;"

# 2. Create Schema

mysql -u root -p fleximart_dw < warehouse_schema.sql

# 3. Load Data

mysql -u root -p fleximart_dw < warehouse_data.sql

# 4. Run analytics Queries

mysql -u root -p fleximart_dw < analytics_queries.sql

```
---

## Schema Design

**Fact Table**: fact_sales — stores transactional sales data

**Dimensions**:
dim_date — calendar information
dim_product — product details
dim_customer — customer attributes

This structure supports fast aggregation and easy drill-down analysis.

---

## Analytics Performed

- Monthly and quarterly sales analysis
- Product performance ranking by revenue
- Customer segmentation based on spending

--- 

## Key Learnings

- Understanding star schema design and dimensional modeling
- Separating transactional data from analytical data
- Writing analytical SQL using grouping and window functions
- Designing warehouses for business reporting

---

## Challenges Faced

- Creating surrogate keys and handling foreign key relationships
- Populating the date dimension correctly using recursive logic
- Avoiding duplicate dimension records
- Ensuring fact records matched valid dimension keys
- Debugging aggregation queries and window functions

---

## Outcome

The data warehouse supports historical analysis of sales data.
Business questions can now be answered using simple SQL queries without affecting the transactional system.