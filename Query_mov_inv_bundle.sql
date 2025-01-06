SELECT ood.organization_code,
 mmt.transaction_id,
 msn.serial_number,
 mmt.inventory_item_id,
 (SELECT segment1
 FROM apps.mtl_system_items_b
 WHERE inventory_item_id = mmt.inventory_item_id
 AND ROWNUM = 1) item,
 (SELECT transaction_type_name
 FROM apps.mtl_transaction_types mtt
 WHERE mtt.transaction_type_id = mmt.transaction_type_id) transaction_type,
  NULL lot_number,
 (select LICENSE_PLATE_NUMBER
 from apps.wms_license_plate_numbers
 where 1=1 AND LPN_ID = mmt.CONTENT_LPN_ID) LPN,
 mmt.creation_date transaction_creation_date,
 (select distinct poh.segment1
 from apps.po_requisition_headers_all poh,
 apps.po_requisition_lines_all pol
 where 1 = 1
 AND poh.requisition_header_id = pol.requisition_header_id
 AND mmt.inventory_item_id = pol.item_id
 AND mmt.transaction_source_id = poh.requisition_header_id) req_number,
 mMt.TRANSACTION_QUANTITY,
 mMt.TRANSACTION_DATE,
 mMt.SUBINVENTORY_CODE,
  (SELECT mil.segment1 || '.' || mil.segment2 || '.' || mil.segment3 || '.' ||
 mil.segment4 || '.' || mil.segment5
 FROM apps.mtl_item_locations mil
 WHERE mil.inventory_location_id = mMt.locator_id) loc
 
 FROM apps.mtl_unit_transactions mut,
 apps.mtl_serial_numbers msn,
 apps.mtl_material_transactions mmt,
 apps.org_organization_definitions ood
 WHERE msn.serial_number = mut.serial_number
 AND mmt.transaction_id = mut.transaction_id
 AND ood.organization_id = mmt.organization_id
 and mmt.ORGANIZATION_ID in (8245) --, 4870, 4869)
-- AND mmt.transaction_date >= sysdate - 10
 -- AND mut.serial_number IN ('<Your Serial Number>')
  and mmt.transaction_source_id = 60745620
 
 UNION
 -- For serial controlled and lot controlled items
 SELECT ood.organization_code,
 mmt.transaction_id,
 msn.serial_number,
 mmt.inventory_item_id,
 (SELECT segment1
 FROM apps.mtl_system_items_b
 WHERE inventory_item_id = mmt.inventory_item_id
 AND ROWNUM = 1) item,
 (SELECT transaction_type_name
 FROM apps.mtl_transaction_types mtt
 WHERE mtt.transaction_type_id = mmt.transaction_type_id) transaction_type,
 mtln.lot_number,
 (select LICENSE_PLATE_NUMBER
 from apps.wms_license_plate_numbers
 where 1=1 AND LPN_ID = mmt.CONTENT_LPN_ID) LPN,
 mmt.creation_date transaction_creation_date,
 (select distinct poh.segment1
 from apps.po_requisition_headers_all poh,
 apps.po_requisition_lines_all pol
 where 1 = 1
 AND poh.requisition_header_id = pol.requisition_header_id
 AND mmt.inventory_item_id = pol.item_id
 AND mmt.transaction_source_id = poh.requisition_header_id) req_number,
 mMt.TRANSACTION_QUANTITY,
 mMt.TRANSACTION_DATE,
 mMt.SUBINVENTORY_CODE,
  (SELECT mil.segment1 || '.' || mil.segment2 || '.' || mil.segment3 || '.' ||
 mil.segment4 || '.' || mil.segment5
 FROM apps.mtl_item_locations mil
 WHERE mil.inventory_location_id = mMt.locator_id) loc
 
 FROM apps.mtl_unit_transactions mut,
 apps.mtl_serial_numbers msn,
 apps.mtl_material_transactions mmt,
 apps.mtl_transaction_lot_numbers mtln,
 apps.org_organization_definitions ood
 WHERE msn.serial_number = mut.serial_number
 AND mmt.transaction_id = mtln.transaction_id
 AND mtln.serial_transaction_id = mut.transaction_id
 AND ood.organization_id = mmt.organization_id
 and mmt.ORGANIZATION_ID in (8245) --, 4870, 4869)
 --AND mmt.transaction_date >= sysdate - 10
 -- AND mut.serial_number IN ('<Your Serial Number>')
 and mmt.transaction_source_id = 60745620
 
 UNION
 -- For lot controlled items
 SELECT ood.organization_code,
 mmt.transaction_id,
 NULL serial_number,
 mmt.inventory_item_id,
 (SELECT segment1
 FROM apps.mtl_system_items_b
 WHERE inventory_item_id = mmt.inventory_item_id
 AND ROWNUM = 1) item,
 (SELECT transaction_type_name
 FROM apps.mtl_transaction_types mtt
 WHERE mtt.transaction_type_id = mmt.transaction_type_id) transaction_type,
 mtln.lot_number,
 (select LICENSE_PLATE_NUMBER
 from apps.wms_license_plate_numbers
 where 1=1 AND LPN_ID = mmt.CONTENT_LPN_ID) LPN,
 mmt.creation_date transaction_creation_date,
 (select distinct poh.segment1
 from apps.po_requisition_headers_all poh,
 apps.po_requisition_lines_all pol
 where 1 = 1
 AND poh.requisition_header_id = pol.requisition_header_id
 AND mmt.inventory_item_id = pol.item_id
 AND mmt.transaction_source_id = poh.requisition_header_id) req_number,
 mMt.TRANSACTION_QUANTITY,
 mMt.TRANSACTION_DATE,
 mMt.SUBINVENTORY_CODE,
  (SELECT mil.segment1 || '.' || mil.segment2 || '.' || mil.segment3 || '.' ||
 mil.segment4 || '.' || mil.segment5
 FROM apps.mtl_item_locations mil
 WHERE mil.inventory_location_id = mMt.locator_id) loc
 
 FROM --mtl_unit_transactions mut,
 --mtl_serial_numbers msn,
 apps.mtl_material_transactions mmt,
 apps.mtl_transaction_lot_numbers mtln,
 apps.org_organization_definitions ood
 WHERE mmt.transaction_id = mtln.transaction_id
 -- AND mtln.serial_transaction_id = mut.transaction_id
 AND ood.organization_id = mmt.organization_id
 and mmt.ORGANIZATION_ID in (8245) --, 4870, 4869)
 --AND mmt.transaction_date >= sysdate - 10
 -- AND mut.serial_number IN ('<Your Serial Number>')
 and mmt.transaction_source_id = 60745620
 ORDER BY 1 DESC
 ;
 
------
 select distinct poh.requisition_header_id
 from apps.po_requisition_headers_all poh,
 apps.po_requisition_lines_all pol
 where 1 = 1
 AND poh.requisition_header_id = pol.requisition_header_id
 --AND mmt.inventory_item_id = pol.item_id
 --AND mmt.transaction_source_id = poh.requisition_header_id) req_number,
 AND poh.segment1 = '7392371.1'

 //

 SELECT ood.organization_code,
 mmt.transaction_id,
 msn.serial_number,
 mmt.inventory_item_id,
 (SELECT segment1
 FROM apps.mtl_system_items_b
 WHERE inventory_item_id = mmt.inventory_item_id
 AND ROWNUM = 1) item,
 (SELECT transaction_type_name
 FROM apps.mtl_transaction_types mtt
 WHERE mtt.transaction_type_id = mmt.transaction_type_id) transaction_type,
  NULL lot_number,
 (select LICENSE_PLATE_NUMBER
 from apps.wms_license_plate_numbers
 where 1=1 AND LPN_ID = mmt.CONTENT_LPN_ID) LPN,
 mmt.creation_date transaction_creation_date,
 (select distinct poh.segment1
 from apps.po_requisition_headers_all poh,
 apps.po_requisition_lines_all pol
 where 1 = 1
 AND poh.requisition_header_id = pol.requisition_header_id
 AND mmt.inventory_item_id = pol.item_id
 AND mmt.transaction_source_id = poh.requisition_header_id) req_number,
 mMt.TRANSACTION_QUANTITY,
 mMt.TRANSACTION_DATE,
 mMt.SUBINVENTORY_CODE,
  (SELECT mil.segment1 || '.' || mil.segment2 || '.' || mil.segment3 || '.' ||
 mil.segment4 || '.' || mil.segment5
 FROM apps.mtl_item_locations mil
 WHERE mil.inventory_location_id = mMt.locator_id) loc
 
 FROM apps.mtl_unit_transactions mut,
 apps.mtl_serial_numbers msn,
 apps.mtl_material_transactions mmt,
 apps.org_organization_definitions ood
 WHERE msn.serial_number = mut.serial_number
 AND mmt.transaction_id = mut.transaction_id
 AND ood.organization_id = mmt.organization_id
 and mmt.ORGANIZATION_ID in (8245) --, 4870, 4869)
 AND mmt.transaction_date between '19-SEP-24' AND '06-NOV-24'
 -- AND mut.serial_number IN ('<Your Serial Number>')
--and mmt.transaction_source_id = 60745620
AND mmt.transaction_type_id in (61,82)
 
 UNION
 -- For serial controlled and lot controlled items
 SELECT ood.organization_code,
 mmt.transaction_id,
 msn.serial_number,
 mmt.inventory_item_id,
 (SELECT segment1
 FROM apps.mtl_system_items_b
 WHERE inventory_item_id = mmt.inventory_item_id
 AND ROWNUM = 1) item,
 (SELECT transaction_type_name
 FROM apps.mtl_transaction_types mtt
 WHERE mtt.transaction_type_id = mmt.transaction_type_id) transaction_type,
 mtln.lot_number,
 (select LICENSE_PLATE_NUMBER
 from apps.wms_license_plate_numbers
 where 1=1 AND LPN_ID = mmt.CONTENT_LPN_ID) LPN,
 mmt.creation_date transaction_creation_date,
 (select distinct poh.segment1
 from apps.po_requisition_headers_all poh,
 apps.po_requisition_lines_all pol
 where 1 = 1
 AND poh.requisition_header_id = pol.requisition_header_id
 AND mmt.inventory_item_id = pol.item_id
 AND mmt.transaction_source_id = poh.requisition_header_id) req_number,
 mMt.TRANSACTION_QUANTITY,
 mMt.TRANSACTION_DATE,
 mMt.SUBINVENTORY_CODE,
  (SELECT mil.segment1 || '.' || mil.segment2 || '.' || mil.segment3 || '.' ||
 mil.segment4 || '.' || mil.segment5
 FROM apps.mtl_item_locations mil
 WHERE mil.inventory_location_id = mMt.locator_id) loc
 
 FROM apps.mtl_unit_transactions mut,
 apps.mtl_serial_numbers msn,
 apps.mtl_material_transactions mmt,
 apps.mtl_transaction_lot_numbers mtln,
 apps.org_organization_definitions ood
 WHERE msn.serial_number = mut.serial_number
 AND mmt.transaction_id = mtln.transaction_id
 AND mtln.serial_transaction_id = mut.transaction_id
 AND ood.organization_id = mmt.organization_id
 and mmt.ORGANIZATION_ID in (8245) --, 4870, 4869)
 AND mmt.transaction_date between '19-SEP-24' AND '06-NOV-24'
 -- AND mut.serial_number IN ('<Your Serial Number>')
-- and mmt.transaction_source_id = 60745620
AND mmt.transaction_type_id in (61,82)
 
 UNION
 -- For lot controlled items
 SELECT ood.organization_code,
 mmt.transaction_id,
 NULL serial_number,
 mmt.inventory_item_id,
 (SELECT segment1
 FROM apps.mtl_system_items_b
 WHERE inventory_item_id = mmt.inventory_item_id
 AND ROWNUM = 1) item,
 (SELECT transaction_type_name
 FROM apps.mtl_transaction_types mtt
 WHERE mtt.transaction_type_id = mmt.transaction_type_id) transaction_type,
 mtln.lot_number,
 (select LICENSE_PLATE_NUMBER
 from apps.wms_license_plate_numbers
 where 1=1 AND LPN_ID = mmt.CONTENT_LPN_ID) LPN,
 mmt.creation_date transaction_creation_date,
 (select distinct poh.segment1
 from apps.po_requisition_headers_all poh,
 apps.po_requisition_lines_all pol
 where 1 = 1
 AND poh.requisition_header_id = pol.requisition_header_id
 AND mmt.inventory_item_id = pol.item_id
 AND mmt.transaction_source_id = poh.requisition_header_id) req_number,
 mMt.TRANSACTION_QUANTITY,
 mMt.TRANSACTION_DATE,
 mMt.SUBINVENTORY_CODE,
  (SELECT mil.segment1 || '.' || mil.segment2 || '.' || mil.segment3 || '.' ||
 mil.segment4 || '.' || mil.segment5
 FROM apps.mtl_item_locations mil
 WHERE mil.inventory_location_id = mMt.locator_id) loc
 
 FROM --mtl_unit_transactions mut,
 --mtl_serial_numbers msn,
 apps.mtl_material_transactions mmt,
 apps.mtl_transaction_lot_numbers mtln,
 apps.org_organization_definitions ood
 WHERE mmt.transaction_id = mtln.transaction_id
 -- AND mtln.serial_transaction_id = mut.transaction_id
 AND ood.organization_id = mmt.organization_id
 and mmt.ORGANIZATION_ID in (8245) --, 4870, 4869)
 AND mmt.transaction_date between '19-SEP-24' AND '06-NOV-24'
 -- AND mut.serial_number IN ('<Your Serial Number>')
-- and mmt.transaction_source_id = 60745620
AND mmt.transaction_type_id in (61,82)
 ORDER BY 1 DESC
 ;