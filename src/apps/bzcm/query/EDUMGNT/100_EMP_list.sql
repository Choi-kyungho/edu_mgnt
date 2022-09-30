select
	emp_no,
	user_id,
	emp_name,
	dept_code,
	pang_sf_get_dept_name(dept_code) as dept_name,
	email,
	phon_number,
	job,
	responsi,
	use_yn
from
	pang_emp_info
where
emp_name like '%%' || :p_emp_name || '%%'
;