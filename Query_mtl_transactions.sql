SELECT 
    mmt.transaction_id,
    mmt.transaction_date,
    mmt.organization_id,
    mmt.inventory_item_id,
    mmt.transaction_quantity,
    mmt.transaction_type_id,
    mmt.transaction_reference,
    mmt.source_code,
    mmt.source_line_id,
    mtl.lot_number,
    msn.serial_number,
    msi.segment1 AS part_number
FROM 
    apps.mtl_material_transactions mmt
LEFT JOIN 
    apps.mtl_transaction_lot_numbers mtl ON mmt.transaction_id = mtl.transaction_id
LEFT JOIN 
    apps.mtl_unit_transactions msn ON mmt.transaction_id = msn.transaction_id
LEFT JOIN 
    apps.mtl_system_items_b msi ON mmt.inventory_item_id = msi.inventory_item_id
WHERE 
    msi.organization_id = mmt.organization_id
AND mmt.transaction_date > '01-JAN-20'
AND msi.segment1 = 'H40462LM'
AND mmt.subinventory_code = 'FG-TMP DEM'
AND mmt.organization_id = 7382
AND mtl.lot_number = '263365'

order by 2 asc;