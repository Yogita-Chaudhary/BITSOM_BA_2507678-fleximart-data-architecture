-- Query 1: Monthly Sales Drill-Down
-- Business Scenario: The CEO wants to see sales performance broken down by time periods. 
--                    Start with yearly total, then quarterly, then monthly sales for 2024.
-- Demonstrates: Drill-down from Year to Quarter to Month

SELECT 
	dd.year, 
	dd.quarter, 
    dd.month_name, 
    SUM(fs.total_amount) AS total_amount, 
    SUM(fs.quantity_sold) AS total_quantity
FROM fact_sales fs 
INNER JOIN dim_date dd
ON fs.date_key = dd.date_key
WHERE dd.year = 2024
GROUP BY dd.year, dd.quarter, dd.month_name
ORDER BY dd.month_name;


-- Query 2: Top 10 Products by Revenue
-- Business Scenario: The product manager needs to identify top-performing products. 
--                    Show the top 10 products by revenue, along with their category, total units sold, 
--                    and revenue contribution percentage.
-- Includes: Revenue percentage calculation

SELECT 
	dp.product_name, 
    dp.category, 
    SUM(fs.quantity_sold) AS units_sold, 
    SUM(fs.total_amount) AS revenue,
    ROUND(SUM(fs.total_amount)/SUM(SUM(fs.total_amount)) OVER() * 100, 2) AS revenue_percentage
FROM fact_sales fs 
INNER JOIN dim_product dp
ON fs.product_key = dp.product_key
GROUP BY dp.product_name, dp.category
ORDER BY revenue DESC
LIMIT 10;


-- Query 3: Customer Segmentation
-- Business Scenario: Marketing wants to target high-value customers. 
--                    Segment customers into 'High Value' (>₹50,000 spent), 'Medium Value' (₹20,000-₹50,000), 
--                    and 'Low Value' (<₹20,000). Show count of customers and total revenue in each segment.
-- Segments: High/Medium/Low value customers

WITH customer_totals AS (
    SELECT 
        dc.customer_key,
        SUM(fs.total_amount) AS total_spent
    FROM fact_sales fs
    JOIN dim_customer dc ON fs.customer_key = dc.customer_key
    GROUP BY dc.customer_key
)
SELECT
    CASE
        WHEN total_spent > 50000 THEN 'High Value'
        WHEN total_spent BETWEEN 20000 AND 50000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment,
    COUNT(*) AS customer_count,
    SUM(total_spent) AS total_revenue,
    AVG(total_spent) AS avg_revenue_per_customer
FROM customer_totals
GROUP BY customer_segment;

