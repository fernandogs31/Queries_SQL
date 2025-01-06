SELECT /*+ NO_EXPAND LEADING(oel,oeh,poh) use_nl(oeh) use_nl(msib) use_nl(poh) use_nl(pov) use_nl(cus) use_nl(pol) use_nl(par1) */
 (SELECT hao.NAME
    FROM hr.hr_all_organization_units hao
   WHERE hao.organization_id = oeh.org_id) so_org,
 (SELECT segment1
    FROM gl.gl_code_combinations
   WHERE code_combination_id = par1.material_account) shipper_company,
 (SELECT segment1
    FROM gl.gl_code_combinations
   WHERE code_combination_id = par2.material_account) receiver_company,
 par1.organization_code shipper_warehouse_code,
 oeh.order_number order_number,
 (SELECT DECODE(NVL(v1.attribute_category, 'X'),
                'GPRS UPS SERVICE LEVEL',
                DECODE(NVL(v1.attribute10, 'X'),
                       'CPU',
                       'CPU',
                       'CFX',
                       'CFX',
                       'CPM',
                       'CPM',
                       DECODE(TO_CHAR(h1.order_source_id),
                              '1265',
                              'CEX',
                              '1163',
                              DECODE((SELECT COUNT(gds.demand_line_id)
                                       FROM gems_ont.gems_ds_lines_all gds,
                                            apps.po_headers_all        p1
                                      WHERE gds.demand_type = 'R'
                                        AND p1.po_header_id = gds.po_header_id
                                        AND NVL(p1.attribute6, 'X') IN
                                            ('PRIORITY', 'IR LINKED')
                                        AND gds.so_line_id = l1.line_id),
                                     0,
                                     DECODE((SELECT COUNT(gds.demand_line_id)
                                              FROM gems_ont.gems_ds_lines_all      gds,
                                                   apps.po_requisition_headers_all r1
                                             WHERE gds.demand_type = 'R'
                                               AND r1.requisition_header_id =
                                                   gds.req_header_id
                                               AND NVL(r1.attribute6, 'X') IN
                                                   ('PRIORITY', 'IR LINKED')
                                               AND gds.so_line_id = l1.line_id),
                                            0,
                                            'CRP',
                                            'CEX'),
                                     'CEX'),
                              DECODE(NVL(t1.CONTEXT, 'X'),
                                     'Service OM',
                                     DECODE(NVL(t1.attribute10, 'N'),
                                            'Y',
                                            'CEX',
                                            'CRP'),
                                     'CRP'))),
                DECODE(TO_CHAR(h1.order_source_id),
                       '1265',
                       'CEX',
                       '1163',
                       DECODE((SELECT COUNT(gds.demand_line_id)
                                FROM gems_ont.gems_ds_lines_all gds,
                                     apps.po_headers_all        p1
                               WHERE gds.demand_type = 'R'
                                 AND p1.po_header_id = gds.po_header_id
                                 AND NVL(p1.attribute6, 'X') IN
                                     ('PRIORITY', 'IR LINKED')
                                 AND gds.so_line_id = l1.line_id),
                              0,
                              DECODE((SELECT COUNT(gds.demand_line_id)
                                       FROM gems_ont.gems_ds_lines_all      gds,
                                            apps.po_requisition_headers_all r1
                                      WHERE gds.demand_type = 'R'
                                        AND r1.requisition_header_id =
                                            gds.req_header_id
                                        AND NVL(r1.attribute6, 'X') IN
                                            ('PRIORITY', 'IR LINKED')
                                        AND gds.so_line_id = l1.line_id),
                                     0,
                                     'CRP',
                                     'CEX'),
                              'CEX'),
                       DECODE(NVL(t1.CONTEXT, 'X'),
                              'Service OM',
                              DECODE(NVL(t1.attribute10, 'N'),
                                     'Y',
                                     'CEX',
                                     'CRP'),
                              'CRP')))
    FROM apps.oe_order_headers_all     h1,
         apps.oe_order_lines_all       l1,
         apps.oe_transaction_types_all t1,
         apps.fnd_common_lookups       v1
   WHERE v1.lookup_type = 'SHIP_METHOD'
     AND h1.header_id = oeh.header_id
     AND h1.header_id = l1.header_id
     AND h1.order_type_id = t1.transaction_type_id
     AND v1.lookup_code =
         NVL(l1.shipping_method_code, '000001_Best Avail_T_BEST AVAIL')
     AND l1.line_id = oel.line_id
     AND ROWNUM = 1) service_level,
 oel.line_number order_line_number,
 oeh.ordered_date order_date,
 oel.actual_shipment_date shipment_date,
 oel.ordered_item,
 poh.segment1 po_number,
 pol.creation_date po_creation_date,
 poh.attribute6 po_classification,
 poh.authorization_status po_status,
 pol.line_num po_line_number,
 poll.shipment_num,
 NVL(pol.quantity, 0) po_quantity,
 msib.item_type,
 (SELECT mc.segment1 || '.' || mc.segment2
    FROM apps.mtl_item_categories  mic,
         apps.mtl_category_sets_tl mcs,
         apps.mtl_categories_b     mc
   WHERE mic.category_set_id = mcs.category_set_id
     AND mcs.category_set_name = 'GEHC GPO CAT SET'
     AND mic.category_id = mc.category_id
     AND mic.inventory_item_id = msib.inventory_item_id
     AND mic.organization_id = 1755) gpo_category,
 msib.attribute3 modality,
 prt.party_name customer_name,
 par2.organization_code receiver_warehouse_code,
 par1.organization_id ship_org_id,
 par2.organization_id recv_org_id,
 (SELECT subinventory
    FROM apps.wsh_delivery_details wdd
   WHERE wdd.source_header_id = oeh.header_id
     AND ROWNUM = 1) shipper_subinventory,
 (SELECT DECODE(asset_inventory, 1, 'ASSET', 2, 'NON_ASSET')
    FROM apps.mtl_secondary_inventories msi, apps.wsh_delivery_details wdd
   WHERE wdd.source_header_id = oeh.header_id
     AND wdd.subinventory = msi.secondary_inventory_name
     AND msi.organization_id = par1.organization_id
     AND ROWNUM = 1) shipping_subinventory_type,
 (SELECT pod.destination_subinventory
    FROM apps.po_distributions_all pod
   WHERE pod.po_header_id = poh.po_header_id
     AND pod.po_header_id = poll.po_header_id
     AND ROWNUM = 1) receiving_subinventory,
 (SELECT DECODE(asset_inventory, 1, 'ASSET', 2, 'NON_ASSET')
    FROM apps.mtl_secondary_inventories msi, apps.po_distributions_all pod
   WHERE pod.po_header_id = poh.po_header_id
     AND pod.po_header_id = poll.po_header_id
     AND pod.destination_subinventory = msi.secondary_inventory_name
     AND msi.organization_id = par2.organization_id
     AND ROWNUM = 1) receiving_subinventory_type,
 pov.pay_group_lookup_code vendor_paygroup,
 (SELECT SUM(NVL(oel2.shipped_quantity, 0))
    FROM apps.oe_order_lines_all oel2, apps.oe_order_headers_all oeh2
   WHERE oel2.sold_to_org_id = oel.sold_to_org_id
     AND oeh2.header_id = oeh.header_id
     AND oeh2.header_id = oel2.header_id
     AND oel2.inventory_item_id = oel.inventory_item_id
     AND oel2.line_number = oel.line_number) total_shipped_quantity,
 (SELECT SUM(NVL(poll2.quantity_received, 0))
    FROM po.po_line_locations_all poll2
   WHERE poll2.po_line_id = pol.po_line_id) po_quantity_received,
 (SELECT SUM(NVL(poll2.quantity_billed, 0))
    FROM apps.po_line_locations_all poll2
   WHERE poll2.po_line_id = pol.po_line_id) po_quantity_invoiced,
 (SELECT SUM(NVL(poll2.quantity_cancelled, 0))
    FROM apps.po_line_locations_all poll2
   WHERE poll2.po_line_id = pol.po_line_id) po_quantity_cancelled,
 (SELECT aia.invoice_num
    FROM apps.ap_invoices_all aia, apps.ap_invoice_lines_all apl
   WHERE aia.invoice_id = apl.invoice_id
     AND apl.line_type_lookup_code = 'ITEM'
     AND apl.po_header_id = poh.po_header_id
     AND apl.inventory_item_id = pol.item_id
     AND ROWNUM = 1) invoice_num,
 (Select aia.INVOICE_TYPE_LOOKUP_CODE
    from apps.ap_invoices_all aia, apps.ap_invoice_lines_all apl
   where aia.invoice_id = APL.invoice_id
     and APL.line_type_lookup_code = 'ITEM'
     and APL.po_header_id = POH.po_header_id
     and APL.inventory_item_id = pol.item_id
     and apl.last_update_date in
         (Select max(apl.last_update_date)
            from apps.ap_invoice_lines_all apl
           where APL.line_type_lookup_code = 'ITEM'
             and APL.po_header_id = POH.po_header_id
             and APL.inventory_item_id = pol.item_id)
     and rownum = 1) INVOICE_TYPE,
 (Select aia.INVOICE_DATE
    from apps.ap_invoices_all aia, apps.ap_invoice_lines_all apl
   where aia.invoice_id = APL.invoice_id
     and APL.line_type_lookup_code = 'ITEM'
     and APL.po_header_id = POH.po_header_id
     and APL.inventory_item_id = pol.item_id
     and apl.last_update_date in
         (Select max(apl.last_update_date)
            from apps.ap_invoice_lines_all apl
           where APL.line_type_lookup_code = 'ITEM'
             and APL.po_header_id = POH.po_header_id
             and APL.inventory_item_id = pol.item_id)
     and rownum = 1) INVOICE_DATE,
 (SELECT TRUNC(SYSDATE) - TRUNC(oel.actual_shipment_date) FROM DUAL) ageing,
 oeh.shipping_instructions,
 (SELECT /*+ leading(wdd) */
   wnd.attribute9
    FROM apps.wsh_delivery_details     wdd,
         apps.wsh_delivery_assignments wda,
         apps.wsh_new_deliveries       wnd
   WHERE wda.delivery_id = wnd.delivery_id
     AND wdd.delivery_detail_id = wda.delivery_detail_id
     AND wdd.source_line_id = oel.line_id
     AND wdd.source_code = 'OE'
     AND ROWNUM = 1) updated_awb,
 (SELECT wnd.waybill /*+ leading(wdd) */
    FROM apps.wsh_delivery_details     wdd,
         apps.wsh_delivery_assignments wda,
         apps.wsh_new_deliveries       wnd
   WHERE wda.delivery_id = wnd.delivery_id
     AND wdd.delivery_detail_id = wda.delivery_detail_id
     AND wdd.source_line_id = oel.line_id
     AND wdd.source_code = 'OE'
     AND ROWNUM = 1) waybill,
 (SELECT wc.freight_code /*+ leading(wdd) */
    FROM apps.wsh_delivery_details     wdd,
         apps.wsh_delivery_assignments wda,
         apps.wsh_new_deliveries       wnd,
         apps.wsh_carriers             wc
   WHERE wda.delivery_id = wnd.delivery_id
     AND wdd.delivery_detail_id = wda.delivery_detail_id
     AND wdd.source_line_id = oel.line_id
     AND wc.carrier_id = wnd.carrier_id
     AND wdd.source_code = 'OE'
     AND ROWNUM = 1) "Freight Carrier Name",
 (SELECT /*+ leading(wdd) */
   wnd.delivery_id
    FROM apps.wsh_delivery_details     wdd,
         apps.wsh_delivery_assignments wda,
         apps.wsh_new_deliveries       wnd
   WHERE wda.delivery_id = wnd.delivery_id
     AND wdd.delivery_detail_id = wda.delivery_detail_id
     AND wdd.source_line_id = oel.line_id
     AND wdd.source_code = 'OE'
     AND ROWNUM = 1) deliveryno,
 (SELECT SUM(NVL(oel2.shipped_quantity, 0))
    FROM apps.oe_order_lines_all oel2, apps.oe_order_headers_all oeh2
   WHERE oel2.sold_to_org_id = oel.sold_to_org_id
     AND oeh2.header_id = oeh.header_id
     AND oeh2.header_id = oel2.header_id
     AND oel2.inventory_item_id = oel.inventory_item_id
     AND oel2.line_number = oel.line_number) -
 (SELECT SUM(NVL(poll2.quantity_received, 0))
    FROM po.po_line_locations_all poll2
   WHERE poll2.po_line_id = pol.po_line_id) intransit_qty,
 poh.currency_code po_currency_code,
 (SELECT sob.currency_code
    FROM apps.org_organization_definitions ood1, apps.gl_sets_of_books sob
   WHERE ood1.set_of_books_id = sob.set_of_books_id
     AND ood1.organization_id = poll.ship_to_organization_id) currency_code_receiving_org,
 ROUND((pol.unit_price * NVL(poh.rate, 1)), 2) unit_price_rcv_org_curr,
 pol.unit_price unit_price_po_currency,
 ROUND(apps.gems_public_apis_pkg.gl_converted_amount(poh.currency_code,
                                                     'USD',
                                                     SYSDATE,
                                                     '1000',
                                                     (pol.unit_price)),
       2) "UNIT_PRICE_IN_USD(OPFX)",
 pol.unit_price *
 ((SELECT SUM(NVL(oel2.shipped_quantity, 0))
     FROM apps.oe_order_lines_all oel2, apps.oe_order_headers_all oeh2
    WHERE oel2.sold_to_org_id = oel.sold_to_org_id
      AND oeh2.header_id = oeh.header_id
      AND oeh2.header_id = oel2.header_id
      AND oel2.inventory_item_id = oel.inventory_item_id
      AND oel2.line_number = oel.line_number) -
 (SELECT SUM(NVL(poll2.quantity_received, 0))
     FROM po.po_line_locations_all poll2
    WHERE poll2.po_line_id = pol.po_line_id)) total_intrst_amt_po_currency,
 ROUND((pol.unit_price * NVL(poh.rate, 1)), 2) *
 ((SELECT SUM(NVL(oel2.shipped_quantity, 0))
     FROM apps.oe_order_lines_all oel2, apps.oe_order_headers_all oeh2
    WHERE oel2.sold_to_org_id = oel.sold_to_org_id
      AND oeh2.header_id = oeh.header_id
      AND oeh2.header_id = oel2.header_id
      AND oel2.inventory_item_id = oel.inventory_item_id
      AND oel2.line_number = oel.line_number) -
  (SELECT SUM(NVL(poll2.quantity_received, 0))
     FROM po.po_line_locations_all poll2
    WHERE poll2.po_line_id = pol.po_line_id)) total_intrst_amt_rcv_currency,
 ROUND(apps.gems_public_apis_pkg.gl_converted_amount(poh.currency_code,
                                                     'USD',
                                                     SYSDATE,
                                                     '1000',
                                                     (pol.unit_price *
                                                     ((SELECT SUM(NVL(oel2.shipped_quantity,
                                                                       0))
                                                          FROM apps.oe_order_lines_all   oel2,
                                                               apps.oe_order_headers_all oeh2
                                                         WHERE oel2.sold_to_org_id =
                                                               oel.sold_to_org_id
                                                           AND oeh2.header_id =
                                                               oeh.header_id
                                                           AND oeh2.header_id =
                                                               oel2.header_id
                                                           AND oel2.inventory_item_id =
                                                               oel.inventory_item_id
                                                           AND oel2.line_number =
                                                               oel.line_number) -
                                                     (SELECT SUM(NVL(poll2.quantity_received,
                                                                       0))
                                                          FROM po.po_line_locations_all poll2
                                                         WHERE poll2.po_line_id =
                                                               pol.po_line_id)))),
       2) total_intrst_amt_usd_currency,
 ROUND(apps.gems_public_apis_pkg.gl_converted_amount(poh.currency_code,
                                                     'USD',
                                                     SYSDATE,
                                                     '1000',
                                                     (pol.unit_price *
                                                     pol.quantity)),
       2) "TOTAL_PO_AMOUNT_USD(OPFX)",
 (SELECT cst.item_cost
    FROM apps.cst_item_costs cst
   WHERE cst.inventory_item_id = pol.item_id
     AND cst.organization_id = ood.organization_id
     AND cst.cost_type_id = 1) unit_frozen_cost_recv_org_lc,
 (SELECT (NVL((SELECT conversion_rate
                FROM gl.gl_daily_rates r, gl.gl_ledgers sob
               WHERE r.conversion_type = '1000'
                 AND r.conversion_date = TRUNC(SYSDATE)
                 AND r.to_currency = 'USD'
                 AND r.from_currency = sob.currency_code
                 AND sob.ledger_id = ood.set_of_books_id),
              1) * NVL(cst.item_cost, 0))
    FROM apps.cst_item_costs cst
   WHERE cst.inventory_item_id = pol.item_id
     AND cst.organization_id = ood.organization_id
     AND cst.cost_type_id = 1) unit_frozen_cost_recv_org_usd,
 (SELECT (NVL((SELECT conversion_rate
                FROM gl.gl_daily_rates r, gl.gl_ledgers sob
               WHERE r.conversion_type = '1000'
                 AND r.conversion_date = TRUNC(SYSDATE)
                 AND r.to_currency = 'USD'
                 AND r.from_currency = sob.currency_code
                 AND sob.ledger_id = ood.set_of_books_id),
              1) * NVL(cst.item_cost, 0))
    FROM apps.cst_item_costs cst
   WHERE cst.inventory_item_id = pol.item_id
     AND cst.organization_id = ood.organization_id
     AND cst.cost_type_id = 1504) unit_mmicv_usd,
 (SELECT (NVL((SELECT conversion_rate
                FROM gl.gl_daily_rates r, gl.gl_ledgers sob
               WHERE r.conversion_type = '1000'
                 AND r.conversion_date = TRUNC(SYSDATE)
                 AND r.to_currency = 'USD'
                 AND r.from_currency = sob.currency_code
                 AND sob.ledger_id = ood.set_of_books_id),
              1) * NVL(cst.item_cost, 0))
    FROM apps.cst_item_costs cst
   WHERE cst.inventory_item_id = pol.item_id
     AND cst.organization_id = ood.organization_id
     AND cst.cost_type_id = 1504) * NVL(pol.quantity, 0) mmicv_extended,
 NVL((SELECT full_name || '|' || employee_number || '|' || fu.user_name
       FROM apps.per_people_f ppf, apps.mtl_planners mpln, apps.fnd_user fu
      WHERE ppf.person_id = mpln.employee_id
        AND mpln.planner_code = msib.planner_code
        AND mpln.organization_id = 1755 /* msi.organization_id*/
        AND fu.employee_id = ppf.person_id
        AND NVL(ppf.effective_end_date, SYSDATE + 5) > SYSDATE
        AND NVL(fu.end_date, SYSDATE + 5) > SYSDATE),
     '||') planner_details
  FROM ont.oe_order_headers_all          oeh,
       ont.oe_order_lines_all            oel,
       inv.mtl_parameters                par1,
       inv.mtl_parameters                par2,
       po.po_headers_all                 poh,
       po.po_lines_all                   pol,
       po.po_line_locations_all          poll,
       inv.mtl_system_items_b            msib,
       apps.ap_supplier_sites_all        pov,
       apps.hz_parties                   prt,
       apps.org_organization_definitions ood,
       apps.hz_cust_accounts             cus
 WHERE oeh.sold_to_org_id = cus.cust_account_id
   AND cus.party_id = prt.party_id
   AND oeh.header_id = oel.header_id
   AND ood.organization_id = poll.ship_to_organization_id
   AND par1.organization_id = oel.ship_from_org_id
   AND oel.inventory_item_id = msib.inventory_item_id
   AND msib.organization_id = 1755
   AND poh.segment1 = oeh.cust_po_number
   AND TO_CHAR(poh.org_id) =
       SUBSTR(oeh.orig_sys_document_ref,
              (INSTR(oeh.orig_sys_document_ref, '.', 1) + 1),
              (INSTR(oeh.orig_sys_document_ref, '.', 1, 2) - 1) -
              (INSTR(oeh.orig_sys_document_ref, '.', 1)))
   AND poh.po_header_id = pol.po_header_id
   AND poh.type_lookup_code = 'STANDARD'
   AND oel.inventory_item_id = pol.item_id
   AND poh.vendor_site_id = pov.vendor_site_id
   AND poll.po_line_id = pol.po_line_id
   AND poll.po_header_id = poh.po_header_id
   AND poll.ship_to_organization_id = par2.organization_id
   AND par2.attribute7 = 'PARTS'
   AND poll.closed_code <> 'FINALLY CLOSED'
   AND (pol.vendor_product_num = oel.orig_sys_line_ref OR
       pol.vendor_product_num = TO_CHAR(oeh.header_id))
   AND oel.actual_shipment_date BETWEEN TO_DATE('01/01/2022', 'dd/mm/yyyy') AND
       SYSDATE + 1 /* AND poh.org_id <> oeh.org_id*/
   AND NOT EXISTS
 (SELECT 1
          FROM apps.fnd_flex_value_sets a, apps.fnd_flex_values b
         WHERE a.flex_value_set_name =
               'GEMS_GPO_INVENTORY_VALUE_EXCLUDED_ORGS'
           AND a.flex_value_set_id = b.flex_value_set_id
           AND NVL(b.enabled_flag, 'Y') = 'Y'
           AND NVL(b.end_date_active, SYSDATE) >= SYSDATE
           AND b.flex_value = par2.organization_code)
   AND (SELECT /*+ index(oel2,OE_ORDER_LINES_N3) */
         SUM(NVL(oel2.shipped_quantity, 0))
          FROM ont.oe_order_lines_all oel2
         WHERE oel2.sold_to_org_id = oel.sold_to_org_id
           AND oel2.cust_po_number = oeh.cust_po_number
           AND oel2.inventory_item_id = oel.inventory_item_id
           AND oel2.line_number = oel.line_number) <>
       (SELECT SUM(NVL(poll2.quantity_received, 0))
          FROM po.po_line_locations_all poll2
         WHERE poll2.po_line_id = pol.po_line_id
           AND poll2.po_header_id = poh.po_header_id)
   AND ((SELECT SUM(NVL(oel2.shipped_quantity, 0))
           FROM apps.oe_order_lines_all oel2, apps.oe_order_headers_all oeh2
          WHERE oel2.sold_to_org_id = oel.sold_to_org_id
            AND oeh2.header_id = oeh.header_id
            AND oeh2.header_id = oel2.header_id
            AND oel2.inventory_item_id = oel.inventory_item_id
            AND oel2.line_number = oel.line_number) -
       (SELECT SUM(NVL(poll2.quantity_received, 0))
           FROM po.po_line_locations_all poll2
          WHERE poll2.po_line_id = pol.po_line_id
            AND poll2.po_header_id = poh.po_header_id)) <> 0
   AND pol.po_line_id NOT IN ('90114472','86977197','86977198')