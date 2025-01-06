SELECT ott.org_id
      ,hrorg.name operating_unit_name
      ,ottl.name order_type_name
      ,ottl.description order_type_description
      ,ott.order_category_code
      ,ott.transaction_type_code
      ,ott.attribute1 order_type
      ,ott.attribute2 order_category
      ,ott.attribute3 adjustment_reason
      ,ott.def_transaction_phase_code
      ,ott.default_fulfillment_set
      ,ott.start_date_active
      ,ott.end_date_active
      ,ott.invoice_source_id
      ,rctta.name AR_transaction_type
      ,ott.non_delivery_invoice_source_id
      ,ott.tax_calculation_event_code
      ,ott.price_list_id
      ,qlht.name pricelist_name
      ,ott.shipping_method_code
      ,ott.scheduling_level_code
      ,ott.warehouse_id
      ,ood.organization_code organization
      --,gcc.concatenated_segments revenue_account
      ,in_type.NAME default_return_line_type
      ,out_type.NAME default_order_line_type

FROM  apps.oe_transaction_types_all  ott
     ,apps.oe_transaction_types_tl   ottl
     ,apps.hr_all_organization_units hrorg
     ,apps.oe_transaction_types_tl   in_type
     ,apps.oe_transaction_types_tl   out_type
     ,apps.qp_list_headers_tl        qlht
     ,apps.org_organization_definitions ood
     ,apps.ra_cust_trx_types_all rctta
     --,apps.gl_code_combinations_kfv  gcc

WHERE ott.transaction_type_id           = ottl.transaction_type_id
AND   hrorg.organization_id             = ott.org_id
AND   ott.DEFAULT_INBOUND_LINE_TYPE_ID  = in_type.transaction_type_id(+)
AND   ott.DEFAULT_OUTBOUND_LINE_TYPE_ID = out_type.transaction_type_id(+)
AND   ott.price_list_id = qlht.list_header_id
AND   ott.warehouse_id = ood.organization_id
AND   ott.cust_trx_type_id = rctta.cust_trx_type_id
AND   ott.org_id = 4330
AND   ott.transaction_type_code = 'ORDER'
--AND   rctta.gl_id_rev = gcc.code_combination_id
;


select *
from apps.ra_cust_trx_types_all rctta