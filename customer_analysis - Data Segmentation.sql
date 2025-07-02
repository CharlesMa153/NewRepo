WITH overall_status AS (
SELECT 
c.customer_key,
SUM(f.sales_amount) as total_spending,
MIN(order_date) as first_order,
MAX(order_date) as last_order,
DATEDIFF (month, MIN(order_date), MAX(order_date)) purchase_length_month,
CASE WHEN DATEDIFF (month, MIN(order_date), MAX(order_date)) >= 12 AND SUM(f.sales_amount) >= 5000 THEN 'VIP'
	 WHEN DATEDIFF (month, MIN(order_date), MAX(order_date)) >= 12 AND SUM(f.sales_amount) < 5000 THEN 'Long-term Customer'
	 ELSE 'New Customer'
END customer_status
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
GROUP BY c.customer_key
)

SELECT 
customer_status,
COUNT(*) as total_customers
FROM overall_status
GROUP BY customer_status
ORDER BY total_customers DESC