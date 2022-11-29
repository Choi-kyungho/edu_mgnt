select
	sf_get_code_name('CM31',
	A.JOB) as id,
	COUNT(A.JOB) as value,
	A.job
from
	pang_emp_info A
inner join (
	select
		DETAIL_CODE_ID
	from
		cm_code_detail
	where
		cm_code_type_id = 'CM31'
		and USE_YN = 'Y'
) B on
	A.job = B.DETAIL_CODE_ID
where use_yn like '%%' || :p_use_yn || '%%'
group by
	A.JOB;
