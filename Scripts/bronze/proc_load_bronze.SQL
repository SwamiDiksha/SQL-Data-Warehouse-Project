/*
===========================================================================
Stored Procedure : Load Bronze Layer (Source -> Bronze)
===========================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external csv files.
    It performs the following acions:
    - Truncates the Bronze tables before loading data.
    - Uses the 'BULK INSERT' command to load the data from source to bronze tables. 

Parameters :
     None.
   This stored procedure not accept any parameters or return any value.

Usage Example:
   EXEC Bronze.load_bronze;
===========================================================================

*/

CREATE OR ALTER PROCEDURE BRONZE.LOAD_BRONZE AS
BEGIN

     declare @totalstart_time datetime , @totalend_time datetime;
     declare @start_time datetime, @end_time datetime;

     set @totalstart_time = getdate();
     BEGIN TRY
           print '==================================';
           PRINT 'loading Bronze Layer '; 
           print '==================================';

           print '------------------------------------';
           print'Loading CRM table ';
           print '------------------------------------';

           /* If we run this bulk insert query again then it will again insert 
              18494 rows int he table agian
              SO TO AVOID INSERTING THE DUPLICATE USE TRUNCATE */

            set @start_time = getdate();
            PRINT '>> Truncating table : bronze.crm_cust_info';
            TRUNCATE TABLE bronze.crm_cust_info;

            PRINT '>> Inserting data into : bronze.crm_cust_info';
            BULK INSERT bronze.crm_cust_info
            FROM 'D:\Pot Pani\Sql Content\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
            with (
                 firstrow = 2,
                 fieldterminator = ',',
                 tablock   --lock the table 
            );
            set @end_time = getdate();
            print'Load duration = ' +cast(datediff( second ,@start_time, @end_time) as nvarchar ) + 'seconds';
            print '-------------';

             --Not enough to write a script  -> i have to test quality of our bronze table 
             --                                 specially if we are working with files
             --SELECT * FROM bronze.crm_cust_info;
             --SELECT COUNT(*) FROM bronze.crm_cust_info;


             --Second crm table
             set @start_time= getdate();
             PRINT '>> Truncating table : bronze.crm_prd_info';
             truncate table bronze.crm_prd_info;

             PRINT '>> Printing data into : bronze.crm_prd_info';
             bulk insert bronze.crm_prd_info
             from 'D:\Pot Pani\Sql Content\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
             with(
                  firstrow= 2,
                  fieldterminator = ',',
                  tablock
             );
             set @end_time = getdate();
             print ' loading duration ='+ cast( datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
            print '-------------';

            --select * from bronze.crm_prd_info;
            --select COUNT(*) from bronze.crm_prd_info;

             --Third crm table
            set @start_time = getdate();
            PRINT '>> Truncating table : BRONZE.CRM_SALES_DETAILS';
            truncate table bronze.crm_sales_details;

            PRINT '>> Printing data into : BRONZE.CRM_SALES_DETAILS';
            BULK INSERT BRONZE.CRM_SALES_DETAILS
            FROM 'D:\Pot Pani\Sql Content\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
            with(
                  firstrow = 2,
                  fieldterminator = ',',
                  tablock
            );
            set @end_time = getdate();
            print'loding duration =' + cast(datediff(second ,@start_time , @end_time) as nvarchar) + 'seconds';
            print '-------------';

            --select * from bronze.crm_sales_details;
            --select COUNT(*) from bronze.crm_sales_details;

            print '------------------------------------';
            print'Loading ERP tables ';
            print '------------------------------------';

            --first erp table
            set @start_time = getdate();
            PRINT '>> Truncating table : bronze.erp_cust_az12';
            truncate table.bronze.erp_cust_az12;

            PRINT '>> Printing data into : bronze.erp_cust_az12';
            bulk insert bronze.erp_cust_az12
            from 'D:\Pot Pani\Sql Content\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
            with(
                  firstrow = 2,
                  fieldterminator = ',',
                  tablock
            );
            set @end_time = getdate();
            print 'loding duration =' + cast( datediff( second ,@start_time, @end_time) as nvarchar) +'second';
            print '-------------';

            --select * from bronze.erp_cust_az12;
            --select COUNT(*) from bronze.erp_cust_az12;

            --second erp table
            set @start_time = getdate();
            PRINT '>> Truncating table  : bronze.erp_loc_a101';
            truncate table bronze.erp_loc_a101;

            PRINT '>> Printing data into : bronze.erp_loc_a101';
            bulk insert bronze.erp_loc_a101
            from 'D:\Pot Pani\Sql Content\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
            with(
                  firstrow = 2,
                  fieldterminator = ',',
                  tablock
            );
            set @end_time = getdate();
            print 'loding duration =' + cast(datediff( second ,@start_time, @end_time) as nvarchar) +'second';
            print '------------';

            --select * from bronze.erp_loc_a101;
            --select COUNT(*) from bronze.erp_loc_a101;

            --Third erp table
            set @start_time = getdate();
            PRINT '>>  Truncating table : bronze.erp_px_cat_g1v2';
            truncate table bronze.erp_px_cat_g1v2;

            PRINT '>> Printing data into : bronze.erp_px_cat_g1v2';
            bulk insert bronze.erp_px_cat_g1v2
            from 'D:\Pot Pani\Sql Content\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
            with(
                  firstrow = 2,
                  fieldterminator = ',',
                  tablock
            );
            set @end_time = getdate();
            print 'loding duration =' + cast( datediff( second ,@start_time, @end_time) as nvarchar) +'second';
            print '--------------';

            set @totalend_time = GETDATE();

            print ' '
            print ' '
            print '====================== '
            print 'Loading bronze layer is completed '
            print '   -Total loading time: ' + cast( datediff(second , @totalstart_time , @totalend_time) as nvarchar ) + 'seconds';
            print '====================== '



            --select * from bronze.erp_px_cat_g1v2;
            --select COUNT(*) from bronze.erp_px_cat_g1v2;
    END TRY

    BEGIN CATCH 
        PRINT '===============================================';
        PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
        PRINT 'Error Message ' + ERROR_MESSAGE();
        PRINT 'Error Number ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error STATE ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '===============================================';

    END CATCH

END ;
