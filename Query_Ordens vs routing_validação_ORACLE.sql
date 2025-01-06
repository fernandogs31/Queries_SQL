SELECT TRANSACTION_ID,
       a.so_calculate_price_flag,
       source_organization_code,a.so_invoice_to_org_id,
       (SELECT oha.order_number
          FROM apps.oe_order_headers_all oha
         WHERE a.so_header_id = oha.header_id) ORDER_num,
       b.name so_org_name,
       a.creation_date,
       (SELECT status
          FROM apps.hz_cust_site_uses_all hcusu
         WHERE site_use_id = a.so_ship_to_org_id)ship_flag,
       (SELECT  status 
          FROM apps.hz_cust_site_uses_all hcusu
         WHERE site_use_id = a.so_invoice_to_org_id)bill_flag, a.error_message ,a.*
  FROM apps.gems_po_defective_shpmnt_stg a,
       apps.hr_all_organization_units    b
 WHERE TRANSACTION_ID > 28726625
   AND a.so_org_id = b.organization_id
      -- AND a.process_flag <> 'ERROR'
       AND a.so_header_id IS NOT NULL
       AND a.po_org_id IS NULL
   AND a.type = 'OTHER';