SELECT DISTINCT
eco.codigo "Org."
,(eie.embarque_num||'/'||eie.embarque_ano) "Shipment eComex"
,eii.invoice_num "Invoice eComex"
,eii.dt_emissao "Invoice date eComex"
,decode(eii.moeda_id, 4681, 'USD') "Invoice currency"
,eii.valor_total "Invoice total eComex"
,eies.codigo "Supplier code"
,eies.nome "Supplier name"
,eiess.codigo "Supplier site code"
,pha.segment1 "PO"
,gcc.segment2 "Account accrual segment"
,(gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5||'.'||gcc.segment6||'.'||gcc.segment7||'.'||gcc.segment8||'.'||gcc.segment9||'.'||gcc.segment10||'.'||gcc.segment11) "All account segment"


FROM 
ecomex.imp_embarques eie
,ecomex.cmx_organizacoes eco
,ecomex.imp_invoices eii
,ecomex.imp_invoices_lin eiil
,ecomex.imp_entidades eies
,ecomex.imp_entidades_sites eiess
,apps.PO_HEADERS_ALL pha
,apps.PO_LINE_LOCATIONS_ALL plla
,apps.PO_LINES_ALL pla
,apps.po_distributions_all pda
,gl.gl_code_combinations gcc

WHERE
    eii.invoice_id = eiil.invoice_id
AND eii.embarque_id = eie.embarque_id
AND eie.organizacao_id = eco.organizacao_id
AND eii.export_id = eies.entidade_id
AND eii.export_site_id = eiess.entidade_site_id
AND eiil.po_id = pha.po_header_id
AND pla.po_header_id = pha.po_header_id
AND plla.po_line_id = pla.po_line_id
AND plla.line_location_id = pda.line_location_id
AND pda.accrual_account_id = gcc.code_combination_id
AND eii.dt_emissao between '01-JAN-2024' and '10-NOV-2024'
AND eies.codigo in ('H27023',
'N05280',
'137751',
'137855',
'N13383',
'835680',
'251109',
'329922',
'100020',
'412984',
'B86200',
'M11775')
;