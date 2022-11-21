
select
	pang_sf_get_dept_name(dept_code) as id,
	count(*) as value,
	dept_code
from
	pang_emp_info
where use_yn like '%%' || :p_use_yn || '%%'
group by
dept_code;