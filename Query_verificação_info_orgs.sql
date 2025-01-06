select ool.ship_from_org_id,ood.organization_code
from apps.oe_order_lines_all          ool,
apps.org_organization_definitions  ood
where ool.ship_from_org_id = ood.organization_id
and ool.creation_date >= '01-APR-24'
--and ood.organization_code in ('U00','U51','U52')
group by ood.organization_code,ool.ship_from_org_id
