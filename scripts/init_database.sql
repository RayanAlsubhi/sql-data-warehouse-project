/*
================================================================================
                         DATA WAREHOUSE INITIALIZATION
================================================================================

PURPOSE:
--------
This script initializes the Data Warehouse database from scratch.

It performs the following steps:
    1. Switches to the master database.
    2. Checks whether the DataWarehouse database already exists.
    3. If it exists, disconnects active users and drops the database.
    4. Creates a fresh DataWarehouse database.
    5. Creates the Bronze, Silver, and Gold schemas.

WHY?
----
This script provides a clean and repeatable starting point for the Data
Warehouse project.

It can be executed whenever the database needs to be completely rebuilt,
for example during development, testing, or when the database structure
needs to be recreated from scratch.

WARNING:
--------
⚠️  DESTRUCTIVE OPERATION!

This script DROPS the existing DataWarehouse database if it exists.

All data, tables, views, stored procedures, indexes, and other objects
inside the database will be permanently deleted.

The following command is especially important:

    WITH ROLLBACK IMMEDIATE

It immediately disconnects other users and rolls back their active
transactions so that the database can be dropped.

DO NOT RUN THIS SCRIPT ON A PRODUCTION DATABASE unless you intentionally
want to completely delete and rebuild it.

SCHEMA ARCHITECTURE:
--------------------
Bronze → Raw/source data
Silver → Cleaned and transformed data
Gold   → Business-ready data for analytics and reporting

================================================================================
*/

USE master;
GO


-- Drop and recreate the "DataWarehouse" database

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'datawarehouse')
BEGIN
    ALTER DATABASE datawarehouse
    SET SINGLE_USER
    WITH ROLLBACK IMMEDIATE;

    DROP DATABASE datawarehouse;
END;
GO


-- Create the "DataWarehouse" database

CREATE DATABASE datawarehouse;
GO

USE datawarehouse;
GO


-- Create Data Warehouse schemas

CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
