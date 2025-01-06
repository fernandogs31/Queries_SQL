Select  
ece.cnpj "CNPJ",
ece.codigo "Empresa",
eco.codigo "Org.",
eid.nr_declaracao "Nr. DI/DA",
--eidl.item_id,
--msi.segment1 "PN",
--ctn.codigo "NCM",
(eie.embarque_num||'/'||eie.embarque_ano) "Embarque eComex",
--ecu.codigo "Utilização",
eivnfe.numero_documento_fiscal "NFE",
eivnfe.serie "Serie",
eivnfe.data_emissao_documento_fiscal "Dt.Emissão",
eivnfe.id_envio_recebto "ID Envio RI",
eivnfe.dt_envio_recebto "Dt.Envio RI"
--ect.descricao "Via de transporte"

from 
ecomex.imp_declaracoes eid,
ecomex.imp_declaracoes_adi eida,
ecomex.imp_declaracoes_lin eidl,
--apps.mtl_system_items msi,
--ecomex.cmx_tab_ncm ctn,
ecomex.imp_embarques eie,
ecomex.cmx_organizacoes eco,
--ecomex.imp_invoices eii,
--ecomex.imp_invoices_lin eiil,
--ecomex.cmx_utilizacoes ecu,
--ecomex.imp_conhecimentos eic,
--ecomex.cmx_tabelas ect,
ecomex.cmx_empresas ece,
ecomex.IMP_VW_NF_ELETRONICA eivnfe

where
    eid.dt_declaracao between '01-jan-2024' and '15-jul-2024'
--and eid.empresa_id = 100010
and eco.codigo = 'U51'
and eid.empresa_id = ece.empresa_id
and eid.declaracao_id = eida.declaracao_id
--and eida.class_fiscal_id = ctn.ncm_id
and eida.declaracao_adi_id = eidl.declaracao_adi_id
--and eidl.item_id = msi.inventory_item_id
--and eidl.invoice_lin_id = eiil.invoice_lin_id
--and eii.invoice_id = eiil.invoice_id
--and eiil.utilizacao_id = ecu.utilizacao_id
and eid.embarque_id = eie.embarque_id
and eie.embarque_id = eivnfe.embarque_id
and eie.organizacao_id = eco.organizacao_id
--and eie.conhec_id = eic.conhec_id
--and ect.tipo = 912
--and eic.via_transporte_id = ect.tabela_id
--and msi.segment1 = '5264644'


UNION

Select 
ece.cnpj "CNPJ",
ece.codigo "Empresa",
eco.codigo "Org.",
eid.nr_declaracao "Nr. DI/DA",
--eidl.item_id,
--msi.segment1 "PN",
--ctn.codigo "NCM",
(eie.embarque_num||'/'||eie.embarque_ano) "Embarque eComex",
--ecu.codigo "Utilização",
eivnfe.numero_documento_fiscal "NFE",
eivnfe.serie "Serie",
eivnfe.data_emissao_documento_fiscal "Dt.Emissão",
eivnfe.id_envio_recebto "ID Envio RI",
eivnfe.dt_envio_recebto "Dt.Envio RI"
--ect.descricao "Via de transporte"

from 
ecomex.imp_declaracoes eid,
ecomex.imp_declaracoes_adi eida,
ecomex.imp_declaracoes_lin eidl,
--apps.mtl_system_items msi,
--ecomex.cmx_tab_ncm ctn,
ecomex.imp_embarques eie,
ecomex.cmx_organizacoes eco,
--ecomex.imp_invoices eii,
--ecomex.imp_invoices_lin eiil,
--ecomex.cmx_utilizacoes ecu,
--ecomex.imp_conhecimentos eic,
--ecomex.cmx_tabelas ect,
ecomex.cmx_empresas ece,
ecomex.IMP_VW_NF_ELETRONICA eivnfe

where
    eid.dt_declaracao between '01-jan-2024' and '15-jul-2024'
--and eid.empresa_id = 100010
and eco.codigo = 'U52'
and eid.empresa_id = ece.empresa_id
and eid.declaracao_id = eida.declaracao_id
--and eida.class_fiscal_id = ctn.ncm_id
and eida.declaracao_adi_id = eidl.declaracao_adi_id
--and eidl.item_id = msi.inventory_item_id
--and eidl.invoice_lin_id = eiil.invoice_lin_id
--and eii.invoice_id = eiil.invoice_id
--and eiil.utilizacao_id = ecu.utilizacao_id
and eid.embarque_id = eie.embarque_id
and eie.embarque_id = eivnfe.embarque_id
and eie.organizacao_id = eco.organizacao_id
--and eie.conhec_id = eic.conhec_id
--and ect.tipo = 912
--and eic.via_transporte_id = ect.tabela_id
--and msi.segment1 = '5264644'

;

//
Select 
ece.cnpj "CNPJ",
ece.codigo "Empresa",
eco.codigo "Org.",
eid.nr_declaracao "Nr. DI/DA",
(eie.embarque_num||'/'||eie.embarque_ano) "Embarque eComex"
--eivnfe.numero_documento_fiscal "NFE",
--eivnfe.serie "Serie",
--eivnfe.data_emissao_documento_fiscal "Dt.Emissão",
--eivnfe.id_envio_recebto "ID Envio RI",
--eivnfe.dt_envio_recebto "Dt.Envio RI"

from 
ecomex.imp_declaracoes eid,
ecomex.imp_declaracoes_adi eida,
ecomex.imp_declaracoes_lin eidl,
--apps.mtl_system_items msi,
--ecomex.cmx_tab_ncm ctn,
ecomex.imp_embarques eie,
ecomex.cmx_organizacoes eco,
--ecomex.imp_invoices eii,
--ecomex.imp_invoices_lin eiil,
--ecomex.cmx_utilizacoes ecu,
--ecomex.imp_conhecimentos eic,
--ecomex.cmx_tabelas ect,
ecomex.cmx_empresas ece
--ecomex.IMP_VW_NF_ELETRONICA eivnfe

where
    eid.dt_declaracao between '01-jan-2024' and '14-jul-2024'
--and eid.empresa_id = 100010
and eco.codigo = 'U51'
and eid.empresa_id = ece.empresa_id
and eid.declaracao_id = eida.declaracao_id
--and eida.class_fiscal_id = ctn.ncm_id
and eida.declaracao_adi_id = eidl.declaracao_adi_id
--and eidl.item_id = msi.inventory_item_id
--and eidl.invoice_lin_id = eiil.invoice_lin_id
--and eii.invoice_id = eiil.invoice_id
--and eiil.utilizacao_id = ecu.utilizacao_id
and eid.embarque_id = eie.embarque_id
--and eie.embarque_id = eivnfe.embarque_id
and eie.organizacao_id = eco.organizacao_id
--and eie.conhec_id = eic.conhec_id
--and ect.tipo = 912
--and eic.via_transporte_id = ect.tabela_id
--and msi.segment1 = '5264644'

UNION
Select 
ece.cnpj "CNPJ",
ece.codigo "Empresa",
eco.codigo "Org.",
eid.nr_declaracao "Nr. DI/DA",
(eie.embarque_num||'/'||eie.embarque_ano) "Embarque eComex"
--eivnfe.numero_documento_fiscal "NFE",
--eivnfe.serie "Serie",
--eivnfe.data_emissao_documento_fiscal "Dt.Emissão",
--eivnfe.id_envio_recebto "ID Envio RI",
--eivnfe.dt_envio_recebto "Dt.Envio RI"

from 
ecomex.imp_declaracoes eid,
ecomex.imp_declaracoes_adi eida,
ecomex.imp_declaracoes_lin eidl,
--apps.mtl_system_items msi,
--ecomex.cmx_tab_ncm ctn,
ecomex.imp_embarques eie,
ecomex.cmx_organizacoes eco,
--ecomex.imp_invoices eii,
--ecomex.imp_invoices_lin eiil,
--ecomex.cmx_utilizacoes ecu,
--ecomex.imp_conhecimentos eic,
--ecomex.cmx_tabelas ect,
ecomex.cmx_empresas ece
--ecomex.IMP_VW_NF_ELETRONICA eivnfe

where
    eid.dt_declaracao between '01-jan-2024' and '14-jul-2024'
--and eid.empresa_id = 100010
and eco.codigo = 'U52'
and eid.empresa_id = ece.empresa_id
and eid.declaracao_id = eida.declaracao_id
--and eida.class_fiscal_id = ctn.ncm_id
and eida.declaracao_adi_id = eidl.declaracao_adi_id
--and eidl.item_id = msi.inventory_item_id
--and eidl.invoice_lin_id = eiil.invoice_lin_id
--and eii.invoice_id = eiil.invoice_id
--and eiil.utilizacao_id = ecu.utilizacao_id
and eid.embarque_id = eie.embarque_id
--and eie.embarque_id = eivnfe.embarque_id
and eie.organizacao_id = eco.organizacao_id
--and eie.conhec_id = eic.conhec_id
--and ect.tipo = 912
--and eic.via_transporte_id = ect.tabela_id
--and msi.segment1 = '5264644'

;

