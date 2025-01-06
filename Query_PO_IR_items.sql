 select distinct ood.organization_code,poh.segment1, poh.creation_date, msi.segment1
 from apps.po_requisition_headers_all poh,
 apps.po_requisition_lines_all pol,
 apps.mtl_system_items msi,
 apps.org_organization_definitions ood
 where 1 = 1
 AND poh.requisition_header_id = pol.requisition_header_id
 AND msi.inventory_item_id = pol.item_id
 AND pol.destination_organization_id = ood.organization_id
 AND poh.creation_date >='01-JAN-24'
 AND ood.organization_code in ('C83','ASP','DMG','DSP','MRC','CTC','SGC')
 --AND mmt.transaction_source_id = poh.requisition_header_id) req_number,
 --AND poh.segment1 = '7392371.1'
-----------------------------------------------------------------------------------
 select distinct ood.organization_code,poh.segment1, poh.creation_date, msi.segment1
 from apps.PO_LINES_ALL pol,
     apps.PO_HEADERS_ALL poh,
     apps.PO_LINE_LOCATIONS_ALL pll,
 apps.mtl_system_items msi,
 apps.org_organization_definitions ood
 where 1 = 1
 AND poh.po_header_id = pol.po_header_id
 AND pol.po_line_id = pll.po_line_id
 AND msi.inventory_item_id = pol.item_id
 AND pll.ship_to_organization_id = ood.organization_id
 AND poh.creation_date >='01-JAN-24'
 AND ood.organization_code in ('U41','U42','U51','U52')
 --AND mmt.transaction_source_id = poh.requisition_header_id) req_number,
 --AND poh.segment1 = '7392371.1'