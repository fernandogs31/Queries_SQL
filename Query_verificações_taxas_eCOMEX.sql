select distinct eet.codigo "Tipo", eet1.codigo "Moeda", eet1.descricao "Descr. Moeda", ect.data, ect.taxa_mn, ect.paridade_uS$, ect.origem_desc
from ecomex.cmx_taxas ect,
     ecomex.cmx_tabelas eet,
     ecomex.cmx_tabelas eet1
where 
ect.moeda_id = eet1.tabela_id
and ect.tipo_id = eet.tabela_id
and ect.data between '20-jan-24' and '30-jan-24'
and ect.moeda_id = 4681



select *
from ecomex.cmx_tabelas
where tipo = '906'
and descricao = 'EURO'