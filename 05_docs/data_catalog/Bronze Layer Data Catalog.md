# Bronze Layer Data Catalog

## Purpose

The Bronze layer stores raw data loaded directly from the source CSV files.
No major business transformations are applied in this layer.

---

# CRM Tables

## bronze.crm_cust_info

| Column | Data Type | Description | Source |
|---|---|---|---|
| cst_id | INT | Unique customer identifier | CRM |
| cst_key | VARCHAR(100) | Customer business key | CRM |
| cst_firstname | VARCHAR(100) | Customer first name | CRM |
| cst_lastname | VARCHAR(100) | Customer last name | CRM |
| cst_marital_status | VARCHAR(10) | Customer marital status code | CRM |
| cst_gndr | VARCHAR(10) | Customer gender code | CRM |
| cst_create_date | DATE | Customer creation date | CRM |

---

## bronze.crm_prd_info

| Column | Data Type | Description | Source |
|---|---|---|---|
| prd_id | INT | Unique product identifier | CRM |
| prd_key | VARCHAR(100) | Product business key containing category information | CRM |
| prd_nm | VARCHAR(100) | Product name | CRM |
| prd_cost | DECIMAL(10,2) | Product cost | CRM |
| prd_line | VARCHAR(50) | Product line code | CRM |
| prd_start_dt | DATE | Product validity start date | CRM |
| prd_end_dt | DATE | Product validity end date | CRM |

---

## bronze.crm_sales_details

| Column | Data Type | Description | Source |
|---|---|---|---|
| sls_ord_num | VARCHAR(150) | Sales order number | CRM |
| sls_prd_key | VARCHAR(100) | Product business key | CRM |
| sls_cust_id | INT | Customer identifier | CRM |
| sls_order_dt | INT | Order date stored as YYYYMMDD | CRM |
| sls_ship_dt | INT | Shipping date stored as YYYYMMDD | CRM |
| sls_due_dt | INT | Due date stored as YYYYMMDD | CRM |
| sls_sales | INT | Sales amount | CRM |
| sls_quantity | INT | Quantity sold | CRM |
| sls_price | INT | Selling price | CRM |

---

# ERP Tables

## bronze.erp_cust_az12

| Column | Data Type | Description | Source |
|---|---|---|---|
| CID | VARCHAR(100) | ERP customer identifier | ERP |
| BDATE | DATE | Customer birth date | ERP |
| GEN | VARCHAR(20) | Customer gender | ERP |

---

## bronze.erp_loc_a101

| Column | Data Type | Description | Source |
|---|---|---|---|
| CID | VARCHAR(100) | ERP customer identifier | ERP |
| CNTRY | VARCHAR(100) | Customer country | ERP |

---

## bronze.erp_px_cat_g1v2

| Column | Data Type | Description | Source |
|---|---|---|---|
| ID | VARCHAR(50) | Product category identifier | ERP |
| CAT | VARCHAR(100) | Product category | ERP |
| SUBCAT | VARCHAR(100) | Product subcategory | ERP |
| MAINTENANCE | VARCHAR(50) | Product maintenance information | ERP |