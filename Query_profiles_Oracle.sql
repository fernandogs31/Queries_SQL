SELECT user_profile_option_name, name, level_set, context, 
       value, last_update_date, last_updated_by
FROM (
SELECT po.user_profile_option_name,
       po.profile_option_name name,
       pov.level_id,
       decode(pov.level_id,
         10001, 'Site',
         10002, 'Application',
         10003, 'Responsibility',
         10004, 'User',
         10005, 'Server',
         10006, 'Organization',
         10007, 'ServResp',
         'Undefined') LEVEL_SET,
       decode(to_char(pov.level_id),
         '10001', '',
         '10002', app.application_short_name,
         '10003', rsp.responsibility_key,
         '10004', usr.user_name,
         '10005', svr.node_name,
         '10006', org.name,
         '10007', (SELECT n.node_name from apps.fnd_nodes n
                   WHERE n.node_id=level_value2) ||'/'||
                   (decode(pov.level_value, -1,'Default',
                    (SELECT responsibility_key
                     FROM apps.fnd_responsibility
                     WHERE responsibility_id = level_value))),
         pov.level_id) CONTEXT,
       pov.profile_option_value VALUE,
       pov.last_update_date,
       usrlst.user_name last_updated_by
FROM apps.fnd_profile_options_vl po,
    apps.fnd_profile_option_values pov,
     apps.fnd_user usr,
     apps.fnd_application app,
     apps.fnd_responsibility_vl rsp,
     apps.fnd_user usrlst,
     apps.fnd_nodes svr,
     apps.hr_operating_units org
WHERE usrlst.user_id = pov.last_updated_by 
 AND pov.application_id = po.application_id
 AND pov.profile_option_id = po.profile_option_id
 AND usr.user_id(+) = pov.level_value
 AND rsp.application_id(+) = pov.level_value_application_id
 AND rsp.responsibility_id(+) = pov.level_value
 AND app.application_id(+) = pov.level_value
 AND svr.node_id(+) = pov.level_value
 AND org.organization_id(+) = pov.level_value

UNION ALL

SELECT user_profile_option_name, profile_option_name name,
       null level_id,
       'Not Set' LEVEL_SET,
       null CONTEXT,
       null VALUE,
       null last_update_date,
       null last_updated_by
FROM apps.fnd_profile_options_vl p
WHERE NOT EXISTS (SELECT 'x' FROM apps.fnd_profile_option_values ov
                  WHERE p.profile_option_id = ov.profile_option_id)
)
WHERE UPPER(user_profile_option_name) LIKE UPPER('printer')
ORDER BY name, level_id, value;