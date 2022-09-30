/*
    업무일지등록 목록 조회

    Parameters
    - report_write_date_fr : 업무 일지 작성_시작
    - report_write_date_to : 업무 일지 작성_종료
    - emp_name : 사원명(작성자)
*/
select a.report_no
	 , a.report_write_date
	 , a.emp_name
	 , a.exec_ctnt
	 , a.plan_ctnt
	 , a.remark
	 , a.first_rg_yms
	 , a.first_rg_idf
	 , a.last_update_yms
	 , a.last_update_idf
  from bzcm02010_a2 a
 where a.report_write_date between :p_report_write_date_fr and :p_report_write_date_to
   and a.emp_name like '%%' || :p_emp_name || '%%'
