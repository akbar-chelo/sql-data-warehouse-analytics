USE DataWarehouse;
GO

/*
===============================================================================
CREATE SILVER CRM TABLES
===============================================================================
*/


-- Creating Customers Table

CREATE TABLE silver.crm_cust_info
(
    cst_id             INT,
    cst_key            VARCHAR(100),
    cst_firstname      VARCHAR(100),
    cst_lastname       VARCHAR(100),
    cst_marital_status VARCHAR(10),
    cst_gndr           VARCHAR(10),
    cst_create_date    DATE,
    dwh_create_date     DATETIME2 DEFAULT GETDATE()
);
GO


-- Creating Products Table

CREATE TABLE silver.crm_prd_info
(
    prd_id             INT,
    cat_id             VARCHAR(50),
    prd_key            VARCHAR(100),
    prd_nm             VARCHAR(100),
    prd_cost           DECIMAL(10,2),
    prd_line           VARCHAR(50),
    prd_start_dt       DATE,
    prd_end_dt         DATE,
    dwh_create_date     DATETIME2 DEFAULT GETDATE()
);
GO


-- Creating Sales Table

CREATE TABLE silver.crm_sales_details
(
    sls_ord_num        VARCHAR(150),
    sls_prd_key        VARCHAR(100),
    sls_cust_id        INT,
    sls_order_dt       DATE,
    sls_ship_dt        DATE,
    sls_due_dt         DATE,
    sls_sales          DECIMAL(18,2),
    sls_quantity       INT,
    sls_price          DECIMAL(18,2),
    dwh_create_date     DATETIME2 DEFAULT GETDATE()
);
GO


/*
===============================================================================
CREATE SILVER ERP TABLES
===============================================================================
*/


-- Creating Customer Information Table

CREATE TABLE silver.erp_cust_az12
(
    CID                 VARCHAR(100),
    BDATE               DATE,
    GEN                 VARCHAR(20),
    dwh_create_date     DATETIME2 DEFAULT GETDATE()
);
GO


-- Creating Customer Location Table

CREATE TABLE silver.erp_loc_a101
(
    CID                 VARCHAR(100),
    CNTRY               VARCHAR(100),
    dwh_create_date     DATETIME2 DEFAULT GETDATE()
);
GO


-- Creating Product Category Information Table

CREATE TABLE silver.erp_px_cat_g1v2
(
    ID                  VARCHAR(50),
    CAT                 VARCHAR(100),
    SUBCAT              VARCHAR(100),
    MAINTENANCE         VARCHAR(50),
    dwh_create_date     DATETIME2 DEFAULT GETDATE()
);
GO