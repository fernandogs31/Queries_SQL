SELECT eif.codigo "Cód.Fornecedor / Fabricante"
,eifs.codigo "Site"
,null "Cód. Interno"
,eifs.codigo_tin "TIN"
,eif.nome "Nome"
,eifs.endereco "Endereço"
,eifs.cidade "Cidade"
,null "Subdivisão"
,eifs.cep "Cód. Postal"
,(Select ectb.auxiliar1 from ecomex.cmx_tabelas_b ectb where ectb.tipo = '902' and ectb.tabela_id = eifs.pais_id) "Cód. País"
,null "E-mail"
,null "Nr. Ident. Adic."
,null "Cód. Ag. Emis."
,'00029372' "Raiz CNPJ"
,null "Versão"
,'RASCUNHO' "Situação"
,2 "Status"
,'S' "Fabricante (S/N)"
,null "Cód. PUCOMEX"
,'06/11/2024' "dataReferencia"

FROM 
ecomex.imp_fabricantes eif
,ecomex.imp_fabricantes_sites eifs

WHERE 
    eif.fabric_id = eifs.fabric_id
AND eif.data_inativacao is null
;