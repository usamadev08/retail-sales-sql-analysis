-- SQL Retail Sales Analysis

-- SECTION 1: Table Creation and Initial Setup
DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales (
    transaction_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),	
    age INT,
    category VARCHAR(15),	
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

-- Verify table creation
SELECT * FROM retail_sales;

-- Count the number of records in the table
SELECT COUNT(*) AS total_records FROM retail_sales;

-- SECTION 2: Data Cleaning
-- Identify rows with NULL values
SELECT * 
FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;

-- Delete rows with NULL values
DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;

-- SECTION 3: Data Exploration
-- Total number of sales
SELECT COUNT(*) AS total_sales FROM retail_sales;

-- Total number of unique customers
SELECT COUNT(DISTINCT customer_id) AS unique_customers FROM retail_sales;

-- Distinct categories of items sold
SELECT DISTINCT category FROM retail_sales;

-- SECTION 4: Data Analysis and Business Insights

-- Q1: Retrieve all transactions made on '2022-11-05'
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2: Retrieve transactions where category is 'Clothing', quantity > 4, in November 2022
SELECT * 
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND quantity > 4;

-- Q3: Calculate total sales and orders for each category
SELECT 
    category,
    SUM(total_sale) AS net_sales,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

-- Q4: Average age of customers purchasing from 'Beauty' category
SELECT
    ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- Q5: Retrieve all transactions where total_sale > 1000
SELECT * 
FROM retail_sales
WHERE total_sale > 1000;

-- Q6: Total number of transactions by gender and category
SELECT 
    category,
    gender,
    COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category;

-- Q7: Best-selling month of each year by average sales
SELECT 
    year,
    month,
    avg_sale
FROM 
(
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale, 
        RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
    FROM retail_sales
    GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)
) AS ranked_sales
WHERE rank = 1;

-- Q8: Top 5 customers by total sales
SELECT 
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- Q9: Unique customers by category
SELECT 
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;

-- Q10: Number of orders by shift (Morning, Afternoon, Evening)
WITH sales_by_shift AS (
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) AS total_orders
FROM sales_by_shift
GROUP BY shift;

-- End of SQL Retail Sales Analysis
