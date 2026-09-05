USE DataWarehouse;
GO

/*
===============================================================================
TIME SERIES ANALYSIS
===============================================================================
*/


-- Monthly Revenue
SELECT
    DATEFROMPARTS(
        YEAR(order_date),
        MONTH(order_date),
        1
    ) AS month,
    SUM(sales_amount) AS total_revenue
FROM gold.fact_sales
GROUP BY
    YEAR(order_date),
    MONTH(order_date)
ORDER BY month;


-- Yearly Revenue
SELECT
    YEAR(order_date) AS year,
    SUM(sales_amount) AS total_revenue
FROM gold.fact_sales
GROUP BY YEAR(order_date)
ORDER BY year;


-- Monthly Order Count
SELECT
    DATEFROMPARTS(
        YEAR(order_date),
        MONTH(order_date),
        1
    ) AS month,
    COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales
GROUP BY
    YEAR(order_date),
    MONTH(order_date)
ORDER BY month;


-- Monthly Running Revenue
WITH monthly_sales AS
(
    SELECT
        DATEFROMPARTS(
            YEAR(order_date),
            MONTH(order_date),
            1
        ) AS month,
        SUM(sales_amount) AS monthly_revenue
    FROM gold.fact_sales
    GROUP BY
        YEAR(order_date),
        MONTH(order_date)
)

SELECT
    month,
    monthly_revenue,
    SUM(monthly_revenue) OVER (
        ORDER BY month
    ) AS running_total_revenue
FROM monthly_sales
ORDER BY month;


-- Month-over-Month Revenue Growth
WITH monthly_sales AS
(
    SELECT
        DATEFROMPARTS(
            YEAR(order_date),
            MONTH(order_date),
            1
        ) AS month,
        SUM(sales_amount) AS monthly_revenue
    FROM gold.fact_sales
    GROUP BY
        YEAR(order_date),
        MONTH(order_date)
),

sales_with_previous_month AS
(
    SELECT
        month,
        monthly_revenue,

        LAG(monthly_revenue) OVER (
            ORDER BY month
        ) AS previous_month_revenue

    FROM monthly_sales
)

SELECT
    month,
    monthly_revenue,
    previous_month_revenue,

    CAST(
        (
            (monthly_revenue - previous_month_revenue)
            / NULLIF(previous_month_revenue, 0)
        ) * 100
        AS DECIMAL(10,2)
    ) AS mom_growth_percentage

FROM sales_with_previous_month
ORDER BY month;