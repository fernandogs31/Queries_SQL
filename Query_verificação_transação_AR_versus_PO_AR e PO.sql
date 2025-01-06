select distinct rct.creation_date, rct.trx_date,rct.trx_number,rct.purchase_order,rct.doc_sequence_value,rct.ct_reference, msib.segment1,rctl.quantity_invoiced,rct.interface_header_attribute2,pha.comments
from APPS.RA_CUSTOMER_TRX_ALL            RCT,
APPS.RA_CUSTOMER_TRX_LINES_ALL      RCTL,
APPS.mtl_system_items_b             MSIB,
apps.PO_HEADERS_ALL pha
where 
--rct.creation_date >= '09-APR-24'
rct.trx_number = '1327224'
and rct.customer_trx_id = rctl.customer_trx_id 
and rctl.inventory_item_id = msib.inventory_item_id
and rct.purchase_order = pha.segment1
--and rct.ct_reference = '60465701'
--and rct.doc_sequence_value = '60465701'
--and msib.segment1 in ('2227720-2','5314887','5451284-2','S5809899')
--and rct.ct_reference is null
--and rct.org_id = 4330
--and rct.purchase_order not like '097%'
--and pha.comments like '%6046%'
order by pha.comments
