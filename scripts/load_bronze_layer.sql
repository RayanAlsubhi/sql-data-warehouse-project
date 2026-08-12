/*
===============================================================================
Script:      load_bronze.sql

Description:
    Loads raw CRM and ERP CSV files into the Bronze layer of the Data Warehouse.

Purpose:
    - Clear existing Bronze table data using TRUNCATE TABLE.
    - Load raw CRM and ERP source data using BULK INSERT.
    - Preserve the source data for further transformation in the Silver layer.

IMPORTANT:
    Replace the placeholder path below with YOUR local datasets path.

    Example:
    FROM 'C:\Your\Path\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'

    Do NOT commit your personal Windows path to the repository.

Source folders:
    - datasets/source_crm/
    - datasets/source_erp/

===============================================================================
*/


-- ================================================================
-- CRM: Customer Information
-- ================================================================

TRUNCATE TABLE bronze.crm_cust_info;

BULK INSERT bronze.crm_cust_info
FROM 'YOUR_LOCAL_PATH\datasets\source_crm\cust_info.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);


-- ================================================================
-- CRM: Product Information
-- ================================================================

TRUNCATE TABLE bronze.crm_prd_info;

BULK INSERT bronze.crm_prd_info
FROM 'YOUR_LOCAL_PATH\datasets\source_crm\prd_info.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);


-- ================================================================
-- CRM: Sales Details
-- ================================================================

TRUNCATE TABLE bronze.crm_sales_details;

BULK INSERT bronze.crm_sales_details
FROM 'YOUR_LOCAL_PATH\datasets\source_crm\sales_details.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);


-- ================================================================
-- ERP: Customer Information
-- ================================================================

TRUNCATE TABLE bronze.erp_cust_az12;

BULK INSERT bronze.erp_cust_az12
FROM 'YOUR_LOCAL_PATH\datasets\source_erp\cust_az12.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);


-- ================================================================
-- ERP: Location Information
-- ================================================================

TRUNCATE TABLE bronze.erp_loc_a101;

BULK INSERT bronze.erp_loc_a101
FROM 'YOUR_LOCAL_PATH\datasets\source_erp\loc_a101.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);


-- ================================================================
-- ERP: Product Category Information
-- ================================================================

TRUNCATE TABLE bronze.erp_px_cat_g1v2;

BULK INSERT bronze.erp_px_cat_g1v2
FROM 'YOUR_LOCAL_PATH\datasets\source_erp\px_cat_g1v2.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
