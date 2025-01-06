SELECT ecnp.*

FROM ecomex.cmx_numerarios_param ecnp
    ,ecomex.cmx_tabelas ect
    
WHERE ect.tipo = 924
AND ect.tabela_id in (133144
,133145
,133159
,144243
,133662
,135208
,135217)
AND ect.tabela_id = ecnp.cd_numerario_id
;
