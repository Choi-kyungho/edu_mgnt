select
	sf_get_emp_name(emp_no) as 사원명,
	cast(TO_CHAR(ROUND(SUM(case
		when EDU_RATE = 100
		then EDU_TIME
		else cast(EDU_TIME as INTEGER) / 100.0 * cast(edu_rate as INTEGER)
	end)), 'FM9999') as INTEGER) as 수료시간
from
	pang_edu_plan_mgnt
where
	edu_absence_yn like '%%' || :p_edu_absence_yn || '%%'
  and pang_sf_get_edu_year(edu_schedule_no) like '%%' || :p_edu_year || '%%'
group by
	emp_no, edu_schedule_no
order by
	수료시간 desc
fetch first 7 rows only;