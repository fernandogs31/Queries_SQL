SELECT eief.tipo "Exceção Tipo"
,decode(eief.regtrib_id,'5451','INTEGRAL') "Regime Tributação"
,eief.descricao "Exceção Descrição"
,eief.aliquota "Exceção Alíquota"
,ectn.codigo "NCM"
,eief.inicio_vigencia "Exceção Data Inicial"
,eief.fim_vigencia "Exceção Data Fim"
,eief.data_inativacao "Execeção Data Inativação"
,decode(eiefl.operacao, 'I', 'Inclusão', 'E', 'Exclusão') "Exceção Operação"
,eiefl.faixa_de_codigo "Faixa de NCM/Item"
,eiefl.faixa_ate_codigo "Faixa até NCM/Item"
,ece.codigo "Exceção Empresa Associada"

FROM
     ecomex.imp_excecoes_fiscais eief
    ,ecomex.imp_excecoes_fiscais_emp eiefp
    ,ecomex.cmx_empresas ece
    ,ecomex.imp_excecoes_fiscais_lin eiefl
    ,ecomex.imp_ex_tarifario eiet
    ,ecomex.cmx_tab_ncm ectn

WHERE 
      eief.tipo = 'II'
AND   eiefp.excecao_id = eief.excecao_id
AND   eiefl.excecao_id = eief.excecao_id
AND   eiet.ex_tarifario_id = eief.ex_ncm_id
AND   eiet.ncm_id = ectn.ncm_id
AND   eiefp.empresa_id = ece.empresa_id
;

select *
from ecomex.cmx_tab_ncm ectn