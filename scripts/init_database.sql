/*
=============================================================
Create Database and Schemas
=============================================================
Script Summary:
    This script checks whether a database named 'DataWarehouse' already exists. 
    If it does, the database is removed and then recreated. After the database 
    is created, three schemas are added: 'bronze', 'silver', and 'gold'.

WARNING:
    Executing this script will remove the entire 'DataWarehouse' database if it 
    is already present. All existing data will be permanently lost. Use this 
    script only when you are certain and ensure that any necessary backups are 
    in place before proceeding.
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
