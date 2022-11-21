
select
	a.edu_plan_no,
	a.edu_schedule_no,
	a.edu_name,
	a.emp_no,
	b.emp_name,
	a.edu_from_dt,
	a.edu_to_dt,
	a.edu_time,
	a.edu_type,
	sf_get_code_name('EDU01', a.edu_type) as edu_type_name,
	a.edu_large_class,
	sf_get_code_name('EDU02', a.edu_large_class) as edu_large_class_name,
	a.edu_middle_class,
	sf_get_code_name('EDU03', a.edu_middle_class) as edu_middle_class_name,
	a.edu_supervision,
	sf_get_code_name('EDU06', a.edu_supervision) as edu_supervision_name,
	a.edu_location,
	a.edu_rate,
	a.edu_cmplt_yn,
	a.edu_absence_yn,
	a.edu_absence_reason,
	a.edu_attach_id,
	a.rmk,
	a.dept_code,
	sf_get_code_name('CM10', a.dept_code) as dept_name,
	a.edu_cost,
	a.edu_year,
	c.close_yn
from
	pang_edu_plan_mgnt a
	left outer join pang_emp_info b on b.emp_no = a.emp_no
	left outer join pang_edu_schdl_mgnt c on c.edu_schedule_no = a.edu_schedule_no
where
	    a.edu_year like '%%' || :p_edu_year || '%%'
	and a.edu_name like '%%' || :p_edu_name || '%%'
	and coalesce(b.emp_name, '%%') like '%%' || :p_emp_name || '%%'
