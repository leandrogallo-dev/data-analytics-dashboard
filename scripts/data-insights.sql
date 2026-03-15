/*
=============================================================
		   Gold Layer: Business Intelligence Views
=============================================================
[i] Script Purpose:
    This script defines and creates a series of analytical views 
    within the 'gold' schema. These views are designed for 
    TESTING! Business Intelligence (BI) reporting, covering:
    - Sales Trends & Cumulative Totals
    - Product Performance (YoY Analysis)
    - Part-to-Whole Category Analysis
    - Data Segmentation (Cost Ranges & Customer Geographics)

[X] WARNING:
    This script uses 'DROP VIEW IF EXISTS' logic. Running this 
    will overwrite any existing views with the same names in 
    the 'gold' schema. Ensure all dependencies are checked 
    before execution.
=============================================================
*/

-- sales over time
/*
SELECT 
	FORMAT(order_date, 'yyyy-MM') AS order_date,
	SUM(sales_amount) AS total_sales_amount,
	COUNT(DISTINCT customer_key) AS total_csutomeres,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MM')
ORDER BY FORMAT(order_date, 'yyyy-MM');
*/

-- Comulative Analysis
IF OBJECT_ID('gold.cumulative_analisys', 'V') IS NOT NULL
    DROP VIEW gold.cumulative_analisys;
GO

CREATE VIEW gold.cumulative_analisys AS
SELECT
	order_date,
	SUM(total_sales) OVER (PARTITION BY order_date ORDER BY order_date) AS running_total_sales,
	AVG(avg_price) OVER (PARTITION BY order_date ORDER BY order_date) AS moving_average_price
FROM (
	SELECT 
		DATETRUNC(MONTH, order_date) AS order_date,
		SUM(sales_amount) AS total_sales,
		AVG(price) AS avg_price
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(MONTH, order_date)
) subquery
GO

-- Performance Analysis
IF OBJECT_ID('gold.perfomance_analisys', 'V') IS NOT NULL
    DROP VIEW gold.perfomance_analisys;
GO

CREATE VIEW gold.perfomance_analisys AS
	SELECT 
		year_order,
		product_name,
		current_sales,
		AVG(current_sales) OVER (PARTITION BY product_name) AS current_average_sales,
		current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg,
		CASE 
			WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Increase'
			WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Decreases'
			ELSE 'Neutral'
		END AS increase,
		-- year-over-tear Analysis
		LAG(current_sales) OVER (PARTITION BY product_name ORDER BY year_order) AS previus_year_sales,
		current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY year_order) AS diif_py,
		CASE 
			WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY year_order) > 0 THEN 'Increase'
			WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY year_order) < 0 THEN 'Decreases'
			ELSE 'Neutral'
		END AS py_change
	FROM (
		SELECT
			YEAR(s.order_date)	AS year_order,
			p.product_name		AS product_name,
			SUM(s.sales_amount) AS current_sales
		FROM gold.fact_sales AS s
		LEFT JOIN gold.dim_products AS p
			ON s.product_key = p.product_key
		WHERE s.order_date IS NOT NULL
		GROUP BY YEAR(s.order_date), p.product_name
	) subquery
GO

-- Part-to-Analysis
IF OBJECT_ID('gold.part_to_analisys', 'V') IS NOT NULL
    DROP VIEW gold.part_to_analisys;
GO

CREATE VIEW gold.part_to_analisys AS
SELECT 
	category,
	total_sales,
	CONCAT(ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER ()) * 100, 2), '%') AS percentaje_total
FROM (
	SELECT 
		p.category				AS category,
		SUM(s.sales_amount)		AS total_sales
	FROM gold.fact_sales		AS s
	LEFT JOIN gold.dim_products AS p
		ON s.product_key = p.product_key
	GROUP BY category
) subquery
GO

-- Data Segmentation
IF OBJECT_ID('gold.data_segmentation', 'V') IS NOT NULL
    DROP VIEW gold.data_segmentation;
GO

CREATE VIEW gold.data_segmentation AS
SELECT 
	cost_range,
	COUNT(product_key) AS total_products
FROM (
	SELECT 
		product_key,
		product_name,
		cost,
		CASE
			WHEN cost < 100 THEN 'Below 100'
			WHEN cost BETWEEN 100 AND 500 THEN '100-500'
			WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
			ELSE 'Above 1000'
		END AS cost_range
	FROM gold.dim_products
) subquery
GROUP BY cost_range
GO

/*
SELECT 
	customer_segment,
	COUNT(customer_key) AS total_customers
FROM (
	SELECT 
		customer_key,
		CASE 
			WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
			WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
			ELSE 'New Customer'
		END AS customer_segment
	FROM (
		SELECT 
			c.customer_key,
			SUM(s.sales_amount) AS total_spending,
			MIN(s.order_date) AS first_order,
			MAX(s.order_date) AS last_order,
			DATEDIFF(MONTH, MIN(s.order_date), MAX(s.order_date)) AS lifespan
		FROM gold.dim_customers AS c
		LEFT JOIN gold.fact_sales AS s
			ON c.customer_key = s.customer_key
		GROUP BY c.customer_key
	) subquery1
) subquery2
GROUP BY customer_segment
ORDER BY total_customers DESC
*/

-- Country customers analisis
IF OBJECT_ID('gold.customers_country', 'V') IS NOT NULL
    DROP VIEW gold.customers_country;
GO

CREATE VIEW gold.customers_country AS
SELECT	
	country,
	COUNT(customer_key) AS total_customers
FROM gold.dim_customers
WHERE country != 'n/a'
GROUP BY country
GO

-- Which categories contribute the most to overall sales
/* WITH category_sales AS (
    SELECT
        p.category,
        SUM(f.sales_amount) AS total_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.category
)
SELECT
    category,
    total_sales,
    SUM(total_sales) OVER () AS overall_sales,
    ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER ()) * 100, 2) AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC; */