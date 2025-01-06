select  distinct  
 ooha.order_number Sales_order
, tt.NAME Order_type
, oola.ORDERED_ITEM PN
, oola.REQUEST_DATE
, oola.ORDERED_QUANTITY
, oola.UNIT_SELLING_PRICE valor_unit_Ordem
, oola.UNIT_LIST_PRICE_PER_PQTY Preco_Lista_PAC
, oola.FLOW_STATUS_CODE status
, (select ORGANIZATION_CODE from apps.org_organization_definitions where ORGANIZATION_ID = oola.SHIP_FROM_ORG_ID) ORG_CODE
,RCTA.TRX_NUMBER
,RCTA.TRX_DATE
,RCTA.INTERFACE_HEADER_ATTRIBUTE1
,RCTA.INTERFACE_HEADER_ATTRIBUTE2
,rctla.DESCRIPTION
,rctla.UNIT_STANDARD_PRICE
,rctla.UNIT_SELLING_PRICE
,rctla.SALES_ORDER
,rctla.INTERFACE_LINE_ATTRIBUTE2
,rctla.LINE_TYPE
,rctla.EXTENDED_AMOUNT
 
FROM
    apps.oe_order_lines_all oola,
    apps.oe_order_headers_all ooha,
    apps.oe_transaction_types_tl tt,
    apps.ra_customer_trx_all rcta,
    apps.ra_customer_trx_lines_all  rctla
 
 
WHERE 1=1
And ooha.header_id = oola.header_id
AND ooha.org_id = oola.org_id
And ooha.org_id = 4330
And ooha.ORDER_TYPE_ID = tt.TRANSACTION_TYPE_ID
AND ooha.org_id = rcta.org_id
AND oola.ship_from_org_id = rctla.warehouse_id
AND oola.inventory_item_id = rctla.inventory_item_id
AND to_char(ooha.order_number) = rcta.interface_header_attribute1
AND rctla.customer_trx_id = rcta.customer_trx_id
AND rctla.line_type = 'LINE'
And ooha.creation_date BETWEEN '01-JAN-2024' AND '22-NOV-2024'
And oola.FLOW_STATUS_CODE not in ('CANCELLED','AWAITING_RETURN','AWAITING_RETURN_DISPOSITION')
--And tt.NAME = 'GPO_BR_RM_CONTRATO_C/ICMS_EC87';
--And oola.ordered_item in ('5167237-2','2351573-H','2160200-43-H')
;