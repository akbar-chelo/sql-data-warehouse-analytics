
/* ======================================================================================
    Bronze Layer Data Validation
====================================================================================== */

SELECT 'crm_cust_info' AS TableName,
       COUNT(*) AS RowCounts
FROM bronze.crm_cust_info

UNION ALL

SELECT 'crm_prd_info',
       COUNT(*)
FROM bronze.crm_prd_info

UNION ALL

SELECT 'crm_sales_details',
       COUNT(*)
FROM bronze.crm_sales_details

UNION ALL

SELECT 'erp_cust_az12',
       COUNT(*)
FROM bronze.erp_cust_az12

UNION ALL

SELECT 'erp_loc_a101',
       COUNT(*)
FROM bronze.erp_loc_a101

UNION ALL

SELECT 'erp_px_cat_g1v2',
       COUNT(*)
FROM bronze.erp_px_cat_g1v2;