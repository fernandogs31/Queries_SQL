SELECT  
    wdd.source_header_number                          "Order_Number"
    ,wda.delivery_id                                   "Delivery_Number"                           
    ,msi.segment1                                      "Part Number"
    ,wdd.src_requested_quantity                        "Ordered Quantity"
    ,wdd.shipped_quantity                              "Shipped Quantity"
    ,CASE
        WHEN oola.source_document_id IS NULL THEN  wdd.cancelled_quantity
        ELSE NULL END    AS                           "Cancelled Quantity"
   ,ooha.ordered_date                                 "Order Date"
   ,ood.organization_code                             "Inv. Org."
   , CASE
        WHEN ( wdd.src_requested_quantity - wdd.shipped_quantity ) = 0 THEN
            'CLOSED'
        WHEN wdd.shipped_quantity IS NULL THEN
            'AWAITING SHIPPING'
        WHEN wdd.shipped_quantity > 0
             AND wdd.shipped_quantity < wdd.src_requested_quantity THEN
            'PARTIALLY SHIPED'
    END AS                                              "Order Status"
   ,DECODE (wdd.released_status,
                                'D', 'Cancelled',
                                'C', 'Shipped',
                                'R', 'Ready to Release',
                                'N', 'Not Ready to Release',
                                'S', 'Released to Warehouse',
                                'Y', 'Staged/Pick Confirmed',
                                'X', 'Not Applicable')"Released Status"

FROM apps.wsh_delivery_details wdd
,apps.wsh_delivery_assignments wda
,apps.wsh_new_deliveries wnd
,apps.oe_order_headers_all ooha
,apps.oe_order_lines_all oola
,apps.mtl_system_items_b msi
,apps.org_organization_definitions ood

WHERE wda.delivery_detail_id = wdd.delivery_detail_id
AND wda.delivery_id = wnd.delivery_id(+)
AND wdd.source_header_id = ooha.header_id
AND wdd.source_line_id = oola.line_id
AND ooha.header_id = oola.header_id
AND msi.inventory_item_id = oola.inventory_item_id
AND msi.organization_id = oola.ship_from_org_id
AND oola.ship_from_org_id = ood.organization_id
AND ooha.ordered_date BETWEEN '01-JUN-24' AND '10-JUN-24'
AND ood.organization_code in ('DAA','KOE','UNS','WXB')
;