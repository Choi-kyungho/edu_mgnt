select
    pang_sf_get_dept_name(dept_code) as id,
	SUM(cast(edu_cost as INTEGER)) as value
from
	pang_edu_plan_mgnt
where edu_absence_yn like '%%' || :p_edu_absence_yn || '%%'
group by dept_code