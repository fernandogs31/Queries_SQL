Select distinct 
eco.codigo "Org",
eid.nr_declaracao "DI/DA",
eid.dt_declaracao "Data_DI/DA",
ect.codigo "URFD",
(eie.embarque_num||'/'||eie.embarque_ano)"Embarque"
--eida.adicao_num,
--eidl.item_id,
--msi.segment1,
--ctn.codigo
--ctn.aliq_II,
--eidl.basecalc_II

from 
ecomex.imp_declaracoes eid,
ecomex.imp_declaracoes_adi eida,
ecomex.imp_declaracoes_lin eidl,
apps.mtl_system_items msi,
ecomex.cmx_tab_ncm ctn,
ecomex.imp_embarques eie,
ecomex.cmx_organizacoes eco,
ecomex.cmx_tabelas ect

where
    eid.dt_declaracao between '01-may-2023' and '28-may-2024'
--and eid.empresa_id = 100010
and eco.organizacao_id in (10366, 10367)
and eid.declaracao_id = eida.declaracao_id
and eida.declaracao_adi_id = eidl.declaracao_adi_id
and eidl.item_id = msi.inventory_item_id
and eida.class_fiscal_id = ctn.ncm_id
and eid.embarque_id = eie.embarque_id
and eie.organizacao_id = eco.organizacao_id
and eid.urfd_id = ect.tabela_id

Order by (eie.embarque_num||'/'||eie.embarque_ano);