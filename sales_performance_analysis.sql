WITH yearly_product_sales AS (
SELECT
YEAR(f.order_date) as order_year,
d.product_name,
SUM(f.sales_amount) as current_sales
FROM gold.fact_sales as f
LEFT JOIN gold.dim_products as d
ON f.product_key = d.product_key
WHERE f.order_date IS NOT NULL
GROUP BY YEAR(f.order_date), d.product_name
)

--Used CTE to make the code more clean

SELECT 
order_year,
product_name,
current_sales,
AVG(current_sales) OVER (PARTITION BY product_name) as avg_sales,
current_sales - AVG(current_sales) OVER (PARTITION BY product_name) as diff_avg,
CASE WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
	 WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
	 ELSE 'Avg'
END avg_info,
LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) as previous_year_sales,
current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) diff_sales_from_previous,
CASE WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
	 WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
	 WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) = 0 THEN 'Same'
	 ELSE NULL
END sales_change
FROM yearly_product_sales
ORDER BY product_name, order_year


--this query produces the performance analysis, that compares the sales of the same product to the average, as well as
--the previous year, CTE, Cases, and windows functions are used.