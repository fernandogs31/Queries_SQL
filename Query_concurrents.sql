SELECT fcp.concurrent_program_name, fr.responsibility_key, frg.request_group_name, fcp.user_concurrent_program_name
FROM apps.fnd_concurrent_programs_vl fcp,
     apps.fnd_request_groups frg,
     apps.fnd_request_group_units frgu,
     apps.fnd_responsibility fr 
WHERE fcp.user_concurrent_program_name = 'GE GPRS INV WMS LABEL PDF REPORT'
AND fcp.application_id = frg.application_id
AND frg.request_group_id = frgu.request_group_id
AND frgu.application_id = fr.application_id
;

//

SELECT     responsibility_name ,
       Frg.Request_Group_Name,
       Fcpv.User_Concurrent_Program_Name,
       Fcpv.Description

FROM   apps.fnd_request_groups frg,
       apps.fnd_request_group_units frgu,
       apps.fnd_concurrent_programs_vl fcpv,
       apps.fnd_responsibility_vl frv

WHERE --Frgu.Request_Unit_Type = 'P'
      frgu.request_group_id = frg.request_group_id
AND   Frgu.Request_Unit_Id = Fcpv.Concurrent_Program_Id
AND   Frv.Request_Group_Id = Frg.Request_Group_Id
--AND Frv.Responsibility_Name Like %XXXX%'
AND Fcpv.User_Concurrent_Program_Name like 'GE GPRS INV WMS LABEL PDF REPORT'
ORDER BY Responsibility_Name;