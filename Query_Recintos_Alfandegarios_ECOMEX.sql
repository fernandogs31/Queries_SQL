Select DISTINCT --ect.auxiliar1 "URFD",
                --ect.auxiliar6 "Recinto", 
                --ect.descricao "Descricao Recinto", 
                ect.tabela_id,
                ect.tipo,
                ect.codigo,
                ect.descricao,
                ect.auxiliar1 "URFD",
                ect.auxiliar6 "RECINTO",
                ect.auxiliar4 "DT_INICIO",
                ect.auxiliar5 "DT_FIM",
                ect1.auxiliar1 "SETOR",
                ect1.descricao "DESCRICAO_SETOR",
                ect.creation_date,
                ect.CREATED_BY,
                ect.LAST_UPDATE_DATE,
                ect.LAST_UPDATED_BY
                --ect.*
               

From ecomex.cmx_tabelas ect,
     ecomex.cmx_tabelas ect1

where ect.tipo = 115
  and ect.auxiliar1 = '0617700'
  and ect.auxiliar6 = '6923201'
  and ect.auxiliar6 = ect1.auxiliar3
--and ect1.auxiliar5 is NULL
order by ect.auxiliar6,
         ect.descricao
;
