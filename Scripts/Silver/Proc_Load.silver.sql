/* 
===========================================================================================
"CREATING SILVER SCHEMA TABLES FROM BRONZE SCHEMA TABLES"

-- Script Purpose:
          This stored procedure performs the ETL(extract, transform, load) process
to populate the 'Silver' schema tables from the 'bronze' schema.
--Actions:
  -Truncates Silver Tables
  -Inserts transformed and clean data from Bronze into Silver tables
============================================================================================
*/

--Silver CRM TABLES
Create or alter PROCEDURE Silver.Load_Silver AS
BEGIN
     PRINT '>> Truncating Table silver.crm_cust_info';
     TRUNCATE TABLE silver.crm_cust_info;
     insert into silver.crm_cust_info(
     cst_id,
     cst_key,
     cst_firstname,
     cst_lastname,
     cst_marital_status,
     cst_gndr,
     cst_create_date
     )
     select
     cst_id,
     cst_key,
     trim(cst_firstname) as cst_firstname,
     trim(cst_lastname) as cst_lastname,
     case when upper(trim(cst_marital_status)) = 'S' then 'Single'
          when upper(trim(cst_marital_status)) = 'M' then 'Married'
          else 'Unknown'
     end as cst_marital_status,
     case when upper(trim(cst_gndr)) = 'M' then 'Male'
          when upper(trim(cst_gndr)) = 'F' then 'Female'
          else 'Unknown'
     end as cst_gndr,
     cst_create_date
     from(
     select
     *,
     row_number() over(partition by cst_id order by cst_create_date desc) as flag_last
     from bronze.crm_cust_info
     where cst_id is not null
     )t where flag_last = 1

     PRINT '>> Truncating Table silver.crm_prd_info';
     TRUNCATE TABLE silver.crm_prd_info;
     Insert into silver.crm_prd_info (
     prd_id,
     cat_id,
     prd_key,
     prd_name,
     prd_cost,
     prd_line,
     prd_start_dt,
     prd_end_dt
     )
     SELECT
     prd_id,
     replace(substring(prd_key, 1, 5), '-', '_') as cat_id,
     substring(prd_key, 7, Len(prd_key)) as prd_key,
     prd_name,
     coalesce(prd_cost, 0) as prd_cost,
     case when upper(trim(prd_line)) = 'M' then 'Mountain'
          when upper(trim(prd_line)) = 'R' then 'Road'
          when upper(trim(prd_line)) = 'T' then 'Touring'
          when upper(trim(prd_line)) = 'S' then 'Other Sales'
          else 'n/a'
     end as prd_line,
     prd_start_dt,
     DATEADD(DAY, -1, LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)) as prd_end_dt
     from bronze.crm_prd_info

     PRINT '>> Truncating Table silver.crm_sales_details';
     TRUNCATE TABLE silver.crm_sales_details;
     insert into silver.crm_sales_details(
     sls_ord_num,
     sls_prd_key,
     sls_cust_id,
     sls_order_dt,
     sls_ship_dt,
     sls_due_dt,
     sls_sales,
     sls_quantity,
     sls_price
     )
     select
     sls_ord_num,
     sls_prd_key,
     sls_cust_id,
     case when sls_order_dt = 0 or len(sls_order_dt) !=8 then null
     else cast(cast(sls_order_dt as varchar) as date)
     end as sls_order_dt,
     sls_ship_dt,
     sls_due_dt,
     case when sls_sales != sls_quantity * abs(sls_price) or sls_sales is null or sls_sales <=0
     then sls_quantity * ABS(sls_price)
     else sls_sales
     end as sls_sales,
     sls_quantity,
     case when sls_price is null or sls_price <=0 
     then sls_sales/nullif(sls_quantity, 0)
     else sls_price
     end as sls_price
     from bronze.crm_sales_details


     -- Silver ERP TABLES

     PRINT '>> Truncating Table silver.erp_CUST_AZ12';
     TRUNCATE TABLE silver.erp_CUST_AZ12;
     Insert into silver.erp_CUST_AZ12(
     CID,
     BDATE,
     GEN
     )
     select
     case when CID like 'NAS%' then substring(CID, 4, len(CID)) 
     else CID
     end as CID,
     case when BDATE > getdate() then null 
     else BDATE 
     end as BDATE,
     case when upper(trim(GEN)) in ('M', 'MALE') then 'Male'
          when upper(trim(GEN)) in ('F', 'FEMALE') then 'Female'
          else 'n/a'
     end as GEN
     from bronze.erp_CUST_AZ12


     PRINT '>> Truncating Table silver.erp_LOC_A101';
     TRUNCATE TABLE silver.erp_LOC_A101;
     insert into silver.erp_LOC_A101 (
     cid,
     cntry
     )
     SELECT
     REPLACE (cid, '-', '') AS CID,
     case when trim(cntry) = 'DE' then 'Germany'
          when trim(cntry) in ('US', 'USA') then 'United States'
          when trim(cntry) = '' or cntry is null then 'n/a'
          else trim(cntry)
     end as CNTRY
     FROM bronze.erp_LOC_A101

     PRINT '>> Truncating Table silver.erp_PX_CAT_G1V2';
     TRUNCATE TABLE silver.erp_PX_CAT_G1V2;
     insert into silver.erp_PX_CAT_G1V2 (
     ID,
     CAT,
     SUBCAT,
     MAINTENANCE
     )
     select*
     from bronze.erp_PX_CAT_G1V2
End







