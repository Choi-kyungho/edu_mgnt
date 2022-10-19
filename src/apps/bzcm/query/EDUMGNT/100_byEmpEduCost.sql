select
    sf_get_emp_name(emp_no) as id,
	SUM(cast(edu_cost as INTEGER)) as value
from
	pang_edu_plan_mgnt
where edu_absence_yn like '%%' || :p_edu_absence_yn || '%%'
group by emp_no