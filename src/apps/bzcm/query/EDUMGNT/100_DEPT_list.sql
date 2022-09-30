
select
	dept_code,
	dept_name,
	use_yn
from
	pang_dept_info
where
	dept_name like '%%' || :p_dept_name || '%%';