```sql
/*
===============================================================================
Stored Procedure: silver.load_silver

Purpose:
    Loads data from the Bronze layer into the Silver layer while applying
    data cleaning, validation, standardization, and business transformations.

Load Strategy:
    - Truncate Silver tables before loading.
    - Transform data during INSERT ... SELECT.
    - Keep the most recent customer record when duplicates exist.
    - Validate and correct invalid values.
    - Track individual table load duration and total batch duration.
    - Capture and re-throw errors using TRY/CATCH.

Note:
    Update table/database paths or names if your project structure differs.
===============================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE
        @start_time DATETIME,
        @end_time DATETIME,
        @batch_start_time DATETIME,
        @batch_end_time DATETIME;

    BEGIN TRY

        -- =========================================================
        -- Start Silver Layer Load
        -- =========================================================

        SET @batch_start_time = GETDATE();

        PRINT '=========================================================';
        PRINT 'Loading Silver Layer';
        PRINT '=========================================================';


        -- =========================================================
        -- Load CRM Tables
        -- =========================================================

        PRINT '---------------------------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '---------------------------------------------------------';


        -- =========================================================
        -- CRM Customer Information
        -- =========================================================

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: silver.crm_cust_info';

        TRUNCATE TABLE silver.crm_cust_info;

        PRINT '>> Inserting Data Into: silver.crm_cust_info';

        INSERT INTO silver.crm_cust_info (
            cst_id,
            cst_key,
            cst_firstname,
            cst_lastname,
            cst_marital_status,
            cst_gndr,
            cst_create_date
        )
        SELECT
            cst_id,
            cst_key,

            TRIM(cst_firstname) AS cst_firstname, -- Remove leading/trailing spaces

            TRIM(cst_lastname) AS cst_lastname, -- Remove leading/trailing spaces

            CASE
                WHEN UPPER(TRIM(cst_marital_status)) = 'S'
                    THEN 'Single' -- Convert source code S to business value Single

                WHEN UPPER(TRIM(cst_marital_status)) = 'M'
                    THEN 'Married' -- Convert source code M to business value Married

                ELSE 'n/a' -- Replace unknown or missing marital status
            END AS cst_marital_status,

            CASE
                WHEN UPPER(TRIM(cst_gndr)) = 'M'
                    THEN 'Male' -- Convert source code M to Male

                WHEN UPPER(TRIM(cst_gndr)) = 'F'
                    THEN 'Female' -- Convert source code F to Female

                ELSE 'n/a' -- Replace unknown or missing gender
            END AS cst_gndr,

            cst_create_date

        FROM (
            SELECT
                *,

                ROW_NUMBER() OVER (
                    PARTITION BY cst_id
                    ORDER BY cst_create_date DESC
                ) AS flag_last -- Assign row number to identify the most recent customer record

            FROM bronze.crm_cust_info

            WHERE cst_id IS NOT NULL -- Exclude records without a customer ID

        ) AS t

        WHERE flag_last = 1; -- Keep only the latest record for each customer


        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '--------------------------------------------';


        -- =========================================================
        -- CRM Product Information
        -- =========================================================

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: silver.crm_prd_info';

        TRUNCATE TABLE silver.crm_prd_info;

        PRINT '>> Inserting Data Into: silver.crm_prd_info';

        INSERT INTO silver.crm_prd_info (
            prd_id,
            cat_id,
            prd_key,
            prd_nm,
            prd_cost,
            prd_line,
            prd_start_dt,
            prd_end_dt
        )
        SELECT
            prd_id,

            REPLACE(
                SUBSTRING(prd_key, 1, 5),
                '-',
                '_'
            ) AS cat_id, -- Extract category ID and replace '-' with '_'

            SUBSTRING(
                prd_key,
                7,
                LEN(prd_key)
            ) AS prd_key, -- Extract product ID from the source product key

            prd_nm,

            ISNULL(
                prd_cost,
                0
            ) AS prd_cost, -- Replace missing product cost with 0

            CASE UPPER(TRIM(prd_line))

                WHEN 'M'
                    THEN 'Mountaine' -- Convert M code to Mountaine

                WHEN 'R'
                    THEN 'Road' -- Convert R code to Road

                WHEN 'S'
                    THEN 'Other Sales' -- Convert S code to Other Sales

                WHEN 'T'
                    THEN 'Touring' -- Convert T code to Touring

                ELSE 'n/a' -- Replace unknown or missing product line

            END AS prd_line,

            CAST(
                prd_start_dt AS DATE
            ) AS prd_start_dt, -- Remove time portion and keep only the date

            CAST(
                LEAD(prd_start_dt) OVER (
                    PARTITION BY prd_key
                    ORDER BY prd_start_dt
                ) - 1 AS DATE
            ) AS prd_end_dt -- End date is one day before the next product version starts

        FROM bronze.crm_prd_info;


        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '--------------------------------------------';


        -- =========================================================
        -- CRM Sales Details
        -- =========================================================

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: silver.crm_sales_details';

        TRUNCATE TABLE silver.crm_sales_details;

        PRINT '>> Inserting Data Into: silver.crm_sales_details';

        INSERT INTO silver.crm_sales_details (
            sls_ord_num,
            sls_prd_key,
            sls_cust_id,
            sls_order_dt,
            sls_ship_dt,
            sls_due_dt,
            sls_sales,
            sls_quantity,
            sls_price
        )
        SELECT
            sls_ord_num,
            sls_prd_key,
            sls_cust_id,

            CASE
                WHEN sls_order_dt <= 0
                     OR LEN(sls_order_dt) != 8
                    THEN NULL -- Replace invalid order dates with NULL

                ELSE CAST(
                    CAST(sls_order_dt AS VARCHAR) AS DATE
                ) -- Convert valid YYYYMMDD value into DATE

            END AS sls_order_dt,

            CASE
                WHEN sls_ship_dt <= 0
                     OR LEN(sls_ship_dt) != 8
                    THEN NULL -- Replace invalid shipping dates with NULL

                ELSE CAST(
                    CAST(sls_ship_dt AS VARCHAR) AS DATE
                ) -- Convert valid YYYYMMDD value into DATE

            END AS sls_ship_dt,

            CASE
                WHEN sls_due_dt <= 0
                     OR LEN(sls_due_dt) != 8
                    THEN NULL -- Replace invalid due dates with NULL

                ELSE CAST(
                    CAST(sls_due_dt AS VARCHAR) AS DATE
                ) -- Convert valid YYYYMMDD value into DATE

            END AS sls_due_dt,

            CASE
                WHEN sls_sales IS NULL
                     OR sls_sales <= 0
                     OR sls_sales != sls_quantity * ABS(sls_price)

                    THEN sls_quantity * ABS(sls_price)
                    -- Recalculate sales when missing, invalid,
                    -- or inconsistent with quantity × price

                ELSE sls_sales

            END AS sls_sales,

            sls_quantity,

            CASE
                WHEN sls_price IS NULL
                     OR sls_price <= 0

                    THEN sls_sales / NULLIF(sls_quantity, 0)
                    -- Recalculate price from sales / quantity
                    -- NULLIF prevents division-by-zero errors

                ELSE sls_price

            END AS sls_price

        FROM bronze.crm_sales_details;


        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '--------------------------------------------';


        -- =========================================================
        -- Load ERP Tables
        -- =========================================================

        PRINT '---------------------------------------------------------';
        PRINT 'Loading ERP Tables';
        PRINT '---------------------------------------------------------';


        -- =========================================================
        -- ERP Customer Information
        -- =========================================================

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: silver.erp_cust_az12';

        TRUNCATE TABLE silver.erp_cust_az12;

        PRINT '>> Inserting Data Into: silver.erp_cust_az12';

        INSERT INTO silver.erp_cust_az12 (
            cid,
            bdate,
            gen
        )
        SELECT

            CASE
                WHEN cid LIKE 'NAS%'

                    THEN SUBSTRING(
                        cid,
                        4,
                        LEN(cid)
                    )
                    -- Remove the NAS prefix to standardize
                    -- customer IDs across source systems

                ELSE cid

            END AS cid,

            CASE
                WHEN bdate > GETDATE()
                    THEN NULL -- Future birth dates are invalid

                ELSE bdate

            END AS bdate,

            CASE
                WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE')
                    THEN 'Female' -- Standardize female values

                WHEN UPPER(TRIM(gen)) IN ('M', 'MALE')
                    THEN 'Male' -- Standardize male values

                ELSE 'n/a' -- Replace unknown or missing gender

            END AS gen

        FROM bronze.erp_cust_az12;


        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '--------------------------------------------';


        -- =========================================================
        -- ERP Location Information
        -- =========================================================

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: silver.erp_loc_a101';

        TRUNCATE TABLE silver.erp_loc_a101;

        PRINT '>> Inserting Data Into: silver.erp_loc_a101';

        INSERT INTO silver.erp_loc_a101 (
            cid,
            cntry
        )
        SELECT

            REPLACE(
                cid,
                '-',
                ''
            ) AS cid, -- Remove '-' from customer ID for standardization

            CASE
                WHEN TRIM(cntry) = 'DE'
                    THEN 'Germany' -- Convert DE country code to Germany

                WHEN TRIM(cntry) IN ('US', 'USA')
                    THEN 'United States' -- Convert US/USA codes to United States

                WHEN TRIM(cntry) = ''
                     OR cntry IS NULL
                    THEN 'n/a' -- Replace missing country values

                ELSE TRIM(cntry) -- Remove unnecessary spaces

            END AS cntry

        FROM bronze.erp_loc_a101;


        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '--------------------------------------------';


        -- =========================================================
        -- ERP Product Category Information
        -- =========================================================

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: silver.erp_px_cat_g1v2';

        TRUNCATE TABLE silver.erp_px_cat_g1v2;

        PRINT '>> Inserting Data Into: silver.erp_px_cat_g1v2';

        INSERT INTO silver.erp_px_cat_g1v2 (
            id,
            cat,
            subcat,
            maintenance
        )
        SELECT
            id,
            cat,
            subcat,
            maintenance

        FROM bronze.erp_px_cat_g1v2;
        -- No transformation is currently required for this table.


        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '--------------------------------------------';


        -- =========================================================
        -- Silver Layer Load Completed
        -- =========================================================

        SET @batch_end_time = GETDATE();

        PRINT '=========================================';
        PRINT 'Loading Silver Layer is Completed';

        PRINT '  - Total Load Duration: '
            + CAST(
                DATEDIFF(
                    SECOND,
                    @batch_start_time,
                    @batch_end_time
                ) AS NVARCHAR
              )
            + ' seconds';

        PRINT '=========================================';


    END TRY

    BEGIN CATCH

        -- =========================================================
        -- Error Handling
        -- =========================================================

        PRINT '============================================';
        PRINT 'ERROR OCCURRED DURING LOADING SILVER LAYER';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT 'Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR);
        PRINT '============================================';

        THROW; -- Re-throw the original error to the caller

    END CATCH

END;
GO
```
