select usr.user_name, resp.responsibility_key, function_type, icx.*
  from apps.icx_sessions icx
  join apps.fnd_user usr on usr.user_id=icx.user_id
  left join apps.fnd_responsibility resp on resp.responsibility_id=icx.responsibility_id
  where --last_connect>sysdate-nvl(FND_PROFILE.VALUE('ICX_SESSION_TIMEOUT'),30)/60/24
    disabled_flag != 'Y' and pseudo_flag = 'N'
    AND usr.USER_NAME <>'GUEST'
    AND usr.USER_NAME <> 'SYSADMIN'
    --and usr.last_connect >='01-APR-24'
    and usr.user_name in ('550003965','550004260','550002090');
    --and resp.responsibility_key like '%MSCA%'