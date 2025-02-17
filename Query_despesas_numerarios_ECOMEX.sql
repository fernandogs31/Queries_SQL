SELECT
DECODE(ein.empresa_id,100010,'BONDED SAO PAULO',
                      100009,'CONTAGEM',
                      100012,'RECIFE',
                      100013,'ITAJAI',
                      100014,'SAO PAULO',
                      100015,'MDI ITAPEVI',
                      100016,'DIV ITAPEVI') "EMPRESA",
ein.nr_referencia,
eie.nome "FORNECEDOR",
eies.codigo "FORNECEDOR SITE",
ein.data_aprovacao,
ein.creation_date,
esu.nm_usuario "USUARIO",
eitp.descricao "TERMO PAGAMENTO",
ecnp.codigo_numerario "DESPESA",
eind.valor_mn "VALOR",
eind.data_despesa,
eie.embarque_num,
eie.embarque_ano

FROM
ecomex.imp_numerarios ein,
ecomex.imp_numerarios_dsp eind,
ecomex.imp_numerarios_ebq eine,
ecomex.imp_entidades eie,
ecomex.imp_entidades_sites eies,
ecomex.sen_usuarios esu,
ecomex.imp_termos_pgto eitp,
ecomex.imp_embarques eie,
ecomex.cmx_vw_numerarios_param ecnp

WHERE 
    ein.creation_date between '01-jan-2024' and '29-feb-2024'
AND ein.numerario_id = eind.numerario_id
AND ein.entidade_id = eie.entidade_id
AND ein.entidade_site_id = eies.entidade_site_id
AND eind.numerario_id = eine.numerario_id
AND ein.created_by = esu.id
AND ein.termo_id = eitp.termo_id
AND eine.embarque_id = eie.embarque_id
AND eind.numer_param_id = ecnp.numer_param_id
AND ein.empresa_id = 100010
AND ecnp.codigo_numerario = 'ANVISA_BARUERI_NAC'