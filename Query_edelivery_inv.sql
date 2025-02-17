select distinct mp.organization_code,
msib.segment1 "PN",
misd.subinventory_code,
decode(mild.default_type,'1','Shipping','2','Receiving') "Default For",
mil.segment1||'.'||mil.segment2||'.'||mil.segment3||'.'||mil.segment4||'.'||mil.segment5 "Locator_Code"

from apps.mtl_item_loc_defaults mild,
apps.MTL_ITEM_SUB_DEFAULTS misd,
apps.mtl_item_locations mil,
apps.mtl_parameters       mp,
apps.mtl_system_items_b   msib

where
misd.inventory_item_id = mild.inventory_item_id
and mild.inventory_item_id = msib.inventory_item_id
and misd.organization_id = mp.organization_id
and mild.locator_id = mil.inventory_location_id
and mp.organization_code = 'DIV'
and misd.subinventory_code = 'FG-EDELVRY'
and mild.default_type in ('1','2')
and msib.segment1 in ('B77031FBED',
'B77131BKED',
'B79821PEED',
'B79821WEED',
'B79831KLED',
'B79831RFED',
'B79831WDED',
'M30321QAED',
'M80171LSED',
'M81521BPED',
'M81521CBED',
'M81631BJED',
'P51821BFED',
'S18021VUED',
'S18031VUED',
'B77221RBED',
'B77231RFED',
'B79031SRED',
'B79821KCED',
'B79931TCED',
'M30321BXED',
'M30321CJED',
'M30321CKED',
'M30321GGED',
'M30331BTED',
'M30361VKED',
'M80171LAED',
'M81521ECED',
'M81601BLED',
'M81621PVED',
'M81631ARED',
'M81631BMED',
'M81631BVED',
'M81631BWED',
'M81631BZED',
'P50801CPED',
'P51831MHED',
'B77021FBED',
'B77021RBED',
'B78121GSED',
'B78121NBED',
'B79021SRED',
'B79821ACED',
'B79821DKED',
'B79921TFED',
'B79971JLED',
'M30321CRED',
'M30331TGED',
'M81521LTED',
'M81521XHED',
'M81631ASED',
'M81631BTED',
'P50801CRED',
'B77021SMED',
'B77121BKED',
'B78121TGED',
'B79821DDED',
'M30321CNED',
'M30331CMED',
'M30361VDED',
'M30361VEED',
'M30361VFED',
'M81061CFED',
'M81521EDED',
'M81601BNED',
'M81601ECED',
'M81631ALED',
'M81631BKED',
'P50821PHED',
'S18021LKED',
'S18121VKED',
'B79821HGED',
'B79821RLED',
'B79841RGED',
'B79921TDED',
'B79931TDED',
'M30321AJED',
'M30321BTED',
'M30321QBED',
'M30361VCED',
'M81531DFED',
'P50831CPED',
'P51821MHED',
'S18021FDED',
'S18121FBED',
'S18121LBED',
'B78331VAED',
'B79021GXED',
'B79031MHED',
'B79031MKED',
'B79821KDED',
'B79821WCED',
'B79821WFED',
'B79921TAED',
'B79921THED',
'M30321TGED',
'M30331BXED',
'M81521CKED',
'M81521VQED',
'M81601BFED',
'M81621PXED',
'M81631BHED',
'M81631BRED',
'M81631BXED',
'M81721PXED',
'S18021XAED',
'B77231RBED',
'B78121MYED',
'B79011MSED',
'B79021MRED',
'B79031HAED',
'B79031MJED',
'B79831KRED',
'B79831RMED',
'B79971JHED',
'B79971JKED',
'M30321CQED',
'M30361VBED',
'M30361VJED',
'M81061LMED',
'M81521BSED',
'M81521CDED',
'M81521TSED',
'M81521XKED',
'M81601BMED',
'M81631SCED',
'P50801CFED',
'P50831PHED',
'P51801BDED',
'B78121BVED',
'B78321VAED',
'B79021GKED',
'B79821DJED',
'B79821HCED',
'B79821HJED',
'B79821KMED',
'B79821REED',
'B79831KEED',
'B79831KKED',
'B79831RGED',
'H25801BGED',
'M81511PSED',
'M81521CJED',
'M81521LSED',
'M81601BDED',
'M81631APED',
'M81631BLED',
'M81631BYED',
'P50821DAED',
'P50821PDED',
'B79971JLED',
'B79821KDED',
'B79821WCED')
;