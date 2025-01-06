SELECT ie.embarque_num,ie.embarque_ano,ie.empresa_id,ie.organizacao_id,cma.*
FROM ecomex.imp_embarques ie
INNER JOIN ecomex.cmx_vw_documentos_anexos cma on cma.documento_id = ie.embarque_id
WHERE 1=1 
AND ie.creation_date >= '01-MAR-24'
--AND ie.embarque_num = 11
--AND ie.embarque_ano = 2024

//

(SELECT ie.embarque_id
FROM ecomex.imp_embarques ie
WHERE CASE WHEN EXISTS (select cma.documento_id from ecomex.imp_embarques ie,ecomex.cmx_vw_documentos_anexos cma where cma.documento_id = ie.embarque_id) THEN 1
ELSE 0 END = 1
AND ie.creation_date >= '01-MAR-24')

//

select *
from ecomex.imp_embarques
where embarque_id = 230630

//

select *
from ecomex.CMX_VW_DOCUMENTOS_ANEXOS
where creation_date >='28-mar-2024'

//

select *
from ecomex.CMX_PROGRAMAS_B
where id in (115,100003)