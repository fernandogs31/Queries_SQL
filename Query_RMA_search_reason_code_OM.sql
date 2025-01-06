select ool.line_id, ooh.order_number, ott.name, OOH.CUST_PO_NUMBER, ool.FLOW_STATUS_CODE, ool.split_from_line_id,ool.*
  from apps.oe_order_headers_all ooh, apps.oe_order_lines_all ool , apps.oe_transaction_types_tl ott
where ooh.header_id = ool.header_id
and ott.transaction_type_id = ooh.order_type_id  --and order_number in ('372358234') 
and ool.RETURN_REASON_CODE LIKE UPPER('WRONG PART')--,'105873345','105873349')
AND ool.FLOW_STATUS_CODE NOT IN ('CLOSED','CANCELLED') AND OOL.ORG_ID = 4330

