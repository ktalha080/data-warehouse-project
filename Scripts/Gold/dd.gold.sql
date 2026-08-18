/*
======================================================================================================
                                        "creating Gold views"
--Script Purpose:
        The script creates views for the Gold layer in the data wharehouse.
The gold llayer represents the final dimension and fact tables (star schema)

Each view performs tranformations and combines data from the silver layer
to produce clean, enriched and business ready dataset.

Usage:
The view can be queried directly for analytics and reporting
======================================================================================================
*/

create view gold.dim_customers AS
SELECT
    ROW_NUMBER() over(ORDER BY cst_id) as customer_key,
    ci.cst_id as customer_id,
    ci.cst_key as customer_number,
    ci.cst_firstname as first_name,
    ci.cst_lastname as last_name,
    la.CNTRY as country,
    ci.cst_marital_status as marital_status,
    case when ci.cst_gndr != 'n/a' then ci.cst_gndr --  crm is the master sheet
    else COALESCE(ca.GEN, 'n/a')
    END as gender,
    ci.cst_create_date as create_date,
    ca.BDATE as birthdate
FROM Silver.crm_cust_info ci
LEFT JOIN Silver.erp_CUST_AZ12 ca
on ci.cst_key=ca.CID
LEFT JOIN Silver.erp_LOC_A101 la
on ci.cst_key=la.CID

--------------------------------------------------------------------

create VIEW gold.dim_products AS
select
    ROW_NUMBER() over(order by pn.prd_start_dt, pn.prd_key) as product_key,
    pn.prd_id as product_id,
    pn.prd_key as product_number,
    pn.prd_name as product_name,
    pn.cat_id as category_id,
    pc.CAT as category,
    pc.SUBCAT as subcategory,
    pc.MAINTENANCE,
    pn.prd_cost as cost,
    pn.prd_line as product_line,
    pn.prd_start_dt as start_date
from silver.crm_prd_info pn
LEFT JOIN silver.erp_PX_CAT_G1V2 pc
on pn.cat_id= pc.ID
where prd_end_dt is NULL -- filter out all historical data 


--------------------------------------------------------------------------------

CREATE VIEW gold.fact_sales AS
SELECT
    sd.sls_ord_num AS order_number,
    pr.product_key,
    cu.customer_key,
    sd.sls_order_dt as order_date,
    sd.sls_ship_dt as shipping_date,
    sd.sls_due_dt as due_date,
    sd.sls_sales as sales_amount,
    sd.sls_quantity as quantity,
    sd.sls_price as price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
on sd.sls_prd_key= pr.product_number
LEFT JOIN gold.dim_customers cu
ON sd.sls_cust_id = cu.customer_id
