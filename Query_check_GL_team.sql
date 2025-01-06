Select *
from gems_gl.ge_journal_details
where set_of_books_id in ( 1186 , 230 )
--and trunc(accounting_date) = TO_DATE('2018/11/10', 'yyyy/mm/dd')
--
-- Trocar a origem ou comentar para pegar os outros modulos:
--
--AND journal_source = 'Periodic Inventory'
--AND journal_category = 'Inventory(1)'
--AND journal_batch = 'Cost Management A 57552966 961284852'
AND period = '07JUL-24'
--AND to_char(DATE_CREATED,'yymmdd') > '220131';