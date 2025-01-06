select msi.creation_date,
       ood.organization_code,
       msi.organization_id,
       msi.inventory_item_id,
       msi.segment1,
       msi.item_type,
       msi.inventory_asset_flag,
       msi.costing_enabled_flag,
       msi.inventory_item_flag,
       msi.mtl_transactions_enabled_flag,
       msi.stock_enabled_flag,
       msi.eng_item_flag,
       msi.inventory_item_status_code
       ,(select max(transaction_date) 
           from apps.mtl_material_transactions mmt
          where mmt.inventory_item_id = msi.inventory_item_id
            and mmt.organization_id = msi.organization_id) last_transaction_date
       ,(select nvl(SUM(moqd.primary_transaction_quantity), 0)
          FROM apps.mtl_onhand_quantities_detail moqd
         where moqd.inventory_item_id = msi.inventory_item_id
           and moqd.organization_id = msi.organization_id) qtd_onhand
from apps.mtl_system_items_b msi
   , apps.org_organization_definitions ood
where nvl(msi.inventory_asset_flag, 'N') = 'N'
AND nvl(msi.costing_enabled_flag, 'N') = 'N'
--and trunc(msi.creation_date) > trunc(to_date('01-NOV-2017','DD/MM/RRRR'))
--and msi.inventory_item_flag = 'Y'
--and msi.mtl_transactions_enabled_flag = 'Y'
--and msi.stock_enabled_flag = 'Y'
--and msi.eng_item_flag = 'N'
and msi.organization_id = ood.organization_id
and ood.organization_id in (10367,4870)

UNION
select msi.creation_date,
       ood.organization_code,
       msi.organization_id,
       msi.inventory_item_id,
       msi.segment1,
       msi.item_type,
       msi.inventory_asset_flag,
       msi.costing_enabled_flag,
       msi.inventory_item_flag,
       msi.mtl_transactions_enabled_flag,
       msi.stock_enabled_flag,
       msi.eng_item_flag,
       msi.inventory_item_status_code
       ,(select max(transaction_date) 
           from apps.mtl_material_transactions mmt
          where mmt.inventory_item_id = msi.inventory_item_id
            and mmt.organization_id = msi.organization_id) last_transaction_date
       ,(select nvl(SUM(moqd.primary_transaction_quantity), 0)
          FROM apps.mtl_onhand_quantities_detail moqd
         where moqd.inventory_item_id = msi.inventory_item_id
           and moqd.organization_id = msi.organization_id) qtd_onhand
from apps.mtl_system_items_b msi
   , apps.org_organization_definitions ood
where nvl(msi.inventory_asset_flag, 'N') = 'N'
AND nvl(msi.costing_enabled_flag, 'N') = 'N'
 
and exists (select 1 from apps.mtl_material_transactions mmt 
             where mmt.inventory_item_id = msi.inventory_item_id 
               and mmt.organization_id = msi.organization_id
               and mmt.transaction_date > trunc(to_date('01-JAN-2017','DD/MM/RRRR')))
 
and msi.inventory_item_flag = 'Y'
and msi.mtl_transactions_enabled_flag = 'Y'
and msi.stock_enabled_flag = 'Y'
and msi.eng_item_flag = 'N'
and msi.organization_id = ood.organization_id
and ood.organization_id in (10367,4870)

order by 1 desc,
         2,
         5
;