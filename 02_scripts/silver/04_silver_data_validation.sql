USE DataWarehouse;
GO

/*
===============================================================================
SILVER LAYER - FINAL DATA VALIDATION
Project: SQL Data Warehouse & Analytics

Purpose:
    Validate the final transformed data in the Silver layer.

Expected Result:
    All data-quality checks should return NO RESULTS / 0 violations.

Tables:
    CRM
        - silver.crm_cust_info
        - silver.crm_prd_info
        - silver.crm_sales_details

    ERP
        - silver.erp_cust_az12
        - silver.erp_loc_a101
        - silver.erp_px_cat_g1v2
===============================================================================
*/


/*
===============================================================================
1. CRM CUSTOMER INFORMATION
===============================================================================
*/


/*-----------------------------------------------------------------------------
1.1 Check NULL Customer IDs
Expected: No results
-----------------------------------------------------------------------------*/

SELECT *
FROM silver.crm_cust_info
WHERE cst_id IS NULL;


/*-----------------------------------------------------------------------------
1.2 Check Duplicate Customer IDs
Expected: No results
-----------------------------------------------------------------------------*/

SELECT
    cst_id,
    COUNT(*) AS record_count
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1;


/*-----------------------------------------------------------------------------
1.3 Check Unwanted Spaces in First Name / Last Name
Expected: No results
-----------------------------------------------------------------------------*/

SELECT
    cst_id,
    cst_firstname,
    cst_lastname
FROM silver.crm_cust_info
WHERE cst_firstname <> TRIM(cst_firstname)
   OR cst_lastname <> TRIM(cst_lastname);


/*-----------------------------------------------------------------------------
1.4 Check Marital Status Standardization
Expected: No results
Allowed values:
    Single
    Married
    n/a
-----------------------------------------------------------------------------*/

SELECT DISTINCT
    cst_marital_status
FROM silver.crm_cust_info
WHERE cst_marital_status NOT IN
(
    'Single',
    'Married',
    'n/a'
);


/*-----------------------------------------------------------------------------
1.5 Check Gender Standardization
Expected: No results
Allowed values:
    Male
    Female
    n/a
-----------------------------------------------------------------------------*/

SELECT DISTINCT
    cst_gndr
FROM silver.crm_cust_info
WHERE cst_gndr NOT IN
(
    'Male',
    'Female',
    'n/a'
);


/*
===============================================================================
2. CRM PRODUCT INFORMATION
===============================================================================
*/


/*-----------------------------------------------------------------------------
2.1 Check NULL Product IDs
Expected: No results
-----------------------------------------------------------------------------*/

SELECT *
FROM silver.crm_prd_info
WHERE prd_id IS NULL;


/*-----------------------------------------------------------------------------
2.2 Check Duplicate Product IDs
Expected: No results
-----------------------------------------------------------------------------*/

SELECT
    prd_id,
    COUNT(*) AS record_count
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1;


/*-----------------------------------------------------------------------------
2.3 Check NULL Product Keys
Expected: No results
-----------------------------------------------------------------------------*/

SELECT *
FROM silver.crm_prd_info
WHERE prd_key IS NULL
   OR TRIM(prd_key) = '';


/*-----------------------------------------------------------------------------
2.4 Check Unwanted Spaces in Product Name
Expected: No results
-----------------------------------------------------------------------------*/

SELECT
    prd_id,
    prd_nm
FROM silver.crm_prd_info
WHERE prd_nm <> TRIM(prd_nm);


/*-----------------------------------------------------------------------------
2.5 Check Negative Product Costs
Expected: No results
-----------------------------------------------------------------------------*/

SELECT *
FROM silver.crm_prd_info
WHERE prd_cost < 0;


/*-----------------------------------------------------------------------------
2.6 Check Product Line Standardization
Expected: No results

Allowed values:
    Mountain
    Road
    Other Sales
    Touring
    n/a
-----------------------------------------------------------------------------*/

SELECT DISTINCT
    prd_line
FROM silver.crm_prd_info
WHERE prd_line NOT IN
(
    'Mountain',
    'Road',
    'Other Sales',
    'Touring',
    'n/a'
);


/*-----------------------------------------------------------------------------
2.7 Check Product Date Range
Expected: No results

Product start date should not be greater than product end date.
-----------------------------------------------------------------------------*/

SELECT
    prd_id,
    prd_key,
    prd_start_dt,
    prd_end_dt
FROM silver.crm_prd_info
WHERE prd_end_dt IS NOT NULL
  AND prd_start_dt > prd_end_dt;


/*-----------------------------------------------------------------------------
2.8 Check Product Start Date
Expected: No results

Start date should not be NULL for a valid product record.
-----------------------------------------------------------------------------*/

SELECT *
FROM silver.crm_prd_info
WHERE prd_start_dt IS NULL;


/*
===============================================================================
3. CRM SALES DETAILS
===============================================================================
*/


/*-----------------------------------------------------------------------------
3.1 Check NULL Order Number
Expected: No results
-----------------------------------------------------------------------------*/

SELECT *
FROM silver.crm_sales_details
WHERE sls_ord_num IS NULL
   OR TRIM(sls_ord_num) = '';


/*-----------------------------------------------------------------------------
3.2 Check NULL Product Key
Expected: No results
-----------------------------------------------------------------------------*/

SELECT *
FROM silver.crm_sales_details
WHERE sls_prd_key IS NULL
   OR TRIM(sls_prd_key) = '';


/*-----------------------------------------------------------------------------
3.3 Check NULL Customer ID
Expected: No results
-----------------------------------------------------------------------------*/

SELECT *
FROM silver.crm_sales_details
WHERE sls_cust_id IS NULL;


/*-----------------------------------------------------------------------------
3.4 Check Invalid Order Dates
Expected: No results
-----------------------------------------------------------------------------*/

SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt IS NULL;


/*-----------------------------------------------------------------------------
3.5 Check Invalid Ship Dates
Expected: No results
-----------------------------------------------------------------------------*/

SELECT *
FROM silver.crm_sales_details
WHERE sls_ship_dt IS NULL;


/*-----------------------------------------------------------------------------
3.6 Check Invalid Due Dates
Expected: No results
-----------------------------------------------------------------------------*/

SELECT *
FROM silver.crm_sales_details
WHERE sls_due_dt IS NULL;


/*-----------------------------------------------------------------------------
3.7 Check Invalid Sales
Expected: No results
-----------------------------------------------------------------------------*/

SELECT *
FROM silver.crm_sales_details
WHERE sls_sales IS NULL
   OR sls_sales <= 0;


/*-----------------------------------------------------------------------------
3.8 Check Invalid Quantity
Expected: No results
-----------------------------------------------------------------------------*/

SELECT *
FROM silver.crm_sales_details
WHERE sls_quantity IS NULL
   OR sls_quantity <= 0;


/*-----------------------------------------------------------------------------
3.9 Check Invalid Price
Expected: No results
-----------------------------------------------------------------------------*/

SELECT *
FROM silver.crm_sales_details
WHERE sls_price IS NULL
   OR sls_price <= 0;


/*-----------------------------------------------------------------------------
3.10 Check Sales Calculation Consistency

Business Rule:
    Sales = Quantity × Price

Expected: No results
-----------------------------------------------------------------------------*/

SELECT
    sls_ord_num,
    sls_prd_key,
    sls_quantity,
    sls_price,
    sls_sales,
    sls_quantity * sls_price AS calculated_sales
FROM silver.crm_sales_details
WHERE ABS(sls_sales - (sls_quantity * sls_price)) > 0.01;


/*-----------------------------------------------------------------------------
3.11 Check Date Sequence

Business Rule:
    Order Date <= Ship Date <= Due Date

Expected: No results
-----------------------------------------------------------------------------*/

SELECT
    sls_ord_num,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_ship_dt > sls_due_dt;


/*
===============================================================================
4. CRM CROSS-TABLE VALIDATION
===============================================================================
*/


/*-----------------------------------------------------------------------------
4.1 Check Sales Customer IDs Against Customer Dimension
Expected: No results

Every sales customer should exist in CRM customer information.
-----------------------------------------------------------------------------*/

SELECT DISTINCT
    s.sls_cust_id
FROM silver.crm_sales_details s
LEFT JOIN silver.crm_cust_info c
    ON s.sls_cust_id = c.cst_id
WHERE c.cst_id IS NULL;


/*-----------------------------------------------------------------------------
4.2 Check Sales Product Keys Against Product Information
Expected: No results

Every sales product key should exist in CRM product information.
-----------------------------------------------------------------------------*/

SELECT DISTINCT
    s.sls_prd_key
FROM silver.crm_sales_details s
LEFT JOIN silver.crm_prd_info p
    ON s.sls_prd_key = p.prd_key
WHERE p.prd_key IS NULL;


/*
===============================================================================
5. ERP CUSTOMER INFORMATION
===============================================================================
*/


/*-----------------------------------------------------------------------------
5.1 Check NULL Customer IDs
Expected: No results
-----------------------------------------------------------------------------*/

SELECT *
FROM silver.erp_cust_az12
WHERE CID IS NULL
   OR TRIM(CID) = '';


/*-----------------------------------------------------------------------------
5.2 Check Unwanted Spaces in Customer ID
Expected: No results
-----------------------------------------------------------------------------*/

SELECT
    CID
FROM silver.erp_cust_az12
WHERE CID <> TRIM(CID);


/*-----------------------------------------------------------------------------
5.3 Check Invalid Birth Dates
Expected: No results

Invalid dates should have been converted to NULL during transformation.
-----------------------------------------------------------------------------*/

SELECT
    CID,
    BDATE
FROM silver.erp_cust_az12
WHERE BDATE < '1900-01-01'
   OR BDATE > '2027-01-01';


/*-----------------------------------------------------------------------------
5.4 Check Gender Standardization
Expected: No results

Allowed values:
    Male
    Female
    n/a
-----------------------------------------------------------------------------*/

SELECT DISTINCT
    GEN
FROM silver.erp_cust_az12
WHERE GEN NOT IN
(
    'Male',
    'Female',
    'n/a'
);


/*
===============================================================================
6. ERP CUSTOMER LOCATION
===============================================================================
*/


/*-----------------------------------------------------------------------------
6.1 Check NULL Customer IDs
Expected: No results
-----------------------------------------------------------------------------*/

SELECT *
FROM silver.erp_loc_a101
WHERE CID IS NULL
   OR TRIM(CID) = '';


/*-----------------------------------------------------------------------------
6.2 Check Customer IDs Containing '-'
Expected: No results
-----------------------------------------------------------------------------*/

SELECT
    CID
FROM silver.erp_loc_a101
WHERE CID LIKE '%-%';


/*-----------------------------------------------------------------------------
6.3 Check Unwanted Spaces in Customer ID
Expected: No results
-----------------------------------------------------------------------------*/

SELECT
    CID
FROM silver.erp_loc_a101
WHERE CID <> TRIM(CID);


/*-----------------------------------------------------------------------------
6.4 Check NULL / Blank Countries
Expected: No results

NULL or blank values should have been standardized to 'n/a'.
-----------------------------------------------------------------------------*/

SELECT *
FROM silver.erp_loc_a101
WHERE CNTRY IS NULL
   OR TRIM(CNTRY) = '';


/*-----------------------------------------------------------------------------
6.5 Check Country Standardization
Expected: No results
-----------------------------------------------------------------------------*/

SELECT DISTINCT
    CNTRY
FROM silver.erp_loc_a101
WHERE CNTRY NOT IN
(
    'United States',
    'Germany',
    'n/a'
)
AND CNTRY IS NOT NULL;


/*
===============================================================================
7. ERP PRODUCT CATEGORY INFORMATION
===============================================================================
*/


/*-----------------------------------------------------------------------------
7.1 Check NULL Product IDs
Expected: No results
-----------------------------------------------------------------------------*/

SELECT *
FROM silver.erp_px_cat_g1v2
WHERE ID IS NULL
   OR TRIM(ID) = '';


/*-----------------------------------------------------------------------------
7.2 Check Duplicate Product IDs
Expected: No results
-----------------------------------------------------------------------------*/

SELECT
    ID,
    COUNT(*) AS record_count
FROM silver.erp_px_cat_g1v2
GROUP BY ID
HAVING COUNT(*) > 1;


/*-----------------------------------------------------------------------------
7.3 Check Unwanted Spaces
Expected: No results
-----------------------------------------------------------------------------*/

SELECT
    ID,
    CAT,
    SUBCAT,
    MAINTENANCE
FROM silver.erp_px_cat_g1v2
WHERE ID <> TRIM(ID)
   OR CAT <> TRIM(CAT)
   OR SUBCAT <> TRIM(SUBCAT)
   OR MAINTENANCE <> TRIM(MAINTENANCE);


/*
===============================================================================
8. ERP CROSS-TABLE VALIDATION
===============================================================================
*/


/*-----------------------------------------------------------------------------
8.1 Check ERP Customer IDs Missing From ERP Location
Expected: No results
-----------------------------------------------------------------------------*/

SELECT DISTINCT
    c.CID
FROM silver.erp_cust_az12 c
LEFT JOIN silver.erp_loc_a101 l
    ON REPLACE(TRIM(c.CID), '-', '')
     = REPLACE(TRIM(l.CID), '-', '')
WHERE l.CID IS NULL;


/*
===============================================================================
9. SILVER TABLE ROW COUNT SUMMARY
===============================================================================
*/

SELECT
    'crm_cust_info' AS TableName,
    COUNT(*) AS RowCount
FROM silver.crm_cust_info

UNION ALL

SELECT
    'crm_prd_info',
    COUNT(*)
FROM silver.crm_prd_info

UNION ALL

SELECT
    'crm_sales_details',
    COUNT(*)
FROM silver.crm_sales_details

UNION ALL

SELECT
    'erp_cust_az12',
    COUNT(*)
FROM silver.erp_cust_az12

UNION ALL

SELECT
    'erp_loc_a101',
    COUNT(*)
FROM silver.erp_loc_a101

UNION ALL

SELECT
    'erp_px_cat_g1v2',
    COUNT(*)
FROM silver.erp_px_cat_g1v2;
GO


/*
===============================================================================
10. FINAL SILVER VALIDATION SUMMARY
===============================================================================

Expected:
    All validation queries above should return NO RESULTS.

    Row count summary should show populated Silver tables.

If a validation query returns records:
    1. Investigate the issue.
    2. Fix the transformation in 03_load_silver_data.sql.
    3. Reload the affected Silver table.
    4. Run this validation script again.

===============================================================================
*/