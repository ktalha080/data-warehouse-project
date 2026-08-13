==========================================================
--Stored Procedure: Load Bronze Layer (Source -> Bronze)
==========================================================
---------------------------------------------------------------------------------------------
--Script Purpose:
     This stored procedure loads the data into the 'Bronze' schema from external csv files.
It perfroms the following actions.
     -Truncates bronze table before loading data.
     -uses the bulk insert command to load data from the csv files to bronze tables.

Usage example:
Exec Bronze.load_bronze_data
----------------------------------------------------------------------------------------------

create or alter procedure Bronze.load_bronze_data as
begin

Truncate table bronze.crm_cust_info;
Bulk insert bronze.crm_cust_info
from 'D:\SQL\sql-data-warehouse-project\datasets\source_crm/cust_info.csv'
with (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    Tablock
);

Truncate table bronze.crm_prd_info;
Bulk insert bronze.crm_prd_info
from 'D:\SQL\sql-data-warehouse-project\datasets\source_crm/prd_info.csv'
with (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    Tablock
);

Truncate table bronze.crm_sales_details;
Bulk insert bronze.crm_sales_details
from 'D:\SQL\sql-data-warehouse-project\datasets\source_crm/sales_details.csv'
with (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    Tablock
);

Truncate table bronze.erp_cust_az12;
Bulk insert bronze.erp_cust_az12
from 'D:\SQL\sql-data-warehouse-project\datasets\source_erp/cust_az12.csv'
with (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    Tablock
);

Truncate table bronze.erp_loc_a101;
Bulk insert bronze.erp_loc_a101
from 'D:\SQL\sql-data-warehouse-project\datasets\source_erp/loc_a101.csv'
with (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    Tablock
);

Truncate table bronze.erp_px_cat_g1v2;
Bulk insert bronze.erp_px_cat_g1v2
from 'D:\SQL\sql-data-warehouse-project\datasets\source_erp/px_cat_g1v2.csv'
with (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    Tablock
);
End

