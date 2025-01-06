select esu.*, ece.codigo
from ecomex.sen_usuarios esu
    ,ecomex.sen_privorg_usuarios espu
    ,ecomex.cmx_empresas ece
where esu.id = espu.usuario_id
and espu.empresa_id = ece.empresa_id