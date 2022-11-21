
SELECT edu_code_id
     , edu_code_name
     , cm_code_type_id
     , url
     , addr
     , business_no
     , president
     , tel_no
     , remarks
     , use_yn
     , first_rg_yms
     , first_rg_idf
     , last_update_yms
     , last_update_idf
     , sort_seq
FROM pang_edu_cust_info
where edu_code_id like '%%' || :p_edu_code_id || '%%'
  and edu_code_name like '%%' || :p_edu_code_name || '%%'
 order by sort_seq
;

