-- Query LPN unload

select * from apps.wms_op_plan_instances
where source_task_id in (
select parent_line_id from apps.mtl_material_transactions_temp
where  lpn_id = 58598531
or transfer_lpn_id = 58598531
or content_lpn_id = 58598531
union
select transaction_temp_id from apps.mtl_material_transactions_temp
where  lpn_id = 58598531
or transfer_lpn_id = 58598531
or content_lpn_id = 58598531); --delete
//
select * from apps.wms_op_operation_instances
where source_task_id in (
select transaction_temp_id from apps.mtl_material_transactions_temp
where  lpn_id = 58598531 or transfer_lpn_id = 58598531
or content_lpn_id = 58598531
union
select parent_line_id from apps.mtl_material_transactions_temp
where  lpn_id = 58598531
or transfer_lpn_id = 58598531
or content_lpn_id = 58598531); --delete
//
select * from apps.wms_dispatched_tasks where 
transaction_temp_id in (select transaction_temp_id from apps.mtl_material_transactions_temp
where lpn_id = 58598531
or transfer_lpn_id = 58598531
or content_lpn_id = 58598531
union
select parent_line_id from apps.mtl_material_transactions_temp
where  lpn_id = 58598531
or transfer_lpn_id = 58598531
or content_lpn_id = 58598531); --delete
//
select * from apps.mtl_transaction_lots_temp
where transaction_temp_id in (select transaction_temp_id from
apps.mtl_material_transactions_temp where lpn_id = 58598531
or transfer_lpn_id = 58598531
or content_lpn_id = 58598531); --delete
//
select * from  apps.mtl_material_transactions_temp
where transaction_temp_id in 
(select parent_line_id from apps.mtl_material_transactions_temp
where lpn_id = 58598531 or transfer_lpn_id = 58598531
or content_lpn_id = 58598531); --delete
//
select * 
from apps.mtl_material_transactions_temp
where lpn_id = 58598531
or transfer_lpn_id = 58598531
or content_lpn_id = 58598531; -- delete
//
select * 
from apps.mtl_transaction_lots_interface
where lot_number in (select lot_number
from apps.wms_lpn_contents where parent_lpn_id = 58598531);
//
select * 
from apps.rcv_lots_interface
where interface_transaction_id in (select interface_transaction_id
from apps.rcv_transactions_interface
where lpn_id = 58598531
or transfer_lpn_id = 58598531);
//
select * 
from apps.rcv_transactions_interface
where lpn_id = 58598531 
or transfer_lpn_id = 58598531;
//
select quantity_detailed --null
      ,wms_process_flag -- 1
from apps.mtl_txn_request_lines
WHERE lpn_id = 58598531
and line_status=7;
//
select source_header_id --null
  , source_name --null
from apps.wms_lpn_contents
where parent_lpn_id = 58598531;

//
SELECT  license_plate_number, lpn_id FROM apps.WMS_LICENSE_PLATE_NUMBERS WHERE license_plate_number = 'U52-15';