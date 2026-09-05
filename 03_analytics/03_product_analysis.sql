USE DataWarehouse;
GO

/*
===============================================================================
PRODUCT ANALYSIS
===============================================================================
*/


-- Top 10 Selling Products by Quantity
SELECT TOP 10
    P.product_name,
    SUM(S.quantity) AS total_quantity_sold
FROM gold.fact_sales AS S
INNER JOIN gold.dim_products AS P
    ON S.product_key = P.product_key
GROUP BY P.product_name
ORDER BY total_quantity_sold DESC;


-- Top 10 Products by Revenue
SELECT TOP 10
    P.product_name,
    SUM(S.sales_amount) AS total_revenue
FROM gold.fact_sales AS S
INNER JOIN gold.dim_products AS P
    ON S.product_key = P.product_key
GROUP BY P.product_name
ORDER BY total_revenue DESC;


-- Top Categories by Revenue
SELECT TOP 10
    P.category,
    SUM(S.sales_amount) AS total_revenue
FROM gold.fact_sales AS S
INNER JOIN gold.dim_products AS P
    ON S.product_key = P.product_key
GROUP BY P.category
ORDER BY total_revenue DESC;


-- Top Subcategories by Revenue
SELECT TOP 10
    P.subcategory,
    SUM(S.sales_amount) AS total_revenue
FROM gold.fact_sales AS S
INNER JOIN gold.dim_products AS P
    ON S.product_key = P.product_key
GROUP BY P.subcategory
ORDER BY total_revenue DESC;


-- Quantity Sold by Product Line
SELECT
    P.product_line,
    SUM(S.quantity) AS total_quantity
FROM gold.fact_sales AS S
INNER JOIN gold.dim_products AS P
    ON S.product_key = P.product_key
GROUP BY P.product_line
ORDER BY total_quantity DESC;