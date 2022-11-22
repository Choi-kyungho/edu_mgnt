select
	bugt_year as id,
	SUM(cast(bugt_amt as INTEGER)) as 총예산 ,
	SUM(cast(use_amt as INTEGER)) as 사용예산
--	TO_CHAR(SUM(cast(bugt_amt as INTEGER)), 'FM999,999,999') || '원' as 총예산 ,
--	TO_CHAR(SUM(cast(use_amt as INTEGER)), 'FM999,999,999') || '원' as 사용예산
--  TO_CHAR(SUM(cast(remain_amt as INTEGER)), 'FM999,999,999') || '원' as remain_amt
from
	pang_bugt_plan_mgnt
where bugt_year  BETWEEN cast(:p_edu_year - 2 as CHAR(10)) and cast(:p_edu_year as CHAR(10))
group by
	bugt_year
order by bugt_year