/*
==============
Create database and schemas
==============
Purpose:
  Create a new database named 'dw_project' after checkin if it already exits.
  If so, it is dropped and recreated. Additionally, the script sets up three schemas
  within the database: 'bronze', 'silver', and 'gold'.
WARNING:
    Running this script will drop the entire 'DataWarehouse' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/


USE master;
GO

-- Drop and recreate the 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'dw_project')
BEGIN
    ALTER DATABASE dw_project SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE dw_project;
END;
GO

-- Create the 'dw_project' database
CREATE DATABASE dw_project;
GO

USE DataWarehouse;
GO
-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
