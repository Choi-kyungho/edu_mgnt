select
	sf_get_emp_name(emp_no) as 사원명,
	cast(TO_CHAR(ROUND(SUM(case
		when EDU_RATE = 100
		then EDU_TIME
		else cast(EDU_TIME as INTEGER) / 100.0 * cast(edu_rate as INTEGER)
	end)), 'FM9999') as INTEGER) as 교육수료시간
from
	pang_edu_plan_mgnt
where
	edu_absence_yn like '%%' || :p_edu_absence_yn || '%%'
group by
	emp_no
order by
	교육수료시간 desc
fetch first 7 rows only;