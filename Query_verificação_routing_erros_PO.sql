SELECT * 
FROM apps.gems_po_defective_shpmnt_stg 
WHERE SOURCE_organization_id = 4870
and creation_date >='07-MAY-24'
and part_number in ('2383761-R','2383761')