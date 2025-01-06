SELECT hou.NAME operating_unit_name,
hou.organization_id operating_unit_id, 
hou.set_of_books_id,
--hou.business_group_id,
ood.organization_name inventory_organization_name,
ood.organization_code Inv_organization_code,
ood.organization_id Inv_organization_id, 
ood.chart_of_accounts_id
--hla.description,
--hla.country


FROM apps.hr_operating_units hou, 
apps.org_organization_definitions ood
--apps.hr_locations_all hla,
--apps.xle_registrations xr

WHERE 1 = 1 
AND hou.organization_id = ood.operating_unit
--AND hla.location_id = xr.location_id
AND ood.organization_name like 'GEMSAM%'
--AND hla.town_or_city like '%SANTO%'
ORDER BY hou.organization_id ASC
;