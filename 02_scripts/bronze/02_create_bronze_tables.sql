USE DataWarehouse;
GO

/*
=====================================
CREATE CRM TABLES
=====================================
*/

-- Creating Customers Table

CREATE TABLE bronze.crm_cust_info
(
    cst_id             INT,
    cst_key            VARCHAR(100),
    cst_firstname      VARCHAR(100),
    cst_lastname       VARCHAR(100),
    cst_marital_status VARCHAR(10),
    cst_gndr           VARCHAR(10),
    cst_create_date    DATE
);
GO


-- Creating Products Table

CREATE TABLE bronze.crm_prd_info
(
    prd_id       INT,
    prd_key      VARCHAR(100),
    prd_nm       VARCHAR(100),
    prd_cost     DECIMAL(10,2),
    prd_line     VARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt   DATE
);
GO


-- Creating Sales Table

CREATE TABLE bronze.crm_sales_details
(
    sls_ord_num  VARCHAR(150),
    sls_prd_key  VARCHAR(100),
    sls_cust_id  INT,
    sls_order_dt INT,
    sls_ship_dt  INT,
    sls_due_dt   INT,
    sls_sales     INT,
    sls_quantity INT,
    sls_price    INT
);
GO


/*
=====================================
CREATE ERP TABLES
=====================================
*/

-- Creating Customer Information Table

CREATE TABLE bronze.erp_cust_az12
(
    CID   VARCHAR(100),
    BDATE DATE,
    GEN   VARCHAR(20)
);
GO


-- Creating Customer Location Table

CREATE TABLE bronze.erp_loc_a101
(
    CID   VARCHAR(100),
    CNTRY VARCHAR(100)
);
GO


-- Creating Product Category Information Table

CREATE TABLE bronze.erp_px_cat_g1v2
(
    ID          VARCHAR(50),
    CAT         VARCHAR(100),
    SUBCAT      VARCHAR(100),
    MAINTENANCE VARCHAR(50)
);
GO
