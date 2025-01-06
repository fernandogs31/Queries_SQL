SELECT DISTINCT
    rctl.sales_order       "SO",
    ottt.name              "SO transaction type",
    rct.trx_date           "AR trx dt",
    rct.trx_number         "AR transaction",
    rct_name.name          "AR transaction type",
    rct.purchase_order     "PO",
    msib.segment1          "Item Code",
    rctl.quantity_invoiced "AR Qty invoiced",
    eii.invoice_num        "eComex invoice",
    ( eie.embarque_num || '/' || eie.embarque_ano )  "Embarque eComex",
    eid.nr_declaracao      "DI eComex",
    ( 
        SELECT
            einfe.numero_documento_fiscal
        FROM
            ecomex.imp_declaracoes   eid,
            ecomex.imp_nf_eletronica einfe
        WHERE
                eid.declaracao_id = einfe.declaracao_id
            AND eid.embarque_id = eie.embarque_id
    )                      "NF eComex",
    (
        SELECT
            einfe.data_emissao_documento_fiscal
        FROM
            ecomex.imp_declaracoes   eid,
            ecomex.imp_nf_eletronica einfe
        WHERE
                eid.declaracao_id = einfe.declaracao_id
            AND eid.embarque_id = eie.embarque_id
    )                      "NF eComex data",
    pha.comments           "PO Comments"
FROM
    apps.ra_customer_trx_all       rct,
    apps.ra_customer_trx_lines_all rctl,
    apps.mtl_system_items_b        msib,
    apps.po_headers_all            pha,
    ecomex.imp_invoices            eii,
    ecomex.imp_embarques           eie,
    ecomex.imp_declaracoes         eid,
    apps.ra_cust_trx_types_all     rct_name,
    apps.oe_order_headers_all      ooha,
    apps.oe_transaction_types_tl   ottt
WHERE rct.customer_trx_id = rctl.customer_trx_id
    AND rctl.inventory_item_id = msib.inventory_item_id
    AND rct.purchase_order = pha.segment1
    AND rct.trx_number = eii.invoice_num
    AND eii.embarque_id = eie.embarque_id
    AND eie.embarque_id = eid.embarque_id
    AND rct_name.cust_trx_type_id = rct.cust_trx_type_id
    AND to_char(ooha.order_number) = rctl.sales_order
    AND ooha.order_type_id = ottt.transaction_type_id
    --AND rctl.sales_order = '60465781' -- Busca por SO --
    AND ottt.name like 'GPO_BR_SCI_NAT_ESTRATEGICA'
    AND rctl.creation_date >= '01-JAN-24'
order by rct.trx_date
;