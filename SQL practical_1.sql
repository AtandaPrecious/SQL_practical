SELECT * FROM retail_sales
LIMIT 10;

SELECT
	COUNT(*)
FROM retail_sales;

-- DATA CLEANING
--MISSING VALUES
SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
	
-- DELETING ROWS WITH MISSING INFORMATION
DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- DATA EXPLORATION

-- How many sales do we have? 1997
SELECT COUNT(*) as total_sale FROM retail_sales;

-- How many customers do we have? 155
SELECT COUNT (DISTINCT customer_id) as total_sale FROM retail_sales

-- What are the distinct product category?
SELECT DISTINCT category FROM retail_sales

-- BUSINESS ANALYSIS
-- Q1: Sales made on 2022-11-05
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

--Q2: Transactions where category is 'clothing' and quantity sold is more than 10 for the month of November 2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
	AND
	TO_CHAR(sale_date, 'YYYY-MM')= '2022-11'
	AND
	quantiy >=4;

-- Q3: Calculate total sales for each category
SELECT
	category,
	SUM(total_sale) as net_sale,
	COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

-- Q4: Average age of customers who purchased from the beauty category
SELECT 
	ROUND(AVG(age),2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'

-- Q5: all transactions where total_sales is greater than 1000
SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- Q6: total number of transactions made by each gender in each product category
SELECT 
	category,
	gender,
	COUNT(*) as total_trans
FROM retail_sales
GROUP
	BY
	category,
	gender
ORDER BY 1;

-- Q7: average sale for each month. find out best selling month in each year
SELECT 
	year,
	month,
	avg_sale
FROM
(
SELECT 
	EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as month,
	AVG(total_sale) as avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC)
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1
-- ORDER BY 1, 3 DESC

-- Q8: Top five customers based on highest total sales
SELECT
	customer_id,
	SUM(total_sale) as tot_sale
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--Q9: Unique number of customers that purchased from each category
SELECT 
	category,
	COUNT(DISTINCT customer_id) as count_cust
FROM retail_sales
GROUP BY
	category

--Q10: Number of orders per hour
WITH hourly_sale --(cde -common table expression)
AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as Shift
FROM retail_sales
)
SELECT 
	Shift,
	COUNT(*) as tot_orders
FROM hourly_sale
GROUP BY Shift