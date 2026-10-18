/*
=================================================================
CREATE DATABASE AND SCHEAMS 
=================================================================
Script purpose:
     This script creates a new database named 'DataWarehouse' after checking if its
     already exists.If the database exists, it is droped and recreated. Additionally
     the scripts se ts up three schemas withi the database  : 'bronze','silver','gold'

Warning:
        Running this script ill delete the entire 'DataWarehouse' database if it 
        exists. All data in the database will be permanantly deleted.proceed with
        causion and ensure you have proper backups before running this script 
*/

use master;
GO

--Drop and recreate 'DataWarehouse' database
IF EXISTS(SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
Begin 
     ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
     DROP  DATABASE WAREHOUSE;
END ;
GO

--CREATE THE 'DATAWAREHOUSE' DATABASE
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
go

--create schemas
CREATE SCHEMA bronze ;
go

CREATE SCHEMA silver ;
go

CREATE SCHEMA gold ;

GO
