/*
=============================================================
Gold Layer Views
=============================================================

Purpose:
    This script creates analytic-ready views in the 'gold' schema.
    These views represent the final business layer used for reporting
    and analytics.

The script performs the following:
    - Creates dimension and fact views for analysis.
    - Builds customer and product dimensions from Silver layer tables.
    - Builds a sales fact view combining customer and product dimensions.
    - Applies final business logic and relationships.

Data Model:
    - dim_customers   : Customer dimension with demographic attributes.
    - dim_products    : Product dimension with category and pricing details.
    - fact_sales      : Sales fact table linked to customers and products.

Usage:
    Execute this script after the Silver layer load process is completed.
    These views are consumed by BI tools, dashboards, and analytical queries.

=============================================================
*/
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers
AS
SELECT
    ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
    ci.cst_id AS customer_id,
    ci.cst_key AS customer_number,
    ci.cst_firstname AS first_name,
    ci.cst_lastname AS last_name,
    ci.cst_marital_status AS marital_status,
    la.CNTRY AS country,
    CASE
        WHEN ci.cst_gndr != 'Unknown' THEN ci.cst_gndr --CRM is the primary source
        ELSE COALESCE(ca.gen, 'Unknown')
    END AS gender,
    ca.bdate AS birth_date,
    ci.cst_create_date
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS ca
    ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 AS la
    ON ci.cst_key = la.cid;
GO

------------------------------------------------------------
-- gold.dim_products
------------------------------------------------------------
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
    pn.prd_id  AS product_id,
    pn.prd_key AS product_number,
    pn.prd_nm  AS product_name,
    pn.cat_id AS category_id,
    pc.cat AS category,
    pc.subcat AS subcategory,
    pc.maintenance,
    pn.prd_cost AS product_cost,
    pn.prd_line AS product_line,
    pn.prd_start_dt AS product_start_date
FROM silver.crm_prd_info AS pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
    ON pn.cat_id = pc.id
WHERE prd_end_dt IS NULL; -- Filter out all historical data
GO

------------------------------------------------------------
-- gold.fact_sales
------------------------------------------------------------
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT
    sd.sls_ord_num   AS order_number,
    gp.product_key,
    gc.customer_key,
    sd.sls_order_dt  AS order_date,
    sd.sls_ship_dt   AS shipping_date,
    sd.sls_due_dt    AS due_date,
    sd.sls_sales     AS sales,
    sd.sls_quantity  AS sales_quantity,
    sd.sls_price     AS sales_price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products gp
    ON sd.sls_prd_key = gp.product_number
LEFT JOIN gold.dim_customers gc
    ON sd.sls_cust_id = gc.customer_id;
GO






