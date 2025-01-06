SELECT

-- Operating unit name
--------------------------------------------------------------------
(SELECT hou.name
FROM apps.hr_operating_units hou
WHERE 1 = 1
AND hou.organization_id = aps.org_id
) ou_name,

-- Supplier number
----------------------------------------------------------------------
ass.segment1 supplier_number,
NULL legacy_supplier_number,
aps.legal_business_name supplier_business_name,

-- Supplier type
----------------------------------------------------------------------
ass.vendor_type_lookup_code supplier_type,

-- Supplier name
----------------------------------------------------------------------
ass.vendor_name supplier_name,
ass.vendor_name_alt supplier_name_alt,

-- Supplier Taxpayer + VAT
----------------------------------------------------------------------
ass.num_1099 taxpayer_num,
ass.vat_registration_num tax_reg_number,
ass.allow_awt_flag supplier_allow_witholding_tax,

-- Supplier creation/update
----------------------------------------------------------------------
/*ASS.CREATION_DATE SUPPLIER_CREATION_DATE,
(select user_name from apps.fnd_user where user_id=ASS.CREATED_BY) SUPPLIER_CREATED_BY,
ASS.LAST_UPDATE_DATE SUPPLIER_LAST_UPDATE_DATE,
decode(ass.END_DATE_ACTIVE,null,'ACTIVE','IN') "Supplier active code",
(select user_name from apps.fnd_user where user_id=ass.LAST_UPDATED_BY) SUPPLIER_LAST_UPDATED_BY,*/
--aps.INACTIVE_DATE,
--APS.CREATION_DATE SUPPLIER_SITE_CREATION_DATE,
--APS.CREATED_BY SUPPLIER_SITE_CREATED_BY,
--APS.LAST_UPDATE_DATE SUPPLIER_SITE_LAST_UPDATE_DATE,
--APS.LAST_UPDATED_BY SUPPLIER_SITE_LAST_UPDATED_BY,

-- Supplier site number
-----------------------------------------------------------------------
aps.vendor_site_code supplier_site_code,
aps.vendor_site_code_alt supplier_site_code_alt,
aps.allow_awt_flag supplier_site_allow_witholding_tax,

-- Supplier site address
-----------------------------------------------------------------------
aps.address_line1 supplier_address_line1,
aps.address_line2 supplier_address_line2,
aps.address_line3 supplier_address_line3,
aps.address_line4 supplier_address_line4,
aps.city supplier_address_city,
aps.state supplier_site_state,
aps.zip supplier_site_zip_code,
aps.country supplier_site_country,

-- Supplier site Brazil attributes
-----------------------------------------------------------------------
DECODE(aps.global_attribute9,1,'CPF'
                            ,2,'CNPJ'
                            ,3,'OTHERS') supplier_site_br_type,
COALESCE(aps.global_attribute10, '') || COALESCE(aps.global_attribute11, '') || COALESCE(aps.global_attribute12, '') supplier_fed_incrip_number,
aps.global_attribute13 supplier_state_incription_number,
aps.global_attribute14 supplier_municipal_inscription_number,
aps.global_attribute15 supplier_fiscal_type,

-- Supplier site contacts
----------------------------------------------------------------------
aps.supplier_notif_method  supplier_site_po_notif_method,
aps.email_address supplier_site_po_email,
iepa.remit_advice_delivery_method supplier_site_remit_method,
iepa.remit_advice_email supplier_site_remit_email,

-- Supplier Payment method and terms
----------------------------------------------------------------------
aps.terms_date_basis supplier_site_terms_base,
aps.invoice_currency_code supplier_site_invoice_cur_code,
aps.payment_currency_code supplier_site_payment_cur_code,
(SELECT paym.payment_method_code
FROM apps.iby_ext_party_pmt_mthds paym
WHERE iepa.ext_payee_id = paym.ext_pmt_party_id
AND aps.vendor_site_id = iepa.supplier_site_id
--AND ass.supplier_site_id IS NULL
AND paym.primary_flag = 'Y' 
AND rownum=1
) supplier_payment_method,
ass.pay_group_lookup_code supplier_site_pay_group,
--IEPA.OBJECT_VERSION_NUMBER MAX_OBJECT_VERSION,
--ieppm.payment_method_code,
iepa.default_payment_method_code supplier_site_payment_method,
t.name supplier_site_terms,

-- Supplier bank details
-----------------------------------------------------------------------
--,accts.country_code BANK_COUNTRY_CODE
decode(accts.country_code,'IN','IN','NULL') country_code,
NULL allow_international_payments,
branch.bank_name bank_name,
branch.branch_number bank_branch_number,
branch.bank_branch_name bank_branch_name,
accts.bank_account_num bank_account_number,
accts.check_digits check_digits,
accts.bank_account_name bank_account_name,
NULL BIC,
accts.iban IBAN,
/*uses.start_date “Account_start_date”
uses.end_date “Account_end_date”
accts.currency_code “Account_Currency_Code”
accts.CREATION_DATE BANK_ACCOUNT_CREATION_DATE
accts.LAST_UPDATE_DATE BANK_ACCOUNT_LAST_UPDATE_DATE
accts.secondary_account_reference “SECONDARY_ACCOUNT_REFERENCE”*/

-- Supplier accounts GL
-------------------------------------------------------------------------
(SELECT gcc.concatenated_segments
                FROM apps.gl_code_combinations_kfv gcc
               WHERE gcc.code_combination_id = aps.accts_pay_code_combination_id
               AND ROWNUM = 1) "Liability account",

(SELECT gcc.concatenated_segments
                FROM apps.gl_code_combinations_kfv gcc
               WHERE gcc.code_combination_id = aps.prepay_code_combination_id
               AND  ROWNUM = 1) "Prepayment account",
               
(SELECT gcc.concatenated_segments
                FROM apps.gl_code_combinations_kfv gcc
               WHERE gcc.code_combination_id = aps.future_dated_payment_ccid
               AND  ROWNUM = 1) "Bills payable account"
               
FROM apps.ap_supplier_sites_all aps,
apps.ap_suppliers ass,
apps.ap_terms t,
apps.iby_external_payees_all iepa, --bank 2
apps.iby_pmt_instr_uses_all uses, --bank 3
apps.iby_account_owners owners, --bank4
apps.iby_ext_bank_accounts accts, --bank5
apps.ce_bank_branches_v branch --bank6

WHERE Aps.org_id = 4330
--AND owners.primary_flag = 'Y'
--AND ass.segment1 IN ('342255','345467') -–'346873'
AND ass.end_date_active IS NULL
AND aps.inactive_date IS NULL
AND aps.terms_id = t.term_id
--AND owners.account_owner_party_id is not null
--AND ieb.country_code = 'IN'
AND owners.ext_bank_account_id = accts.ext_bank_account_id(+)
AND owners.ext_bank_account_id(+) = uses.instrument_id
AND iepa.ext_payee_id = uses.ext_pmt_party_id(+)
AND iepa.payee_party_id = owners.account_owner_party_id
--AND owners.primary_flag IN ('Y','N')
AND uses.end_date is null
AND iepa.supplier_site_id = aps.vendor_site_id
AND ass.vendor_id = aps.vendor_id
AND branch.branch_party_id(+) = accts.branch_id
AND uses.instrument_type = 'BANKACCOUNT'
AND iepa.payment_function IN ('PAYABLES_DISB')

;