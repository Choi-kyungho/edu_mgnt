SELECT  emp_no
          ,user_id
       ,emp_name
       ,dept_code
       ,pang_sf_get_dept_name(dept_code) as dept_name
       ,email
       ,phon_number
       ,job
       ,sf_get_code_name('CM31', job) as job_name
       ,responsi
       ,sf_get_code_name('CM27', responsi) as responsi_name
       ,use_yn
FROM pang_emp_info
WHERE emp_name like '%%' || :p_emp_name || '%%';
ORDER BY dept_code, emp_no;