select wlpn.* 
from  apps.wms_license_plate_numbers wlpn
     ,apps.mtl_parameters           ood
where wlpn.LPN_CONTEXT IN (4,5) 
AND wlpn.ORGANIZATION_ID = ood.organization_id
AND ood.organization_code = 'U51';