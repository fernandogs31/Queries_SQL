SELECT DISTINCT esu.cd_usuario "SSO", esu.nm_usuario "Usuario",(select esu.cd_usuario from ecomex.sen_usuarios esu where esau.grupo_id = esu.id) "Responsabilidade"
FROM ecomex.sen_usuarios esu,
     ecomex.sen_atrib_usuarios esau
WHERE esu.id = esau.usuario_id
AND esau.grupo_id in (100037,100036,100609)
AND esu.dt_inativacao is null
--AND esu.cd_usuario = '502172022'
;