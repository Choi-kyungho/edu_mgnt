
SELECT A.bugt_year
	 , A.dept_code
	 , A.bugt_amt
	 , A.use_amt
	 , A.remain_amt
	 , A.remark
	 , A.use_yn
	 , A.first_rg_yms
	 , A.first_rg_idf
	 , A.last_update_yms
	 , A.last_update_idf
  FROM pang_bugt_plan_mgnt A
where A.bugt_year like '%%' || :p_bugt_year || '%%'
  and A.dept_code like '%%' || :p_dept_code || '%%'
 order by A.bugt_year, A.dept_code
;

