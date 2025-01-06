SELECT DISTINCT 
       mp.organization_code
     , msi.segment1
     , msi.global_attribute8
     , msi.global_attribute2                                                   class_cond_transacao
     , msi.global_attribute3                                                   item_origem
     , msi.global_attribute4                                                   tipo_fiscal
     , msi.global_attribute5                                                   sit_trib_federal
     , msi.global_attribute6                                                   st_trib_estadual  
     ,(SELECT mc.concatenated_segments
           FROM apps.mtl_categories_kfv  mc
              , apps.mtl_category_sets   mcs
              , apps.mtl_item_categories mic
              , apps.mtl_parameters      mp
          WHERE mic.organization_id   = mp.organization_id
            AND msi.inventory_item_id = mic.inventory_item_id
            AND mic.category_set_id   = mcs.category_set_id
            AND mcs.category_set_name = 'FISCAL_CLASSIFICATION'
            AND mic.category_id       = mc.category_id
            AND mcs.structure_id      = mc.structure_id
            AND mp.organization_code  = 'DIV')                                 ncm
     , MSI.attribute3                                                          traducao_portugues
     , inventory_item_status_code
     , (SELECT flv.meaning
           FROM apps.fnd_lookup_values flv
          WHERE flv.lookup_type = 'ITEM_TYPE'
            AND flv.language    = 'US'
            AND flv.lookup_code = msi.item_type)                               item_type
     , DECODE( msi.lot_control_code , 1 , 'No Control'
                                    , 2 , 'Full Control')                      lot_control
     , msi.Lot_divisible_flag
     , MSI.lot_split_enabled
     , MSI.lot_merge_enabled
     , DECODE( msi.serial_number_control_code , 5 , 'At Receipt'
                                              , 1 , 'No Control'
                                              , 6 , 'At Sales Order Issue')   serial_control

     , DECODE(msi.RECEIVING_ROUTING_ID , 1 , 'Standard'
                                       , 2 , 'Inspection'
                                       , 3 , 'Direct')                         receipt_rounting
     , DECODE(msi.inventory_planning_code , 6 , 'Not Planned'
                                          , 2 , 'Min-Max'
                                          , 1 , 'Reoder Point'
                                          , 7 , 'Vendor Managed')              inventory_planning_method
     , msi.planner_code                                                        planner
     , DECODE(msi.planning_make_buy_code , 1 , 'Make'
                                         , 2 , 'Buy')                           make_or_buy
     , msi.min_minmax_quantity                                                 min_quantity
     , msi.max_minmax_quantity                                                 man_quantity
     , DECODE(msi.mrp_safety_stock_code , 1 , 'Non-MRP Planned'
                                        , 2 , 'MRP Planned %' )                safety_stock
     , msav.sourcing_rule_name                                                 sourcing_rule


FROM   apps.mtl_system_items_b   msi
     , apps.mtl_parameters       mp
     , apps.mtl_units_of_measure muom
     , apps.mrp_sr_assignments_v msav

WHERE 1=1
   AND msi.organization_id         = mp.organization_id
   AND msi.primary_unit_of_measure = muom.unit_of_measure
   AND msi.organization_id         = msav.organization_id   (+)
   AND msi.inventory_item_id       = msav.inventory_item_id (+)    
   AND mp.organization_code        IN ('DIV')
   --AND msi.segment1 like '%ED'
   AND msi.segment1 in ('B7931RT-EDL',
   'B7931PW-EDL',
   'M81601ECED',
   'B7880KP-EDL')
;