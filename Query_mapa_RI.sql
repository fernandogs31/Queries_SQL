select  TABLE1.organization_code                                              Org
      , TABLE1.invoice_type_code                                              Invoice_type
      , TABLE1.description                                                    Invoice_type_description
      , TABLE1.validity_key_1                                                 Intended_use
      , TABLE2.cfo_code                                                       CFO
      , TABLE3.validity_key_1                                                 Model
      , TABLE4.validity_key_1                                                 ICMS_type
      , TABLE5.validity_key_1                                                 CST_IPI
      , TABLE6.validity_key_1                                                 CST_ICMS
      , TABLE7.validity_key_1                                                 IPI_taxable_flag
      , TABLE8.validity_key_1                                                 ICMS_taxable_flag
      , TABLE9.validity_key_1                                                 Series
      , TABLE10.validity_key_1                                                CST_COFINS
      , TABLE11.validity_key_1                                                CST_PIS
      , TABLE12.*
      
from (select distinct 
       hou.name
     , mpv.ORGANIZATION_CODE
     , cfit.invoice_type_code
     , cfit.description
     , cfvr.validity_type
     , cfiu.utilization_code validity_key_1
  from apps.Cll_F189_Validity_Rules cfvr,
       apps.cll_f189_invoice_types cfit,
       apps.CLL_F189_ITEM_UTILIZATIONS cfiu,
       apps.mtl_parameters mpv,
       apps.hr_all_organization_units hou
 where mpv.ORGANIZATION_ID = cfvr.organization_id
   and mpv.ORGANIZATION_ID = hou.organization_id
   and cfit.organization_id = cfvr.organization_id
   and cfit.invoice_type_id = cfvr.invoice_type_id
   and cfvr.validity_key_1 = cfiu.utilization_id 
   --  AND cfvr.CREATED_BY = '445454'
  --   and trunc(cfvr.last_update_date) >= trunc(sysdate) -3
   and cfvr.validity_type = 'FISCAL UTILIZATION') TABLE1,
   (select distinct 
       hou.name
     , mpv.ORGANIZATION_CODE
     , cfit.invoice_type_code
     , cfit.description
     , cfvr.validity_type
     , cffo.cfo_code
  from apps.Cll_F189_Validity_Rules cfvr,
       apps.cll_f189_invoice_types cfit,
       apps.cll_f189_fiscal_operations cffo,
       apps.mtl_parameters mpv,
      apps.hr_all_organization_units hou
 where mpv.ORGANIZATION_ID = cfvr.organization_id
   and mpv.ORGANIZATION_ID = hou.organization_id
   and cfit.organization_id = cfvr.organization_id
   and cfit.invoice_type_id = cfvr.invoice_type_id
   and cfvr.validity_key_1 = cffo.cfo_id 
  --   AND cfvr.CREATED_BY = '445454'
  --   and trunc(cfvr.last_update_date) >= trunc(sysdate) -3
   and cfvr.validity_type = 'CFO') TABLE2,
   (select distinct 
       hou.name
     , mpv.ORGANIZATION_CODE
     , cfit.invoice_type_code
     , cfit.description
     , cfvr.validity_type
     , cfvr.validity_key_1
  from apps.Cll_F189_Validity_Rules cfvr,
       apps.cll_f189_invoice_types cfit,
       apps.mtl_parameters mpv,
       apps.hr_all_organization_units hou
 where mpv.ORGANIZATION_ID = cfvr.organization_id
   and mpv.ORGANIZATION_ID = hou.organization_id
   and cfit.organization_id = cfvr.organization_id
   and cfit.invoice_type_id = cfvr.invoice_type_id
   --  AND cfvr.CREATED_BY = '445454'
   --  and trunc(cfvr.last_update_date) >= trunc(sysdate) -3
   and cfvr.validity_type = 'FISCAL DOCUMENT MODEL') TABLE3,
      (select distinct 
       hou.name
     , mpv.ORGANIZATION_CODE
     , cfit.invoice_type_code
     , cfit.description
     , cfvr.validity_type
     , cfvr.validity_key_1
  from apps.Cll_F189_Validity_Rules cfvr,
       apps.cll_f189_invoice_types cfit,
       apps.mtl_parameters mpv,
       apps.hr_all_organization_units hou
 where mpv.ORGANIZATION_ID = cfvr.organization_id
   and mpv.ORGANIZATION_ID = hou.organization_id
   and cfit.organization_id = cfvr.organization_id
   and cfit.invoice_type_id = cfvr.invoice_type_id
   --  AND cfvr.CREATED_BY = '445454'
   --  and trunc(cfvr.last_update_date) >= trunc(sysdate) -3
   and cfvr.validity_type = 'ICMS TYPE') TABLE4,
         (select distinct 
       hou.name
     , mpv.ORGANIZATION_CODE
     , cfit.invoice_type_code
     , cfit.description
     , cfvr.validity_type
     , cfvr.validity_key_1
  from apps.Cll_F189_Validity_Rules cfvr,
       apps.cll_f189_invoice_types cfit,
       apps.mtl_parameters mpv,
       apps.hr_all_organization_units hou
 where mpv.ORGANIZATION_ID = cfvr.organization_id
   and mpv.ORGANIZATION_ID = hou.organization_id
   and cfit.organization_id = cfvr.organization_id
   and cfit.invoice_type_id = cfvr.invoice_type_id
   --  AND cfvr.CREATED_BY = '445454'
   --  and trunc(cfvr.last_update_date) >= trunc(sysdate) -3
   and cfvr.validity_type = 'CST IPI') TABLE5,
       (select distinct 
       hou.name
     , mpv.ORGANIZATION_CODE
     , cfit.invoice_type_code
     , cfit.description
     , cfvr.validity_type
     , cfvr.validity_key_1
  from apps.Cll_F189_Validity_Rules cfvr,
       apps.cll_f189_invoice_types cfit,
       apps.mtl_parameters mpv,
       apps.hr_all_organization_units hou
 where mpv.ORGANIZATION_ID = cfvr.organization_id
   and mpv.ORGANIZATION_ID = hou.organization_id
   and cfit.organization_id = cfvr.organization_id
   and cfit.invoice_type_id = cfvr.invoice_type_id
   --  AND cfvr.CREATED_BY = '445454'
   --  and trunc(cfvr.last_update_date) >= trunc(sysdate) -3
   and cfvr.validity_type = 'CST ICMS') TABLE6,
          (select distinct 
       hou.name
     , mpv.ORGANIZATION_CODE
     , cfit.invoice_type_code
     , cfit.description
     , cfvr.validity_type
     , cfvr.validity_key_1
  from apps.Cll_F189_Validity_Rules cfvr,
       apps.cll_f189_invoice_types cfit,
       apps.mtl_parameters mpv,
       apps.hr_all_organization_units hou
 where mpv.ORGANIZATION_ID = cfvr.organization_id
   and mpv.ORGANIZATION_ID = hou.organization_id
   and cfit.organization_id = cfvr.organization_id
   and cfit.invoice_type_id = cfvr.invoice_type_id
   --  AND cfvr.CREATED_BY = '445454'
   --  and trunc(cfvr.last_update_date) >= trunc(sysdate) -3
   and cfvr.validity_type = 'IPI TAXABLE FLAG') TABLE7,
         (select distinct 
       hou.name
     , mpv.ORGANIZATION_CODE
     , cfit.invoice_type_code
     , cfit.description
     , cfvr.validity_type
     , cfvr.validity_key_1
  from apps.Cll_F189_Validity_Rules cfvr,
       apps.cll_f189_invoice_types cfit,
       apps.mtl_parameters mpv,
       apps.hr_all_organization_units hou
 where mpv.ORGANIZATION_ID = cfvr.organization_id
   and mpv.ORGANIZATION_ID = hou.organization_id
   and cfit.organization_id = cfvr.organization_id
   and cfit.invoice_type_id = cfvr.invoice_type_id
   --  AND cfvr.CREATED_BY = '445454'
   --  and trunc(cfvr.last_update_date) >= trunc(sysdate) -3
   and cfvr.validity_type = 'ICMS TAXABLE FLAG') TABLE8,
         (select distinct 
       hou.name
     , mpv.ORGANIZATION_CODE
     , cfit.invoice_type_code
     , cfit.description
     , cfvr.validity_type
     , cfvr.validity_key_1
  from apps.Cll_F189_Validity_Rules cfvr,
       apps.cll_f189_invoice_types cfit,
       apps.mtl_parameters mpv,
       apps.hr_all_organization_units hou
 where mpv.ORGANIZATION_ID = cfvr.organization_id
   and mpv.ORGANIZATION_ID = hou.organization_id
   and cfit.organization_id = cfvr.organization_id
   and cfit.invoice_type_id = cfvr.invoice_type_id
   --  AND cfvr.CREATED_BY = '445454'
   --  and trunc(cfvr.last_update_date) >= trunc(sysdate) -3
   and cfvr.validity_type = 'INVOICE SERIES') TABLE9,
         (select distinct 
       hou.name
     , mpv.ORGANIZATION_CODE
     , cfit.invoice_type_code
     , cfit.description
     , cfvr.validity_type
     , cfvr.validity_key_1
  from apps.Cll_F189_Validity_Rules cfvr,
       apps.cll_f189_invoice_types cfit,
       apps.mtl_parameters mpv,
       apps.hr_all_organization_units hou
 where mpv.ORGANIZATION_ID = cfvr.organization_id
   and mpv.ORGANIZATION_ID = hou.organization_id
   and cfit.organization_id = cfvr.organization_id
   and cfit.invoice_type_id = cfvr.invoice_type_id
   --  AND cfvr.CREATED_BY = '445454'
   --  and trunc(cfvr.last_update_date) >= trunc(sysdate) -3
   and cfvr.validity_type = 'CST COFINS') TABLE10,
            (select distinct 
       hou.name
     , mpv.ORGANIZATION_CODE
     , cfit.invoice_type_code
     , cfit.description
     , cfvr.validity_type
     , cfvr.validity_key_1
  from apps.Cll_F189_Validity_Rules cfvr,
       apps.cll_f189_invoice_types cfit,
       apps.mtl_parameters mpv,
       apps.hr_all_organization_units hou
 where mpv.ORGANIZATION_ID = cfvr.organization_id
   and mpv.ORGANIZATION_ID = hou.organization_id
   and cfit.organization_id = cfvr.organization_id
   and cfit.invoice_type_id = cfvr.invoice_type_id
   --  AND cfvr.CREATED_BY = '445454'
   --  and trunc(cfvr.last_update_date) >= trunc(sysdate) -3
   and cfvr.validity_type = 'CST PIS') TABLE11,
   (select /*mp.organization_code
      ,cfi.invoice_type_code  CODE
    ,cfi.description        DESCRIPTION
      ,CFI.INACTIVE_DATE
      ,cfi.operation_type     OPERATION_TYPE
      ,cfi.credit_debit_flag  CREDIT_DEBIT
      ,cfi.return_customer_flag        RETURN_TYPE
      ,cfi.project_flag       ORACLE_PA_INTERFACE
      ,cfi.requisition_type   DOCUMENT_TYPE_REQ
      ,cfi.contab_flag        ACCOUNTING_TYPE
      ,cfi.fixed_assets_flag   FIXED_ASSETS_INTERFACE
      ,cfi.parent_flag        PARENT_INVOICE
      ,cfi.fiscal_flag        BOOKKEEPING
      ,cfi.payment_flag       GENERATE_AP_INVOICE
      ,cfi.price_adjust_flag  PRICE_ADJUSTMENT
      ,cfi.tax_adjust_flag    TAX_ADJUSTMENT
      ,cfi.cost_adjust_flag   COST_ADJUSTMENT
      ,cfi.complex_service_flag  COMPLEX_SERVICE_PO
      ,cfi.utilities_flag     UTILITIES
      ,cfi.return_flag        RETURN_INVOICE
      ,cfi.foreign_currency_usage     FOREIGN_CURRENCY
      ,cfi.freight_flag       FREIGHT_INVOICE_TYPE
      ,cfi.permanent_active_credit_flag    PERMANENT_ASSET_CREDIT
      ,cfi.generate_return_invoice         GENERATE_RETURN_TRANSACTION
      ,cfi.wms_flag                        WMS_PHYSICAL_RECEIVING
      ,cfi.bonus_flag                      BONUS
    --Taxes
      ,cfi.icms_reduction_percent          ICMS_BASIS_REDUCTION
      ,cfi.include_icms_flag               ICMS_CALCULATED
      ,cfi.import_icms_flag                IMPORTATION_ICMS
      ,cfi.exclude_icms_st_flag            EXCLUDE_ICMS_ST
      ,cfi.include_iss_flag                ISS_CALCULATED
      ,cfi.include_ipi_flag                IPI_CALCULATED
      ,cfi.pis_flag                        PIS_CALCULATED
      ,cfi.cofins_flag                     COFINS_CALCULATED
      ,cfi.include_ir_flag                 IR_CALCULATED
      ,cfi.inss_calculation_flag           INSS_CALCULATED
      ,cfi.include_sest_senat_flag         SEST_SENAT_CALCULATED
   --Interfaces
      ,CFI.PAY_GROUP_LOOKUP_CODE   PAYMENT_GROUP
      ,RAT.NAME                    TRANSACTION_TYPE
      ,RAS.NAME                    SOURCE_AR
      ,CFI.IPI_TRIBUTARY_CODE_FLAG
      ,RAC1.TAX_CATEGORY           AR_CRED_IPI_CATEGORY_ID
      ,RAC2.TAX_CATEGORY           AR_CRED_ICMS_CATEGORY_ID
      ,RAC3.TAX_CATEGORY           AR_DEB_IPI_CATEGORY_ID
      ,RAC4.TAX_CATEGORY           AR_DEB_ICMS_CATEGORY_ID*/
  --Liability Accounts
      gl1.segment1||'.'||gl1.segment2||'.'||gl1.segment3||'.'||gl1.segment4||'.'||gl1.segment5||'.'||gl1.segment6||'.'||gl1.segment7||'.'||gl1.segment8||'.'||gl1.segment9||'.'||gl1.segment10||'.'||gl1.segment11 LIABILITY_TRANSITORY
      ,gl7.segment1||'.'||gl7.segment2||'.'||gl7.segment3||'.'||gl7.segment4||'.'||gl7.segment5||'.'||gl7.segment6||'.'||gl7.segment7||'.'||gl7.segment8||'.'||gl7.segment9||'.'||gl7.segment10||'.'||gl7.segment11  ICMS_TO_COLLECT
      ,'' ADVANCE_ICMS_ST_TO_COLLECT
      ,gl2.segment1||'.'||gl2.segment2||'.'||gl2.segment3||'.'||gl2.segment4||'.'||gl2.segment5||'.'||gl2.segment6||'.'||gl2.segment7||'.'||gl2.segment8||'.'||gl2.segment9||'.'||gl2.segment10||'.'||gl2.segment11  IPI_TO_COLLECT
      ,gl25.segment1||'.'||gl25.segment2||'.'||gl25.segment3||'.'||gl25.segment4||'.'||gl25.segment5||'.'||gl25.segment6||'.'||gl25.segment7||'.'||gl25.segment8||'.'||gl25.segment9||'.'||gl25.segment10||'.'||gl25.segment11 PIS_TO_COLLECT
      ,gl26.segment1||'.'||gl26.segment2||'.'||gl26.segment3||'.'||gl26.segment4||'.'||gl26.segment5||'.'||gl26.segment6||'.'||gl26.segment7||'.'||gl26.segment8||'.'||gl26.segment9||'.'||gl26.segment10||'.'||gl26.segment11 COFINS_TO_COLLECT
      ,gl8.segment1||'.'||gl8.segment2||'.'||gl8.segment3||'.'||gl8.segment4||'.'||gl8.segment5||'.'||gl8.segment6||'.'||gl8.segment7||'.'||gl8.segment8||'.'||gl8.segment9||'.'||gl8.segment10||'.'||gl8.segment11 ISS_TO_COLLECT
      ,gl3.segment1||'.'||gl3.segment2||'.'||gl3.segment3||'.'||gl3.segment4||'.'||gl3.segment5||'.'||gl3.segment6||'.'||gl3.segment7||'.'||gl3.segment8||'.'||gl3.segment9||'.'||gl3.segment10||'.'||gl3.segment11 IR_TO_COLLECT
      ,gl9.segment1||'.'||gl9.segment2||'.'||gl9.segment3||'.'||gl9.segment4||'.'||gl9.segment5||'.'||gl9.segment6||'.'||gl9.segment7||'.'||gl9.segment8||'.'||gl9.segment9||'.'||gl9.segment10||'.'||gl9.segment11 INSS_EXPENSES
      ,gl14.segment1||'.'||gl14.segment2||'.'||gl14.segment3||'.'||gl14.segment4||'.'||gl14.segment5||'.'||gl14.segment6||'.'||gl14.segment7||'.'||gl14.segment8||'.'||gl14.segment9||'.'||gl14.segment10||'.'||gl14.segment11 SUBSTITUTE_INSS
      ,'' SEST_SENAT
      ,gl4.segment1||'.'||gl4.segment2||'.'||gl4.segment3||'.'||gl4.segment4||'.'||gl4.segment5||'.'||gl4.segment6||'.'||gl4.segment7||'.'||gl4.segment8||'.'||gl4.segment9||'.'||gl4.segment10||'.'||gl4.segment11 IMPORTING_CHARGES
      ,gl10.segment1||'.'||gl10.segment2||'.'||gl10.segment3||'.'||gl10.segment4||'.'||gl10.segment5||'.'||gl10.segment6||'.'||gl10.segment7||'.'||gl10.segment8||'.'||gl10.segment9||'.'||gl10.segment10||'.'||gl10.segment11 IMPORTING_INSURANCE
      ,gl5.segment1||'.'||gl5.segment2||'.'||gl5.segment3||'.'||gl5.segment4||'.'||gl5.segment5||'.'||gl5.segment6||'.'||gl5.segment7||'.'||gl5.segment8||'.'||gl5.segment9||'.'||gl5.segment10||'.'||gl5.segment11 IMPORTING_FREIGHT
      ,gl11.segment1||'.'||gl11.segment2||'.'||gl11.segment3||'.'||gl11.segment4||'.'||gl11.segment5||'.'||gl11.segment6||'.'||gl11.segment7||'.'||gl11.segment8||'.'||gl11.segment9||'.'||gl11.segment10||'.'||gl11.segment11 IMPORTING_OTHER_EXPENSES
      ,gl15.segment1||'.'||gl15.segment2||'.'||gl15.segment3||'.'||gl15.segment4||'.'||gl15.segment5||'.'||gl15.segment6||'.'||gl15.segment7||'.'||gl15.segment8||'.'||gl15.segment9||'.'||gl15.segment10||'.'||gl15.segment11 IMPORTING_PIS
      ,gl16.segment1||'.'||gl16.segment2||'.'||gl16.segment3||'.'||gl16.segment4||'.'||gl16.segment5||'.'||gl16.segment6||'.'||gl16.segment7||'.'||gl16.segment8||'.'||gl16.segment9||'.'||gl16.segment10||'.'||gl16.segment11 IMPORTING_COFINS
      ,gl37.segment1||'.'||gl37.segment2||'.'||gl37.segment3||'.'||gl37.segment4||'.'||gl37.segment5||'.'||gl37.segment6||'.'||gl37.segment7||'.'||gl37.segment8||'.'||gl37.segment9||'.'||gl37.segment10||'.'||gl37.segment11 IMPORTING_IPI
      ,gl38.segment1||'.'||gl38.segment2||'.'||gl38.segment3||'.'||gl38.segment4||'.'||gl38.segment5||'.'||gl38.segment6||'.'||gl38.segment7||'.'||gl38.segment8||'.'||gl38.segment9||'.'||gl38.segment10||'.'||gl38.segment11 IMPORTING_ICMS
      ,gl44.segment1||'.'||gl44.segment2||'.'||gl44.segment3||'.'||gl44.segment4||'.'||gl44.segment5||'.'||gl44.segment6||'.'||gl44.segment7||'.'||gl44.segment8||'.'||gl44.segment9||'.'||gl44.segment10||'.'||gl44.segment11 CIDE
      ,gl31.segment1||'.'||gl31.segment2||'.'||gl31.segment3||'.'||gl31.segment4||'.'||gl31.segment5||'.'||gl31.segment6||'.'||gl31.segment7||'.'||gl31.segment8||'.'||gl31.segment9||'.'||gl31.segment10||'.'||gl31.segment11 SYMBOLIC_RETURN
      ,gl12.segment1||'.'||gl12.segment2||'.'||gl12.segment3||'.'||gl12.segment4||'.'||gl12.segment5||'.'||gl12.segment6||'.'||gl12.segment7||'.'||gl12.segment8||'.'||gl12.segment9||'.'||gl12.segment10||'.'||gl12.segment11  RMA
      ,gl6.segment1||'.'||gl6.segment2||'.'||gl6.segment3||'.'||gl6.segment4||'.'||gl6.segment5||'.'||gl6.segment6||'.'||gl6.segment7||'.'||gl6.segment8||'.'||gl6.segment9||'.'||gl6.segment10||'.'||gl6.segment11 IPI_TO_COLLECT_RMA
      ,gl13.segment1||'.'||gl13.segment2||'.'||gl13.segment3||'.'||gl13.segment4||'.'||gl13.segment5||'.'||gl13.segment6||'.'||gl13.segment7||'.'||gl13.segment8||'.'||gl13.segment9||'.'||gl13.segment10||'.'||gl13.segment11 ICMS_TO_COLLECT_RMA
      ,gl28.segment1||'.'||gl28.segment2||'.'||gl28.segment3||'.'||gl28.segment4||'.'||gl28.segment5||'.'||gl28.segment6||'.'||gl28.segment7||'.'||gl28.segment8||'.'||gl28.segment9||'.'||gl28.segment10||'.'||gl28.segment11 ICMS_ST_TO_COLLECT_RMA
      ,gl29.segment1||'.'||gl29.segment2||'.'||gl29.segment3||'.'||gl29.segment4||'.'||gl29.segment5||'.'||gl29.segment6||'.'||gl29.segment7||'.'||gl29.segment8||'.'||gl29.segment9||'.'||gl29.segment10||'.'||gl29.segment11 SISCOMEX
      ,gl17.segment1||'.'||gl17.segment2||'.'||gl17.segment3||'.'||gl17.segment4||'.'||gl17.segment5||'.'||gl17.segment6||'.'||gl17.segment7||'.'||gl17.segment8||'.'||gl17.segment9||'.'||gl17.segment10||'.'||gl17.segment11 CUSTOM_EXPENSES
      ,'' PIS_REDUCING_ANEEL
      ,'' COFINS_REDUCING_ANEEL
      ,'' ICMS_REDUCING_ANEEL
      ,'' FUNDERSUL_TO_COLLECT
      ,'' SUBSTITUTE_FUNDERSUL
      ,gl39.segment1||'.'||gl39.segment2||'.'||gl39.segment3||'.'||gl39.segment4||'.'||gl39.segment5||'.'||gl39.segment6||'.'||gl39.segment7||'.'||gl39.segment8||'.'||gl39.segment9||'.'||gl39.segment10||'.'||gl39.segment11 FCP_TO_COLLECT
      ,gl40.segment1||'.'||gl40.segment2||'.'||gl40.segment3||'.'||gl40.segment4||'.'||gl40.segment5||'.'||gl40.segment6||'.'||gl40.segment7||'.'||gl40.segment8||'.'||gl40.segment9||'.'||gl40.segment10||'.'||gl40.segment11 FCP_ST_TO_COLLECT
   --Asset Accounts
      ,gl18.segment1||'.'||gl18.segment2||'.'||gl18.segment3||'.'||gl18.segment4||'.'||gl18.segment5||'.'||gl18.segment6||'.'||gl18.segment7||'.'||gl18.segment8||'.'||gl18.segment9||'.'||gl18.segment10||'.'||gl18.segment11 ICMS_TO_RECOVER
      ,''  ADVANCE_ICMS_ST_TO_RECOVER
      ,gl19.segment1||'.'||gl19.segment2||'.'||gl19.segment3||'.'||gl19.segment4||'.'||gl19.segment5||'.'||gl19.segment6||'.'||gl19.segment7||'.'||gl19.segment8||'.'||gl19.segment9||'.'||gl19.segment10||'.'||gl19.segment11 ICMS_ST
      ,gl20.segment1||'.'||gl20.segment2||'.'||gl20.segment3||'.'||gl20.segment4||'.'||gl20.segment5||'.'||gl20.segment6||'.'||gl20.segment7||'.'||gl20.segment8||'.'||gl20.segment9||'.'||gl20.segment10||'.'||gl20.segment11 IPI_TO_RECOVER
      ,gl32.segment1||'.'||gl32.segment2||'.'||gl32.segment3||'.'||gl32.segment4||'.'||gl32.segment5||'.'||gl32.segment6||'.'||gl32.segment7||'.'||gl32.segment8||'.'||gl32.segment9||'.'||gl32.segment10||'.'||gl32.segment11 PIS_TO_RECOVER
      ,gl33.segment1||'.'||gl33.segment2||'.'||gl33.segment3||'.'||gl33.segment4||'.'||gl33.segment5||'.'||gl33.segment6||'.'||gl33.segment7||'.'||gl33.segment8||'.'||gl33.segment9||'.'||gl33.segment10||'.'||gl33.segment11 COFINS_TO_RECOVER
      ,gl23.segment1||'.'||gl23.segment2||'.'||gl23.segment3||'.'||gl23.segment4||'.'||gl23.segment5||'.'||gl23.segment6||'.'||gl23.segment7||'.'||gl23.segment8||'.'||gl23.segment9||'.'||gl23.segment10||'.'||gl23.segment11 ACCOUNT_RECEIVABLE_RMA
      ,gl24.segment1||'.'||gl24.segment2||'.'||gl24.segment3||'.'||gl24.segment4||'.'||gl24.segment5||'.'||gl24.segment6||'.'||gl24.segment7||'.'||gl24.segment8||'.'||gl24.segment9||'.'||gl24.segment10||'.'||gl24.segment11 ICMS_REDUCING_RMA
      ,gl30.segment1||'.'||gl30.segment2||'.'||gl30.segment3||'.'||gl30.segment4||'.'||gl30.segment5||'.'||gl30.segment6||'.'||gl30.segment7||'.'||gl30.segment8||'.'||gl30.segment9||'.'||gl30.segment10||'.'||gl30.segment11 ICMS_ST_REDUCING_RMA
      ,gl22.segment1||'.'||gl22.segment2||'.'||gl22.segment3||'.'||gl22.segment4||'.'||gl22.segment5||'.'||gl22.segment6||'.'||gl22.segment7||'.'||gl22.segment8||'.'||gl22.segment9||'.'||gl22.segment10||'.'||gl22.segment11 IPI_REDUCING_RMA
      ,gl21.segment1||'.'||gl21.segment2||'.'||gl21.segment3||'.'||gl21.segment4||'.'||gl21.segment5||'.'||gl21.segment6||'.'||gl21.segment7||'.'||gl21.segment8||'.'||gl21.segment9||'.'||gl21.segment10||'.'||gl21.segment11 PIS_REDUCING_RMA
      ,gl27.segment1||'.'||gl27.segment2||'.'||gl27.segment3||'.'||gl27.segment4||'.'||gl27.segment5||'.'||gl27.segment6||'.'||gl27.segment7||'.'||gl27.segment8||'.'||gl27.segment9||'.'||gl27.segment10||'.'||gl27.segment11 COFINS_REDUCING_RMA
      ,gl21.segment1||'.'||gl21.segment2||'.'||gl21.segment3||'.'||gl21.segment4||'.'||gl21.segment5||'.'||gl21.segment6||'.'||gl21.segment7||'.'||gl21.segment8||'.'||gl21.segment9||'.'||gl21.segment10||'.'||gl21.segment11 PIS_ST_REDUCING_RMA
      ,gl27.segment1||'.'||gl27.segment2||'.'||gl27.segment3||'.'||gl27.segment4||'.'||gl27.segment5||'.'||gl27.segment6||'.'||gl27.segment7||'.'||gl27.segment8||'.'||gl27.segment9||'.'||gl27.segment10||'.'||gl27.segment11 COFINS_ST_REDUCING_RMA
      ,gl47.segment1||'.'||gl47.segment2||'.'||gl47.segment3||'.'||gl47.segment4||'.'||gl47.segment5||'.'||gl47.segment6||'.'||gl47.segment7||'.'||gl47.segment8||'.'||gl47.segment9||'.'||gl47.segment10||'.'||gl47.segment11 DIF_SOURCE_RMA_REDUCING
      ,gl48.segment1||'.'||gl48.segment2||'.'||gl48.segment3||'.'||gl48.segment4||'.'||gl48.segment5||'.'||gl48.segment6||'.'||gl48.segment7||'.'||gl48.segment8||'.'||gl48.segment9||'.'||gl48.segment10||'.'||gl48.segment11 DIF_DEST_RMA_REDUCING
      ,gl34.segment1||'.'||gl34.segment2||'.'||gl34.segment3||'.'||gl34.segment4||'.'||gl34.segment5||'.'||gl34.segment6||'.'||gl34.segment7||'.'||gl34.segment8||'.'||gl34.segment9||'.'||gl34.segment10||'.'||gl34.segment11 DIF_SOURCE_RMA_RECOVER
      ,gl35.segment1||'.'||gl35.segment2||'.'||gl35.segment3||'.'||gl35.segment4||'.'||gl35.segment5||'.'||gl35.segment6||'.'||gl35.segment7||'.'||gl35.segment8||'.'||gl35.segment9||'.'||gl35.segment10||'.'||gl35.segment11 DIF_DEST_RMA_RECOVER
      ,gl36.segment1||'.'||gl36.segment2||'.'||gl36.segment3||'.'||gl36.segment4||'.'||gl36.segment5||'.'||gl36.segment6||'.'||gl36.segment7||'.'||gl36.segment8||'.'||gl36.segment9||'.'||gl36.segment10||'.'||gl36.segment11 FCP_RMA_RECOVER
      ,gl41.segment1||'.'||gl41.segment2||'.'||gl41.segment3||'.'||gl41.segment4||'.'||gl41.segment5||'.'||gl41.segment6||'.'||gl41.segment7||'.'||gl41.segment8||'.'||gl41.segment9||'.'||gl41.segment10||'.'||gl41.segment11 FCP_ST_RMA_RECOVER
      ,'' RETURN_COST_VARIANCE
      ,gl42.segment1||'.'||gl42.segment2||'.'||gl42.segment3||'.'||gl42.segment4||'.'||gl42.segment5||'.'||gl42.segment6||'.'||gl42.segment7||'.'||gl42.segment8||'.'||gl42.segment9||'.'||gl42.segment10||'.'||gl42.segment11 FCP_RECOVER
      ,gl43.segment1||'.'||gl43.segment2||'.'||gl43.segment3||'.'||gl43.segment4||'.'||gl43.segment5||'.'||gl43.segment6||'.'||gl43.segment7||'.'||gl43.segment8||'.'||gl43.segment9||'.'||gl43.segment10||'.'||gl43.segment11 FCP_ST_RECOVER
      ,gl46.segment1||'.'||gl46.segment2||'.'||gl46.segment3||'.'||gl46.segment4||'.'||gl46.segment5||'.'||gl46.segment6||'.'||gl46.segment7||'.'||gl46.segment8||'.'||gl46.segment9||'.'||gl46.segment10||'.'||gl46.segment11 FCP_RMA_REDUCING
      ,gl45.segment1||'.'||gl45.segment2||'.'||gl45.segment3||'.'||gl45.segment4||'.'||gl45.segment5||'.'||gl45.segment6||'.'||gl45.segment7||'.'||gl45.segment8||'.'||gl45.segment9||'.'||gl45.segment10||'.'||gl45.segment11 FCP_ST_RMA_REDUCING
/*
    -- Fed Withhold Taxes
      ,cfi.IR_VENDOR
      ,cfi.IR_CATEG
      ,cfi.IR_TAX
      ,cfi.INSS_SUBSTITUTE_FLAG
      ,cfi.INSS_TAX
      ,cfi.INSS_AUTONOMOUS_TAX
      ,cfi.WORKER_CATEGORY
      ,cfi.INSS_ADDITIONAL_TAX_1
      ,cfi.INSS_ADDITIONAL_TAX_2
      ,cfi.INSS_ADDITIONAL_TAX_3
      ,cfi.REMUNERATION_FREIGHT
      ,cfi.INCOME_CODE
      ,aw.name
    --User
      ,CFI.CREATION_DATE
      ,CFI.LAST_UPDATE_DATE
      ,FD.USER_NAME SSO
      ,FD.DESCRIPTION       NOME
      ,FD.EMAIL_ADDRESS*/


from apps.cll_f189_invoice_types cfi
    ,apps.gl_code_combinations gl1
    ,apps.gl_code_combinations gl2
    ,apps.gl_code_combinations gl3
    ,apps.gl_code_combinations gl4
    ,apps.gl_code_combinations gl5
    ,apps.gl_code_combinations gl6
    ,apps.gl_code_combinations gl7
    ,apps.gl_code_combinations gl8
    ,apps.gl_code_combinations gl9
    ,apps.gl_code_combinations gl10
    ,apps.gl_code_combinations gl11
    ,apps.gl_code_combinations gl12
    ,apps.gl_code_combinations gl13
    ,apps.gl_code_combinations gl14
    ,apps.gl_code_combinations gl15
    ,apps.gl_code_combinations gl16
    ,apps.gl_code_combinations gl17
    ,apps.gl_code_combinations gl18
    ,apps.gl_code_combinations gl19
    ,apps.gl_code_combinations gl20
    ,apps.gl_code_combinations gl21
    ,apps.gl_code_combinations gl22
    ,apps.gl_code_combinations gl23
    ,apps.gl_code_combinations gl24
    ,apps.gl_code_combinations gl25
    ,apps.gl_code_combinations gl26
    ,apps.gl_code_combinations gl27
    ,apps.gl_code_combinations gl28
    ,apps.gl_code_combinations gl29
    ,apps.gl_code_combinations gl30
    ,apps.gl_code_combinations gl31
    ,apps.gl_code_combinations gl32
    ,apps.gl_code_combinations gl33
    ,apps.gl_code_combinations gl34
    ,apps.gl_code_combinations gl35
    ,apps.gl_code_combinations gl36
    ,apps.gl_code_combinations gl37
    ,apps.gl_code_combinations gl38
    ,apps.gl_code_combinations gl39
    ,apps.gl_code_combinations gl40
    ,apps.gl_code_combinations gl41
    ,apps.gl_code_combinations gl42
    ,apps.gl_code_combinations gl43
    ,apps.gl_code_combinations gl44
    ,apps.gl_code_combinations gl45
    ,apps.gl_code_combinations gl46
    ,apps.gl_code_combinations gl47
    ,apps.gl_code_combinations gl48
    ,apps.mtl_parameters mp
    ,APPS.AP_AWT_GROUPS AW
    ,apps.ra_cust_trx_types_all rat
    ,apps.ra_batch_sources_all  ras
    ,apps.JL_BR_AR_TX_CATEG_ALL  rac1
    ,apps.JL_BR_AR_TX_CATEG_ALL  rac2
    ,apps.JL_BR_AR_TX_CATEG_ALL  rac3
    ,apps.JL_BR_AR_TX_CATEG_ALL  rac4
    ,APPS.FND_USER FD

where gl1.code_combination_id (+)= cfi.cr_code_combination_id
and gl2.code_combination_id (+)= cfi.ipi_liability_ccid
and gl3.code_combination_id (+)= cfi.ir_code_combination_id
and gl4.code_combination_id (+)= cfi.import_tax_ccid
and gl5.code_combination_id (+)= cfi.import_freight_ccid
and gl6.code_combination_id (+)= cfi.RMA_IPI_LIABILITY_CCID
and gl7.code_combination_id (+)= cfi.diff_icms_code_combination_id
and gl8.code_combination_id (+)= cfi.iss_code_combination_id
and gl9.code_combination_id (+)= cfi.inss_expense_ccid
and gl10.code_combination_id (+)= cfi.import_insurance_ccid
and gl11.code_combination_id (+)= cfi.import_expense_ccid
and gl12.code_combination_id (+)= cfi.customer_ccid
and gl13.code_combination_id (+)= cfi.rma_icms_liability_ccid
and gl14.code_combination_id (+)= cfi.inss_code_combination_id
and gl15.code_combination_id (+)= cfi.import_pis_ccid
and gl16.code_combination_id (+)= cfi.import_cofins_ccid
and gl17.code_combination_id (+)= cfi.customs_expense_ccid
and gl18.code_combination_id (+)= cfi.icms_code_combination_id
and gl19.code_combination_id (+)= cfi.icms_st_ccid
and gl20.code_combination_id (+)= cfi.ipi_code_combination_id
and gl21.code_combination_id (+)= cfi.RMA_PIS_RED_CCID
and gl22.code_combination_id (+)= cfi.RMA_IPI_REDUCTION_CCID
and gl23.code_combination_id (+)= cfi.ACCOUNT_RECEIVABLE_CCID
and gl24.code_combination_id (+)= cfi.RMA_ICMS_REDUCTION_CCID
and gl25.code_combination_id (+)= cfi.COLLECT_PIS_CCID
and gl26.code_combination_id (+)= cfi.collect_cofins_ccid
and gl27.code_combination_id (+)= cfi.RMA_COFINS_REDUCTION_CCID
and gl28.code_combination_id (+)= cfi.RMA_ICMS_ST_LIABILITY_CCID
and gl29.code_combination_id (+)= cfi.SISCOMEX_CCID
and gl30.code_combination_id (+)= cfi.RMA_ICMS_ST_REDUCTION_CCID
and gl31.code_combination_id (+)= cfi.SYMBOLIC_RETURN_CCID
and gl32.code_combination_id (+)= cfi.PIS_CODE_COMBINATION_ID
and gl33.code_combination_id (+)= cfi.COFINS_CODE_COMBINATION_ID
and gl34.code_combination_id (+)= cfi.REC_DIFF_ICMS_RMA_SOURCE_CCID
and gl35.code_combination_id (+)= cfi.REC_DIFF_ICMS_RMA_DEST_CCID
and gl36.code_combination_id (+)= cfi.REC_FCP_RMA_CCID
and gl37.code_combination_id (+)= cfi.IMPORT_IPI_CCID
and gl38.code_combination_id (+)= cfi.IMPORT_ICMS_CCID
and gl39.code_combination_id (+)= cfi.FCP_LIABILITY_CCID
and gl40.code_combination_id (+)= cfi.FCP_ST_LIABILITY_CCID
and gl41.code_combination_id (+)= cfi.REC_FCP_ST_RMA_CCID
and gl42.code_combination_id (+)= cfi.FCP_ASSET_CCID
and gl43.code_combination_id (+)= cfi.FCP_ST_ASSET_CCID
and gl44.code_combination_id (+)= cfi.CIDE_CODE_COMBINATION_ID
and gl45.code_combination_id (+)= cfi.RED_FCP_ST_RMA_CCID
and gl46.code_combination_id (+)= cfi.RED_FCP_RMA_CCID
and gl47.code_combination_id (+)= cfi.DIFF_ICMS_RMA_SOURCE_RED_CCID
and gl48.code_combination_id (+)= cfi.DIFF_ICMS_RMA_DEST_RED_CCID
and mp.organization_id = cfi.organization_id
and cfi.AWT_GROUP_ID = AW.GROUP_ID(+)
and rat.CUST_TRX_TYPE_ID (+)= CFI.AR_TRANSACTION_TYPE_ID
and ras.BATCH_SOURCE_ID (+) = CFI.AR_SOURCE_ID
and rac1.TAX_CATEGORY_ID(+)= CFI.AR_CRED_IPI_CATEGORY_ID
and rac2.TAX_CATEGORY_ID(+)= CFI.AR_CRED_ICMS_CATEGORY_ID
and rac3.TAX_CATEGORY_ID(+) = CFI.AR_DEB_IPI_CATEGORY_ID
and rac4.TAX_CATEGORY_ID(+) = CFI.AR_DEB_ICMS_CATEGORY_ID
AND cfi.LAST_UPDATED_BY = FD.USER_ID
--and mp.organization_code IN ('DIV')
--and cfi.invoice_type_code LIKE 'E151'
--or cfi.invoice_type_code LIKE '%E15%')*/
--and cfi.inactive_date is null
--and cfi.created_by = 369198 --fabio
--and cfi.last_updated_by = 445454 -- juliana
--and trunc(cfi.LAST_UPDATE_date) >= TO_date('11102018','ddmmyyyy')
)TABLE12;

   