select eif.*, eifs.*
from ecomex.imp_fabricantes eif,
     ecomex.imp_fabricantes_sites eifs
where eif.fabric_id = eifs.fabric_id

//

select eie.*,eies.*
from ecomex.imp_entidades eie,
ecomex.imp_entidades_sites eies
where eie.entidade_id = eies.entidade_id
