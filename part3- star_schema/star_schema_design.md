# Star Schema Design — FlexiMart

## Section 1: Schema Overview

### FACT TABLE: fact_sales
**Grain:** One row per product per order line item  
**Business Process:** Sales transactions

**Measures:**
- quantity_sold: Number of units sold
- unit_price: Price per unit at time of sale
- discount_amount: Discount applied
- total_amount: Final amount (quantity × unit_price − discount)

**Foreign Keys:**
- date_key → dim_date
- product_key → dim_product
- customer_key → dim_customer

---

### DIMENSION TABLE: dim_date
**Purpose:** Time-based analysis  
**Type:** Conformed dimension  

Attributes:
- date_key (PK): Surrogate key (YYYYMMDD)
- full_date
- day_of_week
- day_of_month
- month
- month_name
- quarter
- year
- is_weekend

---

### DIMENSION TABLE: dim_product
**Purpose:** Product analysis  

Attributes:
- product_key (PK)
- product_id
- product_name
- category
- subcategory
- unit_price

---

### DIMENSION TABLE: dim_customer
**Purpose:** Customer segmentation  

Attributes:
- customer_key (PK)
- customer_id
- customer_name
- city
- state
- customer_segment

---


## Section 2: Design Decisions

The data warehouse is designed at the transaction line-item level, meaning that each row in the fact table represents one product sold in one order. This level of detail was chosen because it allows the business to analyze sales very flexibly. For example, it becomes easy to see which individual product is selling more, how discounts affect sales, or how customer behavior changes over time. If the data were stored only at a daily or monthly level, this type of detailed analysis would not be possible.

Surrogate keys are used instead of natural keys because they are stable and efficient. Natural keys like customer IDs or product IDs may change in operational systems, or may differ across data sources. Surrogate keys ensure that the warehouse remains consistent even if source system identifiers change. They also improve query performance because they are simple integers and join operations become faster.

This star schema design supports drill-down and roll-up analysis very well. Analysts can easily drill down from yearly sales to quarterly, monthly, or even daily sales using the date dimension. Similarly, they can roll up product-level data to category-level or subcategory-level summaries. This makes the warehouse suitable for both high-level reporting and detailed analysis.

## Section 3: Sample Data Flow

**Source Transaction:**  
Order #101, Customer "John Doe", Product "Laptop", Qty: 2, Price: 50000

**Data Warehouse Representation:**

fact_sales:
- date_key: 20240115
- product_key: 5
- customer_key: 12
- quantity_sold: 2
- unit_price: 50000
- total_amount: 100000

dim_date: {date_key: 20240115, full_date: '2024-01-15', month: 1, quarter: 'Q1'}

dim_product: {product_key: 5, product_name: 'Laptop', category: 'Electronics'}

dim_customer: {customer_key: 12, customer_name: 'John Doe', city: 'Mumbai'}
