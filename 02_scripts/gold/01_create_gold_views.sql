USE DataWarehouse;
GO

/*
===============================================================================
CREATE GOLD VIEW: dim_customers
===============================================================================
*/

CREATE VIEW gold.dim_customers AS

SELECT
    ROW_NUMBER() OVER (ORDER BY A.cst_id) AS customer_key,

    A.cst_id AS customer_id,
    A.cst_key AS customer_number,
    A.cst_firstname AS first_name,
    A.cst_lastname AS last_name,
    C.CNTRY AS country,
    A.cst_marital_status AS marital_status,

    -- Data Integration: Prefer CRM gender; use ERP when CRM is unavailable
    CASE
        WHEN A.cst_gndr != 'n/a'
            THEN A.cst_gndr
        ELSE ISNULL(B.GEN, 'n/a')
    END AS gender,

    B.BDATE AS birth_date,

    A.dwh_create_date AS create_date

FROM silver.crm_cust_info AS A

LEFT JOIN silver.erp_cust_az12 AS B
    ON A.cst_key = B.CID

LEFT JOIN silver.erp_loc_a101 AS C
    ON A.cst_key = C.CID;
GO


/*
===============================================================================
CREATE GOLD VIEW: dim_products
===============================================================================
*/

CREATE VIEW gold.dim_products AS

SELECT
    ROW_NUMBER() OVER (ORDER BY A.prd_start_dt, A.prd_id) AS product_key,

    A.prd_id AS product_id,
    A.prd_key AS product_number,
    A.prd_nm AS product_name,

    A.cat_id AS category_id,
    B.CAT AS category,
    B.SUBCAT AS subcategory,
    B.MAINTENANCE AS maintenance,

    A.prd_line AS product_line,
    A.prd_cost AS product_cost,
    A.prd_start_dt AS start_date,
    A.prd_end_dt AS end_date,

    A.dwh_create_date AS create_date

FROM silver.crm_prd_info AS A
LEFT JOIN silver.erp_px_cat_g1v2 AS B
    ON A.cat_id = B.ID

WHERE A.prd_end_dt IS NULL;  -- Filtering only active products
GO


USE DataWarehouse;
GO


/*
===============================================================================
CREATE GOLD VIEW: fact_sales
===============================================================================
*/

CREATE VIEW gold.fact_sales AS

SELECT
    s.sls_ord_num AS order_number,

    -- Replace source product key with Gold surrogate key
    p.product_key,

    -- Replace source customer ID with Gold surrogate key
    c.customer_key,

    -- dates 
    s.sls_order_dt AS order_date,
    s.sls_ship_dt AS shipping_date,
    s.sls_due_dt AS due_date,

    -- measures
    s.sls_sales AS sales_amount,
    s.sls_quantity AS quantity,
    s.sls_price AS price

FROM silver.crm_sales_details AS s

-- Join sales with Product Dimension
LEFT JOIN gold.dim_products AS p
    ON s.sls_prd_key = p.product_number

-- Join sales with Customer Dimension
LEFT JOIN gold.dim_customers AS c
    ON s.sls_cust_id = c.customer_id;
GO