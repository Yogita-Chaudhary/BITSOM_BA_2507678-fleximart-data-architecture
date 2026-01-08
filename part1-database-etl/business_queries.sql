-- Query 1: Customer Purchase History
-- Business Question: Generate a detailed report showing each customer's name, email, 
--                    total number of orders placed, and total amount spent. 
--                    Include only customers who have placed at least 2 orders and 
--                    spent more than ₹5,000. Order by total amount spent in descending order.
-- Expected to return customers with 2+ orders and >5000 spent

SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email, 
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent
FROM fleximart_db.customers c 
INNER JOIN fleximart_db.orders o ON c.customer_id = o.customer_id
INNER JOIN fleximart_db.order_items ot ON o.order_id = ot.order_id
GROUP BY customer_name, c.email
HAVING total_orders >= 2 
	AND total_spent > 5000
ORDER BY total_spent DESC;


-- Query 2: Product Sales Analysis
-- Business Question: For each product category, show the category name, number of 
--                    different products sold, total quantity sold, and total revenue generated. 
--                    Only include categories that have generated more than ₹10,000 in revenue. 
--                    Order by total revenue descending.
-- Expected to return categories with >10000 revenue

SELECT p.category, 
	COUNT(DISTINCT p.product_id) AS num_products,
    SUM(ot.quantity) AS total_quantity_sold, 
    SUM(ot.subtotal) AS total_revenue
FROM products p 
INNER JOIN order_items ot
ON p.product_id = ot.product_id
GROUP BY p.category
HAVING total_revenue > 10000
ORDER BY total_revenue DESC;


-- Query 3: Monthly Sales Trend
-- Business Question: Show monthly sales trends for the year 2024. 
--                    For each month, display the month name, total number of orders, 
--                    total revenue, and the running total of revenue (cumulative revenue from 
--                    January to that month)
-- Expected to show monthly and cumulative revenue

-- Query 3: Monthly Sales Trend (with window function)

SELECT
    month_name,
    total_orders,
    monthly_revenue,
    SUM(monthly_revenue) OVER (ORDER BY month_num) AS cumulative_revenue
FROM (
    SELECT
        MONTH(o.order_date) AS month_num,
        MONTHNAME(o.order_date) AS month_name,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(o.total_amount) AS monthly_revenue
    FROM orders o
    WHERE YEAR(o.order_date) = 2024
    GROUP BY month_num, month_name
) t
ORDER BY month_num;


