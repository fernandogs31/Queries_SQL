select * from all_objects where status = 'INVALID'
/
select object_name, status from dba_objects where object_type like 'MATERIALIZED VIEW' and object_name like 'GE_AP%';
/
select object_name, status from all_objects where object_type like 'MATERIALIZED VIEW' and object_name like 'GE_PO%';