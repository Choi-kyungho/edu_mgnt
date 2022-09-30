
select
    pang_sf_get_dept_name(dept_code) as 부서,
	SUM(EDU_TIME) as 계획,
	TO_CHAR(ROUND(SUM(case
		when EDU_RATE = 100
		then EDU_TIME
		else cast(EDU_TIME as INTEGER) / 100.0 * cast(edu_rate as INTEGER)
	end)), 'FM9999') as 실적
from
	pang_edu_plan_mgnt
where edu_absence_yn like '%%' || :p_edu_absence_yn || '%%'
group by dept_code;