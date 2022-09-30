
select
	sf_get_code_name('CM31',
	JOB) as id,
	COUNT(*) as value
from
	pang_emp_info
where use_yn like '%%' || :p_use_yn || '%%'
group by
	JOB;