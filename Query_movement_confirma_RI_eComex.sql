SELECT *
    FROM apps.cll_f189_invoices              nf
       , apps.cll_f189_invoice_types         tp
       , apps.cll_f189_fiscal_entities_all   emp
       , apps.cll_f189_states                state
       , apps.cll_f189_fiscal_entities_all   fornec
       , apps.cll_f189_invoice_lines         nfl
       , apps.cll_f189_fiscal_operations     fo
       , apps.rcv_shipment_lines             rsl
       , apps.rcv_shipment_headers           rsh
       , apps.cll_f189_entry_operations      op
       , apps.rcv_transactions               rct
       , apps.mtl_material_transactions      trx
       , apps.mtl_system_items_b             mtl
       , apps.cll_f189_invoices              nf_pai
       , apps.cll_f189_invoice_types         tp_pai
       , apps.cll_f189_fiscal_entities_all   emp_pai
       , apps.cll_f189_fiscal_entities_all   frn_pai
   WHERE tp.price_adjust_flag        = 'N'
     AND tp.tax_adjust_flag          = 'N'
     AND tp.invoice_type_id          = nf.invoice_type_id
     AND emp.location_id             = nf.location_id
     AND state.state_id              = emp.state_id
     AND fornec.entity_id            = nf.entity_id
     AND nfl.invoice_id              = nf.invoice_id
     AND fo.cfo_id                   = nfl.cfo_id
     AND (   rsl.shipment_line_id        = nfl.shipment_line_id
          OR nfl.rma_interface_id        = rct.oe_order_line_id
         )
     AND rsh.shipment_header_id      = rsl.shipment_header_id
     AND rsh.receipt_num             = to_char (nf.operation_id)
     AND op.operation_id             = nf.operation_id
     AND op.organization_id          = nf.organization_id
     AND op.location_id              = nf.location_id
     AND rct.shipment_line_id        = rsl.shipment_line_id
     AND (   rct.transaction_type    = 'DELIVER'
          OR op.reversion_flag       = 'S'
         )
     AND (   rct.transaction_type LIKE 'RETURN TO%'
          OR op.reversion_flag      <> 'S'
          OR op.reversion_flag      IS null
         )
     AND trx.rcv_transaction_id      = rct.transaction_id
     AND mtl.inventory_item_id (+)   = nfl.item_id
     AND mtl.organization_id (+)     = nfl.organization_id
     AND nf_pai.invoice_id (+)       = nf.invoice_parent_id
     AND tp_pai.invoice_type_id (+)  = nf_pai.invoice_type_id
     AND emp_pai.organization_id (+) = nf_pai.organization_id
     AND emp_pai.location_id (+)     = nf_pai.location_id
     AND frn_pai.entity_id (+)       = nf_pai.entity_id
     AND op.operation_id         = 443647
     --AND op.organization_id      = 4849
     AND op.location_id          = 1860524
    ;