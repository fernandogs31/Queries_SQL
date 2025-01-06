Select distinct 
eid.nr_declaracao,
eida.adicao_num,
eidl.item_id,
msi.segment1,
ctn.codigo,
ctn.aliq_II,
eidl.basecalc_II

from 
ecomex.imp_declaracoes eid,
ecomex.imp_declaracoes_adi eida,
ecomex.imp_declaracoes_lin eidl,
apps.mtl_system_items msi,
ecomex.cmx_tab_ncm ctn,
ecomex.imp_embarques eie,
ecomex.cmx_organizacoes eco

where
    eid.dt_declaracao between '01-jan-2023' and '31-jan-2024'
and eid.empresa_id = 100010
and eco.organizacao_id = 4849
and eid.declaracao_id = eida.declaracao_id
and eida.declaracao_adi_id = eidl.declaracao_adi_id
and eidl.item_id = msi.inventory_item_id
and eida.class_fiscal_id = ctn.ncm_id
and eid.embarque_id = eie.embarque_id
and eie.organizacao_id = eco.organizacao_id;
