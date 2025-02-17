SELECT OOD.ORGANIZATION_CODE    "Inv Org",
       RCT.CUSTOMER_TRX_ID      "Customer ID",
       RCT.TRX_NUMBER           "Invoice Number", 
       RCT.CREATION_DATE        "Invoice Date",
       RCT_canc.trx_number      "CM Number",
       RCT_canc.trx_date        "CM Date",
       RCT_name.Name            "Transaction Type",
       RCT.status_trx          "Status",
       
       DECODE(JL.ELECTRONIC_INV_STATUS,
           '1','Enviada',
           '2','Finalizada', 
           '3','Error',
           '4','Cancelada',
           '5','Rejeitada',
          '6','Inutilizada',
           '7','Contingencia' ) STATUS_NFE,
       JL.ELECTRONIC_INV_ACCESS_KEY CHAVE_NFE,
      
      -- Customer
      (
       SELECT HP.PARTY_NAME
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
          AND HCSUA.SITE_USE_ID = RCT.BILL_TO_SITE_USE_ID
          ) CUSTOMER          
          ,  
       -- Customer Number       
      (
       SELECT HCAA.ACCOUNT_NUMBER
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
          AND HCSUA.SITE_USE_ID = RCT.BILL_TO_SITE_USE_ID
          ) CUSTOMER_NUMBER         
          ,             
      -- Ship-To
      (
       SELECT HCSUA.LOCATION
         FROM APPS.HZ_CUST_SITE_USES_ALL  HCSUA
             ,APPS.HZ_CUST_ACCT_SITES_ALL HCASA
             ,APPS.HZ_CUST_ACCOUNTS_ALL   HCAA
             ,APPS.HZ_PARTIES             HP
             ,APPS.HZ_PARTY_SITES         HPS 
             ,APPS.HZ_LOCATIONS           HL
             ,APPS.HR_ALL_ORGANIZATION_UNITS  HOU   

 

        WHERE HCSUA.CUST_ACCT_SITE_ID = HCASA.CUST_ACCT_SITE_ID
          AND HCASA.CUST_ACCOUNT_ID = HCAA.CUST_ACCOUNT_ID
          AND HCAA.PARTY_ID = HPS.PARTY_ID
          AND HP.PARTY_ID = HPS.PARTY_ID
          AND HCASA.PARTY_SITE_ID = HPS.PARTY_SITE_ID
          AND HPS.LOCATION_ID = HL.LOCATION_ID
          AND HCSUA.ORG_ID = HOU.ORGANIZATION_ID
          AND HCSUA.SITE_USE_CODE = 'SHIP_TO'
          AND HCSUA.SITE_USE_ID = RCT.SHIP_TO_SITE_USE_ID) SHIP_TO
     ,          
     -- Bill-To
     (
     SELECT HCSUA.LOCATION
       FROM APPS.HZ_CUST_SITE_USES_ALL  HCSUA
           ,APPS.HZ_CUST_ACCT_SITES_ALL HCASA
           ,APPS.HZ_CUST_ACCOUNTS_ALL   HCAA
           ,APPS.HZ_PARTIES             HP
           ,APPS.HZ_PARTY_SITES         HPS 
           ,APPS.HZ_LOCATIONS           HL
           ,APPS.HR_ALL_ORGANIZATION_UNITS  HOU   

 

      WHERE HCSUA.CUST_ACCT_SITE_ID = HCASA.CUST_ACCT_SITE_ID
        AND HCASA.CUST_ACCOUNT_ID = HCAA.CUST_ACCOUNT_ID
        AND HCAA.PARTY_ID = HPS.PARTY_ID
        AND HP.PARTY_ID = HPS.PARTY_ID
        AND HCASA.PARTY_SITE_ID = HPS.PARTY_SITE_ID
        AND HPS.LOCATION_ID = HL.LOCATION_ID
        AND HCSUA.ORG_ID = HOU.ORGANIZATION_ID
        AND HCSUA.SITE_USE_CODE = 'BILL_TO' 
        AND HCSUA.SITE_USE_ID = RCT.BILL_TO_SITE_USE_ID
       ) BILL_TO,
      A_VENDOR.NAME          SALESPERSON,
      RCTL.LINE_NUMBER        Line_Number,
      MSI.SEGMENT1   Part_Number,
      RCTL.quantity_invoiced   QTDE,
      RCTL.sales_order SO,
      OTTT.name Tipo,
      RCTL.unit_selling_price "Vlr.Unit",
      RCTL.GLOBAL_ATTRIBUTE1 CFOP,
      RCTL.GLOBAL_ATTRIBUTE2 NCM ,
      RCTL.GLOBAL_ATTRIBUTE3 TRANSACTION_CLASS,
      RCTL.GLOBAL_ATTRIBUTE4 "Item Origin",
      (select trx_number 
              from apps.ra_customer_trx_all rct_cross
                   where rct_cross.customer_trx_id = rct.RELATED_CUSTOMER_TRX_ID 
                         and rownum = 1) "Cross Reference"
FROM 
      APPS.ORG_ORGANIZATION_DEFINITIONS   OOD,
      APPS.JTF_RS_SALESREPS               A_VENDOR,
      APPS.oe_order_headers_all           OOHA,
      APPS.oe_transaction_types_tl        OTTT,
      APPS.mtl_system_items_b             MSI,
      APPS.RA_CUSTOMER_TRX_ALL            RCT,
      APPS.RA_CUSTOMER_TRX_LINES_ALL      RCTL,
      APPS.RA_CUSTOMER_TRX_ALL            RCT_canc,      
      APPS.JL_BR_CUSTOMER_TRX_EXTS        JL,
      APPS.ra_cust_trx_types_all          RCT_name


WHERE 1=1
  AND rctl.inventory_item_id = msi.inventory_item_id
  and ooha.order_number = RCTL.sales_order
  AND ooha.order_type_id = ottt.transaction_type_id
  AND RCT.CUSTOMER_TRX_ID = RCTL.CUSTOMER_TRX_ID
  AND RCT.ORG_ID = RCTL.ORG_ID
  AND RCTL.LINE_TYPE = 'LINE'
  AND A_VENDOR.ORG_ID (+)= RCT.ORG_ID
  AND RCT.PRIMARY_SALESREP_ID = A_VENDOR.SALESREP_ID(+)
  AND RCTL.WAREHOUSE_ID = OOD.ORGANIZATION_ID
  AND JL.CUSTOMER_TRX_ID(+) = RCT.CUSTOMER_TRX_ID
  and rct.customer_Trx_id = rct_canc.previous_customer_trx_id(+)
  AND rct_name.cust_trx_type_id = rct.cust_trx_type_id
  AND TRUNC(RCT.CREATION_DATE) between  '09-APR-2024' and '10-APR-2024'
--AND TRUNC(RCT.CREATION_DATE) >=  '01-JAN-2019'
--AND RCT.INTERFACE_HEADER_ATTRIBUTE1
  AND OOD.ORGANIZATION_CODE in ('U51', 'U52')
  AND rct.cust_trx_type_id In
       (select cust_trx_type_id
          from apps.ra_cust_trx_types_all
          WHERE NAME LIKE '%INV%')