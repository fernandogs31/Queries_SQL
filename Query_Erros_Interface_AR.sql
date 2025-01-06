select distinct *
from apps.RA_INTERFACE_ERRORS_ALL iea,
apps.RA_INTERFACE_LINES_ALL aila
--apps.RA_INTERFACE_DISTRIBUTIONS_ALL ida
where aila.interface_line_attribute1 = '30002683'
and iea.interface_line_id = aila.interface_line_id
--and aila.interface_line_id = ida.interface_line_id

// 

select *
from apps.RA_INTERFACE_DISTRIBUTIONS_ALL
where interface_line_id = 1070366392