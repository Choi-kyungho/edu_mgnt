select
	a.edu_year,
	a.dept_code,
	sf_get_code_name('CM10', a.dept_code) as dept_name,
	a.emp_no,
	b.emp_name,
	a.edu_name,
	TO_CHAR(a.edu_cost, 'FM999,999,999') || '원' as edu_cost,
	a.edu_from_dt,
	a.edu_to_dt,
	a.edu_time || ' (h)' as edu_time,
	sf_get_code_name('EDU01', a.edu_type) as edu_type_name,
	sf_get_code_name('EDU02', a.edu_large_class) as edu_large_class_name,
	sf_get_code_name('EDU03', a.edu_middle_class) as edu_middle_class_name,
	sf_get_code_name('EDU06', a.edu_supervision) as edu_supervision_name,
	a.edu_location,
	a.edu_rate || '%%' as edu_rate,
	a.edu_cmplt_yn,
	a.edu_absence_yn,
	a.rmk
from
	pang_edu_plan_mgnt a
	left outer join pang_emp_info b on b.emp_no = a.emp_no
	left outer join pang_edu_schdl_mgnt c on c.edu_schedule_no = a.edu_schedule_no
where
	    a.edu_year like '%%' || :p_edu_year || '%%'
	and b.emp_name like '%%' || :p_emp_name || '%%'
	and a.dept_code like '%%' || :p_dept_code || '%%'
