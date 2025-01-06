SELECT DISTINCT eccp.produto_id "ecomex_cp_id"
      ,eccpc.codigo "pucomex_id"
      ,eccp.denominacao "denominacao"
      ,eccp.descricao "detalham_compl_prod"
      ,eccp.modalidade "modalidade"
      ,eccp.ncm "ncm"
      ,DECODE (eccp.origem, 1 , 'Manual'
                          , 2 , 'Portal único'
                          , 4 , 'Carga excel') "tipo_criacao"
      ,eccpa.atributo "atributo"
      ,ecctna.nomeapresentacao "desc_atributo"
      ,eccpa.valor "dominio"
      ,eccpa.descricao "desc_dominio"      
      ,eccpc.cpfcnpjraiz "cnpj_raiz"
      ,eccpc.situacao "situacao"
      ,eccpc.versao "versao"
      ,eccpc.dt_ult_envio "dt_ult_envio"
      ,eccpc.status "status"
      ,eccpi.codigointerno "PN"
      ,eccpo.conhecido "fabricante_conhec"
      ,eccpo.operador_id "ecomex_operador_id"
      ,eccpo.codigopais "cod_pais"
      

FROM ecomex.cmx_catalogo_produto eccp
    ,ecomex.cmx_catalogo_produto_atrib eccpa
    ,ecomex.cmx_catalogo_produto_cnpj eccpc
    ,ecomex.cmx_catalogo_produto_item eccpi
    ,ecomex.cmx_catalogo_produto_op eccpo
    ,ecomex.cmx_vw_tab_ncm_atributos_brw ecctna
    
WHERE
    eccp.produto_id = eccpa.produto_id
AND eccpa.ncm_atributo_id = ecctna.ncm_atributo_id
AND eccp.produto_id = eccpc.produto_id
AND eccp.produto_id = eccpi.produto_id
AND eccp.produto_id = eccpo.produto_id
;