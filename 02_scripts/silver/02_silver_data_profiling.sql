USE DataWarehouse;
GO

/*
===============================================================================
SILVER LAYER - CRM DATA PROFILING
Project: SQL Data Warehouse & Analytics
Purpose: Identify data quality issues in CRM Bronze tables
Source Layer: Bronze
Target Layer: Silver

Tables:
    1. bronze.crm_cust_info
    2. bronze.crm_prd_info
    3. bronze.crm_sales_details

Note:
    This script is for PROFILING.
    Returned rows indicate potential data-quality issues that need
    transformation or investigation before loading into Silver.
===============================================================================
*/


/*
===============================================================================
1. CRM CUSTOMER INFORMATION
===============================================================================
*/


/*-----------------------------------------------------------------------------
1.1 Check Duplicate and NULL Customer IDs
-----------------------------------------------------------------------------*/

SELECT
    cst_id,
    COUNT(*) AS record_count
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1
    OR cst_id IS NULL
ORDER BY cst_id;


/*-----------------------------------------------------------------------------
1.2 Check Duplicate Customer IDs Only
-----------------------------------------------------------------------------*/

SELECT
    cst_id,
    COUNT(*) AS duplicate_count
FROM bronze.crm_cust_info
WHERE cst_id IS NOT NULL
GROUP BY cst_id
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;


/*-----------------------------------------------------------------------------
1.3 Check NULL Customer IDs
-----------------------------------------------------------------------------*/

SELECT *
FROM bronze.crm_cust_info
WHERE cst_id IS NULL;


/*-----------------------------------------------------------------------------
1.4 Check Unwanted Spaces in First and Last Names
-----------------------------------------------------------------------------*/

SELECT
    cst_id,
    cst_firstname,
    cst_lastname
FROM bronze.crm_cust_info
WHERE cst_firstname <> TRIM(cst_firstname)
   OR cst_lastname <> TRIM(cst_lastname);


/*-----------------------------------------------------------------------------
1.5 Check Marital Status Values
-----------------------------------------------------------------------------*/

SELECT
    cst_marital_status,
    COUNT(*) AS record_count
FROM bronze.crm_cust_info
GROUP BY cst_marital_status
ORDER BY record_count DESC;


/*-----------------------------------------------------------------------------
1.6 Check Gender Values
-----------------------------------------------------------------------------*/

SELECT
    cst_gndr,
    COUNT(*) AS record_count
FROM bronze.crm_cust_info
GROUP BY cst_gndr
ORDER BY record_count DESC;


/*-----------------------------------------------------------------------------
1.7 Check NULL Values in Customer Table
-----------------------------------------------------------------------------*/

SELECT
    SUM(CASE WHEN cst_id IS NULL THEN 1 ELSE 0 END) AS null_cst_id,
    SUM(CASE WHEN cst_key IS NULL THEN 1 ELSE 0 END) AS null_cst_key,
    SUM(CASE WHEN cst_firstname IS NULL THEN 1 ELSE 0 END) AS null_cst_firstname,
    SUM(CASE WHEN cst_lastname IS NULL THEN 1 ELSE 0 END) AS null_cst_lastname,
    SUM(CASE WHEN cst_marital_status IS NULL THEN 1 ELSE 0 END) AS null_marital_status,
    SUM(CASE WHEN cst_gndr IS NULL THEN 1 ELSE 0 END) AS null_gender,
    SUM(CASE WHEN cst_create_date IS NULL THEN 1 ELSE 0 END) AS null_create_date
FROM bronze.crm_cust_info;


/*
===============================================================================
2. CRM PRODUCT INFORMATION
===============================================================================
*/


/*-----------------------------------------------------------------------------
2.1 Check Duplicate Product IDs
-----------------------------------------------------------------------------*/

SELECT
    prd_id,
    COUNT(*) AS duplicate_count
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;


/*-----------------------------------------------------------------------------
2.2 Check NULL Product IDs
-----------------------------------------------------------------------------*/

SELECT *
FROM bronze.crm_prd_info
WHERE prd_id IS NULL;


/*-----------------------------------------------------------------------------
2.3 Check Duplicate Product Keys
-----------------------------------------------------------------------------*/

SELECT
    prd_key,
    COUNT(*) AS duplicate_count
FROM bronze.crm_prd_info
GROUP BY prd_key
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;


/*-----------------------------------------------------------------------------
2.4 Check NULL Values in Product Table
-----------------------------------------------------------------------------*/

SELECT
    SUM(CASE WHEN prd_id IS NULL THEN 1 ELSE 0 END) AS null_prd_id,
    SUM(CASE WHEN prd_key IS NULL THEN 1 ELSE 0 END) AS null_prd_key,
    SUM(CASE WHEN prd_nm IS NULL THEN 1 ELSE 0 END) AS null_prd_nm,
    SUM(CASE WHEN prd_cost IS NULL THEN 1 ELSE 0 END) AS null_prd_cost,
    SUM(CASE WHEN prd_line IS NULL THEN 1 ELSE 0 END) AS null_prd_line,
    SUM(CASE WHEN prd_start_dt IS NULL THEN 1 ELSE 0 END) AS null_start_date,
    SUM(CASE WHEN prd_end_dt IS NULL THEN 1 ELSE 0 END) AS null_end_date
FROM bronze.crm_prd_info;


/*-----------------------------------------------------------------------------
2.5 Check Unwanted Spaces in Product Name
-----------------------------------------------------------------------------*/

SELECT
    prd_id,
    prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm <> TRIM(prd_nm);


/*-----------------------------------------------------------------------------
2.6 Check Product Line Values
-----------------------------------------------------------------------------*/

SELECT
    prd_line,
    COUNT(*) AS record_count
FROM bronze.crm_prd_info
GROUP BY prd_line
ORDER BY record_count DESC;


/*-----------------------------------------------------------------------------
2.7 Check Negative Product Costs
-----------------------------------------------------------------------------*/

SELECT *
FROM bronze.crm_prd_info
WHERE prd_cost < 0;


/*-----------------------------------------------------------------------------
2.8 Check NULL Product Costs
-----------------------------------------------------------------------------*/

SELECT *
FROM bronze.crm_prd_info
WHERE prd_cost IS NULL;


/*-----------------------------------------------------------------------------
2.9 Check Invalid Product Date Ranges
-----------------------------------------------------------------------------*/

SELECT
    prd_id,
    prd_key,
    prd_start_dt,
    prd_end_dt
FROM bronze.crm_prd_info
WHERE prd_end_dt IS NOT NULL
  AND prd_start_dt > prd_end_dt;


/*-----------------------------------------------------------------------------
2.10 Check Product Date Sequence
-----------------------------------------------------------------------------*/

SELECT
    prd_id,
    prd_key,
    prd_start_dt,
    prd_end_dt
FROM bronze.crm_prd_info
ORDER BY
    prd_key,
    prd_start_dt;


/*
===============================================================================
3. CRM SALES DETAILS
===============================================================================
*/


/*-----------------------------------------------------------------------------
3.1 Check NULL Order Numbers
-----------------------------------------------------------------------------*/

SELECT *
FROM bronze.crm_sales_details
WHERE sls_ord_num IS NULL;


/*-----------------------------------------------------------------------------
3.2 Check NULL Product Keys
-----------------------------------------------------------------------------*/

SELECT *
FROM bronze.crm_sales_details
WHERE sls_prd_key IS NULL;


/*-----------------------------------------------------------------------------
3.3 Check NULL Customer IDs
-----------------------------------------------------------------------------*/

SELECT *
FROM bronze.crm_sales_details
WHERE sls_cust_id IS NULL;


/*-----------------------------------------------------------------------------
3.4 Check Duplicate Sales Order + Product Combinations
-----------------------------------------------------------------------------*/

SELECT
    sls_ord_num,
    sls_prd_key,
    COUNT(*) AS record_count
FROM bronze.crm_sales_details
GROUP BY
    sls_ord_num,
    sls_prd_key
HAVING COUNT(*) > 1
ORDER BY record_count DESC;


/*-----------------------------------------------------------------------------
3.5 Check Invalid Order Dates
-----------------------------------------------------------------------------*/

SELECT
    sls_ord_num,
    sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0
   OR LEN(sls_order_dt) <> 8;


/*-----------------------------------------------------------------------------
3.6 Check Invalid Ship Dates
-----------------------------------------------------------------------------*/

SELECT
    sls_ord_num,
    sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt <= 0
   OR LEN(sls_ship_dt) <> 8;


/*-----------------------------------------------------------------------------
3.7 Check Invalid Due Dates
-----------------------------------------------------------------------------*/

SELECT
    sls_ord_num,
    sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0
   OR LEN(sls_due_dt) <> 8;


/*-----------------------------------------------------------------------------
3.8 Check NULL Sales
-----------------------------------------------------------------------------*/

SELECT *
FROM bronze.crm_sales_details
WHERE sls_sales IS NULL;


/*-----------------------------------------------------------------------------
3.9 Check Negative or Zero Sales
-----------------------------------------------------------------------------*/

SELECT *
FROM bronze.crm_sales_details
WHERE sls_sales <= 0;


/*-----------------------------------------------------------------------------
3.10 Check NULL Quantity
-----------------------------------------------------------------------------*/

SELECT *
FROM bronze.crm_sales_details
WHERE sls_quantity IS NULL;


/*-----------------------------------------------------------------------------
3.11 Check Zero or Negative Quantity
-----------------------------------------------------------------------------*/

SELECT *
FROM bronze.crm_sales_details
WHERE sls_quantity <= 0;


/*-----------------------------------------------------------------------------
3.12 Check NULL Price
-----------------------------------------------------------------------------*/

SELECT *
FROM bronze.crm_sales_details
WHERE sls_price IS NULL;


/*-----------------------------------------------------------------------------
3.13 Check Zero or Negative Price
-----------------------------------------------------------------------------*/

SELECT *
FROM bronze.crm_sales_details
WHERE sls_price <= 0;


/*-----------------------------------------------------------------------------
3.14 Check Sales Calculation Consistency
Business Rule:

    Sales = Quantity × Price

-----------------------------------------------------------------------------*/

SELECT
    sls_ord_num,
    sls_prd_key,
    sls_quantity,
    sls_price,
    sls_sales,
    sls_quantity * ABS(sls_price) AS calculated_sales
FROM bronze.crm_sales_details
WHERE sls_sales IS NOT NULL
  AND sls_quantity IS NOT NULL
  AND sls_price IS NOT NULL
  AND sls_sales <> sls_quantity * ABS(sls_price);


/*-----------------------------------------------------------------------------
3.15 Check Sales / Quantity / Price Issues Together
-----------------------------------------------------------------------------*/

SELECT
    SUM(CASE WHEN sls_sales IS NULL THEN 1 ELSE 0 END) AS null_sales,
    SUM(CASE WHEN sls_sales <= 0 THEN 1 ELSE 0 END) AS invalid_sales,

    SUM(CASE WHEN sls_quantity IS NULL THEN 1 ELSE 0 END) AS null_quantity,
    SUM(CASE WHEN sls_quantity <= 0 THEN 1 ELSE 0 END) AS invalid_quantity,

    SUM(CASE WHEN sls_price IS NULL THEN 1 ELSE 0 END) AS null_price,
    SUM(CASE WHEN sls_price <= 0 THEN 1 ELSE 0 END) AS invalid_price
FROM bronze.crm_sales_details;


/*
===============================================================================
4. CRM CROSS-TABLE RELATIONSHIP PROFILING
===============================================================================
*/


/*-----------------------------------------------------------------------------
4.1 Sales Records with Missing Customer in CRM Customer Table
-----------------------------------------------------------------------------*/

SELECT
    s.sls_cust_id,
    COUNT(*) AS sales_records
FROM bronze.crm_sales_details s
LEFT JOIN bronze.crm_cust_info c
    ON s.sls_cust_id = c.cst_id
WHERE c.cst_id IS NULL
GROUP BY s.sls_cust_id
ORDER BY sales_records DESC;


/*-----------------------------------------------------------------------------
4.2 Sales Records with Missing Product in CRM Product Table
-----------------------------------------------------------------------------*/

SELECT
    s.sls_prd_key,
    COUNT(*) AS sales_records
FROM bronze.crm_sales_details s
LEFT JOIN bronze.crm_prd_info p
    ON s.sls_prd_key = p.prd_key
WHERE p.prd_key IS NULL
GROUP BY s.sls_prd_key
ORDER BY sales_records DESC;


/*
===============================================================================
5. CRM SUMMARY
===============================================================================
*/

SELECT
    'crm_cust_info' AS TableName,
    COUNT(*) AS RowCount
FROM bronze.crm_cust_info

UNION ALL

SELECT
    'crm_prd_info',
    COUNT(*)
FROM bronze.crm_prd_info

UNION ALL

SELECT
    'crm_sales_details',
    COUNT(*)
FROM bronze.crm_sales_details;


USE DataWarehouse;
GO

/*
===============================================================================
SILVER LAYER - ERP DATA PROFILING
Project: SQL Data Warehouse & Analytics
Purpose: Identify data quality issues in ERP Bronze tables

Tables:
    1. bronze.erp_cust_az12
    2. bronze.erp_loc_a101
    3. bronze.erp_px_cat_g1v2

Note:
    This script is for PROFILING.
    Returned rows indicate potential data-quality issues that need
    transformation or investigation before loading into Silver.
===============================================================================
*/


/*
===============================================================================
1. ERP CUSTOMER INFORMATION
===============================================================================
*/


/*-----------------------------------------------------------------------------
1.1 Check Duplicate Customer IDs
-----------------------------------------------------------------------------*/

SELECT
    CID,
    COUNT(*) AS record_count
FROM bronze.erp_cust_az12
GROUP BY CID
HAVING COUNT(*) > 1
ORDER BY record_count DESC;


/*-----------------------------------------------------------------------------
1.2 Check NULL Customer IDs
-----------------------------------------------------------------------------*/

SELECT *
FROM bronze.erp_cust_az12
WHERE CID IS NULL
   OR TRIM(CID) = '';


/*-----------------------------------------------------------------------------
1.3 Check Unwanted Spaces in Customer ID
-----------------------------------------------------------------------------*/

SELECT
    CID
FROM bronze.erp_cust_az12
WHERE CID <> TRIM(CID);


/*-----------------------------------------------------------------------------
1.4 Check Birth Date Values
-----------------------------------------------------------------------------*/

SELECT
    CID,
    BDATE
FROM bronze.erp_cust_az12
WHERE BDATE IS NULL
   OR BDATE < '1900-01-01'
   OR BDATE > '2027-01-01'
ORDER BY BDATE;


/*-----------------------------------------------------------------------------
1.5 Check Gender Values
-----------------------------------------------------------------------------*/

SELECT
    GEN,
    COUNT(*) AS record_count
FROM bronze.erp_cust_az12
GROUP BY GEN
ORDER BY record_count DESC;


/*-----------------------------------------------------------------------------
1.6 Check Unexpected Gender Values
-----------------------------------------------------------------------------*/

SELECT DISTINCT
    GEN
FROM bronze.erp_cust_az12
WHERE UPPER(TRIM(GEN)) NOT IN
(
    'M',
    'MALE',
    'F',
    'FEMALE'
)
AND GEN IS NOT NULL;


/*-----------------------------------------------------------------------------
1.7 Check NULL Values
-----------------------------------------------------------------------------*/

SELECT
    SUM(CASE WHEN CID IS NULL THEN 1 ELSE 0 END) AS null_cid,
    SUM(CASE WHEN BDATE IS NULL THEN 1 ELSE 0 END) AS null_bdate,
    SUM(CASE WHEN GEN IS NULL THEN 1 ELSE 0 END) AS null_gen
FROM bronze.erp_cust_az12;


/*
===============================================================================
2. ERP CUSTOMER LOCATION
===============================================================================
*/


/*-----------------------------------------------------------------------------
2.1 Check Duplicate Customer IDs
-----------------------------------------------------------------------------*/

SELECT
    CID,
    COUNT(*) AS record_count
FROM bronze.erp_loc_a101
GROUP BY CID
HAVING COUNT(*) > 1
ORDER BY record_count DESC;


/*-----------------------------------------------------------------------------
2.2 Check NULL Customer IDs
-----------------------------------------------------------------------------*/

SELECT *
FROM bronze.erp_loc_a101
WHERE CID IS NULL
   OR TRIM(CID) = '';


/*-----------------------------------------------------------------------------
2.3 Check Unwanted Spaces in Customer ID
-----------------------------------------------------------------------------*/

SELECT
    CID
FROM bronze.erp_loc_a101
WHERE CID <> TRIM(CID);


/*-----------------------------------------------------------------------------
2.4 Check Customer IDs Containing '-'
-----------------------------------------------------------------------------*/

SELECT
    CID
FROM bronze.erp_loc_a101
WHERE CID LIKE '%-%';


/*-----------------------------------------------------------------------------
2.5 Check Country Values
-----------------------------------------------------------------------------*/

SELECT
    CNTRY,
    COUNT(*) AS record_count
FROM bronze.erp_loc_a101
GROUP BY CNTRY
ORDER BY record_count DESC;


/*-----------------------------------------------------------------------------
2.6 Check NULL or Blank Countries
-----------------------------------------------------------------------------*/

SELECT *
FROM bronze.erp_loc_a101
WHERE CNTRY IS NULL
   OR TRIM(CNTRY) = '';


/*-----------------------------------------------------------------------------
2.7 Check Unexpected Country Codes
-----------------------------------------------------------------------------*/

SELECT DISTINCT
    UPPER(TRIM(CNTRY)) AS CNTRY
FROM bronze.erp_loc_a101
WHERE UPPER(TRIM(CNTRY)) NOT IN
(
    'US',
    'USA',
    'DE'
)
AND CNTRY IS NOT NULL
AND TRIM(CNTRY) <> '';


/*-----------------------------------------------------------------------------
2.8 Check NULL Values
-----------------------------------------------------------------------------*/

SELECT
    SUM(CASE WHEN CID IS NULL THEN 1 ELSE 0 END) AS null_cid,
    SUM(CASE WHEN CNTRY IS NULL THEN 1 ELSE 0 END) AS null_country
FROM bronze.erp_loc_a101;


/*
===============================================================================
3. ERP PRODUCT CATEGORY INFORMATION
===============================================================================
*/


/*-----------------------------------------------------------------------------
3.1 Check Duplicate Product IDs
-----------------------------------------------------------------------------*/

SELECT
    ID,
    COUNT(*) AS record_count
FROM bronze.erp_px_cat_g1v2
GROUP BY ID
HAVING COUNT(*) > 1
ORDER BY record_count DESC;


/*-----------------------------------------------------------------------------
3.2 Check NULL Product IDs
-----------------------------------------------------------------------------*/

SELECT *
FROM bronze.erp_px_cat_g1v2
WHERE ID IS NULL
   OR TRIM(ID) = '';


/*-----------------------------------------------------------------------------
3.3 Check Unwanted Spaces
-----------------------------------------------------------------------------*/

SELECT
    ID,
    CAT,
    SUBCAT,
    MAINTENANCE
FROM bronze.erp_px_cat_g1v2
WHERE ID <> TRIM(ID)
   OR CAT <> TRIM(CAT)
   OR SUBCAT <> TRIM(SUBCAT)
   OR MAINTENANCE <> TRIM(MAINTENANCE);


/*-----------------------------------------------------------------------------
3.4 Check NULL Values
-----------------------------------------------------------------------------*/

SELECT
    SUM(CASE WHEN ID IS NULL THEN 1 ELSE 0 END) AS null_id,
    SUM(CASE WHEN CAT IS NULL THEN 1 ELSE 0 END) AS null_category,
    SUM(CASE WHEN SUBCAT IS NULL THEN 1 ELSE 0 END) AS null_subcategory,
    SUM(CASE WHEN MAINTENANCE IS NULL THEN 1 ELSE 0 END) AS null_maintenance
FROM bronze.erp_px_cat_g1v2;


/*-----------------------------------------------------------------------------
3.5 Check Category Values
-----------------------------------------------------------------------------*/

SELECT
    CAT,
    COUNT(*) AS record_count
FROM bronze.erp_px_cat_g1v2
GROUP BY CAT
ORDER BY record_count DESC;


/*-----------------------------------------------------------------------------
3.6 Check Subcategory Values
-----------------------------------------------------------------------------*/

SELECT
    SUBCAT,
    COUNT(*) AS record_count
FROM bronze.erp_px_cat_g1v2
GROUP BY SUBCAT
ORDER BY record_count DESC;


/*-----------------------------------------------------------------------------
3.7 Check Maintenance Values
-----------------------------------------------------------------------------*/

SELECT
    MAINTENANCE,
    COUNT(*) AS record_count
FROM bronze.erp_px_cat_g1v2
GROUP BY MAINTENANCE
ORDER BY record_count DESC;


/*
===============================================================================
4. ERP CROSS-TABLE RELATIONSHIP PROFILING
===============================================================================
*/


/*-----------------------------------------------------------------------------
4.1 Check ERP Customer IDs Missing from ERP Location
-----------------------------------------------------------------------------*/

SELECT
    c.CID
FROM bronze.erp_cust_az12 c
LEFT JOIN bronze.erp_loc_a101 l
    ON REPLACE(TRIM(c.CID), '-', '')
     = REPLACE(TRIM(l.CID), '-', '')
WHERE l.CID IS NULL;


/*-----------------------------------------------------------------------------
4.2 Check CRM Customer IDs Missing from ERP Customer Information
-----------------------------------------------------------------------------*/

SELECT
    c.cst_id,
    c.cst_key
FROM bronze.crm_cust_info c
LEFT JOIN bronze.erp_cust_az12 e
    ON c.cst_key = SUBSTRING(TRIM(e.CID), 4, LEN(TRIM(e.CID)))
WHERE e.CID IS NULL;


/*-----------------------------------------------------------------------------
4.3 Check CRM Customer IDs Missing from ERP Location
-----------------------------------------------------------------------------*/

SELECT
    c.cst_id,
    c.cst_key
FROM bronze.crm_cust_info c
LEFT JOIN bronze.erp_loc_a101 e
    ON c.cst_key = REPLACE(TRIM(e.CID), '-', '')
WHERE e.CID IS NULL;


/*
===============================================================================
5. ERP SUMMARY
===============================================================================
*/

SELECT
    'erp_cust_az12' AS TableName,
    COUNT(*) AS RowCount
FROM bronze.erp_cust_az12

UNION ALL

SELECT
    'erp_loc_a101',
    COUNT(*)
FROM bronze.erp_loc_a101

UNION ALL

SELECT
    'erp_px_cat_g1v2',
    COUNT(*)
FROM bronze.erp_px_cat_g1v2;