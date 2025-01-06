SELECT
    wdd.source_header_number                          order_number,
    mtrh.request_number                               move_order_number,
    wnd.global_attribute14                            actual_delivery_date,
    mtrh.creation_date                                move_order_date,
    wdd.creation_date,
    wdd.source_header_type_name                       order_type,
    hp.party_name                                     bill_to_customer,
    hps.party_site_number                             ship_to_loc_num,
    hps.party_site_name                               ship_to_loc_name,
    oel.ordered_item,
    msi.description,
    oel.order_quantity_uom,
    wdd.src_requested_quantity                        ordered_quantity,
    wdd.shipped_quantity,
    CASE
        WHEN oel.source_document_id IS NULL THEN  wdd.cancelled_quantity
        ELSE NULL END                                               AS cancelled_quantity,
    oel.unit_selling_price                            unit_selling_price,
    ( oel.ordered_quantity * oel.unit_selling_price ) extended_price,
    oeh.ordered_date,
    ood.organization_code,
    CASE
        WHEN ( wdd.src_requested_quantity - wdd.shipped_quantity ) = 0 THEN
            'CLOSED'
        WHEN wdd.shipped_quantity IS NULL THEN
            'AWAITING SHIPPING'
        WHEN wdd.shipped_quantity > 0
             AND wdd.shipped_quantity < wdd.src_requested_quantity THEN
            'PARTIALLY SHIPED'
    END                                               AS order_status,
    rct.trx_number,
    rct.trx_date,
    rct.status_trx,
    decode (wdd.released_status,
'D', 'Cancelled',
'C', 'Shipped',
'R', 'Ready to Release',
'N', 'Not Ready to Release',
'S', 'Released to Warehouse',
'Y', 'Staged/Pick Confirmed',
'X', 'Not Applicable'
) released_status_name,
/*ROUND (DECODE ((oel.ordered_quantity - wdd.shipped_quantity),0, 
NULL, TRUNC (SYSDATE) - mtrh.creation_date),0
) pending_since,*/
wdd.released_status, NULL, NULL

FROM apps.wsh_delivery_details wdd,
apps.wsh_delivery_assignments wda,
apps.wsh_new_deliveries wnd,
apps.oe_order_headers_all oeh,
apps.oe_order_lines_all oel,
apps.hz_parties hp,
apps.hz_cust_accounts hca,
apps.hz_party_sites hps,
apps.mtl_system_items_b msi,
apps.ra_customer_trx_lines_all rctl,
apps.ra_customer_trx_all rct,
apps.org_organization_definitions ood,
apps.mtl_txn_request_lines mtrl,
apps.mtl_txn_request_headers mtrh

WHERE wda.delivery_detail_id = wdd.delivery_detail_id
AND wda.delivery_id = wnd.delivery_id(+)
AND NVL(wdd.line_direction, 'O') IN ('O','IO')
AND NVL (wda.TYPE, 'S') IN ('S', 'C')
AND wdd.source_header_id = oeh.header_id
AND wdd.source_line_id = oel.line_id
AND oeh.header_id = oel.header_id
AND hp.party_id = hca.party_id
AND oeh.sold_to_org_id = hca.cust_account_id
AND hps.location_id(+) = oel.ship_to_org_id
AND msi.inventory_item_id = oel.inventory_item_id
AND msi.organization_id = oel.ship_from_org_id
/* following join to get those order whose invoices are not created */
AND rctl.interface_line_attribute6(+)=oel.line_id
AND rct.customer_trx_id(+) = rctl.customer_trx_id
AND rctl.interface_line_attribute1 = TO_CHAR (oeh.order_number)
AND wdd.move_order_line_id = mtrl.line_id
AND oel.ship_from_org_id = ood.organization_id
AND mtrh.header_id = mtrl.header_id
AND wdd.move_order_line_id = mtrl.line_id
--and wdd.source_header_number=112104873–112909588–112400057
AND TO_DATE (oeh.ordered_date) BETWEEN NVL (:f_date, oeh.ordered_date)
AND NVL (:t_date, oeh.ordered_date)
AND hp.country = 'DO'

union
SELECT wdd.source_header_number order_number,
mtrh.request_number move_order_number,
wnd.global_attribute14 actual_delivery_date, 
mtrh.creation_date move_order_date,
wdd.creation_date, 
wdd.source_header_type_name order_type,
hp.party_name bill_to_customer, 
hps.party_site_number ship_to_loc_num,
hps.party_site_name ship_to_loc_name, 
oel.ordered_item,
msi.description, oel.order_quantity_uom,
wdd.src_requested_quantity ordered_quantity, 
wdd.shipped_quantity,
CASE when oel.SOURCE_DOCUMENT_ID is null then
wdd.cancelled_quantity
else
null
end as cancelled_quantity
, oel.unit_selling_price unit_selling_price,
(oel.ordered_quantity * oel.unit_selling_price) extended_price,
oeh.ordered_date, ood.organization_code,
CASE
WHEN (wdd.src_requested_quantity - wdd.shipped_quantity) =
0 AND wdd.released_status <> 'D'
THEN 'CLOSED'
WHEN wdd.shipped_quantity IS NULL
THEN 'AWAITING SHIPPING'
WHEN wdd.shipped_quantity > 0
AND wdd.shipped_quantity < wdd.src_requested_quantity
THEN 'PARTIALLY SHIPPED'
WHEN (wdd.src_requested_quantity - wdd.shipped_quantity) =
0 AND wdd.released_status = 'D'
THEN 'CANCELLED'
END AS order_status,
NULL, NULL, NULL, NULL,
ROUND (DECODE ((oel.ordered_quantity - wdd.shipped_quantity),
0, NULL,
TRUNC (SYSDATE) - wdd.creation_date
),
0
) pending_since,
wdd.released_status,null,null/*, oer.reason_code, oer.comments*/

FROM apps.wsh_delivery_details wdd,
apps.wsh_delivery_assignments wda,
apps.wsh_new_deliveries wnd,
apps.oe_order_headers_all oeh,
apps.oe_order_lines_all oel,
apps.hz_parties hp,
apps.hz_cust_accounts hca,
apps.hz_party_sites hps,
apps.mtl_system_items_b msi,
apps.org_organization_definitions ood,
apps.mtl_txn_request_lines mtrl,
apps.mtl_txn_request_headers mtrh

WHERE wda.delivery_detail_id = wdd.delivery_detail_id
AND wda.delivery_id = wnd.delivery_id(+)
--AND NVL (wdd.line_direction, ‘O’) IN (‘O’, ‘IO’)
AND wdd.source_header_id = oeh.header_id
AND wdd.source_line_id = oel.line_id
AND oeh.header_id = oel.header_id
AND hp.party_id = hca.party_id
AND oeh.sold_to_org_id = hca.cust_account_id
AND hps.location_id(+) = oel.ship_to_org_id
AND msi.inventory_item_id = oel.inventory_item_id
AND msi.organization_id = oel.ship_from_org_id
AND oel.ship_from_org_id = ood.organization_id
AND mtrh.header_id = mtrl.header_id
AND wdd.move_order_line_id = NVL( mtrl.line_id,wdd.move_order_line_id)
AND wdd.released_status IN ('B','S','R')
--and wdd.source_header_number=112104873–112909588
AND TO_DATE (oeh.ordered_date) BETWEEN NVL (:f_date, oeh.ordered_date)
AND NVL (:t_date, oeh.ordered_date)
AND hp.country = 'DO'

Union
SELECT wdd.source_header_number order_number,
NULL move_order_number,
wnd.global_attribute14 actual_delivery_date,
NULL move_order_date,
wdd.creation_date,
wdd.source_header_type_name order_type, 
hp.party_name bill_to_customer,
hps.party_site_number ship_to_loc_num,
hps.party_site_name ship_to_loc_name, 
oel.ordered_item,
msi.description, oel.order_quantity_uom,
wdd.src_requested_quantity ordered_quantity, 
wdd.shipped_quantity,
CASE when oel.SOURCE_DOCUMENT_ID is null then
wdd.cancelled_quantity
else
null
end as cancelled_quantity
, oel.unit_selling_price unit_selling_price,
(oel.ordered_quantity * oel.unit_selling_price) extended_price,
oeh.ordered_date, ood.organization_code,
CASE
WHEN (wdd.src_requested_quantity - wdd.shipped_quantity
) = 0
AND wdd.released_status <> 'D'
THEN 'CLOSED'
WHEN wdd.shipped_quantity IS NULL
THEN 'AWAITING SHIPPING'
WHEN wdd.shipped_quantity > 0
AND wdd.shipped_quantity < wdd.src_requested_quantity
THEN 'PARTIALLY SHIPPED'
WHEN (wdd.src_requested_quantity - wdd.shipped_quantity) = 0
AND wdd.released_status = 'D'
THEN 'CANCELLED'
END AS order_status,
NULL, NULL, NULL, NULL,
ROUND (DECODE ((oel.ordered_quantity - wdd.shipped_quantity),
0, NULL,
TRUNC (SYSDATE)- wdd.creation_date
),
0
) pending_since,
wdd.released_status, NULL,NULL -- oer.reason_code, oer.comments

FROM apps.wsh_delivery_details wdd,
apps.wsh_delivery_assignments wda,
apps.wsh_new_deliveries wnd,
apps.oe_order_headers_all oeh,
apps.oe_order_lines_all oel,
apps.hz_parties hp,
apps.hz_cust_accounts hca,
apps.hz_party_sites hps,
apps.mtl_system_items_b msi,
apps.org_organization_definitions ood

WHERE wda.delivery_detail_id = wdd.delivery_detail_id
AND wda.delivery_id = wnd.delivery_id(+)
--AND NVL (wdd.line_direction, ‘O’) IN (‘O’, ‘IO’)
AND wdd.source_header_id = oeh.header_id
AND wdd.source_line_id = oel.line_id
AND oeh.header_id = oel.header_id
AND hp.party_id = hca.party_id
AND oeh.sold_to_org_id = hca.cust_account_id
AND hps.location_id(+) = oel.ship_to_org_id
AND msi.inventory_item_id = oel.inventory_item_id
AND msi.organization_id = oel.ship_from_org_id
AND oel.ship_from_org_id = ood.organization_id
AND wdd.released_status IN ( 'B','S','R')
AND wdd.move_order_line_id IS NULL
--AND wdd.source_header_number = 112104873
AND TO_DATE (oeh.ordered_date) BETWEEN NVL (:f_date, oeh.ordered_date)
AND NVL (:t_date, oeh.ordered_date)
AND hp.country = 'DO'

UNION
SELECT wdd.source_header_number order_number,
mtrh.request_number move_order_number,
wnd.global_attribute14 actual_delivery_date,
mtrh.creation_date move_order_date,
wdd.creation_date,
wdd.source_header_type_name order_type, 
hp.party_name bill_to_customer,
hps.party_site_number ship_to_loc_num,
hps.party_site_name ship_to_loc_name, 
oel.ordered_item,
msi.description, oel.order_quantity_uom,
wdd.src_requested_quantity ordered_quantity, 
wdd.shipped_quantity,
CASE when oel.SOURCE_DOCUMENT_ID is null then
wdd.cancelled_quantity
else
null
end as cancelled_quantity
, oel.unit_selling_price unit_selling_price,
(oel.ordered_quantity * oel.unit_selling_price) extended_price,
oeh.ordered_date, ood.organization_code,
CASE
WHEN (wdd.src_requested_quantity - wdd.shipped_quantity
) = 0
AND wdd.released_status <> 'D'
THEN 'CLOSED'
WHEN wdd.shipped_quantity IS NULL
THEN 'AWAITING SHIPPING'
WHEN wdd.shipped_quantity > 0
AND wdd.shipped_quantity < wdd.src_requested_quantity
THEN 'PARTIALLY SHIPPED'
WHEN (wdd.src_requested_quantity - wdd.shipped_quantity) = 0
AND wdd.released_status = 'D'
THEN 'CANCELLED'
END AS order_status,
NULL, NULL, NULL, NULL,
ROUND (DECODE ((oel.ordered_quantity - wdd.shipped_quantity),
0, NULL,
TRUNC (SYSDATE) - wdd.creation_date
),
0
) pending_since,
wdd.released_status, 
oer.reason_code, 
oer.comments

FROM apps.wsh_delivery_details wdd,
apps.wsh_delivery_assignments wda,
apps.wsh_new_deliveries wnd,
apps.oe_order_headers_all oeh,
apps.oe_order_lines_all oel,
apps.hz_parties hp,
apps.hz_cust_accounts hca,
apps.hz_party_sites hps,
apps.mtl_system_items_b msi,
apps.org_organization_definitions ood,
apps.mtl_txn_request_lines mtrl,
apps.mtl_txn_request_headers mtrh ,
apps.oe_order_lines_history lh ,
apps.oe_reasons oer

WHERE wda.delivery_detail_id = wdd.delivery_detail_id
AND wda.delivery_id = wnd.delivery_id(+)
--AND NVL (wdd.line_direction, ‘O’) IN (‘O’, ‘IO’)
AND wdd.source_header_id = oeh.header_id
AND wdd.source_line_id = oel.line_id
AND oeh.header_id = oel.header_id
AND hp.party_id = hca.party_id
AND oeh.sold_to_org_id = hca.cust_account_id
AND hps.location_id(+) = oel.ship_to_org_id
AND msi.inventory_item_id = oel.inventory_item_id
AND msi.organization_id = oel.ship_from_org_id
AND oel.ship_from_org_id = ood.organization_id
AND mtrh.header_id(+) = mtrl.header_id
AND mtrl.line_id(+) = wdd.move_order_line_id
AND oel.line_id = lh.line_id
AND lh.reason_id = oer.reason_id
AND wdd.released_status IN ('D')
--AND wdd.source_header_number = 112104873–112909588
AND TO_DATE (oeh.ordered_date) BETWEEN NVL (:f_date, oeh.ordered_date)
AND NVL (:t_date, oeh.ordered_date)
AND hp.country = 'DO'

UNION
SELECT TO_CHAR (oeh.order_number) order_number, 
NULL move_order_number,
NULL actual_delivery_date, 
NULL move_order_date, 
NULL, 
NULL order_type,
hp.party_name bill_to_customer,
hps.party_site_number ship_to_loc_num,
hps.party_site_name ship_to_loc_name, 
oel.ordered_item,
msi.description, 
oel.order_quantity_uom,
oel.ordered_quantity ordered_quantity, 
NULL, 
NULL,
oel.unit_selling_price unit_selling_price,
(oel.ordered_quantity * oel.unit_selling_price) extended_price,
oeh.ordered_date, ood.organization_code,
oel.flow_status_code order_status, NULL, NULL, NULL, NULL, NULL, NULL,
NULL, NULL

FROM apps.oe_order_headers_all oeh,
apps.oe_order_lines_all oel,
apps.hz_parties hp,
apps.hz_cust_accounts hca,
apps.hz_party_sites hps,
apps.mtl_system_items_b msi,
apps.org_organization_definitions ood

WHERE oeh.header_id = oel.header_id(+) /* this join for rows whose line level data is not available */
AND hp.party_id = hca.party_id
AND oeh.sold_to_org_id = hca.cust_account_id
AND hps.location_id(+) = oel.ship_to_org_id
AND msi.inventory_item_id(+)=oel.inventory_item_id /* this join for rows whose line level data is not available */
AND msi.organization_id(+) = oel.ship_from_org_id /* this join for rows whose line level data is not available */
AND oel.ship_from_org_id = ood.organization_id(+) /* this join for rows whose line level data is not available */
--and wdd.RELEASED_STATUS in(‘D’,’B’)
--and oeh.ORDER_NUMBER =112105131–112909588–112104621
AND TO_DATE (oeh.ordered_date) BETWEEN NVL (:f_date, oeh.ordered_date)
AND NVL (:t_date, oeh.ordered_date)
AND oeh.flow_status_code = 'ENTERED'
AND hp.country = 'DO'

Union
/*this union for order Booked but his transactions are not done in delivery table and for cancelled order*/
SELECT to_char(oeh.ORDER_NUMBER) order_number,
mtrh.request_number move_order_number,
wnd.global_attribute14 actual_delivery_date,
mtrh.creation_date move_order_date,
wdd.creation_date, 
wdd.source_header_type_name order_type,
hp.party_name bill_to_customer, 
hps.party_site_number ship_to_loc_num,
hps.party_site_name ship_to_loc_name, 
oel.ordered_item,
msi.description, oel.order_quantity_uom,
wdd.src_requested_quantity ordered_quantity, 
wdd.shipped_quantity,
CASE when oel.SOURCE_DOCUMENT_ID is null then
wdd.cancelled_quantity
else
null
end as cancelled_quantity,
oel.unit_selling_price unit_selling_price,
(oel.ordered_quantity * oel.unit_selling_price) extended_price,
oeh.ordered_date, ood.organization_code,
CASE
WHEN (wdd.src_requested_quantity - wdd.shipped_quantity) = 0 
AND wdd.released_status<> 'D'
THEN 'CLOSED'
WHEN wdd.shipped_quantity IS NULL
THEN 'AWAITING SHIPPING'
WHEN wdd.shipped_quantity > 0
AND wdd.shipped_quantity < wdd.src_requested_quantity
THEN 'PARTIALLY SHIPPED'
WHEN (wdd.src_requested_quantity - wdd.shipped_quantity) = 0 
AND wdd.released_status = 'D'
THEN 'CANCELLED'
END AS order_status,
NULL, NULL, NULL, NULL,
ROUND (DECODE ((oel.ordered_quantity - wdd.shipped_quantity),0, 
NULL,
TRUNC (SYSDATE) - wdd.creation_date),0) pending_since,
wdd.released_status,
null,
null
/*, oer.reason_code, oer.comments*/

FROM apps.oe_order_headers_all oeh, 
apps.oe_order_lines_all oel, 
apps.wsh_delivery_details wdd, 
apps.wsh_delivery_assignments wda, 
apps.wsh_new_deliveries wnd, 
apps.hz_party_sites hps, 
apps.hz_cust_accounts hca, 
apps.hz_parties hp, 
apps.mtl_system_items_b msi, 
apps.org_organization_definitions ood, 
apps.mtl_txn_request_lines mtrl, 
apps.mtl_txn_request_headers mtrh 
    
WHERE oeh.header_id = oel.header_id
--AND wdd.source_header_id = oeh.header_id
AND wdd.source_line_id (+) = oel.line_id
AND wda.delivery_id = wnd.delivery_id (+)
AND wda.delivery_detail_id (+) = wdd.delivery_detail_id
AND hps.location_id (+) = oel.ship_to_org_id
AND oeh.sold_to_org_id = hca.cust_account_id
AND hp.party_id = hca.party_id
AND msi.inventory_item_id = oel.inventory_item_id
AND msi.organization_id = oel.ship_from_org_id
AND oel.ship_from_org_id = ood.organization_id
AND wdd.move_order_line_id = mtrl.line_id (+)
AND mtrh.header_id (+) = mtrl.header_id
AND nvl(wdd.released_status, 'n') IN ( 'n' )
--AND oeh.order_number = 112909462
AND oeh.flow_status_code IN ('booked', 'cancelled')
AND TO_DATE(oeh.ordered_date) BETWEEN nvl(:f_date, oeh.ordered_date) 
AND nvl(:t_date, oeh.ordered_date)
AND hp.country = 'DO'
;