/*
=============================================================
Create Database and Schemas
=============================================================
Script Summary:
    - Checks if a database named 'DataWarehouse' already exists.
    - Drops the database if it exists and recreates it.
    - Creates the schemas: bronze, silver, and gold.

WARNING:
    - Executing this script will delete the entire 'DataWarehouse' database if it exists.
    - All existing data will be permanently lost.
    - Ensure required backups are taken before running this script.

*/

USE master;
GO

-- Drop and recreate the 'DataWarehouse' database
IF EXISTS (
    SELECT 1
    FROM sys.databases
    WHERE name = 'DataWarehouse'
)
BEGIN
    ALTER DATABASE DataWarehouse
        SET SINGLE_USER
        WITH ROLLBACK IMMEDIATE;

    DROP DATABASE DataWarehouse;
END;
GO

-- Create the 'DataWarehouse' database
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Create schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
