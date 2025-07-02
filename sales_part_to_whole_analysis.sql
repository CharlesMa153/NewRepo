SELECT
category,
total_sales,
SUM(total_sales) OVER () as overall_sales,
CONCAT(ROUND((CAST(total_sales as FLOAT)/ SUM(total_sales) OVER ()) * 100, 2), '%') as percentage_sales
FROM
(
SELECT
category,
SUM(sales_amount) as total_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products d
ON d.product_key = f.product_key
GROUP BY category
)t
ORDER BY total_sales DESC

--this query finds the overall sales and used the total sales of each category to find the percentage of sales each category covered
--subquery is used in this case.
