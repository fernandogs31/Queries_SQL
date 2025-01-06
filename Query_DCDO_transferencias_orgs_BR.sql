----- QUERY REQUISIÇÕES - TRANSFERENCIA - ORGS BRAZIL ------

SELECT DISTINCT 
mp.organization_code "Demand Org"
,prha.segment1 "Requisition Order Number"
,prla.line_num "Requisition Line Order Number"
        , ( SELECT mcv.attribute7
           FROM apps.gems_material_class_v gmc
              , apps.mtl_item_categories   mic
              , apps.mtl_system_items_b    msi
              , apps.mtl_categories_v      mcv
          WHERE msi.inventory_item_id  = mic.inventory_item_id
            AND msi.organization_id    = mic.organization_id
            AND mic.category_id        = mcv.category_id
            AND mic.category_set_id    = 403
            AND mic.category_id        = gmc.category_id
            AND mic.organization_id    = mp.organization_id
            AND mic.inventory_item_id  = gdla.inventory_item_id
            AND ROWNUM <= 1
       )                                                                           "Modality"
     , ( SELECT vflex.description
           FROM apps.fnd_flex_values_vl  vflex
              , apps.fnd_flex_valueset_v vset
          WHERE vflex.flex_value_set_id  = vset.flex_value_set_id
            AND vset.flex_value_set_name = 'GEMS_MC_MODALITY'
            AND vflex.flex_value         = ( SELECT mcv.attribute7
                                               FROM apps.gems_material_class_v gmc
                                                  , apps.mtl_item_categories   mic
                                                  , apps.mtl_system_items_b    msi
                                                  , apps.mtl_categories_v      mcv
                                              WHERE msi.inventory_item_id = mic.inventory_item_id
                                                AND msi.organization_id   = mic.organization_id
                                                AND mic.category_id       = mcv.category_id
                                                AND mic.category_set_id   = 403
                                                AND mic.category_id       = gmc.category_id
                                                AND mic.organization_id   = mp.organization_id
                                                AND mic.inventory_item_id = gdla.inventory_item_id
                                           )
            AND ROWNUM <= 1
       )                                                                             "Modality Desc"
     , msib.segment1                                                                 "Item Key"
     , msib.description                                                              "Item Desc"
     , gdla.quantity_ordered                                                         "Primary Order Item Qty"
     , gdla.quantity_sourced                                                         "Qty Open"
     , DECODE (gdla.status , 'C', 'COMPLETE'
                           , 'P', 'PENDING'
      )                                                                              "CDO status"
     , mp_seller.organization_code                                                   "Inv Org Key"
     , ooha.order_number                                                             "Primary Order Nbr Key"
     , oola.flow_status_code                                                         "Lin Status"
     , oola.request_date                                                             "Ord RSD Dt"
     , oola.schedule_ship_date                                                       "Ord SSD Dt"
     , oola.actual_shipment_date                                                     "Ord ASD Dt"
     , oola.schedule_ship_date                                                       "Adjstd Fpd"
     , oola.cust_po_number                                                           "Primary PO Number"
     , ( SELECT listagg(wda.delivery_id,', ' ON OVERFLOW TRUNCATE) WITHIN GROUP (ORDER BY wda.delivery_id ASC)
           FROM apps.wsh_delivery_assignments wda
              , apps.wsh_delivery_details     wdd
          WHERE wda.delivery_detail_id = wdd.delivery_detail_id
            AND wdd.source_header_id   = oola.header_id
            AND wdd.source_line_id     = oola.line_id
       )                                                                             "Primary Delivery Number"
     , ( CASE
           WHEN gdla.po_header_id IS NOT NULL THEN
           'PSO'
         ELSE
           'SSO'
         END
       )                                                                             "MYO Order Type"
     , gdla.creation_date                                                            "Primary Order Prcrd"
     , prla.last_update_date                                                         "Requisition order Date"
     , gdla.last_update_date                                                         "Last CDO Date"
     , fnd.user_name                                                                 "User SSO CDO Run"
     , fnd.description                                                               "User Name CDO Run"
     , ottt.name                                                                     "Order type"

FROM
   apps.po_requisition_headers_all  prha
 , apps.po_requisition_lines_all   prla
 , apps.mtl_parameters             mp
 , apps.mtl_parameters             mp_seller
 , gems_ont.gems_ds_lines_all      gdla
--, gems_ont.gems_ds_lines_v        gdlv
 , apps.mtl_system_items_b         msib
 , apps.oe_order_headers_all    ooha
 , apps.oe_order_lines_all      oola
 , apps.oe_transaction_types_tl ottt
 , apps.fnd_user                fnd

WHERE
prla.org_id = prha.org_id
AND prla.requisition_header_id = prha.requisition_header_id
AND gdla.org_id = prla.org_id
AND gdla.document_line_id = prla.requisition_line_id
AND gdla.document_header_id = prla.requisition_header_id
AND gdla.inventory_item_id               = prla.item_id
AND mp.organization_id                   = gdla.source_entity_id
AND mp_seller.organization_id            = gdla.organization_id
AND msib.inventory_item_id               = gdla.inventory_item_id
AND gdla.so_header_id = ooha.header_id
AND oola.header_id = ooha.header_id
AND fnd.user_id                          = gdla.last_updated_by
AND ottt.transaction_type_id             = ooha.order_type_id

--
AND prla.need_by_date BETWEEN '01-JAN-2024' AND '31-DEC-2024'
AND mp.organization_code in ('C83','DMG','DIV','DSP','MRC','CTC','SGC','ULC','CSC')
;