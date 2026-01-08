# Part 2 — NoSQL (MongoDB Analysis)

**Project:** FlexiMart Data Architecture  
**Module:** Part 2 – NoSQL Database Analysis  

---

## Overview

This part of the project uses MongoDB to store and analyze semi-structured product and review data.  
It shows how NoSQL databases handle nested documents, flexible schemas, and arrays, which are difficult to model in relational databases.

MongoDB is used to perform filtering, updates, and aggregation on product and review data using Python.

---

## Files in this Folder

| File | Purpose |
|------|----------|
| `products_catalog.json` | Raw product and review data |
| `mongodb.py` | Python script for MongoDB operations |
| `nosql_analysis.md` | Explanation of NoSQL queries and results |

---

## Setup Instructions
```bash
### 1. Start MongoDB

#Make sure MongoDB is running.

#**Windows:**  
#Start MongoDB from *Services* or MongoDB Compass.

#**Mac:**

brew services start mongodb-community

# 2. Install Python Dependencies
pip install pymongo python-dotenv

# 3. Run MongoDB Operations
python mongodb.py
```
This will:
- Load the product data into MongoDB
- Run queries and aggregations
- Insert and update reviews

```bash
# 4. Verify Data
mongosh
use fleximart_db
db.products.find().limit(5)

```
---

## Operations Performed

- Load JSON product catalog into MogoDB
- Find products based on category and price
- Calculate average ratings from nested review arrays
- Add new reviews to products
- Aggregate data by category

---

## Key Learnings

- Understanding how NoSQL differs from relational databases
- Working with nested JSON structures
- Writing MongoDB queries using PyMongo
- Using aggregation pipelines for analytics

--- 

## Challenges Faced

1. MongoDB service not running or not recognized in the system PATH.
2. Differences between Mongo shell syntax and PyMongo syntax.
3. Handling nested arrays when calculating average ratings.
4. Debugging aggregation pipelines.

---

## Outcome

MongoDB was successfully used to:
- Store flexible product data
- Analyze reviews and ratings
- Support semi-structured data analysis