select edu_schedule_no, edu_year, edu_from_dt, edu_to_dt, close_yn, rmk
  from pang_edu_schdl_mgnt
 where edu_schedule_no = (select MAX(edu_schedule_no)
                            from pang_edu_schdl_mgnt
                           where close_yn = :p_close_yn)