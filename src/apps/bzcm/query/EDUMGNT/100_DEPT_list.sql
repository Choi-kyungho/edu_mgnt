
select
	dept_code, dept_name,use_yn, valid_start_date ,valid_end_date ,parent_dept_code,
	first_rg_yms, first_rg_idf, last_update_yms, last_update_idf
from
	pang_dept_info
where
	dept_code like '%%' || :p_dept_name || '%%'
	order by dept_code ;