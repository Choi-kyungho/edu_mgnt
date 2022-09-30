select
	edu_plan_no,
	edu_schedule_no,
	edu_name,
	emp_no,
	edu_time,
	edu_type,
	edu_supervision,
	edu_location,
	edu_rate,
	edu_cmplt_yn,
	edu_absence_reason,
	rmk,
	edu_large_class,
	edu_middle_class,
	edu_from_dt,
	edu_to_dt,
	edu_attach_id
from
	pang_edu_plan_mgnt pepm a
where
	a.edu_plan_no like '%%' || :p_edu_plan_no || '%%'