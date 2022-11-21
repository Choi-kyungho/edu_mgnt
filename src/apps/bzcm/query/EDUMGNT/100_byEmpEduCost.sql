select
    sf_get_emp_name(emp_no) as id,
	SUM(cast(edu_cost as INTEGER)) as value
from
	pang_edu_plan_mgnt
where edu_absence_yn like '%%' || :p_edu_absence_yn || '%%'
  and pang_sf_get_edu_year(edu_schedule_no) BETWEEN cast(:p_edu_year - 2 as CHAR(10)) and cast(:p_edu_year as CHAR(10))
group by emp_no