/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/
-- This is a psql language.
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE start_time TIME, end_time TIME, batch_start_time TIME, batch_end_time TIME; 
	BEGIN
		SET batch_start_time = CURRENT_TIME;
		\echo '================================================';
		\echo 'Loading Bronze Layer';
		\echo '================================================';

		\echo '------------------------------------------------';
		\echo 'Loading CRM Tables';
		\echo '------------------------------------------------';

		SET start_time = CURRENT_TIME;
		\echo '>> Truncating Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;
		\echo '>> Inserting Data Into: bronze.crm_cust_info';
		\copy bronze.crm_cust_info
		FROM '/tmp/datasets/source_crm/cust_info.csv'
		DELIMITER ','
    CSV HEADER;
		SET end_time = CURRENT_TIME;
		\echo '>> Load Duration: ' + CAST(DATEDIFF(second, start_time, end_time) AS VARCHAR) + ' seconds';
		\echo '>> -------------';

        SET start_time = CURRENT_TIME;
		\echo '>> Truncating Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;

		\echo '>> Inserting Data Into: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM '/tmp/datasets/source_crm/prd_info.csv'
		DELIMITER ','
    CSV HEADER;
		SET end_time = CURRENT_TIME;
		\echo '>> Load Duration: ' + CAST(DATEDIFF(second, start_time, end_time) AS VARCHAR) + ' seconds';
		\echo '>> -------------';

        SET start_time = CURRENT_TIME;
		\echo '>> Truncating Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;
		\echo '>> Inserting Data Into: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'datasets/source_crm/sales_details.csv'
		DELIMITER ','
    CSV HEADER;
		SET end_time = CURRENT_TIME;
		\echo '>> Load Duration: ' + CAST(DATEDIFF(second, start_time, end_time) AS VARCHAR) + ' seconds';
		\echo '>> -------------';

		\echo '------------------------------------------------';
		\echo 'Loading ERP Tables';
		\echo '------------------------------------------------';
		
		SET start_time = CURRENT_TIME;
		\echo '>> Truncating Table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;
		\echo '>> Inserting Data Into: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM '/tmp/datasets/source_erp/loc_a101.csv'
		DELIMITER ','
    CSV HEADER;
		SET end_time = CURRENT_TIME;
		\echo '>> Load Duration: ' + CAST(DATEDIFF(second, start_time, end_time) AS VARCHAR) + ' seconds';
		\echo '>> -------------';

		SET start_time = CURRENT_TIME;
		\echo '>> Truncating Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;
		\echo '>> Inserting Data Into: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM '/tmp/datasets/source_erp/cust_az12.csv'
		DELIMITER ','
    CSV HEADER;
		SET end_time = CURRENT_TIME;
		\echo '>> Load Duration: ' + CAST(DATEDIFF(second, start_time, end_time) AS VARCHAR) + ' seconds';
		\echo '>> -------------';

		SET start_time = CURRENT_TIME;
		\echo '>> Truncating Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		\echo '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM '/tmp/datasets/source_erp/px_cat_g1v2.csv'
		DELIMITER ','
    CSV HEADER;
		SET end_time = CURRENT_TIME;
		\echo '>> Load Duration: ' + CAST(DATEDIFF(second, start_time, end_time) AS VARCHAR) + ' seconds';
		\echo '>> -------------';

		SET batch_end_time = CURRENT_TIME;
		\echo '=========================================='
		\echo 'Loading Bronze Layer is Completed';
        \echo '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, batch_start_time, batch_end_time) AS VARCHAR) + ' seconds';
		\echo '=========================================='
	EXCEPTION
		\echo '=========================================='
		\echo 'ERROR OCCURED DURING LOADING BRONZE LAYER'
      /*
		\echo 'Error Message' + ERROR_MESSAGE();
		\echo 'Error Message' + CAST (ERROR_NUMBER() AS VARCHAR);
		\echo 'Error Message' + CAST (ERROR_STATE() AS VARCHAR);
		\echo '=========================================='
*/
  END
END
