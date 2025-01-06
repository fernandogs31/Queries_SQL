select fp.printer_name   printer_name,                          
        fp.printer_name,  
     fpt.DESCRIPTION                           description
from apps.fnd_printer_tl fpt, apps.fnd_printer fp 
where fp.printer_name = fpt.printer_name 
AND fp.printer_type LIKE '%PASTA%'
and  fp.printer_name like 'br%215'