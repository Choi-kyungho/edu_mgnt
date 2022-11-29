select
	A.DEPT_CODE,
	A.DEPT_NAME as id,
	COUNT(B.EMP_NO) as VALUE
from
	pang_dept_info A
left outer join pang_emp_info B on
	A.DEPT_CODE = B.DEPT_CODE
where a.use_yn like '%%' || :p_use_yn || '%%'
group by
	A.DEPT_CODE,
	A.DEPT_NAME;