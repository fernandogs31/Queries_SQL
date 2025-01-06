Select eie.entidade_id
,eie.codigo
,eie.nome
,eies.entidade_site_id
,eies.codigo
,eies.endereco
,eies.operating_unit_id
from ecomex.imp_entidades eie
,ecomex.imp_entidades_sites eies
,ecomex.cmx_vw_carga_operador_estrang ecvcoe
where
eie.entidade_id = eies.entidade_id
and eies.operating_unit_id = 4330
and eies.entidade_site_id = ecvcoe.entidade_site_id
--and ecvcoe.entidade_site_id = 11522045
and eie.codigo = '559787'
--and eies.entidade_site_id = 11522045
;

select ecvcoe.*
from ecomex.cmx_vw_carga_operador_estrang ecvcoe
where ecvcoe.entidade_codigo = '559787'
and ecvcoe.site_codigo like '%H01163 -WXB'
--and ecvcoe.entidade_site_id = 924663
order by ecvcoe.entidade_site_id asc
;

16840118 -- HC1338
2356414 -- WXB