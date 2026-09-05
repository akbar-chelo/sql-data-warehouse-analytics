# Gold Layer Data Catalog

## Purpose

The Gold layer contains business-ready data designed for analytics,
reporting, and Power BI.

The Gold layer follows a Star Schema with:

- `gold.dim_customers`
- `gold.dim_products`
- `gold.fact_sales`

The Gold layer is built from the cleaned and standardized Silver layer.

---

# 1. Customer Dimension

## gold.dim_customers

### Description

The Customer Dimension combines customer information from CRM and ERP
sources into a single business-ready view.

### Grain

One row represents one customer.

### Source Tables

- `silver.crm_cust_info`
- `silver.erp_cust_az12`
- `silver.erp_loc_a101`

### Columns

| Column | Data Type | Description | Source | Transformation |
|---|---|---|---|---|
| customer_key | INT | Unique surrogate key for the customer | Gold | Generated using `ROW_NUMBER()` |
| customer_id | INT | Original customer identifier | CRM | `cst_id` |
| customer_number | VARCHAR(50) | Customer business key | CRM | `cst_key` |
| first_name | VARCHAR(50) | Customer first name | CRM | `cst_firstname` |
| last_name | VARCHAR(50) | Customer last name | CRM | `cst_lastname` |
| country | VARCHAR(50) | Customer country | ERP | From `erp_loc_a101` |
| marital_status | VARCHAR(10) | Customer marital status | CRM | Standardized in Silver |
| gender | VARCHAR(10) | Customer gender | CRM + ERP | CRM preferred, ERP fallback |
| birth_date | DATE | Customer birth date | ERP | From `erp_cust_az12` |
| create_date | DATETIME2 | Data warehouse creation date | CRM/Silver | `dwh_create_date` |

### Business Rules

- CRM is the primary source for customer information.
- ERP provides additional customer attributes.
- CRM gender is preferred when available.
- ERP gender is used when CRM gender is `n/a`.
- Customer country comes from the ERP location table.
- `customer_key` is generated as a surrogate key.

---

# 2. Product Dimension

## gold.dim_products

### Description

The Product Dimension combines product information from CRM with
product category information from ERP.

### Grain

One row represents one active product.

### Source Tables

- `silver.crm_prd_info`
- `silver.erp_px_cat_g1v2`

### Columns

| Column | Data Type | Description | Source | Transformation |
|---|---|---|---|---|
| product_key | INT | Unique surrogate key for the product | Gold | Generated using `ROW_NUMBER()` |
| product_id | INT | Original product identifier | CRM | `prd_id` |
| product_number | VARCHAR(100) | Product business key | CRM | `prd_key` |
| product_name | VARCHAR(100) | Product name | CRM | `prd_nm` |
| category_id | VARCHAR(50) | Product category identifier | CRM | `cat_id` |
| category | VARCHAR(100) | Product category | ERP | From `erp_px_cat_g1v2` |
| subcategory | VARCHAR(100) | Product subcategory | ERP | From `erp_px_cat_g1v2` |
| maintenance | VARCHAR(50) | Product maintenance information | ERP | From `erp_px_cat_g1v2` |
| product_line | VARCHAR(50) | Product line | CRM | `prd_line` |
| product_cost | DECIMAL(10,2) | Product cost | CRM | `prd_cost` |
| start_date | DATE | Product validity start date | CRM | `prd_start_dt` |
| end_date | DATE | Product validity end date | CRM | `prd_end_dt` |
| create_date | DATETIME2 | Data warehouse creation date | CRM/Silver | `dwh_create_date` |

### Business Rules

- CRM is the primary source for product information.
- ERP provides category, subcategory, and maintenance information.
- `cat_id` from CRM is matched with `ID` from ERP.
- Only active products are included in the Gold view.
- Active products are identified by `end_date IS NULL`.
- `product_key` is generated as a surrogate key.

---

# 3. Sales Fact

## gold.fact_sales

### Description

The Sales Fact contains business-ready sales transactions and connects
sales activity with customer and product dimensions.

### Grain

One row represents one sales order line for a product.

### Source Tables

- `silver.crm_sales_details`
- `gold.dim_customers`
- `gold.dim_products`

### Columns

| Column | Data Type | Description | Source | Transformation |
|---|---|---|---|---|
| order_number | VARCHAR(150) | Sales order number | CRM | `sls_ord_num` |
| product_key | INT | Gold product surrogate key | Gold | Joined from `dim_products` |
| customer_key | INT | Gold customer surrogate key | Gold | Joined from `dim_customers` |
| order_date | DATE | Sales order date | CRM/Silver | `sls_order_dt` |
| shipping_date | DATE | Product shipping date | CRM/Silver | `sls_ship_dt` |
| due_date | DATE | Sales due date | CRM/Silver | `sls_due_dt` |
| sales_amount | DECIMAL(18,2) | Sales revenue | CRM/Silver | `sls_sales` |
| quantity | INT | Quantity sold | CRM/Silver | `sls_quantity` |
| price | DECIMAL(18,2) | Selling price | CRM/Silver | `sls_price` |

### Business Rules

- Sales transactions originate from the CRM sales table.
- Source product keys are mapped to the Gold `product_key`.
- Source customer IDs are mapped to the Gold `customer_key`.
- Sales measures come from the validated Silver layer.
- The fact table connects sales transactions with customer and product dimensions.

---

# 4. Star Schema

The Gold layer follows a Star Schema.

```text
                    gold.dim_customers
                           |
                           | 1
                           |
                           | *
                    gold.fact_sales
                           *
                           |
                           | 1
                           |
                    gold.dim_products