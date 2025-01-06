select eief.*, eiefp.empresa_id, ece.codigo
from ecomex.imp_excecoes_fiscais eief
    ,ecomex.imp_excecoes_fiscais_emp eiefp
    ,ecomex.cmx_empresas ece
where --eief.tipo = 'II'
  eiefp.excecao_id = eief.excecao_id
and   eiefp.empresa_id = ece.empresa_id