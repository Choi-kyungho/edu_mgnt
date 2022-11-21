select
	edu_year,
	pang_sf_get_dept_name(dept_code) as cls,
	TO_CHAR(SUM(cast(edu_cost as INTEGER)), 'FM999,999,999') || '원' as edu_cost
from
	pang_edu_plan_mgnt
where
	edu_absence_yn like '%%' || :p_edu_absence_yn || '%%'
	and edu_year like '%%' || :p_edu_year || '%%'
group by
	dept_code,
	edu_year
