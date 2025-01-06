select ood.organization_code,
       ood.organization_name,
       kfv.concatenated_segments,
       kfv.description,
       lot.lot_number,
 trunc(lot.expiration_date),
 trunc(lot.origination_date),
(trunc(lot.expiration_date) -  trunc(sysdate)) days_to_expire
from apps.mtl_lot_numbers lot,
apps.mtl_system_items_kfv kfv,
apps.mtl_onhand_quantities_detail moqd,
apps.org_organization_definitions ood
where lot.inventory_item_id=kfv.inventory_item_id
and lot.organization_id=kfv.organization_id
and lot.inventory_item_id=moqd.inventory_item_id
and lot.organization_id=moqd.organization_id
and lot.lot_number =moqd.lot_number
and ood.organization_id = moqd.organization_id
--and kfv.concatenated_segments like '3%'----------Item segments
--and (trunc(lot.expiration_date) -  trunc(sysdate)) >= nvl(:p_more_days, (trunc(lot.expiration_date) -  trunc(sysdate)))
--and (trunc(lot.expiration_date) -  trunc(sysdate)) <= nvl(:p_less_days, (trunc(lot.expiration_date) -  trunc(sysdate)))
and ood.organization_code = 'U42'
order by ood.organization_code,(trunc(lot.expiration_date) -  trunc(sysdate))