USE DataWarehouse;
GO

/*
===============================================================================
SALES ANALYSIS
===============================================================================
*/

-- Total Revenue
SELECT
    SUM(sales_amount) AS total_revenue
FROM gold.fact_sales;


-- Total Orders
SELECT
    COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales;


-- Total Quantity Sold
SELECT
    SUM(quantity) AS total_quantity_sold
FROM gold.fact_sales;


-- Average Order Value
SELECT
    CAST(
        SUM(sales_amount) / NULLIF(COUNT(DISTINCT order_number), 0)
        AS DECIMAL(10,2)
    ) AS average_order_value
FROM gold.fact_sales;


-- Average Selling Price
SELECT
    CAST(AVG(price) AS DECIMAL(10,2)) AS average_selling_price
FROM gold.fact_sales;


-- Overall Sales Summary
SELECT
    SUM(sales_amount) AS total_revenue,
    COUNT(DISTINCT order_number) AS total_orders,
    SUM(quantity) AS total_quantity_sold,
    CAST(
        SUM(sales_amount) / NULLIF(COUNT(DISTINCT order_number), 0)
        AS DECIMAL(10,2)
    ) AS average_order_value,
    CAST(AVG(price) AS DECIMAL(10,2)) AS average_selling_price
FROM gold.fact_sales;