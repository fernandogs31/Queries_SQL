select *
from apps.cll_f255_notifications
where 
--parameter_value1 = '8921653539'
creation_date >= '30-aug-24'
--and event_name = 'oracle.apps.cll.mtl_material_transactions'
--parameter_value2 = '10306'
--and notification_id = '41499441'
order by creation_date desc
;