SELECT *
  FROM (SELECT wdth.transaction_temp_id,
               wdth.task_id,
               oeh.order_number,
               oel.line_number,
               msi.concatenated_segments item_number,
               'Pick',
               'Completed',
               fu1.user_name             assigned_to,
               wdth.person_id,
               mmtt.transaction_quantity,
               mmtt.transaction_uom
          FROM apps.oe_order_headers_all         oeh,
               apps.wms_dispatched_tasks_history wdth,
               apps.mtl_material_transactions    mmtt,
               apps.oe_order_lines_all           oel,
               apps.fnd_user                     fu1,
               apps.mtl_system_items_kfv         msi --,
         WHERE msi.organization_id = mmtt.organization_id
           AND msi.inventory_item_id = wdth.inventory_item_id
           AND oel.line_id = mmtt.trx_source_line_id
           AND mmtt.transaction_source_type_id = wdth.transaction_source_type_id
           AND mmtt.transaction_type_id = wdth.transaction_type_id
           AND mmtt.subinventory_code = wdth.dest_subinventory_code
           AND mmtt.move_order_line_id = wdth.move_order_line_id
           AND oeh.header_id = oel.header_id
           AND fu1.employee_id(+) = wdth.person_id
           AND wdth.transaction_id = mmtt.transaction_batch_id
        --   AND oeh.order_number = 3531000428
        UNION
        SELECT mmtt.transaction_temp_id,
               wdt.task_id,
               oeh.order_number,
               oel.line_number,
               msi.concatenated_segments item_number,
               decode(mmtt.wms_task_type,
                      1,
                      'Pick',
                      2,
                      'Putaway',
                      3,
                      'Cycle Count',
                      4,
                      'Replenish',
                      5,
                      'Move Order Transfer',
                      6,
                      'Move Order Issue',
                      7,
                      'Staging Move',
                      8,
                      'Inspection') task_type,
               flv.meaning task_status,
               fu1.user_name assigned_to,
               wdt.person_id,
               mmtt.transaction_quantity,
               mmtt.transaction_uom
          FROM apps.oe_order_headers_all           oeh,
               apps.mtl_material_transactions_temp mmtt,
               apps.wms_dispatched_tasks           wdt,
               apps.oe_order_lines_all             oel,
               apps.fnd_lookup_values              flv,
               apps.fnd_user                       fu1,
               apps.mtl_system_items_kfv           msi
         WHERE msi.organization_id = mmtt.organization_id
           AND msi.inventory_item_id = mmtt.inventory_item_id
           AND oel.line_id = mmtt.trx_source_line_id
           AND flv.lookup_type = 'WMS_TASK_STATUS'
           AND flv.lookup_code = nvl(wdt.status,
                                     nvl(mmtt.wms_task_status,
                                         1))
           AND flv.language = 'US'
           AND mmtt.transaction_source_type_id = 2
           AND wdt.transaction_temp_id(+) = mmtt.transaction_temp_id
           AND oeh.header_id = oel.header_id
           AND fu1.employee_id(+) = wdt.person_id)
 --WHERE order_number = :p_order_number
 ORDER BY order_number;

 select * from apps.wms_dispatched_tasks_history
 where 1=1
 and organization_id = 4330
 ;

SELECT *
  FROM (SELECT wdth.transaction_temp_id,
               wdth.task_id, wdth.organization_id,
               oeh.order_number,
               oel.line_number,
               msi.concatenated_segments item_number,
               'Pick',
               'Completed',
               fu1.user_name             assigned_to,
               wdth.person_id,
               mmtt.transaction_quantity,
               mmtt.transaction_uom
          FROM apps.oe_order_headers_all         oeh,
               apps.wms_dispatched_tasks_history wdth,
               apps.mtl_material_transactions    mmtt,
               apps.oe_order_lines_all           oel,
               apps.fnd_user                     fu1,
               apps.mtl_system_items_kfv         msi --,
         WHERE msi.organization_id = mmtt.organization_id
           AND msi.inventory_item_id = wdth.inventory_item_id
           AND oel.line_id = mmtt.trx_source_line_id
           AND mmtt.transaction_source_type_id = wdth.transaction_source_type_id
           AND mmtt.transaction_type_id = wdth.transaction_type_id
           AND mmtt.subinventory_code = wdth.dest_subinventory_code
           AND mmtt.move_order_line_id = wdth.move_order_line_id
           AND oeh.header_id = oel.header_id
           AND fu1.employee_id(+) = wdth.person_id
           AND wdth.transaction_id = mmtt.transaction_batch_id
        --   AND oeh.order_number = 3531000428
        UNION
        SELECT mmtt.transaction_temp_id,
               wdt.task_id, wdt.organization_id,
               oeh.order_number,
               oel.line_number,
               msi.concatenated_segments item_number,
               decode(mmtt.wms_task_type,
                      1,
                      'Pick',
                      2,
                      'Putaway',
                      3,
                      'Cycle Count',
                      4,
                      'Replenish',
                      5,
                      'Move Order Transfer',
                      6,
                      'Move Order Issue',
                      7,
                      'Staging Move',
                      8,
                      'Inspection') task_type,
               flv.meaning task_status,
               fu1.user_name assigned_to,
               wdt.person_id,
               mmtt.transaction_quantity,
               mmtt.transaction_uom
          FROM apps.oe_order_headers_all           oeh,
               apps.mtl_material_transactions_temp mmtt,
               apps.wms_dispatched_tasks           wdt,
               apps.oe_order_lines_all             oel,
               apps.fnd_lookup_values              flv,
               apps.fnd_user                       fu1,
               apps.mtl_system_items_kfv           msi
         WHERE msi.organization_id = mmtt.organization_id
           AND msi.inventory_item_id = mmtt.inventory_item_id
           AND oel.line_id = mmtt.trx_source_line_id
           AND flv.lookup_type = 'WMS_TASK_STATUS'
           AND flv.lookup_code = nvl(wdt.status,
                                     nvl(mmtt.wms_task_status,
                                         1))
           AND flv.language = 'US'
           AND mmtt.transaction_source_type_id = 2
           AND wdt.transaction_temp_id(+) = mmtt.transaction_temp_id
           AND oeh.header_id = oel.header_id
           AND fu1.employee_id(+) = wdt.person_id)
 WHERE organization_id = 4330 --:p_order_number
 
 ORDER BY order_number;
 