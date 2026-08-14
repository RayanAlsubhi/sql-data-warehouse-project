/*
===============================================================================
Script: Create Silver Layer Tables
Purpose:
    - Drop existing Silver layer tables if they already exist.
    - Recreate the Silver layer tables with the required structure.
    - Add a DWH creation timestamp to track when each record is loaded.

Notes:
    - This script is intended to be executed during the database initialization
      or development phase.
    - DROP TABLE removes the existing table and all of its data.
    - The dwh_create_date column automatically stores the date and time when
      a record is inserted if no value is explicitly provided.
    - Adjust data types and column sizes according to the source data and
      transformation requirements of your project.
===============================================================================
*/


-- ============================================================================
-- CRM: Customer Information
-- ============================================================================
-- Check whether the Silver customer table already exists.
-- If it exists, drop it before recreating it.
IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
BEGIN
    DROP TABLE silver.crm_cust_info;
END;

-- Create the Silver customer table.
-- This table will contain the cleaned and transformed customer data
-- coming from the Bronze layer.
CREATE TABLE silver.crm_cust_info
(
    cst_id              INT,
    cst_key             NVARCHAR(50),
    cst_firstname       NVARCHAR(50),
    cst_lastname        NVARCHAR(50),
    cst_marital_status  NVARCHAR(50),
    cst_gndr            NVARCHAR(50),
    cst_create_date     DATE,

    -- Automatically records when the record is loaded into the DWH.
    dwh_create_date     DATETIME2 DEFAULT GETDATE()
);


-- ============================================================================
-- CRM: Product Information
-- ============================================================================
-- Check whether the Silver product table already exists.
-- Drop it before recreating it to ensure a clean table structure.
IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
BEGIN
    DROP TABLE silver.crm_prd_info;
END;

-- Create the Silver product table.
-- This table will contain cleaned and transformed product information
-- from the Bronze layer.
CREATE TABLE silver.crm_prd_info
(
    prd_id              INT,
    prd_key             NVARCHAR(50),
    prd_nm              NVARCHAR(100),
    prd_cost            INT,
    prd_line            NVARCHAR(50),
    prd_start_dt        DATETIME,
    prd_end_dt          DATETIME,

    -- Automatically records when the record is loaded into the DWH.
    dwh_create_date     DATETIME2 DEFAULT GETDATE()
);


-- ============================================================================
-- CRM: Sales Details
-- ============================================================================
-- Check whether the Silver sales table already exists.
-- Drop it before recreating it.
IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
BEGIN
    DROP TABLE silver.crm_sales_details;
END;

-- Create the Silver sales details table.
-- This table will contain cleaned and transformed sales transaction data
-- from the Bronze layer.
CREATE TABLE silver.crm_sales_details
(
    sls_ord_num         NVARCHAR(50),
    sls_prd_key         NVARCHAR(50),
    sls_cust_id         INT,
    sls_order_dt        INT,
    sls_ship_dt         INT,
    sls_due_dt          INT,
    sls_sales            INT,
    sls_quantity        INT,
    sls_price            INT,

    -- Automatically records when the record is loaded into the DWH.
    dwh_create_date     DATETIME2 DEFAULT GETDATE()
);


-- ============================================================================
-- ERP: Customer Information
-- ============================================================================
-- Check whether the Silver ERP customer table already exists.
-- Drop it before recreating it.
IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL
BEGIN
    DROP TABLE silver.erp_cust_az12;
END;

-- Create the Silver ERP customer table.
-- This table will store cleaned customer information coming from the ERP
-- source system.
CREATE TABLE silver.erp_cust_az12
(
    CID                 NVARCHAR(50),
    BDATE               DATE,
    GEN                 NVARCHAR(10),

    -- Automatically records when the record is loaded into the DWH.
    dwh_create_date     DATETIME2 DEFAULT GETDATE()
);


-- ============================================================================
-- ERP: Location Information
-- ============================================================================
-- Check whether the Silver ERP location table already exists.
-- Drop it before recreating it.
IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
BEGIN
    DROP TABLE silver.erp_loc_a101;
END;

-- Create the Silver ERP location table.
-- This table will store cleaned location/country information
-- coming from the ERP source system.
CREATE TABLE silver.erp_loc_a101
(
    CID                 NVARCHAR(50),
    CNTRY               NVARCHAR(50),

    -- Automatically records when the record is loaded into the DWH.
    dwh_create_date     DATETIME2 DEFAULT GETDATE()
);


-- ============================================================================
-- ERP: Product Category Information
-- ============================================================================
-- Check whether the Silver ERP product category table already exists.
-- Drop it before recreating it.
IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
BEGIN
    DROP TABLE silver.erp_px_cat_g1v2;
END;

-- Create the Silver ERP product category table.
-- This table will store cleaned product category, subcategory,
-- and maintenance information from the ERP source system.
CREATE TABLE silver.erp_px_cat_g1v2
(
    ID                  NVARCHAR(50),
    CAT                 NVARCHAR(50),
    SUBCAT              NVARCHAR(50),
    MAINTENANCE         NVARCHAR(50),

    -- Automatically records when the record is loaded into the DWH.
    dwh_create_date     DATETIME2 DEFAULT GETDATE()
);
