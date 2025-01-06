select (select segment1
          from mtl_system_items_b
         where INVENTORY_ITEM_ID = a.INVENTORY_ITEM_ID
           and organization_id = a.organization_id) item,
       a.*
  from GEMS_INV.GE_GPO_DEF_ROUTING_DETAILS a
 where organization_id = 4870
