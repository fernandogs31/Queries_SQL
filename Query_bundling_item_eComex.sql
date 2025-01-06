Select distinct 
ece.cnpj "CNPJ",
ece.codigo "Empresa",
eco.codigo "Org.",
eid.nr_declaracao "Nr. DI/DA",
msi.segment1 "PN",
ctn.codigo "NCM",
(eie.embarque_num||'/'||eie.embarque_ano) "Embarque eComex",
ecu.codigo "Utilização",
ect.descricao "Via de transporte",
decode(eiil.preco_unitario_m_ir_bundling, null, 'Linha a Linha', 'Bundling') "Bundling"

from 
ecomex.imp_declaracoes eid,
ecomex.imp_declaracoes_adi eida,
ecomex.imp_declaracoes_lin eidl,
apps.mtl_system_items msi,
ecomex.cmx_tab_ncm ctn,
ecomex.imp_embarques eie,
ecomex.cmx_organizacoes eco,
ecomex.imp_invoices eii,
ecomex.imp_invoices_lin eiil,
ecomex.cmx_utilizacoes ecu,
ecomex.imp_conhecimentos eic,
ecomex.cmx_tabelas ect,
ecomex.cmx_empresas ece

where
    eid.dt_declaracao between '01-jan-2024' and '31-oct-2024'
--and eid.empresa_id = 100010
--and eco.organizacao_id = 4849
and eid.empresa_id = ece.empresa_id
and eid.declaracao_id = eida.declaracao_id
and eida.class_fiscal_id = ctn.ncm_id
and eida.declaracao_adi_id = eidl.declaracao_adi_id
and eidl.item_id = msi.inventory_item_id
and eidl.invoice_lin_id = eiil.invoice_lin_id
and eii.invoice_id = eiil.invoice_id
and eiil.utilizacao_id = ecu.utilizacao_id
and eid.embarque_id = eie.embarque_id
and eie.organizacao_id = eco.organizacao_id
and eie.conhec_id = eic.conhec_id
and ect.tipo = 912
and eic.via_transporte_id = ect.tabela_id

order by eco.codigo,eid.nr_declaracao
;