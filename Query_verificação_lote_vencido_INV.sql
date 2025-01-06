select *
from apps.mtl_unit_transactions

select *
from apps.mtl_transaction_lot_numbers

    SELECT decode (msi.lot_control_code          , '1', 'N', 'S') --(2=FULL CONTROL) / (1= NO CONTROL)
         , decode (msi.serial_number_control_code, '1', 'N', 'S') --(1=NO CONTROL) / (2=AT RECEIPT) / (5=AT SO ISSUE) / (6=PREDEFINED)
      FROM apps.oe_order_lines_all          ool
         , apps.po_headers_all              poh
         , apps.po_lines_all                pol
         , apps.po_line_locations_all       pll
         , apps.mtl_system_items_b          msi
     WHERE pol.po_header_id      = poh.po_header_id
       AND pll.po_header_id      = poh.po_header_id
       AND pll.po_line_id        = pol.po_line_id
       AND ool.inventory_item_id = pol.item_id
       AND ool.ship_from_org_id  = msi.organization_id
       AND pol.item_id           = msi.inventory_item_id
       AND pll.line_location_id  = pn_line_location_id
       AND (
              (    pol.vendor_product_num = ool.orig_sys_line_ref
               AND ool.split_from_line_id IS null
              )
            OR
              (    ool.split_from_line_id IS NOT null
               AND ool.line_set_id        IS NOT null
               AND ool.line_set_id        = (SELECT ool2.line_set_id
                                               FROM oe_order_lines_all ool2
                                              WHERE ool2.header_id         = ool.header_id
                                                AND ool2.orig_sys_line_ref = pol.vendor_product_num
                                            )
              )
           )
       AND ROWNUM = 1;