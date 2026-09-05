# Silver Layer Data Catalog

## Purpose

The Silver layer contains cleaned, standardized, and transformed data
from the Bronze layer.

Data quality issues identified during profiling are handled during the
Bronze-to-Silver transformation process.

---

# CRM Tables

## silver.crm_cust_info

| Column | Data Type | Description | Source | Transformation |
|---|---|---|---|---|
| cst_id | INT | Unique customer identifier | Bronze CRM | NULL IDs removed; duplicates handled |
| cst_key | VARCHAR(100) | Customer business key | Bronze CRM | Preserved |
| cst_firstname | VARCHAR(100) | Customer first name | Bronze CRM | Unwanted spaces removed using TRIM() |
| cst_lastname | VARCHAR(100) | Customer last name | Bronze CRM | Unwanted spaces removed using TRIM() |
| cst_marital_status | VARCHAR(10) | Customer marital status | Bronze CRM | S → Single, M → Married |
| cst_gndr | VARCHAR(10) | Customer gender | Bronze CRM | M → Male, F → Female |
| cst_create_date | DATE | Customer creation date | Bronze CRM | Preserved |
| dwh_create_date | DATETIME2 | Warehouse record creation timestamp | Silver | DEFAULT GETDATE() |

### Data Quality Rules

- Duplicate `cst_id` records are removed.
- NULL `cst_id` records are excluded.
- Leading and trailing spaces are removed from customer names.
- Marital status codes are standardized into readable values.
- Gender codes are standardized into readable values.
- Unknown values are represented as `n/a`.

---

## silver.crm_prd_info

| Column | Data Type | Description | Source | Transformation |
|---|---|---|---|---|
| prd_id | INT | Unique product identifier | Bronze CRM | Preserved |
| cat_id | VARCHAR(50) | Product category identifier | Bronze CRM | Extracted from `prd_key` |
| prd_key | VARCHAR(100) | Product business key | Bronze CRM | Product portion extracted from encoded key |
| prd_nm | VARCHAR(100) | Product name | Bronze CRM | Unwanted spaces removed |
| prd_cost | DECIMAL(10,2) | Product cost | Bronze CRM | Validated; NULL handled according to business rule |
| prd_line | VARCHAR(50) | Product line | Bronze CRM | M → Mountain, R → Road, S → Other Sales, T → Touring |
| prd_start_dt | DATE | Product validity start date | Bronze CRM | Preserved |
| prd_end_dt | DATE | Product validity end date | Bronze CRM | Derived using LEAD() and DATEADD() |
| dwh_create_date | DATETIME2 | Warehouse record creation timestamp | Silver | DEFAULT GETDATE() |

### Data Quality Rules

- Product key is separated into category ID and product key.
- Product names are trimmed.
- Product line codes are standardized.
- Product validity periods are derived from product start dates.
- The next product start date minus one day becomes the previous product's end date.

---

## silver.crm_sales_details

| Column | Data Type | Description | Source | Transformation |
|---|---|---|---|---|
| sls_ord_num | VARCHAR(150) | Sales order number | Bronze CRM | Preserved |
| sls_prd_key | VARCHAR(100) | Product business key | Bronze CRM | Preserved |
| sls_cust_id | INT | Customer identifier | Bronze CRM | Preserved |
| sls_order_dt | DATE | Sales order date | Bronze CRM | Converted from YYYYMMDD integer |
| sls_ship_dt | DATE | Shipping date | Bronze CRM | Converted from YYYYMMDD integer |
| sls_due_dt | DATE | Due date | Bronze CRM | Converted from YYYYMMDD integer |
| sls_sales | DECIMAL(18,2) | Sales amount | Bronze CRM | Invalid/inconsistent values recalculated |
| sls_quantity | INT | Quantity sold | Bronze CRM | Validated |
| sls_price | DECIMAL(18,2) | Selling price | Bronze CRM | Invalid values recalculated where possible |
| dwh_create_date | DATETIME2 | Warehouse record creation timestamp | Silver | DEFAULT GETDATE() |

### Data Quality Rules

- Invalid numeric dates are converted to NULL.
- Sales values are checked against quantity × price.
- Invalid sales values are recalculated where possible.
- Invalid prices are recalculated where possible.
- Quantity and price values are validated to prevent invalid measures.

---

# ERP Tables

## silver.erp_cust_az12

| Column | Data Type | Description | Source | Transformation |
|---|---|---|---|---|
| CID | VARCHAR(100) | Customer identifier | Bronze ERP | ERP prefix removed and spaces trimmed |
| BDATE | DATE | Customer birth date | Bronze ERP | Invalid dates converted to NULL |
| GEN | VARCHAR(20) | Customer gender | Bronze ERP | M/Male → Male; F/Female → Female |
| dwh_create_date | DATETIME2 | Warehouse record creation timestamp | Silver | DEFAULT GETDATE() |

### Data Quality Rules

- ERP-specific customer ID prefix is removed.
- Unwanted spaces are removed.
- Invalid birth dates are converted to NULL.
- Gender values are standardized into readable values.
- Unknown gender values are represented as `n/a`.

---

## silver.erp_loc_a101

| Column | Data Type | Description | Source | Transformation |
|---|---|---|---|---|
| CID | VARCHAR(100) | Customer identifier | Bronze ERP | Hyphens and unwanted spaces removed |
| CNTRY | VARCHAR(100) | Customer country | Bronze ERP | Country codes standardized |
| dwh_create_date | DATETIME2 | Warehouse record creation timestamp | Silver | DEFAULT GETDATE() |

### Data Quality Rules

- Hyphens are removed from customer IDs.
- Unwanted spaces are removed.
- US and USA are standardized to United States.
- DE is standardized to Germany.
- NULL and blank country values are standardized to `n/a`.

---

## silver.erp_px_cat_g1v2

| Column | Data Type | Description | Source | Transformation |
|---|---|---|---|---|
| ID | VARCHAR(50) | Product category identifier | Bronze ERP | Trimmed |
| CAT | VARCHAR(100) | Product category | Bronze ERP | Trimmed |
| SUBCAT | VARCHAR(100) | Product subcategory | Bronze ERP | Trimmed |
| MAINTENANCE | VARCHAR(50) | Product maintenance information | Bronze ERP | Trimmed |
| dwh_create_date | DATETIME2 | Warehouse record creation timestamp | Silver | DEFAULT GETDATE() |

### Data Quality Rules

- Duplicate and NULL category IDs are checked.
- Unwanted spaces are removed where required.
- Category, subcategory, and maintenance values are validated.
- No unnecessary transformations are applied when source values are already valid.


---

# Bronze → Silver Data Flow

## CRM

```text
bronze.crm_cust_info
        ↓
silver.crm_cust_info

bronze.crm_prd_info
        ↓
silver.crm_prd_info

bronze.crm_sales_details
        ↓
silver.crm_sales_details