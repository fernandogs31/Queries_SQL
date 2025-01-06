SELECT DISTINCT ecvnp.chk_ativo "Ativo ?"
               ,ecvnp.codigo_numerario "Código despesa"
               ,ecvnp.descricao_numerario "Descrição despesa"
               ,ecvnp.entidade_codigo "Código entidade"
               ,ecvnp.entidade_descricao "Entidade"
               ,ecvnp.entidade_site_codigo "Código site"
               ,ecvnp.entidade_site_endereco "Entidade endereço"
               ,ect.descricao "Categoria"
               ,ecvnp.tp_nota "Tipo custo"
               ,decode(ecvnp.tp_rateio,'P', 'Peso líquido'
                                      ,'A', 'Valor aduaneiro'
                                      ,'C', 'CIF + II + IPI') "Tipo rateio"
               ,ecvnp.tp_destino "Destino"
               ,ecvnp.gera_icms "Base de cálculo ICMS"
               ,ecvnp.gera_pis_cofins "Base de cáluclo PIS/COFINS"
               ,ecvnp.assoc_doc_cambio "Associado a documento câmbio ?"
               ,ecvnp.data_inativacao "Data de inativação"
               ,ecvnp.creation_date "Data de criação"
               ,ecvnp.last_update_date "Data de atualização"
               ,ecvnpu.*
FROM   ecomex.CMX_VW_NUMERARIOS_PARAM ecvnp
      ,ecomex.cmx_tabelas ect
      --,ecomex.cmx_tabelas ect1
      ,ecomex.CMX_VW_NUMERARIOS_PARAM_UF ecvnpu
      
WHERE ect.tipo = 925
AND   ecvnp.categoria_id = ect.tabela_id
AND   ecvnp.numer_param_id = ecvnpu.numer_param_id
;
