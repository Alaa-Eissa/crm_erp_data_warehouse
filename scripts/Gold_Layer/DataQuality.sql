-- Quality checks 
-- check for nulls or duplicates in primary key 
-- Expectation : No Results
select prd_id , count(*)
from silver.crm_prd_info
group by prd_id
having count(*) > 1 or prd_id is null


-- check for unwanted soaces 
-- Expectation : No Results
 select prd_nm 
 from silver.crm_prd_info
 where prd_nm != trim(prd_nm)


 -- check for Nulls or Negative Numbers
 -- Expectation : No Results 
 select prd_cost 
 from silver.crm_prd_info
 where prd_cost < 0 or prd_cost is null


 --- Data Standardization & Consistency 
 select distinct prd_line 
 from silver.crm_prd_info


 -- check for invalid date order 
  select * 
  from silver.crm_prd_info
  where prd_end_dt < prd_start_dt 
 
 select NullIF(sls_order_dt , 0) sls_order_Dt
 from bronze.crm_sales_details
 where sls_order_dt<=0
 or len(sls_order_dt) !=8
 or sls_order_dt > 20500101
 or sls_order_dt < 19000101

 select distinct 
 sls_sales as old_sls_sales ,  sls_quantity , sls_price as old_sls_price,
	CASE when sls_Sales is null or sls_Sales <=0 or sls_Sales != sls_quantity * ABS(sls_price)
	     then sls_quantity * ABS(sls_price)
    END as sls_Sales,
	CASE when sls_price is null or sls_price <=0
	     then sls_sales/NULLIF(sls_quantity,0)
	     Else sls_price
	ENd as sls_price
 from bronze.crm_sales_details
------------------------------------------
-- Table erp_cust_az12
 -- Identify out of range dates 
 select distinct bdate
 from silver.erp_cust_az12
 where bdate< '1924-01-01' or bdate > getdate()
 -- Data Standardization & Consistency
 select distinct 
 gen 
 from silver.erp_cust_az12
 ---------------------------------------------
 -- Table erp_loc_a101
 select distinct cntry
 from silver.erp_loc_a101
 order by cntry
  
 select * from silver.erp_loc_a101 
 -----------------------------------------------
 -- Table erp_px_cat_g1v2
 -- check for uneanted spaces
 select * from silver.erp_px_cat_g1v2
 where cat ! = Trim(cat) or subcat != Trim(subcat) or maintenance!= Trim(maintenance)
 -- Data Standardization & Consistency
 select distinct 
 maintenance
 from silver.erp_px_cat_g1v2

 select * from silver.erp_px_cat_g1v2