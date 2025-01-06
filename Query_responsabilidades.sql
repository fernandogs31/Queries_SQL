SELECT frv.responsibility_name,
fpo.profile_option_name,
fpot.user_profile_option_name,
fpov.profile_option_value

FROM apps.fnd_profile_options_tl fpot,
apps.fnd_profile_options fpo,
apps.fnd_profile_option_values fpov,
apps.FND_RESPONSIBILITY_VL frv

WHERE fpot.profile_option_name = fpo.profile_option_name
AND fpo.profile_option_id      = fpov.profile_option_id
--AND fpov.level_id              = '10003'
AND fpov.level_value           = frv.responsibility_id
AND frv.responsibility_name  in ('GEHC Warehouse Management, BR U51 Manager','GEHC Warehouse Management, BR U51 User', 'GEHC Warehouse Management, BR U52 Manager','GEHC Warehouse Management, BR U52 User', 
'GEMSAM OM BR Brasil Cust Serv Supervisor', 'GEHC Warehouse Management, BR U41 Manager','GEHC Warehouse Management, BR U41 User','GEHC Warehouse Management, BR U42 Manager', 'GEHC Warehouse Management, BR U42 User')
order by frv.responsibility_name;