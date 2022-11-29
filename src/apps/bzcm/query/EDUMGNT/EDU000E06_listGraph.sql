select '사용예산' as id , use_amt as value  from pang_bugt_plan_mgnt
where bugt_year = :p_bugt_year and dept_code like '%%' || :p_dept_code || '%%'
union
select '잔액' as id , remain_amt  as value  from pang_bugt_plan_mgnt
where bugt_year = :p_bugt_year and dept_code like '%%' || :p_dept_code || '%%'