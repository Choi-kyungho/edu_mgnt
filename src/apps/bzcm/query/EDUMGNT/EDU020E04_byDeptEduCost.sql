select a.id, a.총예산, a.사용예산 from(
select
	row_number() over(order by use_amt desc) as rownum,
	pang_sf_get_dept_name(dept_code) as id,
	sum(cast(bugt_amt as INTEGER)) as 총예산 ,
	sum(cast(use_amt as INTEGER)) as 사용예산
from
	pang_bugt_plan_mgnt
where
	bugt_year like '%%' || :p_edu_year || '%%'
group by
	dept_code,
	use_amt
) a
where a.rownum < 10
union ALL
select '기타' as id, SUM(a.총예산) as 총예산, SUM(a.사용예산) as 사용예산 FROM(select
	row_number() over(order by use_amt asc) as rownum,
	pang_sf_get_dept_name(dept_code) as id,
	sum(cast(bugt_amt as INTEGER)) as 총예산 ,
	sum(cast(use_amt as INTEGER)) as 사용예산
from
	pang_bugt_plan_mgnt
where
	bugt_year like '%%' || :p_edu_year || '%%'
group by
	dept_code,
	use_amt
	limit 30) a
	order by 사용예산 desc, 총예산 desc