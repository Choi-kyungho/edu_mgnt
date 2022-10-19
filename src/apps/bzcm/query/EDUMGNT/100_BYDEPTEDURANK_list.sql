select
	pang_sf_get_dept_name(dept_code) as 부서명,
	cast(TO_CHAR(ROUND(SUM(case
		when EDU_RATE = 100
		then EDU_TIME
		else cast(EDU_TIME as INTEGER) / 100.0 * cast(edu_rate as INTEGER)
	end)), 'FM9999') as INTEGER) as 수료시간
from
	pang_edu_plan_mgnt
group by
	dept_code
order by
	수료시간 desc
fetch first 7 rows only;