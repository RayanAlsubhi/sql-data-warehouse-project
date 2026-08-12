/*
================================================================================
Procedure:      bronze.load_bronze
Description:    Loads raw data from CRM and ERP CSV source files into the
                Bronze layer of the Data Warehouse.

Purpose:
    - Perform a full refresh of the Bronze layer tables.
    - Remove existing data using TRUNCATE TABLE.
    - Load fresh data using BULK INSERT.
    - Track individual table load durations.
    - Track the total Bronze layer load duration.
    - Handle and report errors using TRY...CATCH.

Source Systems:
    CRM:
        - cust_info.csv
        - prd_info.csv
        - sales_details.csv

    ERP:
        - cust_az12.csv
        - loc_a101.csv
        - px_cat_g1v2.csv

IMPORTANT:
    - The file paths below are placeholders.
    - Before running this procedure, replace 'YOUR_LOCAL_PATH' with
      the actual location of the project on your machine.
    - Make sure SQL Server has permission to access the specified files.
    - The CSV files are expected to contain a header row.
    - FIRSTROW = 2 is used to skip the header row.

Example:
    Replace:

        YOUR_LOCAL_PATH

    With your own project path, for example:

        C:\Users\YourName\Desktop\sql-data-warehouse-project\

Loading Strategy:
    1. Start the Bronze layer batch and record the start time.
    2. Truncate each Bronze table.
    3. Load fresh data from the corresponding CSV file.
    4. Calculate and display the load duration for each table.
    5. Calculate and display the total batch load duration.
    6. If an error occurs, capture and display error information.
================================================================================
*/


CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN

    DECLARE @start_time DATETIME,
            @end_time DATETIME,
            @batch_start_time DATETIME,
            @batch_end_time DATETIME;

    BEGIN TRY

        -- =========================================================
        -- Start Bronze Layer Load
        -- =========================================================

        SET @batch_start_time = GETDATE();

        PRINT '=========================================================';
        PRINT 'Loading Bronze Layer';
        PRINT '=========================================================';


        -- =========================================================
        -- Load CRM Tables
        -- =========================================================

        PRINT '---------------------------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '---------------------------------------------------------';


        -- Load CRM Customer Information
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.crm_cust_info';

        TRUNCATE TABLE bronze.crm_cust_info;

        PRINT '>> Inserting Data Into: bronze.crm_cust_info';

        BULK INSERT bronze.crm_cust_info
        FROM 'YOUR_LOCAL_PATH\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '-----------------';


        -- Load CRM Product Information
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.crm_prd_info';

        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT '>> Inserting Data Into: bronze.crm_prd_info';

        BULK INSERT bronze.crm_prd_info
        FROM 'YOUR_LOCAL_PATH\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '-----------------';


        -- Load CRM Sales Details
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.crm_sales_details';

        TRUNCATE TABLE bronze.crm_sales_details;

        PRINT '>> Inserting Data Into: bronze.crm_sales_details';

        BULK INSERT bronze.crm_sales_details
        FROM 'YOUR_LOCAL_PATH\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '-----------------';


        -- =========================================================
        -- Load ERP Tables
        -- =========================================================

        PRINT '---------------------------------------------------------';
        PRINT 'Loading ERP Tables';
        PRINT '---------------------------------------------------------';


        -- Load ERP Customer Information
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.erp_cust_az12';

        TRUNCATE TABLE bronze.erp_cust_az12;

        PRINT '>> Inserting Data Into: bronze.erp_cust_az12';

        BULK INSERT bronze.erp_cust_az12
        FROM 'YOUR_LOCAL_PATH\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '-----------------';


        -- Load ERP Location Information
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.erp_loc_a101';

        TRUNCATE TABLE bronze.erp_loc_a101;

        PRINT '>> Inserting Data Into: bronze.erp_loc_a101';

        BULK INSERT bronze.erp_loc_a101
        FROM 'YOUR_LOCAL_PATH\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '-----------------';


        -- Load ERP Product Category Information
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';

        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';

        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'YOUR_LOCAL_PATH\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '-----------------';


        -- =========================================================
        -- Bronze Layer Load Completed
        -- =========================================================

        SET @batch_end_time = GETDATE();

        PRINT '=========================================';
        PRINT 'Loading Bronze Layer is Completed';
        PRINT '  - Total Load Duration: '
            + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR)
            + ' seconds';
        PRINT '=========================================';


    END TRY


    BEGIN CATCH

        -- =========================================================
        -- Error Handling
        -- =========================================================

        PRINT '============================================';
        PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT 'Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR);
        PRINT '============================================';

        -- Re-throw the original error
        THROW;

    END CATCH

END;
