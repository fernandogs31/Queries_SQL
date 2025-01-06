SELECT DISTINCT 
       avs.name
     , avs.org_code
     , avs.ri_number
     , avs.lpn
     , avs.lpn_context
     , avs.passivel_inspecao
     , avs.item
     , avs.descricao
     , avs.subinventario
     , avs.qtd
     , avs.uom_code
     , avs.po
     , avs.rma
     , avs.tipo
     , avs.inspecionado
  FROM ( SELECT qr.name                                                    name
              , ( SELECT organization_code
                     FROM apps.mtl_parameters
                    WHERE organization_id = qr.organization_id
                 )                                                         org_code
              , mmt_s.ri_number                                            ri_number
              , qr.license_plate_number                                    lpn
              , decode(wlpn.lpn_context, '1', 'Resides in Inventory'
                                       , '2', 'Resides in WIP'
                                       , '3', 'Resides in Receiving'
                                       , '4', 'Resides in Stores'
                                       , '5', 'Pre-generated'
                                       , '6', 'Resides in Intransit'
                                       , '7', 'Resides in Vendor Site'
                                       , '8', 'Packing context'
                                       , '9', 'Loaded for shipment'
                                       , '10', 'Prepack of WIP'
                                       , '11', 'Picked'
                      )                                                    lpn_context
              , NVL(qr.character1, 'N')                                    Passivel_inspecao
              , msi.segment1                                               item
              , msi.description                                            descricao
              , mmt_s.subinventory                                          subinventario
              , wlc.quantity                                               qtd
              , wlc.uom_code                                               uom_code
              , ( SELECT ph.segment1
                    FROM apps.rcv_transactions      rt
                       , apps.po_line_locations_all pll
                       , apps.po_headers_all        ph
                   WHERE rt.organization_id   = qr.organization_id
                     AND pll.line_location_id = rt.po_line_location_id
                     AND pll.po_header_id     = ph.po_header_id
                     AND ph.org_id            = 4330
                     AND rt.transfer_lpn_id   = qr.lpn_id
                     AND ROWNUM               <= 1
                )                                                          po
              , ( SELECT ooh.order_number
                    FROM apps.rcv_transactions     rt
                       , apps.oe_order_headers_all ooh
                   WHERE rt.transfer_lpn_id    = qr.lpn_id
                     AND rt.organization_id    = qr.organization_id
                     AND rt.oe_order_header_id = ooh.header_id
                     AND ooh.org_id            = 4330
                     AND ROWNUM               <= 1
                )                                                          rma
              , ( SELECT qr1.character3
                    FROM apps.qa_results_v qr1
                   WHERE qr1.name          = 'GPRS WMS ITEM VELOCITY'
                     AND qr1.character3 LIKE '%ANVISA%'
                     AND qr1.character2    = msi.segment1
                     AND EXISTS ( SELECT 1
                                    FROM apps.mtl_parameters mp
                                   WHERE mp.organization_id    = msi.organization_id
                                     AND mp.organization_code IN ( 'U51', 'U52' )
                                     AND mp.organization_code  = qr1.character1
                                )
                     AND ROWNUM           <= 1
                )                                                          tipo
              , NVL(( SELECT CASE 
                               WHEN rt.transaction_type = 'DELIVER' THEN
                                 'Y'
                             ELSE
                               'N'
                             END
                        FROM apps.rcv_transactions      rt
                       WHERE rt.organization_id  = msi.organization_id
                         AND rt.transfer_lpn_id  = wlpn.lpn_id
                         AND ROWNUM             <= 1
                    ), 'N')                                                Inspecionado
           FROM apps.qa_results_v                 qr
              , apps.mtl_onhand_quantities_detail moqd
              , apps.wms_license_plate_numbers    wlpn
              , apps.wms_lpn_contents             wlc
              , apps.mtl_system_items_b           msi
              , ( SELECT DISTINCT 
                         mmt.shipment_number       ri_number
                       , mmt.subinventory_code     subinventory
                       , mmt.organization_id
                       , mmt.inventory_item_id
                       , mmt.lpn_id
                       , mmt.transfer_lpn_id
                    FROM apps.mtl_material_transactions    mmt
                   WHERE (  mmt.source_code  = 'RCV'
                         OR mmt.source_code != 'RCV' )
                ) mmt_s
          WHERE qr.lpn_id                = moqd.lpn_id(+)
            AND qr.lpn_id                = wlpn.lpn_id
            AND qr.organization_id       = msi.organization_id
            AND wlc.inventory_item_id    = msi.inventory_item_id
            AND wlpn.lpn_id              = wlc.parent_lpn_id
            AND mmt_s.organization_id    = msi.organization_id
            AND mmt_s.inventory_item_id  = msi.inventory_item_id
            AND (  mmt_s.lpn_id          = wlpn.lpn_id
                OR mmt_s.transfer_lpn_id = wlpn.lpn_id )
            AND EXISTS ( SELECT 1
                           FROM apps.mtl_parameters mp
                          WHERE mp.organization_id    = qr.organization_id
                            AND mp.organization_code IN ( 'U51', 'U52' )
                       )
            AND EXISTS ( SELECT 1
                           FROM apps.qa_results_v       qr1
                          WHERE qr1.name          = 'GPRS WMS ITEM VELOCITY'
                            AND qr1.character3 LIKE '%ANVISA%'
                            AND qr1.character2    = msi.segment1
                            AND EXISTS ( SELECT 1
                                           FROM apps.mtl_parameters mp
                                          WHERE mp.organization_id    = msi.organization_id
                                            AND mp.organization_code IN ( 'U51', 'U52' )
                                            AND mp.organization_code  = qr1.character1
                                       )
                       )
            AND qr.name                 IN ('U51 INSPECTION PLAN ANVISA', 'U52 INSPECTION PLAN ANVISA') )avs
            
ORDER BY avs.ri_number
       , avs.lpn
       , avs.item
;
