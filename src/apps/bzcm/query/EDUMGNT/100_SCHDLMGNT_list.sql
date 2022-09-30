
select
	a.edu_schedule_no,
	a.edu_year ,
	a.edu_from_dt,
	a.edu_to_dt,
	a.close_yn,
	a.rmk
from
	pang_edu_schdl_mgnt a
where a.edu_year like '%%' || :p_edu_year || '%%'
  and a.rmk like '%%' || :p_rmk || '%%'