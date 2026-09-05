USE DataWarehouse;
GO

/*
===============================================================================
CUSTOMER ANALYSIS
===============================================================================
*/


-- Top 10 Customers by Revenue
SELECT TOP 10
    C.customer_id,
    C.first_name,
    C.last_name,
    SUM(S.sales_amount) AS total_revenue
FROM gold.fact_sales AS S
INNER JOIN gold.dim_customers AS C
    ON S.customer_key = C.customer_key
GROUP BY
    C.customer_id,
    C.first_name,
    C.last_name
ORDER BY total_revenue DESC;


-- Customers by Country
SELECT
    country,
    COUNT(*) AS total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC;


-- Revenue by Gender
SELECT
    C.gender,
    SUM(S.sales_amount) AS total_revenue
FROM gold.dim_customers AS C
INNER JOIN gold.fact_sales AS S
    ON C.customer_key = S.customer_key
GROUP BY C.gender
ORDER BY total_revenue DESC;


-- Revenue by Marital Status
SELECT
    C.marital_status,
    SUM(S.sales_amount) AS total_revenue
FROM gold.dim_customers AS C
INNER JOIN gold.fact_sales AS S
    ON C.customer_key = S.customer_key
GROUP BY C.marital_status
ORDER BY total_revenue DESC;