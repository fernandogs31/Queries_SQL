SELECT gl.set_of_books_id,
gl.name,
gl.short_name,
hou.name operatin_unit,
hou.organization_id operating_unit_id,
org.organization_name warehouse_name,
org.organization_id warehouse_id
 FROM apps.org_organization_definitions org,
 apps.hr_operating_units hou,
 apps.gl_sets_of_books gl
 where org.operating_unit=hou.organization_id
 and hou.set_of_books_id = gl.set_of_books_id
 and gl.currency_code = 'BRL'
order by 1,3,6

select *
from apps.gl_sets_of_books gl