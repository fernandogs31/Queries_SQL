SELECT eco.codigo "ORG"
      ,(eie.embarque_num||'/'||eie.embarque_ano) "Embarque eComex"
      ,eic.house
      ,eic.master
      ,eic.dt_emissao
      ,eii.codigo
      ,eii.nome "Transportadora"
FROM ecomex.imp_conhecimentos eic
    ,ecomex.imp_embarques eie
    ,ecomex.cmx_organizacoes eco
    ,ecomex.imp_entidades eii
WHERE eie.conhec_id = eic.conhec_id
(AND eic.transportador_id = eii.entidade_id
AND eie.organizacao_id = eco.organizacao_id
AND (eco.codigo = 'U52' OR eco.codigo = 'U51')
AND eic.dt_emissao between '01-JAN-23' AND '21-JUN-24')