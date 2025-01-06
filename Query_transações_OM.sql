SELECT *
FROM  apps.oe_order_lines_all oola
WHERE  --oola.shipping_method_code like '%CPU%'
oola.header_id = 136302183

//

select *
from APPS.OE_ORDER_HEADERS_ALL ooha
--apps.oe_order_lines_all oola
where ooha.order_number = 1000013776
--ooha.ordered_date between '01-jan-22' and '15-apr-24'
--and ooha.shipping_method_code like '%_CPU'
--group by ooha.order_number