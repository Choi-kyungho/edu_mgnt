select
    pang_sf_get_edu_year(A.edu_schedule_no) as 연도,
	SUM(A.EDU_TIME) as 계획,
	TO_CHAR(ROUND(SUM(case
		when A.EDU_RATE = 100
		then A.EDU_TIME
		else cast(A.EDU_TIME as INTEGER) / 100.0 * cast(A.edu_rate as INTEGER)
	end)), 'FM9999') as 실적
from
	pang_edu_plan_mgnt A INNER join pang_dept_info B on A.DEPT_CODE = B.DEPT_CODE and B.use_yn = 'Y'
where edu_absence_yn like '%%' || :p_edu_absence_yn || '%%'
  and pang_sf_get_edu_year(A.edu_schedule_no) BETWEEN cast(:p_edu_year - 2 as CHAR(10)) and cast(:p_edu_year as CHAR(10))
--and pang_sf_get_edu_year(edu_schedule_no) BETWEEN '2020' and '2022'
group by A.edu_schedule_no
order by 연도;