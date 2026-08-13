========================================================
-- Create Bronze Tables
Script Purpose:
     This script creates tables in the 'Bronze' schema.
========================================================


CREATE TABLE Bronze.crm_cust_info(
	cst_id int,
	cst_key nvarchar(50),
	cst_firstname nvarchar(50),
	cst_lastname nvarchar(50),
	cst_marital_status nvarchar(50),
	cst_gndr nvarchar(50),
	cst_create_date date 
)

GO
CREATE TABLE Bronze.crm_prd_info(
	prd_id int,
	prd_key nvarchar(50),
	prd_name nvarchar(50),
	prd_cost decimal(10, 2),
	prd_line nvarchar(50),
	prd_start_dt date,
	prd_end_dt date 
) 

GO
CREATE TABLE Bronze.crm_sales_details(
	sls_ord_num nvarchar(50) NOT NULL,
	sls_prd_key nvarchar(50) NOT NULL,
	sls_cust_id int,
	sls_order_dt varchar(50),
	sls_ship_dt date,
	sls_due_dt date,
	sls_sales int,
	sls_quantity int,
	sls_price decimal(10, 2) 
) 

GO
CREATE TABLE Bronze.erp_CUST_AZ12(
	CID nvarchar(50) NOT NULL,
	BDATE date,
	GEN nvarchar(10) 
)

GO
CREATE TABLE Bronze.erp_LOC_A101(
	CID nvarchar(50) NOT NULL,
	CNTRY nvarchar(50) 
)

GO
CREATE TABLE Bronze.erp_PX_CAT_G1V2(
	ID nvarchar(50),
	CAT varchar(50),
	SUBCAT varchar(50),
	MAINTENANCE varchar(10) 
) 
