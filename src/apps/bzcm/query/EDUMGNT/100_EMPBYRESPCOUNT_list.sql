
 select
	sf_get_code_name('CM27',
	responsi) as id,
	COUNT(*) as value,
	responsi
from
	pang_emp_info
where use_yn like '%%' || :p_use_yn || '%%'
group by
	responsi ;