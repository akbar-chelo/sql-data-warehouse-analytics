USE DataWarehouse;
GO

/*
===============================================================================
CRM CUSTOMER INFORMATION
Bronze → Silver Transformation
===============================================================================
*/


TRUNCATE TABLE silver.crm_cust_info;
GO

INSERT INTO silver.crm_cust_info
(
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
)
SELECT
    cst_id,
    cst_key,

    -- Remove unwanted spaces
    TRIM(cst_firstname) AS cst_firstname,

    -- Remove unwanted spaces
    TRIM(cst_lastname) AS cst_lastname,

    -- Standardize marital status
    CASE UPPER(TRIM(cst_marital_status))
        WHEN 'S' THEN 'Single'
        WHEN 'M' THEN 'Married'
        ELSE 'n/a'
    END AS cst_marital_status,

    -- Standardize gender
    CASE UPPER(TRIM(cst_gndr))
        WHEN 'M' THEN 'Male'
        WHEN 'F' THEN 'Female'
        ELSE 'n/a'
    END AS cst_gndr,

    cst_create_date

FROM
(
    SELECT
        *,
        ROW_NUMBER() OVER
        (
            PARTITION BY cst_id
            ORDER BY cst_create_date DESC
        ) AS rnk
    FROM bronze.crm_cust_info
) t
WHERE rnk = 1
  AND cst_id IS NOT NULL;
GO


/*
===============================================================================
CRM PRODUCT INFORMATION
Bronze → Silver Transformation
===============================================================================
*/


TRUNCATE TABLE silver.crm_prd_info;
GO

INSERT INTO silver.crm_prd_info (
    prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
)
SELECT
    prd_id,

    -- Extract category ID from encoded product key
    REPLACE(
            SUBSTRING (prd_key, 1, 5),
            '-',
            '_'
           ) AS cat_id,

    -- Extract actual product key
    SUBSTRING (
                prd_key,
                7,
                LEN(prd_key)
            ) AS prd_key,

    -- Remove unwanted spaces
    TRIM(prd_nm) AS prd_nm,

    -- Preserve source cost for now
    ISNULL(prd_cost, 0) as prd_cost,

    -- Standardize product line
    CASE UPPER(TRIM(prd_line))
        WHEN 'M' THEN 'Mountain'
        WHEN 'R' THEN 'Road'
        WHEN 'S' THEN 'Other Sales'
        WHEN 'T' THEN 'Touring'
        ELSE 'n/a'
    END AS prd_line,

    prd_start_dt,

    -- Generate end date from next product version
    DATEADD(
        DAY,
        -1,
        LEAD(prd_start_dt) OVER
        (
            PARTITION BY prd_key
            ORDER BY prd_start_dt
        )
    ) AS prd_end_dt

FROM bronze.crm_prd_info;


/*
===============================================================================
CRM SALES INFORMATION
Bronze → Silver Transformation
===============================================================================
*/


TRUNCATE TABLE silver.crm_sales_details;
GO

INSERT INTO silver.crm_sales_details (
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
)

SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,

    -- Convert invalid numeric dates to NULL and valid YYYYMMDD values to DATE
    CASE
        WHEN sls_order_dt <= 0
             OR LEN(sls_order_dt) != 8
            THEN NULL
        ELSE CAST(CAST(sls_order_dt AS VARCHAR(8)) AS DATE)
    END AS sls_order_dt,

    CASE
        WHEN sls_ship_dt <= 0
             OR LEN(sls_ship_dt) != 8
            THEN NULL
        ELSE CAST(CAST(sls_ship_dt AS VARCHAR(8)) AS DATE)
    END AS sls_ship_dt,

    CASE
        WHEN sls_due_dt <= 0
             OR LEN(sls_due_dt) != 8
            THEN NULL
        ELSE CAST(CAST(sls_due_dt AS VARCHAR(8)) AS DATE)
    END AS sls_due_dt,

    -- Recalculate invalid or inconsistent sales
    CASE
        WHEN sls_sales IS NULL
             OR sls_sales <= 0
             OR sls_sales != sls_quantity * ABS(sls_price)
            THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END AS sls_sales,

    sls_quantity,

    -- Recalculate invalid price from sales and quantity
    CASE
        WHEN sls_price IS NULL
             OR sls_price <= 0
            THEN sls_sales / NULLIF(sls_quantity, 0)
        ELSE sls_price
    END AS sls_price

FROM bronze.crm_sales_details;


/*
===============================================================================
ERP CUSTOMER INFORMATION
Bronze → Silver Transformation
===============================================================================
*/


TRUNCATE TABLE silver.erp_cust_az12;
GO

INSERT INTO silver.erp_cust_az12 (
    CID,
    BDATE,
    GEN
)

SELECT
    -- Remove NAS prefix from customer ID
    CASE WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID, 4, LEN(CID))
         ELSE CID
    END AS CID,

    -- Validate birth date
    CASE
        WHEN BDATE < '1900-01-01'
          OR BDATE > '2027-01-01'
            THEN NULL
        ELSE BDATE
    END AS BDATE,

    -- Standardize gender
    CASE
        WHEN UPPER(TRIM(GEN)) IN ('MALE', 'M')
            THEN 'Male'
        WHEN UPPER(TRIM(GEN)) IN ('FEMALE', 'F')
            THEN 'Female'
        ELSE 'n/a'
    END AS GEN

FROM bronze.erp_cust_az12


/*
===============================================================================
ERP CUSTOMER LOCATION INFORMATION
Bronze → Silver Transformation
===============================================================================
*/


TRUNCATE TABLE silver.erp_loc_a101;
GO

INSERT INTO silver.erp_loc_a101 (
    CID,
    CNTRY
)

SELECT

    -- Remove '-' from Customer ID
    REPLACE(TRIM(CID), '-', '') AS CID,

    -- Data Standardization and Consistency
    CASE
        WHEN UPPER(TRIM(CNTRY)) IN ('US', 'USA')
            THEN 'United States'

        WHEN UPPER(TRIM(CNTRY)) = 'DE'
            THEN 'Germany'

        WHEN TRIM(CNTRY) = ''
          OR CNTRY IS NULL
            THEN 'n/a'

        ELSE TRIM(CNTRY)
    END AS CNTRY

FROM bronze.erp_loc_a101;


/*
===============================================================================
ERP PRODUCT CATEGORY INFORMATION
Bronze → Silver Transformation
===============================================================================
*/


TRUNCATE TABLE silver.erp_px_cat_g1v2;
GO

INSERT INTO silver.erp_px_cat_g1v2 (
    ID,
    CAT,
    SUBCAT,
    MAINTENANCE
)

SELECT

    -- Remove unwanted spaces from Product Category ID
    TRIM(ID) AS ID,

    -- Remove unwanted spaces
    TRIM(CAT) AS CAT,

    -- Remove unwanted spaces
    TRIM(SUBCAT) AS SUBCAT,

    -- Data Standardization and Consistency
    TRIM(MAINTENANCE) AS MAINTENANCE

FROM bronze.erp_px_cat_g1v2;



