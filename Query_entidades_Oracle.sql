SELECT DISTINCT
  asp.vendor_id,
  asp.segment1 "Supplier_code",
  asp.vendor_name  "Supplier",
  ass.vendor_site_code "Site",
  hou.name  "OU",
  ass.address_line1,
  ass.address_line2,
  ass.address_line3,
  ass.address_line4,
  ass.city,
  ass.state,
  ass.zip,
  ass.country
  --ass.phone,
  --person.person_first_name,
  --person.person_last_name,
  --pty_rel.primary_phone_number,
  --pty_rel.email_address
  
FROM
  apps.po_vendor_sites_all ass,
  apps.po_vendors asp,
 -- apps.ap_supplier_contacts APSC,
  --apps.hz_parties person,
  --apps.hz_parties pty_rel,
  apps.hr_operating_units hou
  
WHERE
  asp.vendor_id = ass.vendor_id
--AND apsc.per_party_id = person.party_id
--AND apsc.rel_party_id = pty_rel.party_id
AND ass.org_id = hou.organization_id
--AND apsc.org_party_site_id = ass.party_site_id
AND hou.name = 'GEMSAM_OU_BRL_GEMS_BRA'
--AND ass.state is null
--AND asp.vendor_name like '%GE%PRECISION%'
AND ass.country <> 'BR'
;