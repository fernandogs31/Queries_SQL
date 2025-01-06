SELECT 'ARinvoice' SOURCE,
       (SELECT h.party_name
          FROM apps.hz_parties                   h,
               apps.hz_cust_accounts_all         c,
               apps.hz_cust_acct_sites_all       u,
               apps.hz_cust_site_uses_all        s,
               apps.ra_customer_trx_all          i,
               apps.ra_cust_trx_line_gl_dist_all d
         WHERE i.customer_trx_id = d.customer_trx_id
           AND d.event_id = e.event_id
           AND h.party_id = c.party_id
           AND c.cust_account_id = u.cust_account_id
           AND u.cust_acct_site_id = s.cust_acct_site_id
           AND s.site_use_id = i.bill_to_site_use_id
           AND s.site_use_code = 'BILL_TO'
         GROUP BY h.party_name) pname,
       (SELECT h.party_id
          FROM apps.hz_parties                   h,
               apps.hz_cust_accounts_all         c,
               apps.hz_cust_acct_sites_all       u,
               apps.hz_cust_site_uses_all        s,
               apps.ra_customer_trx_all          i,
               apps.ra_cust_trx_line_gl_dist_all d
         WHERE i.customer_trx_id = d.customer_trx_id
           AND d.event_id = e.event_id
           AND h.party_id = c.party_id
           AND c.cust_account_id = u.cust_account_id
           AND u.cust_acct_site_id = s.cust_acct_site_id
           AND s.site_use_id = i.bill_to_site_use_id
           AND s.site_use_code = 'BILL_TO'
         GROUP BY h.party_id) pid,
       h.accounting_date,
       (SELECT i.trx_number
          FROM apps.ra_customer_trx_all i, apps.ra_cust_trx_line_gl_dist_all d
         WHERE i.customer_trx_id = d.customer_trx_id
           AND d.event_id = e.event_id
         GROUP BY i.trx_number) docnumber,
        (SELECT j.name
          FROM apps.ra_customer_trx_all i, apps.ra_cust_trx_types_all j,apps.ra_cust_trx_line_gl_dist_all d
         WHERE i.customer_trx_id = d.customer_trx_id
           AND d.event_id = e.event_id
           AND i.cust_trx_type_id = j.cust_trx_type_id
           GROUP BY j.name) ARtype,
        (SELECT i.interface_header_attribute2
          FROM apps.ra_customer_trx_all i, apps.ra_cust_trx_line_gl_dist_all d
         WHERE i.customer_trx_id = d.customer_trx_id
           AND d.event_id = e.event_id
           GROUP BY i.interface_header_attribute2) OMtype,
       h.gl_transfer_status_code,
       h.je_category_name,
       h.doc_sequence_value,
       h.doc_category_code,
       l.accounting_class_code,
       l.ae_line_num,
       g.segment1,
       g.segment2,
       g.segment3,
       g.segment4,
       g.segment5,
       g.segment6,
       g.segment7,
       g.segment8,
       g.segment9,
       l.gl_transfer_mode_code,
       l.accounted_dr,
       l.accounted_cr,
       l.description,
       l.currency_code,
       l.currency_conversion_date,
       l.currency_conversion_rate,
       gj.NAME btchname,
       gh.NAME hdrname,
       gh.je_source,
       gh.je_category,
       gh.status,
       gh.period_name
  FROM apps.xla_events               e,
       apps.xla_ae_headers           h,
       apps.xla_ae_lines             l,
       apps.gl_code_combinations_kfv g,
       apps.gl_import_references     gi,
       apps.gl_je_batches            gj,
       apps.gl_je_headers            gh,
       apps.gl_je_lines              gl
 WHERE e.event_id = h.event_id
   AND h.ae_header_id = l.ae_header_id
   AND l.application_id = 222
   AND h.je_category_name IN ('Sales Invoices', 'Credit Memos')
   AND l.code_combination_id = g.code_combination_id
   AND gi.je_batch_id = gj.je_batch_id
   AND gj.je_batch_id = gh.je_batch_id
   AND gi.je_header_id = gh.je_header_id
   AND gi.je_header_id = gl.je_header_id
   AND gh.je_header_id = gl.je_header_id
   AND gi.je_line_num = gl.je_line_num
   AND gi.gl_sl_link_id = l.gl_sl_link_id
   AND h.accounting_date BETWEEN '01-JAN-2022' AND SYSDATE
   AND g.segment1 = '1106'
   --AND gh.ledger_id in (230,1186)
   AND gh.period_name = '09SEP-22'
   AND gi.gl_sl_link_table = l.gl_sl_link_table
   AND gh.status = 'P'
   ;