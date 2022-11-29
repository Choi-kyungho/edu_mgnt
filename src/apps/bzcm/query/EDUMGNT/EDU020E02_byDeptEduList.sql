select
    pang_sf_get_dept_name(A.dept_code) as 부서,
    A.dept_code as dept_code,
	SUM(A.EDU_TIME) as 계획,
	TO_CHAR(ROUND(SUM(case
		when A.EDU_RATE = 100
		then A.EDU_TIME
		else cast(A.EDU_TIME as INTEGER) / 100.0 * cast(A.edu_rate as INTEGER)
	end)), 'FM9999') as 실적
from
	pang_edu_plan_mgnt A INNER join pang_dept_info B on A.DEPT_CODE = B.DEPT_CODE and B.use_yn = 'Y'
where A.edu_absence_yn like '%%' || :p_edu_absence_yn || '%%'
  and pang_sf_get_edu_year(A.edu_schedule_no) like '%%' || :p_edu_year || '%%'
group by A.dept_code, A.edu_schedule_no;