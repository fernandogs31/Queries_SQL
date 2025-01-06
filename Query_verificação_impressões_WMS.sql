select *
from apps.wsh_report_printers
where concurrent_program_id in (select concurrent_program_id from apps.fnd_concurrent_programs_vl where concurrent_program_name = 'WSHRDPIK' and application_id = 665);