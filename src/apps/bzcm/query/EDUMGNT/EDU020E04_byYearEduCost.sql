select
	A.bugt_year as edu_year,
	'-' as cls,
	TO_CHAR(SUM(cast(A.bugt_amt as INTEGER)), 'FM999,999,999') || '원' as bugt_amt ,
	TO_CHAR(SUM(cast(A.use_amt as INTEGER)), 'FM999,999,999') || '원' as edu_cost ,
	TO_CHAR(SUM(cast(A.remain_amt as INTEGER)), 'FM999,999,999') || '원' as remain_amt
from
	pang_bugt_plan_mgnt A
where
	A.bugt_year  BETWEEN cast(:p_edu_year - 2 as CHAR(10)) and cast(:p_edu_year as CHAR(10))
group by
	A.bugt_year
order by
	A.bugt_year