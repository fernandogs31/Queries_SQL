Select distinct
ece.cnpj "CNPJ",
ece.codigo "Empresa",
eco.codigo "Org.",
eid.nr_declaracao "Nr. DI/DA",
eie_exp.codigo "Código Exportador",
eie_exp.nome "Exportador",
eies_exp.codigo "Código Site_Exportador",
eie_sup.codigo "Código Fornecedor",
eie_sup.nome "Fornecedor",
eies_sup.codigo "Código Site_Fornecedor",
msi.segment1 "PN",
--ctn.codigo "NCM",
(eie.embarque_num||'/'||eie.embarque_ano) "Embarque eComex"
--ecu.codigo "Utilização"
--ect.descricao "Via de transporte"

from 
ecomex.imp_declaracoes eid,
ecomex.imp_declaracoes_adi eida,
ecomex.imp_declaracoes_lin eidl,
apps.mtl_system_items msi,
--ecomex.cmx_tab_ncm ctn,
ecomex.imp_embarques eie,
ecomex.cmx_organizacoes eco,
ecomex.imp_invoices eii,
ecomex.imp_invoices_lin eiil,
--ecomex.cmx_utilizacoes ecu,
--ecomex.imp_conhecimentos eic,
--ecomex.cmx_tabelas ect,
ecomex.cmx_empresas ece,
ecomex.imp_entidades eie_exp,
ecomex.imp_entidades_sites eies_exp,
ecomex.imp_entidades eie_sup,
ecomex.imp_entidades_sites eies_sup

where
    eid.dt_declaracao between '01-jan-2024' and '21-nov-2024'
--and eid.empresa_id = 100010
--and eco.organizacao_id = 4849
and eid.empresa_id = ece.empresa_id
and eid.embarque_id = eie.embarque_id
and eie.organizacao_id = eco.organizacao_id
and eid.declaracao_id = eida.declaracao_id
--and eida.class_fiscal_id = ctn.ncm_id
and eida.declaracao_adi_id = eidl.declaracao_adi_id
and eidl.item_id = msi.inventory_item_id
and eidl.invoice_lin_id = eiil.invoice_lin_id
and eiil.invoice_id = eii.invoice_id
and eii.export_id = eie_exp.entidade_id
and eii.export_site_id = eies_exp.entidade_site_id
and eii.fornec_id = eie_sup.entidade_id
and eii.fornec_site_id = eies_sup.entidade_site_id
--and eiil.utilizacao_id = ecu.utilizacao_id
--and eie.conhec_id = eic.conhec_id
--and ect.tipo = 912
--and eic.via_transporte_id = ect.tabela_id
and msi.segment1 in ('5167237-2','2351573-H','2160200-43-H')

--order by eco.codigo,eid.nr_declaracao
;