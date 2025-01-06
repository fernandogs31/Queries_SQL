SELECT DISTINCT 
       mp.organization_code
     , msi.segment1
     , msi.global_attribute8
     , msi.global_attribute2                                                   class_cond_transacao
     , msi.global_attribute3                                                   item_origem
     , msi.global_attribute4                                                   tipo_fiscal
     , msi.global_attribute5                                                   sit_trib_federal
     , msi.global_attribute6                                                   st_trib_estadual   
     , inventory_item_status_code
    , ( SELECT flv.meaning
           FROM apps.fnd_lookup_values flv
          WHERE flv.lookup_type = 'ITEM_TYPE'
            AND flv.language    = 'US'
            AND flv.lookup_code = msi.item_type )                              item_type
            , DECODE ( msi.lot_control_code , 1 , 'No Control'
                                     , 2 , 'Full Control' )                    lot_control
, DECODE ( msi.serial_number_control_code , 5 , 'At Receipt'
                                               , 1 , 'No Control'
                                               , 6 , 'At Sales Order Issue' )  serial_control
, DECODE ( msi.return_inspection_requirement , 1 , 'Yes'
                                                  , 2 , 'No' )                 rma_insp_req
, DECODE ( msi.RECEIVING_ROUTING_ID , 1 , 'Standard'
                                     , 2 , 'Inspection'
                                     , 3 , 'Direct')                    Receipt_Rounting                                                  
, msi.returnable_flag
     , ( SELECT mc.concatenated_segments
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
            AND mp.organization_code  = 'U51')                                ncm_dmg
         , msav.sourcing_rule_name                                                 sourcing_rule
     , msav.description                                                        sourcing_rule_desc
      ,( SELECT flv.meaning
           FROM apps.fnd_lookup_values flv
                ,apps.mtl_system_items_b msi_gem
          WHERE flv.lookup_type = 'ITEM_TYPE'
           AND flv.language    = 'US'
            AND flv.lookup_code = msi_gem.item_type
            AND msi_gem.inventory_item_id = msi.inventory_item_id
            and msi_gem.organization_id = 3) GEM_ITEM_TYPE
             ,msi.Lot_divisible_flag
     ,MSI.lot_split_enabled
  ,MSI.lot_merge_enabled
   , MSI.attribute3          AS Traducao_Portugues
   , MSI.INVENTORY_ASSET_FLAG
   , MSI.COSTING_ENABLED_FLAG
   , MSI.INVENTORY_ITEM_FLAG
   , msi.COST_OF_SALES_ACCOUNT
   , gcc.segment1
   , gcc.segment2
   , gcc.segment3
   , gcc.segment4
   , gcc.segment5
   , gcc.segment6
   , gcc.segment7
   , gcc.segment8
   , gcc.segment9
   , gcc.segment10
   , gcc.segment11
   , msi.SALES_ACCOUNT
   , gcc1.segment1
   , gcc1.segment2
   , gcc1.segment3
   , gcc1.segment4
   , gcc1.segment5
   , gcc1.segment6
   , gcc1.segment7
   , gcc1.segment8
   , gcc1.segment9
   , gcc1.segment10
   , gcc1.segment11
--  MSI.Global_Attribute2
FROM   apps.mtl_system_items_b   msi
     , apps.mtl_parameters       mp
     , apps.mtl_units_of_measure muom
     , apps.mrp_sr_assignments_v msav
     , apps.gl_code_combinations gcc
     , apps.gl_code_combinations gcc1
WHERE 1=1
   AND msi.organization_id         = mp.organization_id
   AND msi.primary_unit_of_measure = muom.unit_of_measure
   AND msi.organization_id         = msav.organization_id   (+)
   AND msi.inventory_item_id       = msav.inventory_item_id (+)
   AND msi.COST_OF_SALES_ACCOUNT   = gcc.code_combination_id
   AND msi.SALES_ACCOUNT           = gcc1.code_combination_id       
   AND mp.organization_code        IN ('U51')
--AND msi.segment1 = 'H4000SR'
;