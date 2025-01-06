select ood.organization_code "Org.", ood.organization_name "Operating Unit", ood.operating_unit "Operation unit code", 
decode (ood.operating_unit, 13,   'EQP', 
                            1030, 'EQP', 
                            3171, 'EQP / SVC',
                            3371, 'EQP / SVC',
                            6132, 'EQP / SVC',
                            729,  'EQP / SVC') "Invoice Type"
from apps.org_organization_definitions ood
where ood.operating_unit in (13,1030,3171,3371,6132,729,3171,3371,6132,729)
order by ood.operating_unit, ood.organization_code
;