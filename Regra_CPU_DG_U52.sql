NVL((SELECT L.LINE_TYPE_ID
             FROM APPS.MTL_SYSTEM_ITEMS_B I,
                  APPS.OE_ORDER_LINES_ALL L,
                  APPS.FND_COMMON_LOOKUPS V1,
                  APPS.MTL_PARAMETERS     M
            WHERE NVL(GEMS_ONT.GE_ONT_GLOBALPARTS_UTL_PKG.GE_WMS_RULE_FNC('GPO : Pick Batch',
                                                                          'mt.header_id',
                                                                          MPTDTV.HEADER_ID),
                      'X') = 'GPO_' || M.ORGANIZATION_CODE || '_CPU_RULE'
              AND MPTDTV.TRANSACTION_SOURCE_TYPE_ID IN (2, 8)
              AND MPTDTV.TXN_SOURCE_LINE_ID = L.LINE_ID
              AND MPTDTV.FROM_ORGANIZATION_ID = M.ORGANIZATION_ID
              AND MPTDTV.FROM_ORGANIZATION_ID = I.ORGANIZATION_ID
              AND MPTDTV.INVENTORY_ITEM_ID = I.INVENTORY_ITEM_ID
              AND V1.LOOKUP_TYPE = 'SHIP_METHOD'
              AND V1.LOOKUP_CODE =
                  NVL(L.SHIPPING_METHOD_CODE,
                      '000001_Best Avail_T_BEST AVAIL')
              AND NVL(V1.ATTRIBUTE_CATEGORY, 'X') =
                  'GPRS UPS SERVICE LEVEL'
              AND NVL(V1.ATTRIBUTE10, 'X') = 'CPU'
              AND I.HAZARD_CLASS_ID IS NULL
              AND NVL(GEMS_ONT.GE_ONT_GLOBALPARTS_UTL_PKG.GE_WMS_RULE_FNC('GPO: DG Category',
                                                                          'gemsi.inventory_item_id',
                                                                          I.INVENTORY_ITEM_ID),
                      'X') = 'X'
              AND NVL(GEMS_ONT.GE_ONT_GLOBALPARTS_UTL_PKG.GE_WMS_RULE_FNC('GPO: Exempted Standard Category',
                                                                                     'gemsi.inventory_item_id',
                                                                                     I.INVENTORY_ITEM_ID),
                                 'X') = 'X'
              AND ROWNUM = 1),
           -99)