CREATE VIEW gold.product_report AS
WITH basic_info AS (
SELECT
f.order_number,
f.order_date,
f.customer_key,
f.sales_amount,
f.quantity,
p.product_key,
p.product_name,
p.category,
p.subcategory,
p.cost
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
WHERE order_date IS NOT NULL
),

advanced_info AS (
SELECT
product_key,
product_name,
category,
subcategory,
cost,
DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS total_month_visited,
MAX(order_date) AS last_sale_date,
COUNT(DISTINCT order_number) AS total_orders,
COUNT(DISTINCT customer_key) AS total_customers,
SUM(sales_amount) AS total_sales,
SUM(quantity) AS total_quantity,
ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)),1) AS avg_selling_price
FROM basic_info
GROUP BY
    product_key,
    product_name,
    category,
    subcategory,
    cost
)

SELECT 
product_key,
product_name,
category,
subcategory,
cost,
last_sale_date,
DATEDIFF(MONTH, last_sale_date, GETDATE()) AS months_unseen,
CASE WHEN total_sales > 50000 THEN 'High-Performer'
	 WHEN total_sales >= 10000 THEN 'Mid-Performer'
	 ELSE 'Low-Performer'
END AS product_performance,
total_month_visited,
total_orders,
total_sales,
total_quantity,
total_customers,
avg_selling_price,
CASE WHEN total_month_visited = 0 THEN total_sales
	 ELSE total_sales / total_month_visited
END AS avg_monthly_sales
FROM advanced_info 

--this query is a product report that gives detail information about everything related (very similar to customer report)
--1. product key (distinct)
--2. product name
--3. category of product
--4. sub category of product
--5. cost of product
--6. last time product was sold
--7. total months that the product was unsold for
--8. how well the product performs: High-Performer (total sales of over $50000)
--                                  Mid-Performer (total sales of over $10000)
--                                  Low_Performer (total sales less than $10000)
--9. total month the product was involved in purchase
--10. total number of product sold
--11. total money the product got
--12. total quantity the product had sold
--13. total customers involved in purchasing the product
--14. average price of the product
--15. average money the product is involved per month
--finally, this is also uploaded as Views so that a new query can access it.