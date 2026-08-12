/*
===============================================================================
Procedure:   bronze.load_bronze

Description:
    Loads raw CRM and ERP source data into the Bronze layer.

Purpose:
    - Truncate existing Bronze tables.
    - Load fresh data from CRM and ERP CSV files.
    - Centralize the Bronze layer loading process into one stored procedure.

IMPORTANT:
    Replace YOUR_LOCAL_PATH with the local path to the project before execution.

Example:
    C:\Your\Path\sql-data-warehouse-project

Source folders:
    - datasets/source_crm/
    - datasets/source_erp/
===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN

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

END;
