SELECT
----------------------------------------------------------
-- Party Information
----------------------------------------------------------
         hp.party_number "Registry ID", hp.party_name "Party Name",
         hp.party_type "Party Type",
         DECODE (hp.status,
                 'A', 'Active',
                 'I', 'Inactive',
                 hp.status
                ) "Party Status",
 
----------------------------------------------------------
-- Account Information
----------------------------------------------------------
         hca.account_number "Account Number",
         DECODE (hca.status,
                 'A', 'Active',
                 'I', 'Inactive',
                 hca.status
                ) "Account Status",
         hca.account_name "Account Description",
         hca.customer_class_code "Classification",
         DECODE (hca.customer_type,
                 'R', 'External',
                 'I', 'Internal',
                 hca.customer_type
                ) "Account Type",
 
----------------------------------------------------------
-- Site Information
----------------------------------------------------------
         hps.party_site_number "Customer Site Number",
         DECODE (hcas.status, 'A', 'Active', 'Inactive') "Site Status",
         DECODE (hcas.bill_to_flag,
                 'P', 'Primary',
                 'Y', 'Yes',
                 hcas.bill_to_flag
                ) "Bill To Flag",
         DECODE (hcas.ship_to_flag,
                 'P', 'Primary',
                 'Y', 'Yes',
                 hcas.ship_to_flag
                ) "Ship To Flag",
         hcas.cust_acct_site_id "Customer Acct Site ID",
 
----------------------------------------------------------
-- Address Information
----------------------------------------------------------
         hl.address1 "Address1", hl.address2 "Address2",
         hl.address3 "Address3", hl.address4 "Address4", hl.city "City",
         hl.state "State", hl.postal_code "Zip Code",hl.country "Country",ter.NAME "Territory",
 
----------------------------------------------------------
-- DFF Information (specific to client)
----------------------------------------------------------
         hcas.attribute4 "SMG Key", hcas.attribute8 "GLN Key",
         hca.attribute3 "Credit Approval Date",
         hca.attribute7 "Credit Approved By",
         hca.attribute4 "Acct Opened Date",
         hca.attribute5 "Credit Collection Status",
         hca.attribute1 "BPCS Last Trx Date",
         hca.attribute2 "BPCS Avg Pay Days",
         hca.attribute6 "BPCS RCM Reference",
----------------------------------------------------------
-- Collector Information
----------------------------------------------------------
        col.NAME "Collector Name",
 
----------------------------------------------------------
-- Account Profile Information
----------------------------------------------------------
         hcp.credit_checking "Credit Check Flag",
         hcp.credit_hold "Credit Hold Flag",
         hcpa.auto_rec_min_receipt_amount "Min Receipt Amount",
         hcpa.overall_credit_limit "Credit Limit",
         hcpa.trx_credit_limit "Order Credit Limit",
 
--------------------------------------------------------
-- Attachment Flag
----------------------------------------------------------
         NVL ((SELECT 'Y'
                 FROM apps.fnd_documents_vl doc,
                      apps.fnd_lobs blo,
                      apps.fnd_attached_documents att
                WHERE doc.media_id = blo.file_id
                  AND doc.document_id = att.document_id
                  AND att.entity_name = 'AR_CUSTOMERS'
                  AND att.pk1_value = hca.cust_account_id
                  AND ROWNUM = 1),
              'N'
             ) "Attachment Flag",
 
----------------------------------------------------------
-- Party Relationship Flag
----------------------------------------------------------
         NVL
            ((SELECT 'Y'
                FROM apps.hz_cust_acct_relate_all hzcar
               WHERE hzcar.cust_account_id = hca.cust_account_id
                 AND hzcar.relationship_type = 'ALL'
                 AND ROWNUM = 1),
             'N'
            ) "Party Relationship Flag",
 
----------------------------------------------------------
-- Account Relationship Flag
----------------------------------------------------------
         NVL
            ((SELECT 'Y'
                FROM apps.hz_cust_acct_relate_all hzcar
               WHERE hzcar.cust_account_id = hca.cust_account_id
                     AND ROWNUM = 1),
             'N'
            ) "Account Relationship Flag",
 
----------------------------------------------------------
-- Party Contact Flag
----------------------------------------------------------
         NVL
            ((SELECT 'Y'
                FROM apps.hz_parties hp2
               WHERE 1 = 1
                 AND hp2.party_id = hp.party_id
                 AND (   hp2.url IS NOT NULL
                      OR
                         -- LENGTH(TRIM(hp.email_address)) > 5
                         INSTR (hp2.email_address, '@') > 0
                      OR hp2.primary_phone_purpose IS NOT NULL
                     )),
             'N'
            ) "Party Contact Flag",
 
----------------------------------------------------------
-- Account Contact Flag
----------------------------------------------------------
         NVL
            ((SELECT 'Y'
                FROM apps.hz_contact_points
               WHERE STATUS = 'A'
                 AND owner_table_id =
                        (SELECT hcar.party_id
                           FROM apps.hz_cust_account_roles hcar, apps.ar_contacts_v acv
                          WHERE hcar.cust_account_id = hca.cust_account_id
                            AND hcar.cust_account_role_id = acv.contact_id
                            AND hcar.cust_acct_site_id IS NULL
                            -- look for account level only
                            AND ROWNUM = 1
                                          -- add this row to show inactive sites (i.e. with no site id)
                        )
                 AND ROWNUM = 1),
             'N'
            ) "Account Contact Flag",
 
----------------------------------------------------------
-- Site Contact Flag
----------------------------------------------------------
         NVL
            ((SELECT 'Y'
                FROM apps.hz_contact_points
               WHERE STATUS = 'A'
                 AND owner_table_id =
                        (SELECT hcar.party_id
                           FROM apps.hz_cust_account_roles hcar, apps.ar_contacts_v acv
                          WHERE hcar.cust_acct_site_id = hcas.cust_acct_site_id
                            AND hcar.cust_account_role_id = acv.contact_id
                            AND ROWNUM = 1
                                          -- add this row to show inactive sites (i.e. with no site id)
                        )
                 AND ROWNUM = 1),
             'N'
            -- any contact (email, phone, fax) would suffice this condition
            ) "Site Contact Flag",

-- Brazil Details Account
---------------------------------------------------------------
(DECODE(hcas.global_attribute2 ,2,'CNPJ'
                               ,1,'CPF'
                               ,3,'OTHERS')) "Type Inscription",
(hcas.global_attribute3||hcas.global_attribute4||hcas.global_attribute5) "Federal Inscription",
 hcas.global_attribute6 "State Incsription",
 hcas.global_attribute7 "Municipal Inscription",
 hcas.global_attribute8 "Type Contributor",
            
-- Site GL Accounts 
---------------------------------------------------------------
(SELECT gcc.concatenated_segments
                FROM apps.HZ_CUST_SITE_USES_ALL hcsua, apps.gl_code_combinations_kfv gcc
               WHERE gcc.code_combination_id = hcsua.gl_id_rec
               AND hcsua.cust_acct_site_id = hcas.cust_acct_site_id
               AND  ROWNUM = 1) "Receivables account",

(SELECT gcc.concatenated_segments
                FROM apps.HZ_CUST_SITE_USES_ALL hcsua, apps.gl_code_combinations_kfv gcc
               WHERE gcc.code_combination_id = hcsua.gl_id_rev
               AND hcsua.cust_acct_site_id = hcas.cust_acct_site_id
               AND  ROWNUM = 1) "Revenue account",

(SELECT gcc.concatenated_segments
                FROM apps.HZ_CUST_SITE_USES_ALL hcsua, apps.gl_code_combinations_kfv gcc
               WHERE gcc.code_combination_id = hcsua.gl_id_tax
               AND hcsua.cust_acct_site_id = hcas.cust_acct_site_id
               AND  ROWNUM = 1) "Tax account",

(SELECT gcc.concatenated_segments
                FROM apps.HZ_CUST_SITE_USES_ALL hcsua, apps.gl_code_combinations_kfv gcc
               WHERE gcc.code_combination_id = hcsua.gl_id_freight
               AND hcsua.cust_acct_site_id = hcas.cust_acct_site_id
               AND  ROWNUM = 1) "Freight account",

(SELECT gcc.concatenated_segments
                FROM apps.HZ_CUST_SITE_USES_ALL hcsua, apps.gl_code_combinations_kfv gcc
               WHERE gcc.code_combination_id = hcsua.gl_id_clearing
               AND hcsua.cust_acct_site_id = hcas.cust_acct_site_id
               AND  ROWNUM = 1) "Clearing account",

(SELECT gcc.concatenated_segments
                FROM apps.HZ_CUST_SITE_USES_ALL hcsua, apps.gl_code_combinations_kfv gcc
               WHERE gcc.code_combination_id = hcsua.gl_id_unbilled
               AND hcsua.cust_acct_site_id = hcas.cust_acct_site_id
               AND  ROWNUM = 1) "Unbilled account",

(SELECT gcc.concatenated_segments
                FROM apps.HZ_CUST_SITE_USES_ALL hcsua, apps.gl_code_combinations_kfv gcc
               WHERE gcc.code_combination_id = hcsua.gl_id_unpaid_rec
               AND hcsua.cust_acct_site_id = hcas.cust_acct_site_id
               AND  ROWNUM = 1) "Unpaid Receivables account",

(SELECT gcc.concatenated_segments
                FROM apps.HZ_CUST_SITE_USES_ALL hcsua, apps.gl_code_combinations_kfv gcc
               WHERE gcc.code_combination_id = hcsua.gl_id_unearned
               AND hcsua.cust_acct_site_id = hcas.cust_acct_site_id
               AND  ROWNUM = 1) "Unearned account",

(SELECT gcc.concatenated_segments
                FROM apps.HZ_CUST_SITE_USES_ALL hcsua, apps.gl_code_combinations_kfv gcc
               WHERE gcc.code_combination_id = hcsua.gl_id_remittance
               AND hcsua.cust_acct_site_id = hcas.cust_acct_site_id
               AND  ROWNUM = 1) "Remittance account"
           
    FROM apps.hz_parties hp,
         apps.hz_party_sites hps,
         apps.hz_cust_accounts_all hca,
         apps.hz_cust_acct_sites_all hcas,
          apps.hz_customer_profiles hcp,
          apps.hz_cust_profile_amts hcpa,
          apps.hz_locations hl,
          apps.ra_territories ter,
          apps.ar_collectors col
   WHERE 1 = 1
     AND hp.party_id = hca.party_id
     AND hca.cust_account_id = hcas.cust_account_id(+)
     AND hps.party_site_id(+) = hcas.party_site_id
     AND hp.party_id = hcp.party_id
     AND hca.cust_account_id = hcp.cust_account_id
     AND hps.location_id = hl.location_id(+)
     AND col.collector_id = hcp.collector_id
     AND hcas.territory_id = ter.territory_id(+)
     AND hcp.cust_account_profile_id = hcpa.cust_account_profile_id(+)
     AND hcas.org_id = 4330
     ----
     --AND hp.party_type = 'ORGANIZATION'       -- only ORGANIZATION Party types
     AND hp.status = 'A'                      -- only Active Parties/Customers
----
-- comment/uncomment as needed
----
--AND hl.country = 'BR'
--AND hp.party_number        = '3306979'
--AND hca.account_number     = '16748124'
ORDER BY TO_NUMBER (hp.party_number), hp.party_name, hca.account_number;