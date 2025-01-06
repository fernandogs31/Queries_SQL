SELECT
    msi_master.segment1 AS item_number,
    msi_master.description AS item_description,
    msi_master.item_type AS item_type,
   -- NULL AS  Item_number_child,
    ood_master.organization_code AS master_org_code,
    NULL AS child_org_code,
    msi_master.creation_date AS Date_master,
    NULL As Date_child
        
FROM 
    apps.mtl_system_items_b msi_master,
    --apps.mtl_system_items_b msi_child,
    --apps.org_organization_definitions ood_child,
    apps.org_organization_definitions ood_master

WHERE 1=1
   AND msi_master.organization_id = ood_master.organization_id
    --AND msi_child.organization_id = ood_child.organization_id
    AND ood_master.organization_id = 3 -- 3 -- 4335
    --AND ood_child.organization_id = 4335
    AND msi_master.creation_date >= '01-JAN-24'
    --AND msi_child.creation_date >= '01-JAN-24'
    
UNION

SELECT 
    msi_child.segment1 AS item_number,
    msi_child.description AS item_description,
    msi_child.item_type AS item_type,
   -- NULL AS  Item_number_child,
   NULL AS master_org_code,
    ood_child.organization_code AS child_org_code,
   NULL AS Date_master,
    msi_child.creation_date As Date_child
        
FROM 
    --apps.mtl_system_items_b msi_master,
    apps.mtl_system_items_b msi_child,
    apps.org_organization_definitions ood_child
    --apps.org_organization_definitions ood_master

WHERE 1=1
    --AND msi_master.organization_id = ood_master.organization_id
    AND msi_child.organization_id = ood_child.organization_id
    --AND msi_master.inventory_item_id = msi_child.inventory_item_id
    --AND ood_master.organization_id = 3
    AND ood_child.organization_id = 4335--in (5832,8666,8668,8345,5792,5452,7222,8245,7182,5872,10366,10367) --4335
    --AND msi_master.creation_date >= '01-JAN-24'
    AND msi_child.creation_date >= '01-JAN-24'
;


SELECT
    msi_master.segment1 AS item_number,
    msi_master.description AS item_description,
    msi_master.item_type AS item_type,
    --NULL AS  Item_number_child,
    ood_master.organization_code AS master_org_code,
    NULL AS child_org_code,
    msi_master.creation_date AS Date_master,
    NULL As Date_child
        
FROM 
    apps.mtl_system_items_b msi_master,
    --apps.mtl_system_items_b msi_child,
    --apps.org_organization_definitions ood_child,
    apps.org_organization_definitions ood_master

WHERE 1=1
   AND msi_master.organization_id = ood_master.organization_id
    --AND msi_child.organization_id = ood_child.organization_id
    AND ood_master.organization_id = 4335 -- 3 -- 4335
    --AND ood_child.organization_id = 4335
    AND msi_master.creation_date >= '01-JAN-24'
    --AND msi_child.creation_date >= '01-JAN-24'
    
UNION

SELECT 
    msi_child.segment1 AS item_number,
    msi_child.description AS item_description,
    msi_child.item_type AS item_type,
    --msi_child.segment1 AS  Item_number_child,
    NULL AS master_org_code,
    ood_child.organization_code AS child_org_code,
    NULL AS Date_master,
    msi_child.creation_date As Date_child
        
FROM 
    --apps.mtl_system_items_b msi_master,
    apps.mtl_system_items_b msi_child,
    apps.org_organization_definitions ood_child
    --apps.org_organization_definitions ood_master

WHERE 1=1
    --AND msi_master.organization_id = ood_master.organization_id
    AND msi_child.organization_id = ood_child.organization_id
    --AND msi_master.inventory_item_id = msi_child.inventory_item_id
    --AND ood_master.organization_id = 3
    AND ood_child.organization_id in (4870,4849,10366,10367) --4335
    --AND msi_master.creation_date >= '01-JAN-24'
    AND msi_child.creation_date >= '01-JAN-24'
;