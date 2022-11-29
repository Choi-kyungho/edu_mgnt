select
	bugt_year as edu_year,
	dept_code,
	pang_sf_get_dept_name(dept_code) as cls,
	TO_CHAR(bugt_amt, 'FM999,999,999') || '원' as bugt_amt ,
	TO_CHAR(use_amt, 'FM999,999,999') || '원' as edu_cost ,
	TO_CHAR(remain_amt, 'FM999,999,999') || '원' as remain_amt
from
	pang_bugt_plan_mgnt
where
	bugt_year = '2022'
order by
	use_amt desc,
	bugt_amt