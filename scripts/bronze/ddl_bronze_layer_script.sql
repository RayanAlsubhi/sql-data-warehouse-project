/*
================================================================================
Script:      Create Bronze Layer Tables
Description: This script creates the tables required for the Bronze layer of
             the Data Warehouse.

Purpose:
    - Drop existing Bronze layer tables if they already exist.
    - Recreate the Bronze tables with the required structure.
    - Prepare the Bronze layer for loading raw data from CRM and ERP sources.

Sources:
    - CRM: Customer, Product, and Sales data.
    - ERP: Customer, Location, and Product Category data.

Notes:
    - The Bronze layer is used to store raw/source data before transformation
      and cleaning in the Silver layer.
    - OBJECT_ID(..., 'U') is used to check whether a user table already exists
      before dropping it.
    - Running this script will DROP and recreate the Bronze tables, so any
      existing data in these tables will be deleted.

Tables Created:
    CRM:
        - bronze.crm_cust_info
        - bronze.crm_prd_info
        - bronze.crm_sales_details

    ERP:
        - bronze.erp_cust_az12
        - bronze.erp_loc_a101
        - bronze.erp_px_cat_g1v2

================================================================================
*/

-- ================================================================
-- Create CRM Customer Table
-- ================================================================

IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
BEGIN 
    DROP TABLE bronze.crm_cust_info;
END;

CREATE TABLE bronze.crm_cust_info
(
    cst_id             INT,
    cst_key            NVARCHAR(50),
    cst_firstname      NVARCHAR(50),
    cst_lastname       NVARCHAR(50),
    cst_marital_status NVARCHAR(50),
    cst_gndr           NVARCHAR(50),
    cst_create_date    DATE
);


-- ================================================================
-- Create CRM Product Table
-- ================================================================

IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
BEGIN 
    DROP TABLE bronze.crm_prd_info;
END;

CREATE TABLE bronze.crm_prd_info
(
    prd_id       INT,
    prd_key      NVARCHAR(50),
    prd_nm       NVARCHAR(100),
    prd_cost     INT,
    prd_line     NVARCHAR(50),
    prd_start_dt DATETIME,
    prd_end_dt   DATETIME
);


-- ================================================================
-- Create CRM Sales Details Table
-- ================================================================

IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
BEGIN 
    DROP TABLE bronze.crm_sales_details;
END;

CREATE TABLE bronze.crm_sales_details
(
    sls_ord_num  NVARCHAR(50),
    sls_prd_key  NVARCHAR(50),
    sls_cust_id  INT,
    sls_order_dt INT,
    sls_ship_dt  INT,
    sls_due_dt   INT,
    sls_sales     INT,
    sls_quantity  INT,
    sls_price    INT
);


-- ================================================================
-- Create ERP Customer Table
-- ================================================================

IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
BEGIN 
    DROP TABLE bronze.erp_cust_az12;
END;

CREATE TABLE bronze.erp_cust_az12
(
    CID   NVARCHAR(50),
    BDATE DATE,
    GEN   NVARCHAR(10)
);


-- ================================================================
-- Create ERP Location Table
-- ================================================================

IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
BEGIN 
    DROP TABLE bronze.erp_loc_a101;
END;

CREATE TABLE bronze.erp_loc_a101
(
    CID   NVARCHAR(50),
    CNTRY NVARCHAR(50)
);


-- ================================================================
-- Create ERP Product Category Table
-- ================================================================

IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
BEGIN 
    DROP TABLE bronze.erp_px_cat_g1v2;
END;

CREATE TABLE bronze.erp_px_cat_g1v2
(
    ID          NVARCHAR(50),
    CAT         NVARCHAR(50),
    SUBCAT      NVARCHAR(50),
    MAINTENANCE NVARCHAR(50)
);
