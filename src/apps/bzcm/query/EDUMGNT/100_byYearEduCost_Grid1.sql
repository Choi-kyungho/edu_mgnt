select
    edu_year  as edu_year,
    ' -전체- ' as cls,
	TO_CHAR(SUM(cast(edu_cost as INTEGER)), 'FM999,999,999') || '원' as edu_cost
from
	pang_edu_plan_mgnt
where edu_absence_yn like '%%' || :p_edu_absence_yn || '%%'
group by edu_year
order by edu_year