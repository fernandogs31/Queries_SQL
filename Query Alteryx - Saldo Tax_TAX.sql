SELECT OOD.ORGANIZATION_CODE,
 ''''||MSI.SEGMENT1||'''' SEGMENT1,
(SELECT CASE WHEN COUNT(*) > 0 THEN 'Y' ELSE 'N' END 
FROM APPS.MTL_CATEGORY_SETS MCS,
APPS.MTL_CATEGORIES_B MCB,
APPS.MTL_ITEM_CATEGORIES MIC 
WHERE MCS.CATEGORY_SET_NAME = 'FISCAL_CLASSIFICATION' 
AND MCS.CATEGORY_SET_ID = MIC.CATEGORY_SET_ID 
AND MCS.STRUCTURE_ID = MCB.STRUCTURE_ID 
AND MCB.CATEGORY_ID = MIC.CATEGORY_ID 
AND MIC.INVENTORY_ITEM_ID = MSI.INVENTORY_ITEM_ID 
AND MIC.ORGANIZATION_ID = MSI.ORGANIZATION_ID AND ROWNUM = 1) FISCAL_CLASSIFICATION,
MSI.GLOBAL_ATTRIBUTE4 IND_PRODUTO,
CASE MSI.GLOBAL_ATTRIBUTE4 
WHEN 'A' THEN 'ATIVO FIXO' 
WHEN 'C' THEN 'COMPRADOS' 
WHEN 'E' THEN 'EMBALAGEM' 
WHEN 'F' THEN 'FABRICADOS' 
WHEN 'I' THEN 'INACABADO' 
WHEN 'M' THEN 'MATERIA-PRIMA' 
WHEN 'O' THEN 'OUTROS' 
WHEN 'S' THEN 'SERVICOS' 
WHEN 'U' THEN 'USO E CONSUMO' END IND_PRD_DESC,
TRANSLATE(MSI.ATTRIBUTE3, CHR(9)||CHR(10)||CHR(13)||';',' ,') DESCRICAO_TRAD, TRANSLATE(MSI.DESCRIPTION, CHR(9)||CHR(10)||CHR(13)||';',' ,') DESCRIPTION,
MSI.CREATION_DATE CREATION_DATE,
MSI.LAST_UPDATE_DATE LAST_UPDATE_DATE 

FROM APPS.MTL_SYSTEM_ITEMS_B MSI,
APPS.ORG_ORGANIZATION_DEFINITIONS OOD,
(SELECT DISTINCT MSI.ORGANIZATION_ID,
MSI.INVENTORY_ITEM_ID 
FROM APPS.MTL_SYSTEM_ITEMS_B MSI,
APPS.CST_PAC_ITEM_COSTS CPIC,
APPS.CST_COST_GROUP_ASSIGNMENTS CCG, 
APPS.CST_PAC_PERIODS CPP, 
APPS.ORG_ORGANIZATION_DEFINITIONS OOD 
WHERE MSI.ORGANIZATION_ID = OOD.ORGANIZATION_ID 
AND MSI.INVENTORY_ITEM_ID = CPIC.INVENTORY_ITEM_ID 
AND MSI.INVENTORY_ITEM_STATUS_CODE != 'INACTIVE' 
AND CPIC.TOTAL_LAYER_QUANTITY != 0 
AND CPIC.PAC_PERIOD_ID = CPP.PAC_PERIOD_ID 
AND CPIC.COST_GROUP_ID = CCG.COST_GROUP_ID 
AND CCG.ORGANIZATION_ID = OOD.ORGANIZATION_ID 
AND CPP.PERIOD_START_DATE >= '01-FEB-24'
AND CPP.PERIOD_END_DATE <= '12-MAR-24'
AND CPP.COST_TYPE_ID = 2782 
AND CPP.LEGAL_ENTITY = OOD.LEGAL_ENTITY 
AND OOD.OPERATING_UNIT = 4330) SLD 
WHERE MSI.INVENTORY_ITEM_ID = SLD.INVENTORY_ITEM_ID 
AND MSI.ORGANIZATION_ID = SLD.ORGANIZATION_ID 
AND OOD.OPERATING_UNIT = 4330 AND OOD.ORGANIZATION_ID = SLD.ORGANIZATION_ID 
and inventory_item_status_code != 'Inactive';