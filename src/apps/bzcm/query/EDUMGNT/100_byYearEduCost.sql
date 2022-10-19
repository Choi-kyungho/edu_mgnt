select
    std_year  as id,
	SUM(cast(edu_cost as INTEGER)) as value
--	TO_CHAR(SUM(cast(edu_cost as INTEGER)), 'FM999,999,999') as value
from
	pang_edu_plan_mgnt
where edu_absence_yn like '%%' || :p_edu_absence_yn || '%%'
group by std_year