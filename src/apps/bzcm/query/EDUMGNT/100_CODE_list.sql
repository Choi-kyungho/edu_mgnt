
select
	code,
	code_name,
	up_code,
	rmk,
	use_yn
from
	pang_com_code
where code like '%%' || :p_code || '%%'
  and code_name like '%%' || :p_name || '%%'
  and use_yn like '%%' || :p_use_yn || '%%'
;