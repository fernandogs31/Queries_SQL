select
a.* from







(select mp.organization_code           ORG_CODE,
       msib.segment1                  ITEM_NUMBER,
       msib.description               ITEM_DESCRIPTION,
       msib.item_type                 ITEM_TYPE,
       moqd.subinventory_code         SUBINVENTORY,
       mil.segment1||'.'||mil.segment2||'.'||mil.segment3||'.'||mil.segment4||'.'||mil.segment5 LOCATOR,
       moqd.transaction_quantity      QUANTITY,
       moqd.transaction_uom_code      UOM,
       mut.serial_number              SERIAL_NUMBER,
       moqd.lot_number                LOT_NUMBER,
       mln.expiration_date            LOT_EXPIRATION_DATE,
       wlpn.license_plate_number      LPN,
       msib.inventory_item_id,
       (select Decode(mcb.Segment2,NULL,mcb.Segment1,mcb.Segment1||'.'||mcb.Segment2) Category_Name



from apps.MTL_ITEM_CATEGORIES mic
     ,apps.mtl_system_items_b msi
     ,INV.MTL_CATEGORY_SETS_TL mcs
     ,INV.MTL_CATEGORIES_B mcb
where 1=1
and msi.segment1 =msib.segment1
and msi.organization_id in ('1755')
and msi.organization_id = mic.organization_id
and msi.inventory_item_id = mic.inventory_item_id
and mcs.category_set_id=mic.category_set_id
--and mic.category_set_id = 1100000505
and mic.category_id = 40591
AND mic.category_id = mcb.category_id) binbulk
from apps.mtl_onhand_quantities_detail moqd,
     apps.mtl_parameters               mp,
     apps.mtl_system_items_b           msib,
     apps.mtl_item_locations      mil,
     apps.wms_license_plate_numbers    wlpn,
     apps.mtl_unit_transactions        mut,
     --apps.MTL_ONHAND_SERIAL_MWB_V mut,
     apps.mtl_lot_numbers              mln
where moqd.organization_id = mp.organization_id
and   msib.organization_id = moqd.organization_id
and   msib.inventory_item_id = moqd.inventory_item_id
and   mil.inventory_location_id = moqd.locator_id
and   wlpn.lpn_id(+) = moqd.lpn_id
and   mut.transaction_id (+) = moqd.create_transaction_id
and   mln.inventory_item_id (+) = moqd.inventory_item_id
and   mln.organization_id (+) = moqd.organization_id
and   mln.lot_number (+) = moqd.lot_number
--and   msib.segment1='1407-3320-000'--'5700000-37'--'5392737'--'6600-1249-500'--'5922000-R'--'1407-3902-000'
--and   moqd.subinventory_code like '%GD'
and   mp.organization_code in ('U00','U41','U42','U51','U52','SBZ') -- Put the correct Organization Code
order by mp.organization_code, msib.segment1,moqd.subinventory_code, mil.segment1||'.'||mil.segment2||'.'||mil.segment3||'.'||mil.segment4||'.'||mil.segment5
) a
where
1=1