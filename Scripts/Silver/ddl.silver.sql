/*
======================================================================
-- Create silver Tables
======================================================================
----------------------------------------------------------------------
--PURPOSE OF THIS SCRIPT
  This script creates tables in the silver schema, dropping 
existing tables if they already exist.
Run this script to refine the DDL structure of 'Bronze' Tables
----------------------------------------------------------------------
*/

If object_id('silver.crm_cust_info', 'U') is not null
drop table silver.crm_cust_info;
CREATE TABLE silver.crm_cust_info(
	cst_id int,
	cst_key nvarchar(50),
	cst_firstname nvarchar(50),
	cst_lastname nvarchar(50),
	cst_marital_status nvarchar(50),
	cst_gndr nvarchar(50),
	cst_create_date date,
    dwh_create_date datetime2 default getdate()    
)

if object_id('silver.crm_prd_info', 'U') is not null
drop table silver.crm_prd_info;
CREATE TABLE silver.crm_prd_info(
	prd_id int,
    cat_id nvarchar(50),
	prd_key nvarchar(50),
	prd_name nvarchar(50),
	prd_cost decimal(10, 2),
	prd_line nvarchar(50),
	prd_start_dt date,
	prd_end_dt date,
    dwh_create_date datetime2 default getdate()
) 

if object_id('silver.crm_sales_details', 'U') is not null
drop table silver.crm_sales_details;
CREATE TABLE silver.crm_sales_details(
	sls_ord_num nvarchar(50) NOT NULL,
	sls_prd_key nvarchar(50) NOT NULL,
	sls_cust_id int,
	sls_order_dt date,
	sls_ship_dt date,
	sls_due_dt date,
	sls_sales int,
	sls_quantity int,
	sls_price decimal(10, 2),
    dwh_create_date datetime2 default getdate()    
) 

if object_id('silver.erp_CUST_AZ12', 'U') is not null
drop table silver.erp_CUST_AZ12;
CREATE TABLE silver.erp_CUST_AZ12(
	CID nvarchar(50) NOT NULL,
	BDATE date,
	GEN nvarchar(10),
    dwh_create_date datetime2 default getdate()   
)

if object_id('silver.erp_LOC_A101', 'U') is not null
drop table silver.erp_LOC_A101;
CREATE TABLE silver.erp_LOC_A101(
	CID nvarchar(50) NOT NULL,
	CNTRY nvarchar(50),
    dwh_create_date datetime2 default getdate()   
)

if object_id('silver.erp_PX_CAT_G1V2', 'U') is not null
drop table silver.erp_PX_CAT_G1V2;
CREATE TABLE silver.erp_PX_CAT_G1V2(
	ID nvarchar(50),
	CAT varchar(50),
	SUBCAT varchar(50),
	MAINTENANCE varchar(10),
    dwh_create_date datetime2 default getdate()
) 

