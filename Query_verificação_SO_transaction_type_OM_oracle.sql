SELECT DISTINCT  ood.organization_code
       ,ottt.name
       ,ooha.order_number
      -- ,ooha.ordered_date


FROM apps.oe_order_headers_all ooha
    ,apps.oe_order_lines_all oola
    ,apps.org_organization_definitions ood
    ,apps.oe_transaction_types_tl ottt

WHERE 1=1
AND ooha.order_type_id = ottt.transaction_type_id
AND ooha.ordered_date >= '01-JAN-22'
AND ooha.org_id = 4330
AND ooha.header_id = oola.header_id
AND oola.ship_from_org_id = ood.organization_id
AND ood.organization_code IN ('ASP','DIV','DSP','DMG','C83')
AND ottt.name in ( 'RM_SCRAP_BR'
                  ,'RM_SCRAP_BR_IMP'
                  ,'SCRAP_DOMESTIC_BR'
                  ,'INV_ADJUST_CONS_SCRAP_BR'
                  ,'EQP_BR_RM_SUCATA_C/IMP_DIST'
                  ,'EQP_BR_RM_SUCATA_C/IMP_EC87'
                  ,'GPO_BR_RM_SUCATA_C/IMP_DIST'
                  ,'GPO_BR_RM_SUCATA_C/IMP_EC87'
                  ,'GPO_BR_RM_SUCATA_S/IMP_EC87'
                  ,'EQP_BR_RM_SUCATA_S/IMP_EC87'
                  ,'FA_RM_SUCATA_BR'
                  ,'EQP_BR_RM_DESTRU_C/IMP_DIST'
                  ,'EQP_BR_RM_DESTRU_C/IMP_EC87'
                  ,'GPO_BR_RM_DESTRU_C/IMP_DIST'
                  ,'GPO_BR_RM_DESTRU_C/IMP_EC87'
                  ,'GPO_BR_RM_DESTRU_S/ICMS_EC87'
                  ,'EQP_BR_RM_DESTRU_S/ICMS_EC87'
                  ,'EQP_RM_DESTRUICAO_MIDIA_STW'
                  ,'FA_RM_DESTRUICAO_BR'
)
;
