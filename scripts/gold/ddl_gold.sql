```sql
/*
===============================================================================
Gold Layer - Dimension Views
===============================================================================

Purpose:
    Create business-ready dimension views in the Gold layer by combining
    and enriching data from the Silver layer.

Dimensions:
    - gold.dim_customers
    - gold.dim_products

Data Modeling:
    - Generate surrogate keys using ROW_NUMBER().
    - Use CRM as the primary source for customer information.
    - Enrich CRM data with ERP customer and location information.
    - Enrich product data with ERP category information.
    - Keep only the current product records in the product dimension.

The Gold layer provides clean, business-friendly dimensions that can be
used by fact tables and analytical queries.
===============================================================================
*/


-- =========================================================
-- Create Customer Dimension
-- =========================================================

CREATE VIEW gold.dim_customers AS
SELECT

    ROW_NUMBER() OVER (
        ORDER BY cst_id
    ) AS customer_key, -- Generate a surrogate key for the customer dimension

    ci.cst_id AS customer_id, -- Original customer ID from CRM

    ci.cst_key AS customer_number, -- Business key used to identify the customer

    ci.cst_firstname AS first_name, -- Customer first name from CRM

    ci.cst_lastname AS last_name, -- Customer last name from CRM

    la.cntry AS country, -- Add country information from the ERP location table

    ci.cst_marital_status AS marital_status, -- Use standardized marital status from CRM

    CASE
        WHEN ci.cst_gndr != 'n/a'
            THEN ci.cst_gndr -- CRM is the master source for gender information

        ELSE COALESCE(
            ca.gen,
            'n/a'
        ) -- If CRM gender is unavailable, use ERP gender; otherwise use 'n/a'

    END AS gender,

    ca.bdate AS birthdate, -- Add customer birthdate from ERP

    ci.cst_create_date AS create_date -- Customer creation date from CRM


FROM silver.crm_cust_info ci

LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key = ca.cid
    -- Enrich CRM customers with ERP customer information.
    -- LEFT JOIN keeps all CRM customers even when no ERP match exists.

LEFT JOIN silver.erp_loc_a101 la
    ON ci.cst_key = la.cid;
    -- Enrich customers with country information from ERP.
    -- LEFT JOIN keeps all CRM customers even when location data is missing.



-- =========================================================
-- Create Product Dimension
-- =========================================================

CREATE VIEW gold.dim_products AS
SELECT

    ROW_NUMBER() OVER (
        ORDER BY pn.prd_start_dt, pn.prd_key
    ) AS product_key, -- Generate a surrogate key for the product dimension

    pn.prd_id AS product_id, -- Original product ID from CRM

    pn.prd_key AS product_number, -- Business key used to identify the product

    pn.prd_nm AS product_name, -- Product name from CRM

    pn.cat_id AS category_id, -- Category identifier used to join CRM and ERP data

    pc.cat AS category, -- Category name from ERP

    pc.subcat AS subcategory, -- Subcategory name from ERP

    pc.maintenance AS maintenance, -- Product maintenance information from ERP

    pn.prd_cost AS product_cost, -- Standardized product cost from CRM

    pn.prd_line AS product_line, -- Standardized product line from CRM

    pn.prd_start_dt AS start_date -- Date when the current product version became active


FROM silver.crm_prd_info pn

LEFT JOIN silver.erp_px_cat_g1v2 pc
    ON pn.cat_id = pc.id
    -- Enrich CRM products with category, subcategory, and maintenance
    -- information from the ERP product category table.

WHERE pn.prd_end_dt IS NULL;
-- Keep only the current product records.
-- Historical product versions have an end date and are excluded.
```
