INSERT INTO fleximart_dw.dim_date (
    date_key,
    full_date,
    day_of_week,
    day_of_month,
    month,
    month_name,
    quarter,
    year,
    is_weekend
)
SELECT
    DATE_FORMAT(dte, '%Y%m%d') AS date_key,
    dte AS full_date,
    DAYNAME(dte),
    DAYOFMONTH(dte),
    MONTH(dte),
    MONTHNAME(dte),
    CONCAT('Q', QUARTER(dte)),
    YEAR(dte),
    CASE WHEN WEEKDAY(dte) IN (5,6) THEN 1 ELSE 0 END
FROM (
    WITH RECURSIVE dates AS (
        SELECT DATE('2024-01-01') AS dte
        UNION ALL
        SELECT DATE_ADD(dte, INTERVAL 1 DAY)
        FROM dates
        WHERE dte < '2024-02-29'
    )
    SELECT dte FROM dates
) AS t;

INSERT INTO fleximart_dw.dim_product (product_id, product_name, category, unit_price)
SELECT product_id, product_name, category, price
FROM fleximart_db.products;
SET SQL_SAFE_UPDATES = 0;
UPDATE dim_product
SET subcategory = CASE
    WHEN product_name REGEXP '(?i)\\b(Samsung Galaxy|iPhone|Phone|Nord)\\b' THEN 'Mobiles'
    WHEN product_name REGEXP '(?i)\\b(Laptop|MacBook)\\b'    THEN 'Laptops'
    WHEN product_name REGEXP '(?i)\\b(Headphones|Earbud|Earbuds)\\b' THEN 'Audio'
    WHEN product_name REGEXP '(?i)\\b(Monitor)\\b'          THEN 'Monitors'
    WHEN product_name REGEXP '(?i)\\b(TV|Television)\\b'    THEN 'Televisions'
    ELSE 'Unknown'
  END
WHERE subcategory IS NULL
  AND category = 'Electronics';
  UPDATE dim_product
SET subcategory = CASE
    WHEN product_name REGEXP '(?i)\\b(Shoes|Sneakers)\\b' THEN 'Shoes'
    WHEN product_name REGEXP '(?i)\\b(Jeans|T-Shirt|Shirt|Trackpants)\\b'    THEN 'Cloths'
    ELSE 'Unknown'
  END
WHERE subcategory IS NULL
  AND category = 'Fashion';
  UPDATE dim_product
SET subcategory = CASE
    WHEN product_name LIKE '%Almond%' THEN 'Dry Fruits'
    WHEN product_name LIKE '%Rice%' THEN 'Grains'
    WHEN product_name LIKE '%Honey%' THEN 'Condiments'
    WHEN product_name LIKE '%Dal%' THEN 'Pulses'
    ELSE 'Other'
END
WHERE category = 'Groceries'
  AND subcategory IS NULL;
  INSERT INTO fleximart_dw.dim_customer (customer_id, customer_name, city)
SELECT customer_id, CONCAT(first_name,' ',last_name), city
FROM fleximart_db.customers;
UPDATE dim_customer
SET state = CASE
    WHEN city like 'Trivandrum' THEN 'Kerala'
    WHEN city like 'Pune' THEN 'Maharashtra'
    WHEN city like 'Mumbai' THEN 'Maharashtra'
    WHEN city like 'Lucknow' THEN 'Uttar Pradesh'
    WHEN city like 'Kolkata' THEN 'West Bengal'
    WHEN city like 'Kochi' THEN 'Kerala'
    WHEN city like 'Jaipur' THEN 'Rajasthan'
    WHEN city like 'Indore' THEN 'Madhya Pradesh'
    WHEN city like 'Hyderabad' THEN 'Telangana'
    WHEN city like 'Delhi' THEN 'Delhi'
    WHEN city like 'Chennai' THEN 'Tamil Nadu'
    WHEN city like 'Chandigarh' THEN 'Chandigarh'
    WHEN city like 'Bangalore' THEN 'Karnataka'
    WHEN city like 'Ahmedabad' THEN 'Gujarat'
    ELSE 'Unknown'
  END
WHERE state IS NULL;
UPDATE dim_customer
SET customer_segment = CASE customer_key
    WHEN 1 THEN 'Corporate'
    WHEN 2 THEN 'Retail'
    WHEN 3 THEN 'Corporate'
    WHEN 4 THEN 'Corporate'
    WHEN 5 THEN 'Retail'
    WHEN 6 THEN 'Small Business'
    WHEN 7 THEN 'Retail'
    WHEN 8 THEN 'Corporate'
    WHEN 9 THEN 'Retail'
    WHEN 10 THEN 'Small Business'
    WHEN 11 THEN 'Corporate'
    WHEN 12 THEN 'Retail'
    WHEN 13 THEN 'Small Business'
    WHEN 14 THEN 'Corporate'
    WHEN 15 THEN 'Corporate'
    WHEN 16 THEN 'Retail'
    WHEN 17 THEN 'Small Business'
    WHEN 18 THEN 'Retail'
    WHEN 19 THEN 'Corporate'
    WHEN 20 THEN 'Small Business'
    WHEN 21 THEN 'Small Business'
    WHEN 22 THEN 'Corporate'
    WHEN 23 THEN 'Retail'
    WHEN 24 THEN 'Small Business'
    WHEN 25 THEN 'Corporate'
END;

INSERT INTO fleximart_dw.fact_sales (
    date_key, product_key, customer_key,
    quantity_sold, unit_price, discount_amount, total_amount
)
SELECT
    date_key,
    product_key,
    customer_key,
    quantity_sold,
    unit_price,
    discount_amount,
    (quantity_sold * unit_price) - discount_amount AS total_amount
FROM (
    SELECT
        d.date_key,
        p.product_key,
        c.customer_key,
        SUM(ot.quantity) AS quantity_sold,
        ot.unit_price,

        CASE
            WHEN d.is_weekend = 1 AND c.customer_segment = 'Corporate'
                THEN ROUND(SUM(ot.subtotal) * 0.05, 2)
            ELSE 0
        END AS discount_amount

    FROM fleximart_db.order_items ot

	JOIN fleximart_db.orders o
    ON o.order_id = ot.order_id

	JOIN fleximart_dw.dim_date d
    ON d.full_date = o.order_date

	JOIN fleximart_dw.dim_product p
    ON p.product_id = ot.product_id

	JOIN fleximart_dw.dim_customer c
    ON c.customer_id = o.customer_id
    GROUP BY
        d.date_key,
        p.product_key,
        c.customer_key,
        ot.unit_price,
        d.is_weekend
) x;


SELECT * FROM fleximart_dw.dim_dates;
SELECT * FROM fleximart_dw.dim_product;
SELECT * FROM fleximart_dw.dim_customer;
SELECT * FROM fleximart_dw.fact_sales;