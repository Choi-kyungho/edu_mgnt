select '사용예산' as id, sum(use_amt) as value from pang_bugt_plan_mgnt
where bugt_year like '%%' || :p_bugt_year || '%%'
group by bugt_year
union
select '잔액' as id, sum(remain_amt) as value from pang_bugt_plan_mgnt
where bugt_year like '%%' || :p_bugt_year || '%%'
group by bugt_year