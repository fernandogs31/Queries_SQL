SELECT DISTINCT       
                eiil.invoice_lin_id ID
               ,eii.invoice_num inv_ecomex
               ,eivir.ir_numero IR
               ,msi.segment1 main_pn
               ,eiil.qtde qty
               ,decode(eiil.preco_unitario_m_ir_bundling, null, 'Line per Line', 'Bundle') type
               --,msi1.segment1 components
               --,eiild.qtde qty_component
       
FROM    ecomex.imp_invoices eii
       ,ecomex.imp_invoices_lin eiil
       ,ecomex.imp_int_req_gehc eivir
       ,apps.mtl_system_items msi
       --,ecomex.imp_invoices_lin_det eiild
       --,apps.mtl_system_items msi1

WHERE eii.invoice_id = eiil.invoice_id
AND   eiil.item_id = msi.inventory_item_id
--AND   eiil.preco_unitario_m_ir_bundling = 
AND   eiil.int_req_id = eivir.int_req_id
AND   eivir.ir_numero = '7405138.1'
 -- IR number --
--AND   msi.segment1 like 'H48722BA' -- Main PN --
ORDER BY eivir.ir_numero
;


SELECT DISTINCT eii.invoice_num inv_ecomex
,eiil.nr_linha LINHA
               ,eivir.ir_numero IR
               ,msi.segment1 main_pn
               ,eiil.qtde qty
               ,decode(eiil.preco_unitario_m_ir_bundling, null, 'Line per Line', 'Bundle') type
               ,msi1.segment1 components
               ,eiild.qtde qty_component
       
FROM    ecomex.imp_invoices eii
       ,ecomex.imp_invoices_lin eiil
       ,ecomex.imp_int_req_gehc eivir
       ,apps.mtl_system_items msi
       ,ecomex.imp_invoices_lin_det eiild
       ,apps.mtl_system_items msi1

WHERE eii.invoice_id = eiil.invoice_id
AND   eiil.item_id = msi.inventory_item_id
--AND   eiil.preco_unitario_m_ir_bundling <> null
AND   eiil.invoice_lin_id = eiild.invoice_lin_id
AND   eiild.item_id = msi1.inventory_item_id
AND   eiil.int_req_id = eivir.int_req_id
AND   eivir.ir_numero = '7403037.1' -- IR number --
--AND   msi1.segment1 like 'B1%' -- Component PN --
order by 1,2

--

select * 
from GEMS_INV.GEMS_INV_BR_BUNDLE_CTL
where internal_req in ('5374366.1')