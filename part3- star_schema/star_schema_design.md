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

The data warehouse is designed at the transaction line-item level, meaning that each record in the fact table represents a single product sold within an order. This level of granularity was selected because it allows detailed and flexible analysis of sales data. It enables the business to examine product performance, pricing trends, customer behavior, and the impact of discounts over time. If the data were aggregated at a higher level, such as monthly totals, many of these detailed insights would be lost.

Surrogate keys have been used instead of natural keys to improve consistency and performance. Natural identifiers such as customer IDs or product codes may change in operational systems or may differ across data sources. Surrogate keys provide a stable and uniform way to link tables within the warehouse, and they also improve query efficiency because integer-based joins are faster.

This star schema structure supports both drill-down and roll-up analysis. Users can drill down from yearly to quarterly, monthly, and daily sales, or roll up detailed data into higher-level summaries, making the warehouse suitable for both operational and strategic reporting.


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

dim_date: {date_key: 20240115, full_date: '2024-01-15', month: 1, quarter: 'Q1', year: }

dim_product: {product_key: 5, product_name: 'Laptop', category: 'Electronics'}

dim_customer: {customer_key: 12, customer_name: 'John Doe', city: 'Mumbai'}





