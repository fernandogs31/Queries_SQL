select
ol.line_id,
GEMS_INV.GE_GPO_BR_NAT_PKG.NATIONALIZATION_PROCESS_CHECK('ORDER_LINE_ID',ol.line_id) AS "NAT STATUS"
from
apps.oe_order_lines_all
where line_id in ()---ENTER RETURN REFERENCE HERE;
