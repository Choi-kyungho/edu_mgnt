select
	A.EDU_YEAR,
	A.DEPT_CODE,
	A.DEPT_NAME,
	A.EMP_NO,
	A.EMP_NAME,
	A.EDU_PLAN_HOUR,
	A.EDU_CMPLT_HOUR,
	A.EDU_CMPLT_RATE || '%%' AS EDU_CMPLT_RATE,
	A.EDU_COST_TOTAL,
	A.EMAIL
from
	(
	select
		A.edu_year as edu_year,
		A.dept_code as dept_code,
		pang_sf_get_dept_name(a.dept_code) as dept_name,
		A.emp_no as emp_no,
		b.emp_nm as EMP_NAME,
		SUM(cast(A.edu_time as INTEGER)) || '시간' as edu_plan_hour,
		b.edu_cmplt_hour || '시간' as edu_cmplt_hour,
		TO_CHAR(ROUND(cast(b.edu_cmplt_hour as FLOAT) / cast(SUM(cast(A.edu_time as FLOAT)) as INTEGER) * 100), 'FM999') as edu_cmplt_rate,
		TO_CHAR(SUM(cast(A.edu_cost as INTEGER)), 'FM999,999,999') || '원' as edu_cost_total,
		c.email
	from
		pang_edu_plan_mgnt A
	left outer join VIEW_EDU_CMPLT_HOUR B on
		A.EDU_YEAR = B.EDU_YEAR
		and A.EMP_NO = B.EMP_NO
    left outer join pang_emp_info c on a.emp_no = c.emp_no
	group by
		A.emp_no,
		A.dept_code,
		A.edu_year,
		b.edu_cmplt_hour,
		b.emp_nm,
		c.email
) A
where
	 A.EDU_YEAR like '%%' || :p_edu_year || '%%'
  AND A.EMP_NAME like '%%' || :p_emp_name || '%%'
  AND A.DEPT_CODE like '%%' || :p_dept_code || '%%'
  AND A.EMP_NO like '%%' || :p_emp_no || '%%'
  AND (CASE
		WHEN A.EDU_CMPLT_RATE = '100'
		THEN 'Y'
		ELSE 'N'
		END) LIKE  '%%' || :p_cmplt_yn || '%%'
order by
	a.edu_year,
	a.dept_code;