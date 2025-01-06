  SELECT HCAA.account_number
             ,HP.party_number
             ,HP.party_name
             ,HP.party_type
             ,HPS.party_site_number
             ,DECODE(HCASA.GLOBAL_ATTRIBUTE2,2,'CNPJ'
                                             ,1,'CPF'
                                             ,3,'OTHERS') TYPE_INCSRIPTION
             ,(HCASA.GLOBAL_ATTRIBUTE3||HCASA.GLOBAL_ATTRIBUTE4||HCASA.GLOBAL_ATTRIBUTE5) CNPJ_CPF_OTHERS
             ,HCASA.GLOBAL_ATTRIBUTE6 IE
             ,HCASA.GLOBAL_ATTRIBUTE7 IM
             ,HCASA.GLOBAL_ATTRIBUTE8 CONTRIBUTOR_TYPE
             
         FROM APPS.HZ_CUST_SITE_USES_ALL  HCSUA
             ,APPS.HZ_CUST_ACCT_SITES_ALL HCASA
             ,APPS.HZ_CUST_ACCOUNTS_ALL   HCAA
             ,APPS.HZ_PARTIES             HP
             ,APPS.HZ_PARTY_SITES         HPS 
        WHERE HCSUA.CUST_ACCT_SITE_ID = HCASA.CUST_ACCT_SITE_ID
          AND HCASA.CUST_ACCOUNT_ID = HCAA.CUST_ACCOUNT_ID
          AND HCAA.PARTY_ID = HPS.PARTY_ID
          AND HP.PARTY_ID = HPS.PARTY_ID
          AND HCASA.PARTY_SITE_ID = HPS.PARTY_SITE_ID
          AND HCASA.GLOBAL_ATTRIBUTE_CATEGORY = 'JL.BR.ARXCUDCI.Additional'
          --AND HCSUA.SITE_USE_ID = RCT.BILL_TO_SITE_USE_ID