USE DataWarehouse;
GO

/*
===============================================================================
GOLD LAYER - DATA VALIDATION
===============================================================================

Purpose:
    Validate the final Gold dimension and fact views.

Expected Result:
    Validation queries should return NO RESULTS unless otherwise specified.

Tables:
    gold.dim_customers
    gold.dim_products
    gold.fact_sales
===============================================================================
*/


/*
===============================================================================
1. CUSTOMER DIMENSION VALIDATION
===============================================================================
*/


-- Check NULL Customer IDs
-- Expected: No results

SELECT *
FROM gold.dim_customers
WHERE customer_id IS NULL;


-- Check Duplicate Customer IDs
-- Expected: No results

SELECT
    customer_id,
    COUNT(*) AS record_count
FROM gold.dim_customers
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- Check NULL Customer Numbers
-- Expected: No results

SELECT *
FROM gold.dim_customers
WHERE customer_number IS NULL
   OR TRIM(customer_number) = '';


-- Check NULL Customer Names
-- Expected: No results

SELECT *
FROM gold.dim_customers
WHERE first_name IS NULL
   OR last_name IS NULL;


-- Check Customer Gender Standardization
-- Expected: No results

SELECT DISTINCT
    gender
FROM gold.dim_customers
WHERE gender NOT IN ('Male', 'Female', 'n/a');


-- Check Customer Marital Status Standardization
-- Expected: No results

SELECT DISTINCT
    marital_status
FROM gold.dim_customers
WHERE marital_status NOT IN ('Single', 'Married', 'n/a');


-- Check Customer Key Uniqueness
-- Expected: No results

SELECT
    customer_key,
    COUNT(*) AS record_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;


/*
===============================================================================
2. PRODUCT DIMENSION VALIDATION
===============================================================================
*/


-- Check NULL Product IDs
-- Expected: No results

SELECT *
FROM gold.dim_products
WHERE product_id IS NULL;


-- Check Duplicate Product IDs
-- Expected: No results

SELECT
    product_id,
    COUNT(*) AS record_count
FROM gold.dim_products
GROUP BY product_id
HAVING COUNT(*) > 1;


-- Check NULL Product Numbers
-- Expected: No results

SELECT *
FROM gold.dim_products
WHERE product_number IS NULL
   OR TRIM(product_number) = '';


-- Check NULL Product Names
-- Expected: No results

SELECT *
FROM gold.dim_products
WHERE product_name IS NULL
   OR TRIM(product_name) = '';


-- Check Product Key Uniqueness
-- Expected: No results

SELECT
    product_key,
    COUNT(*) AS record_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;


-- Check Negative Product Costs
-- Expected: No results

SELECT *
FROM gold.dim_products
WHERE product_cost < 0;


-- Check Product Date Range
-- Expected: No results

SELECT
    product_id,
    start_date,
    end_date
FROM gold.dim_products
WHERE end_date IS NOT NULL
  AND start_date > end_date;


/*
===============================================================================
3. SALES FACT VALIDATION
===============================================================================
*/


-- Check NULL Order Numbers
-- Expected: No results

SELECT *
FROM gold.fact_sales
WHERE order_number IS NULL
   OR TRIM(order_number) = '';


-- Check NULL Product Keys
-- Expected: No results

SELECT *
FROM gold.fact_sales
WHERE product_key IS NULL;


-- Check NULL Customer Keys
-- Expected: No results

SELECT *
FROM gold.fact_sales
WHERE customer_key IS NULL;


-- Check Invalid Sales Amount
-- Expected: No results

SELECT *
FROM gold.fact_sales
WHERE sales_amount IS NULL
   OR sales_amount <= 0;


-- Check Invalid Quantity
-- Expected: No results

SELECT *
FROM gold.fact_sales
WHERE quantity IS NULL
   OR quantity <= 0;


-- Check Invalid Price
-- Expected: No results

SELECT *
FROM gold.fact_sales
WHERE price IS NULL
   OR price <= 0;


-- Check Sales Calculation
-- Expected: No results

SELECT
    order_number,
    product_key,
    quantity,
    price,
    sales_amount,
    quantity * price AS calculated_sales
FROM gold.fact_sales
WHERE ABS(sales_amount - (quantity * price)) > 0.01;


-- Check Sales Date Sequence
-- Expected: No results

SELECT
    order_number,
    order_date,
    shipping_date,
    due_date
FROM gold.fact_sales
WHERE order_date > shipping_date
   OR shipping_date > due_date;


/*
===============================================================================
4. FACT → DIMENSION RELATIONSHIP VALIDATION
===============================================================================
*/


-- Check Fact Sales with Missing Products
-- Expected: No results

SELECT DISTINCT
    f.product_key
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
    ON f.product_key = p.product_key
WHERE p.product_key IS NULL;


-- Check Fact Sales with Missing Customers
-- Expected: No results

SELECT DISTINCT
    f.customer_key
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
    ON f.customer_key = c.customer_key
WHERE c.customer_key IS NULL;


/*
===============================================================================
5. GOLD ROW COUNT VALIDATION
===============================================================================
*/

SELECT
    'dim_customers' AS TableName,
    COUNT(*) AS RowCount
FROM gold.dim_customers

UNION ALL

SELECT
    'dim_products',
    COUNT(*)
FROM gold.dim_products

UNION ALL

SELECT
    'fact_sales',
    COUNT(*)
FROM gold.fact_sales;


/*
===============================================================================
6. GOLD DATA SUMMARY
===============================================================================
*/

SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    COUNT(*) AS total_sales_records,
    SUM(quantity) AS total_quantity,
    SUM(sales_amount) AS total_sales
FROM gold.fact_sales;


/*
===============================================================================
FINAL EXPECTATION

    Customer validation             → No violations
    Product validation              → No violations
    Sales validation                → No violations
    Fact → Dimension relationships  → No violations

    Row count and summary queries
    should return populated results.

===============================================================================
*/