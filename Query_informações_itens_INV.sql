SELECT DISTINCT mp.organization_code,
                PHA.SEGMENT1          PO,
                pha.comments,
                PHA.ORG_ID,
                AP.VENDOR_NAME,
                ASSA.VENDOR_SITE_CODE,
                PLA.LINE_NUM,
                PRV.RELEASE_NUM,
                msib.segment1          ITEM
                -- ,PLA.ITEM_ID
               ,
                (select meaning
                   from apps.fnd_lookup_values
                  where lookup_type = 'MTL_LOT_CONTROL'
                    and lookup_code = msib.lot_control_code) lot_control,
                (select meaning
                   from apps.fnd_lookup_values
                  where lookup_type = 'MTL_SHELF_LIFE'
                    and lookup_code = msib.shelf_life_code) shelf_life_control,
                msib.shelf_life_days,
                (select meaning
                   from apps.fnd_lookup_values
                  where lookup_type = 'MTL_SERIAL_NUMBER'
                    and lookup_code = msib.serial_number_control_code) serial_control,
                msib.HAZARD_CLASS_ID,
                (select mc.segment1||'.'||mc.segment2
            from apps.mtl_system_items_b msi,
                 apps.MTL_ITEM_CATEGORIES mic,
                 apps.org_organization_definitions  ood1,
                 apps.MTL_CATEGORY_SETS          mcs,
                 apps.MTL_CATEGORIES             mc

            where mic.inventory_item_id = msi.inventory_item_id
            and   mic.organization_id = msi.organization_id
            and   msi.organization_id = ood1.organization_id
            and   mcs.category_set_id = mic.category_set_id
            and   mc.category_id = mic.category_id
            and   mcs.category_set_name = 'GE_GPO_ITEM_STOCK_REGION'
            and   ood1.organization_id = 1755
            and   msi.inventory_item_id = msib.inventory_item_id) GPO_binbulk,
                PLA.ITEM_DESCRIPTION,
                PLL.QUANTITY,
                PLL.QUANTITY_RECEIVED QTDE_RECEBIDA,
                PLL.QUANTITY_BILLED,
                pla.unit_price,
                hl.LOCATION_CODE,
                PLL.CLOSED_CODE STATUS_ENTREGA,
                PLA.TRANSACTION_REASON_CODE UTILIZACAO_FISCAL_PO,
                PHA.CREATION_DATE,
                GL.CONCATENATED_SEGMENTS,
                FD.USER_NAME SSO_REQUESTOR,
                FD.DESCRIPTION NOME,
                pha.authorization_status,
                PHA.INTERFACE_SOURCE_CODE,
                PHA.ATTRIBUTE6,
                pha.po_header_id,
                pda.po_distribution_id PO_CHARGE_ACCOUNT,
                pda.destination_subinventory
 
  FROM apps.PO_LINE_LOCATIONS_ALL    PLL,
       apps.PO_HEADERS_ALL           PHA,
       apps.PO_LINES_ALL             PLA,
       apps.PO_releases_ALL          PRV,
       apps.hr_locations_all         hl,
       apps.ap_suppliers             ap,
       apps.mtl_system_items_b       msib,
       apps.mtl_parameters           mp,
       apps.ap_supplier_sites_all    assa,
       apps.gl_code_combinations_kfv gl,
       apps.po_distributions_all     pda,
       apps.fnd_user                 fd
WHERE PLL.PO_HEADER_ID = PHA.PO_HEADER_ID
   AND PLL.PO_LINE_ID = PLA.PO_LINE_ID
   and pla.po_header_id = pha.po_header_id
   and pll.ship_to_location_id = hl.location_id
   and ap.vendor_id = pha.vendor_id
   and PRV.PO_RELEASE_ID (+) = PLL.PO_RELEASE_ID
   and msib.inventory_item_id = pla.item_id
   and msib.organization_id = mp.organization_id
   and mp.organization_id = hl.inventory_organization_id
   and ap.vendor_id = assa.vendor_id
   and pha.vendor_site_id = assa.vendor_site_id
   and pda.code_combination_id = gl.code_combination_id
   and pda.line_location_id = pll.line_location_id
   and pda.DELIVER_TO_PERSON_ID = fd.user_id(+)
   and pha.authorization_status = 'APPROVED'
   and PHA.closed_code = 'OPEN'
   and PHA.CREATION_DATE >= '20-MAY-23'
   --and pha.currency_code <> 'BRL'
   --and PLA.TRANSACTION_REASON_CODE is not null
   and mp.organization_code = 'T42'
      --  and ASSA.VENDOR_SITE_CODE = 'IBS MS0100 -M02'
     -- AND PHA.SEGMENT1 in ('551020051878')
AND PHA.INTERFACE_SOURCE_CODE = 'GEMSBUY'
AND PHA.ORG_ID = 4330
--  AND PLL.LINE_LOCATION_ID = 158240860
--AND PHA.ATTRIBUTE6 = 'NATIONALIZE'
--AND MSI.LOT_CONTROL_CODE = 1
--AND AP.VENDOR_NAME LIKE 'GUILHERM%'
--AND ASSA.GLOBAL_ATTRIBUTE9 = '1'
ORDER BY 1, 5,2;