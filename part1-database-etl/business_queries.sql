-- Query 1: Customer Purchase History
-- Business Question: Generate a detailed report showing each customer's name, email, 
--                    total number of orders placed, and total amount spent. 
--                    Include only customers who have placed at least 2 orders and 
--                    spent more than ₹5,000. Order by total amount spent in descending order.
-- Expected to return customers with 2+ orders and >5000 spent

SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email, COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent
FROM customers c 
INNER JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY customer_name, c.email
HAVING total_orders >= 2 
AND total_spent > 5000
ORDER BY total_amount_spent DESC;


-- Query 2: Product Sales Analysis
-- Business Question: For each product category, show the category name, number of 
--                    different products sold, total quantity sold, and total revenue generated. 
--                    Only include categories that have generated more than ₹10,000 in revenue. 
--                    Order by total revenue descending.
-- Expected to return categories with >10000 revenue

SELECT p.category, COUNT(DISTINCT ot.quantity) AS num_products,
    COUNT(DISTINCT ot.quantity) AS total_quantity_sold, SUM(ot.unit_price * ot.quantity) AS total_revenue
FROM products p RIGHT JOIN order_items order_items
ON p.product_id = ot.product_id

-- Query 3: Monthly Sales Trend
-- Business Question: Show monthly sales trends for the year 2024. 
--                    For each month, display the month name, total number of orders, 
--                    total revenue, and the running total of revenue (cumulative revenue from 
--                    January to that month)
-- Expected to show monthly and cumulative revenue

SELECT 

