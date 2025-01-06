Select 
rila.interface_line_attribute1,
rila.creation_date,
rila.request_id,
rila.customer_trx_id,
rila.batch_source_name,
rila.line_gdf_attribute1,
rila.line_gdf_attribute2,
rila.line_gdf_attribute3,
rila.line_gdf_attribute4,
rila.line_gdf_attribute5,
rila.line_gdf_attribute6,
rila.line_gdf_attribute7,
rila.orig_system_bill_customer_id,
rila.primary_salesrep_id,
rila.cust_trx_type_id,
rila.org_id,
rila.*
from apps.ra_interface_lines_all RILA
where 
--rila.interface_line_attribute1 in ('1841919')
rila.creation_date = '26-MAR-2024';