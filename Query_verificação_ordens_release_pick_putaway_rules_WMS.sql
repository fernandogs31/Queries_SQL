/*
## Picking Tasks Details
## Bishnu Choudhury - 15-OCT-2013
*/
select distinct
       mmtt.transaction_temp_id pick_task_id
       ,ooh.org_id,ool.line_id,ooh.order_number
       ,(ool.line_number||'.'||ool.shipment_number) line
       ,ool.flow_status_code ln_status
       ,oos.name
       ,(select name from apps.oe_transaction_types_tl where transaction_type_id = ooh.order_type_id) order_type
       ,ool.ship_to_org_id
       ,ool.ordered_item
       ,mmtt.transaction_quantity trnx_qty
       ,ool.ORDERED_QUANTITY ord_qty
       ,mmtt.move_order_line_id mo_line_id
       ,mtrh.request_number mo,mtrl.line_number mo_line
       ,(select distinct delivery_id from apps.WSH_DELIVERY_ASSIGNMENTS where delivery_detail_id in (select distinct delivery_detail_id from apps.wsh_delivery_details where move_order_line_id = mmtt.move_order_line_id) and rownum =1) delivery
       ,ood.organization_code org
       , ood.organization_id
       ,mmtt.subinventory_code from_sub
       ,(select picking_order from apps.mtl_secondary_inventories where secondary_inventory_name = mmtt.subinventory_code and organization_id = mmtt.organization_id) subinv_pck_ord
       ,(SELECT mil.segment1 || '.' || mil.segment2 || '.' || mil.segment3 || '.' ||mil.segment4 || '.' || mil.segment5 FROM apps.mtl_item_locations mil WHERE mil.inventory_location_id = mmtt.locator_id) loc
       ,(SELECT mil.picking_order FROM apps.mtl_item_locations mil WHERE mil.inventory_location_id = mmtt.locator_id) loc_pick_ord
       ,mmtt.lot_number
       ,mmtt.serial_number
       ,mmtt.transfer_subinventory to_sub
       ,(SELECT mil.segment1 || '.' || mil.segment2 || '.' || mil.segment3 || '.' ||mil.segment4 || '.' || mil.segment5 FROM apps.mtl_item_locations mil WHERE mil.inventory_location_id = mmtt.transfer_to_location) to_loc
       ,(SELECT  license_plate_number FROM apps.WMS_LICENSE_PLATE_NUMBERS WHERE lpn_id = mmtt.lpn_id) lpn
       ,(SELECT  license_plate_number FROM apps.WMS_LICENSE_PLATE_NUMBERS WHERE lpn_id = mmtt.transfer_lpn_id) transfer_lpn
       ,mmtt.transfer_lpn_id
       ,(select meaning from apps.mfg_lookups where lookup_type = 'WMS_LPN_CONTEXT' and lookup_code = (SELECT  lpn_context FROM apps.WMS_LICENSE_PLATE_NUMBERS WHERE lpn_id = mmtt.lpn_id)) lpn_context
       ,(select meaning from apps.mfg_lookups where lookup_type = 'WMS_LPN_CONTEXT' and lookup_code = (SELECT  lpn_context FROM apps.WMS_LICENSE_PLATE_NUMBERS WHERE lpn_id = mmtt.transfer_lpn_id)) xfer_lpn_context
       ,(select meaning from apps.mfg_lookups where lookup_code = mmtt.wms_task_type and lookup_type = 'WMS_TASK_TYPES') wms_task_type
--       ,(SELECT picking_rule_name FROM apps.WSH_PICKING_RULES_V WHERE picking_rule_id = mmtt.pick_rule_id) pick_rule
       ,(select transaction_source_type_name from apps.MTL_TXN_SOURCE_TYPES where transaction_source_type_id = mmtt.transaction_source_type_id) transaction_source_type
       ,(SELECT transaction_type_name FROM apps.mtl_transaction_types WHERE transaction_type_id = mmtt.transaction_type_id) transaction_type
       ,(SELECT meaning FROM apps.mfg_lookups WHERE lookup_type = 'MTL_TRANSACTION_ACTION' AND lookup_code = mmtt.transaction_action_id) transaction_action
       ,mmtt.posting_flag,mmtt.process_flag
       , ( SELECT P.NAME
          FROM APPS.FND_CONCURRENT_REQUESTS R,
               APPS.WSH_PICKING_BATCHES     PB,
               APPS.WSH_PICKING_RULES       P
         WHERE R.REQUEST_ID = PB.REQUEST_ID
           AND R.CONCURRENT_PROGRAM_ID = 1003890
           AND PB.NAME = mtrh.REQUEST_NUMBER
           AND R.ARGUMENT1 = TO_CHAR(P.PICKING_RULE_ID) ) Release_rule
       ,(SELECT NAME FROM apps.WMS_STRATEGIES_TL WHERE strategy_id = mmtt.put_away_strategy_id) putaway_stratergy
       ,(SELECT NAME FROM apps.WMS_RULES_TL WHERE rule_id = mmtt.put_away_rule_id) putaway_rule
       ,(SELECT NAME FROM apps.WMS_STRATEGIES_TL WHERE strategy_id = mmtt.pick_strategy_id) pick_stratergy
       ,(SELECT NAME FROM apps.WMS_RULES_TL WHERE rule_id = mmtt.pick_rule_id) pick_rule
       ,(SELECT operation_plan_name FROM apps.WMS_OP_PLANS_VL WHERE operation_plan_id = mmtt.operation_plan_id) op_plan
       ,(select name from APPS.WMS_RULES_V where organization_id = mmtt.organization_id and type_code = 7 and type_hdr_id = mmtt.operation_plan_id and rownum = 1) wms_ope_rule
       ,decode(nvl(mmtt.transaction_status,0),2,'Save Only',3,'Ready to Process','Default') trnxn_status
       ,(select meaning from apps.mfg_lookups where lookup_type = 'WMS_TASK_STATUS' and lookup_code = mmtt.wms_task_status) wms_task_status
       ,mmtt.task_priority
       ,(select mc.segment1||'.'||mc.segment2
        from apps.mtl_system_items_b msi,
             apps.MTL_ITEM_CATEGORIES mic,
             apps.org_organization_definitions  ood1,
             apps.MTL_CATEGORY_SETS          mcs,
             apps.MTL_CATEGORIES             mc
        where mic.inventory_item_id = msi.inventory_item_id
        and   mic.organization_id = msi.organization_id
        and   msi.organization_id = ood1.organization_id
        and   mcs.category_set_id = mic.category_set_id
        and   mc.category_id = mic.category_id
        and   mcs.category_set_name = 'GE_GPO_ITEM_STOCK_REGION'
        and   ood1.organization_id = 1755--ool.ship_from_org_id
        and   msi.inventory_item_id = msib.inventory_item_id) gpo_stk_cat
       ,(select hazard_class from apps.PO_HAZARD_CLASSES_TL where hazard_class_id = msib.hazard_class_id) hazard_class
       ,(select un_number from apps.PO_UN_NUMBERS_TL where un_number_id = msib.un_number_id) un_number
       ,decode(nvl(msib.SERIAL_NUMBER_CONTROL_CODE,1),1,'NO','YES') SERIAL_FLAG
       ,decode(nvl(msib.LOT_CONTROL_CODE,1),1,'NO','YES') LOT_FLAG
       ,mmtt.last_update_date
       ,(select user_name||' : '||description from apps.fnd_user where user_id = mmtt.last_updated_by) updated_by
       ,wdd.batch_id pick_batch
      ,mmtt.allocated_lpn_id
from apps.MTL_MATERIAL_TRANSACTIONS_TEMP mmtt
    ,apps.oe_order_headers_all           ooh
    ,apps.oe_order_lines_all             ool
    ,apps.mtl_parameters                 ood
    ,apps.oe_order_sources                oos
    ,apps.MTL_TXN_REQUEST_HEADERS         mtrh
    ,apps.MTL_TXN_REQUEST_lines           mtrl
    ,apps.mtl_system_items_b              msib
    ,apps.wsh_delivery_details            wdd

where mmtt.trx_source_line_id = ool.line_id (+)
AND ool.header_id = ooh.header_id(+)
AND ood.organization_id = mmtt.organization_id
and ood.organization_code in ('U52','U51')--in ('U00')
and oos.order_source_id = ooh.order_source_id
and mtrl.header_id = mtrh.header_id
and mtrl.line_id = mmtt.move_order_line_id
and msib.segment1 = ool.ordered_item
and msib.organization_id = ool.ship_from_org_id
and wdd.move_order_line_id = mmtt.move_order_line_id
and wdd.source_code = 'OE'
AND ooh.order_number in ('70235641')
--AND msib.segment1 = '46-303456P1'
ORDER BY 1