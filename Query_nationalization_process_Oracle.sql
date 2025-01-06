select *
from apps.ge_gpo_nationalization_line	natl,
apps.ge_gpo_nationalization_header nath

where nath.nationalization_so_line_id = natl.nationalization_so_line_id
--and natl.creation_date >='20-AUG-24'
and natl.nationalization_so_line_id = 373353367

SELECT *
          FROM apps.ge_gpo_nationalization_line ggml
       WHERE 1=1  --and LPN_ID =58579397; 
         AND nationalization_so_line_id in (372145996);