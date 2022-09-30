
select
	a.edu_plan_no,
	a.edu_schedule_no,
	a.edu_name,
	a.emp_no,
	a.edu_large_class,
	a.edu_middle_class,
	a.edu_from_dt,
	a.edu_to_dt
from
	pang_edu_plan_mgnt a
where
	a.edu_plan_no like '%%' || :p_edu_plan_no || '%%'
   