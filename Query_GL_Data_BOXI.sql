SELECT accounting_date
    ,code_combination_id
    ,journal_source
    ,journal_category
    ,period
    ,segment5
    ,segment7
    ,inv_item_num
    ,po_num
    ,journal_batch
    ,journal_name
    ,journal_line_desc
    ,batch_description
    ,document_num
    ,order_num
    ,segment2
    ,segment1
    ,segment3
    ,segment4
    ,segment5
    ,segment6
    ,segment7
    ,segment8
    ,segment9
    ,currency_code
    ,(accounted_dr -  accounted_dr
    ,(mor_converted_dr - mor_converted_cr)
    ,(op_converted_dr - op_converted_dr)
    ,transaction_code
    ,inventory_org
    ,legacy_account
    ,line_description


FROM gems_gl.ge_journal_details
WHERE set_of_books_id in ( 1186 , 230 )
--and trunc(accounting_date) = TO_DATE('2018/11/10', 'yyyy/mm/dd')
--journal_source = 'BR Remittances'
--AND journal_category = 'Inventory(1)'
--AND journal_batch = 'Cost Management A 57552966 961284852'
--AND period = '07JUL-24'
AND status = 'PROCESSED'
--AND inventory_org in ('DMG')
AND accounting_date between '01-JAN-24' and '31-JAN-24'
;