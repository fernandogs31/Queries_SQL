SELECT cpp.period_name                                                                            Period 
     , ccg.cost_group                                                                             Cost_Group 
     , ood.organization_code                                                                      Organization 
     , basl.subinventory_code                                                                     Subinventory 
     , decode(msif.asset_inventory, 1, 'Y', 2,'N', null)                                          ASSET_INVENTORY
     , gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5||'.'||gcc.segment6||'.HCST01.'||
       gcc.segment8||'.'||decode(ccg.cost_group, 'CG01PAC', 'G', 'CG02PAC', 'G', 'CG04PAC', 'G', gcc.segment9 )||'.'||
       gcc.segment10||'.'||gcc.segment11 Conta_Reclass
     , msi.segment1                                                                               Item  
     , msi.inventory_asset_flag
     , msi.costing_enabled_flag
     , msi.description                                                                            Description 
     , msi.primary_uom_code                                                                       Uom 
     , round(cpic.item_cost,2)                                                                    Cost_Unit 


     , ( basl.total_layer_quantity -          
         basl.buy_quantity -                  
         basl.make_quantity -                 
         basl.issue_quantity )                                                                    Beginning_bal_qty 


     , ( decode(sign(nvl(basl.buy_quantity,0)),-1,0,basl.buy_quantity)   +   
         decode(sign(nvl(basl.make_quantity,0)),-1,0,basl.make_quantity) + 
         decode(sign(nvl(basl.issue_quantity,0)),-1,0,basl.issue_quantity) )                      Qty_Entries 


     , ( decode(sign(nvl(basl.buy_quantity,0)),-1,abs(basl.buy_quantity),0)   +    
         decode(sign(nvl(basl.make_quantity,0)),-1,abs(basl.make_quantity),0) +    
         decode(sign(nvl(basl.issue_quantity,0)),-1,abs(basl.issue_quantity),0) )                 Qty_Issues 


     , basl.total_layer_quantity                                                                  Qty_Subinv 

     , decode(sign(nvl(basl.total_intransit_quantity,0)),-1,0,0) Qty_Transit

     , round(( nvl( basl.total_layer_quantity, 0 ) + 
       nvl(decode(sign(nvl(basl.total_intransit_quantity,0)),-1,0,0),0)) * 
       nvl( cpic.item_cost, 0 ), 2)                                                               Value     

     , to_char(sysdate,'DD-MM-YYYY HH24:MI:SS')                                                   REPORT_EXTRACT_DATE 
  FROM 
     (
      SELECT * 
      FROM apps.cll_f032_subinventory_layers A
      WHERE NOT EXISTS (SELECT 1
                        FROM xxisv.xxisv_f032_subinventory_layers A1
                        WHERE A.ORGANIZATION_ID = A1.ORGANIZATION_ID
                          AND A.INVENTORY_ITEM_ID = A1.INVENTORY_ITEM_ID
                          AND A.PAC_PERIOD_ID = A1.PAC_PERIOD_ID
                          AND A.COST_GROUP_ID = A1.COST_GROUP_ID
                          AND A.SUBINVENTORY_CODE = A1.SUBINVENTORY_CODE)
        UNION ALL
        select * 
        from xxisv.xxisv_f032_subinventory_layers 
        )  basl 
     , apps.cst_pac_item_costs           cpic 
     , apps.mtl_system_items_b           msi 
     , apps.cst_pac_periods              cpp 
     , apps.org_organization_definitions ood 
     , apps.mtl_secondary_inventories    msif
     , apps.gl_code_combinations_kfv     gcc
     , apps.cst_cost_groups_v            ccg 
WHERE basl.pac_period_id        = ( select pac_period_id from apps.cst_pac_periods  
                                     where period_name = '11NOV-24' 
                                       and legal_entity = 4329 )  
   and basl.cost_group_id       = ccg.cost_group_id 
   and cpic.pac_period_id       = basl.pac_period_id        
   and cpic.cost_group_id       = basl.cost_group_id        
   and cpic.inventory_item_id   = basl.inventory_item_id    
   and msi.organization_id      = basl.organization_id      
   and msi.inventory_item_id    = basl.inventory_item_id    
   and cpp.pac_period_id        = basl.pac_period_id        
   and cpp.legal_entity         = 4329 
   and cpp.cost_type_id         = 2782 
   and ood.organization_id      = basl.organization_id 
   and msi.costing_enabled_flag = 'Y' 
   and msif.organization_id (+)          = basl.organization_id
   and msif.secondary_inventory_name (+) = basl.subinventory_code
   and gcc.code_combination_id(+)  = msif.material_account
   and ccg.cost_group in ('CG02PAC','CG09PAC');
