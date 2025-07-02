CREATE VIEW gold.customer_report AS
WITH basic_info AS (
SELECT
f.order_number,
f.product_key,
f.order_date,
f.sales_amount,
f.quantity,
d.customer_key,
d.customer_number,
CONCAT(d.first_name, ' ', d.last_name) as customer_name,
DATEDIFF(year, d.birthdate, GETDATE()) as customer_age
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers d
On d.customer_key = f.customer_key
WHERE order_date IS NOT NULL
),


advanced_info AS (
SELECT 
customer_key,
customer_number,
customer_name,
customer_age,
COUNT(DISTINCT order_number) as total_orders,
SUM(sales_amount) as total_sales,
SUM(quantity) as total_quantity,
COUNT(DISTINCT product_key) as total_products,
MAX(order_date) as latest_order,
DATEDIFF(month, MIN(order_date), MAX(order_date)) as total_month_visited
FROM basic_info
GROUP BY
	customer_key,
	customer_number,
	customer_name,
	customer_age
)

SELECT
customer_key,
customer_number,
customer_name,
customer_age,
total_orders,
total_sales,
total_quantity,
total_products,
latest_order,
total_month_visited,
CASE WHEN total_month_visited >= 12 AND total_sales > 5000 THEN 'VIP'
	 WHEN total_month_visited >= 12 AND total_sales <= 5000 THEN 'Long-term Customer'
	 ELSE 'New Customer'
END visit_info,
DATEDIFF(month, latest_order, GETDATE()) as months_unseen,
CASE WHEN total_orders = 0 THEN 0
	 ELSE ROUND(total_sales / total_orders, 2)
END avg_order_value,
CASE WHEN total_month_visited = 0 THEN 0
	 ELSE ROUND(total_sales / total_month_visited, 2)
END avg_monthly_value
FROM advanced_info

--this query gets different types of information about the customer as well as their relationship with the store
--1. customer key (distinct)
--2. customer number (distinct)
--3. customer name
--4. customer age
--5. the total orders the customer has ordered
--6. the total amount the customer paid
--7. the total # items the customer purchased
--8. the total distinct products the customer purchased
--9. the last time the customer purchased from the store
--10.the total months the customer has visited
--11.the customer status: VIP (1 Year long visitor + 5000+ spending), 
--						  Long-term Customer (1 Year long visitor)
--						  New Customer (Less than 1 Year visitor)
--12.the number of months the customer hasn't visited
--13.the average amount the customer spends per visit
--14.the average amount the customer spends a month at the store
--Finally, this customer report is uploaded in Views, where we can use this database in a new query using FROM.