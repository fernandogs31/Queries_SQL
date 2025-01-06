SELECT DISTINCT
 hl.location_code "Org"
,pha.segment1 "PO"
,asp.vendor_name  "Supplier"
,ass.vendor_site_code "Site"
,at.name "Payment Term"
,msi.segment1 "Part Number"
,(pla.unit_price * pla.quantity) "Total Amount"
,gcc.segment2 "Account accrual segment"
,(gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5||'.'||gcc.segment6||'.'||gcc.segment7||'.'||gcc.segment8||'.'||gcc.segment9||'.'||gcc.segment10||'.'||gcc.segment11) "All account segment"

FROM 
 apps.PO_HEADERS_ALL pha
,apps.PO_LINE_LOCATIONS_ALL plla
,apps.PO_LINES_ALL pla
,apps.po_distributions_all pda
,apps.po_vendor_sites_all ass
,apps.po_vendors asp
,gl.gl_code_combinations gcc
,apps.hr_operating_units hou
,apps.hr_locations hl
,apps.mtl_system_items_b msi
,apps.ap_terms at

WHERE
    1=1
AND pha.creation_date between '01-JAN-24' AND '21-NOV-24'
AND pha.org_id = hou.organization_id
AND hou.name = 'GEMSAM_OU_BRL_GEMS_BRA'
AND asp.vendor_id = pha.vendor_id
AND ass.vendor_site_id = pha.vendor_site_id
AND pha.terms_id = at.term_id
AND pla.po_header_id = pha.po_header_id
AND pla.item_id = msi.inventory_item_id
AND plla.po_line_id = pla.po_line_id
AND plla.ship_to_location_id = hl.location_id
AND plla.line_location_id = pda.line_location_id
AND pda.accrual_account_id = gcc.code_combination_id
;

select *
from apps.org_organization_definitions ood
where organization_code in ('DMG','DIV')