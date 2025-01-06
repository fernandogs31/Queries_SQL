select distinct pll.line_location_id PLLI,
       ph.segment1 PO,
       pl.quantity
       --ph.date
       
from apps.PO_LINE_LOCATIONS_ALL pll,
     apps.PO_LINES_ALL pl,
     apps.PO_HEADERS_ALL ph,
     apps.mtl_system_items_b msib,
     ecomex.cmx_empresas ece
     
where 
1=1
--and pll.line_location_id in (175288127,163798791)
and ph.segment1 = '265610.1'
and msib.segment1 = 'M1168794-S'
and pl.item_id = msib.inventory_item_id
and pll.po_line_id = pl.po_line_id
and pl.po_header_id = ph.po_header_id;