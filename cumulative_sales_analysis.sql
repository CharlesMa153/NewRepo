SELECT
order_date,
total_sales,
SUM(total_sales) OVER (ORDER BY order_date) as cumulative_total_sales
FROM 
(
SELECT 
DATETRUNC(month, order_date) as order_date,
SUM(sales_amount) as total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
)t


--this query calculates the total sales per month as well as the cumulative amount using windows functions and subquery.