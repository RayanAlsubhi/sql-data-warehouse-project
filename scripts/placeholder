/*
===============================================================================
Script: load_bronze_layer.sql
Description:
    Loads raw CRM source data into Bronze layer tables using BULK INSERT.

Important:
    Replace the file paths below with the location of your datasets.

Example:
    FROM 'C:\your_path\datasets\source_crm\cust_info.csv'

Dataset Structure:
    datasets/
    └── source_crm/
        ├── cust_info.csv
        ├── prd_info.csv
        └── sales_details.csv
===============================================================================
*/

-- ================================================================
-- Load CRM Customer Data
-- ================================================================

TRUNCATE TABLE bronze.crm_cust_info;

BULK INSERT bronze.crm_cust_info
FROM 'C:\your_path\datasets\source_crm\cust_info.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);

-- ================================================================
-- Load CRM Product Data
-- ================================================================

TRUNCATE TABLE bronze.crm_prd_info;

BULK INSERT bronze.crm_prd_info
FROM 'C:\your_path\datasets\source_crm\prd_info.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);

-- ================================================================
-- Load CRM Sales Data
-- ================================================================

TRUNCATE TABLE bronze.crm_sales_details;

BULK INSERT bronze.crm_sales_details
FROM 'C:\your_path\datasets\source_crm\sales_details.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
