--------------------------------------------------------------------------------
-- Query 분리를 위해, Object마다 ;; (세미콜론 2개)를 사용합니다.
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- View
--------------------------------------------------------------------------------
--cm_employee_view
create or replace view cm_employee_view as
select   a.emp_no
       , a.corp_code
       , a.busi_place
       , a.emp_name
       , a.unit_work_no
       , a.plant_code
       , b.detail_code_name AS plant_name
       , a.equip_code
       , c.detail_code_name AS equip_name
       , a.unit_work_code
       , d.detail_code_name AS unit_work
       , a.responsi
       , a.ent_date
       , a.on_work_yn
       , a.birthday
       , a.birthday_type
       , a.mobile_no
       , a.email
       , a.first_rg_yms
       , a.last_update_yms
  from cm_employee a
       left join cm_code_detail b on b.cm_code_type_id = 'CM10'
                                 and b.detail_code_id = a.plant_code
                                 and b.etc_ctnt1 = a.busi_place
       left join cm_code_detail c on c.cm_code_type_id = 'CM11'
                                 and c.detail_code_id = a.equip_code
       left join cm_code_detail d on d.cm_code_type_id = 'CM12'
                                 and d.detail_code_id = a.unit_work_code
                                 and d.etc_ctnt1 = a.busi_place
;;


--------------------------------------------------------------------------------
-- Function
--------------------------------------------------------------------------------
--sf_get_code_name
create or replace function sf_get_code_name(p_code_type character varying, p_code character varying)
 returns character varying
 language plpgsql
as $function$
declare
    v_code_name         varchar(100);
begin
    select max(a.detail_code_name)
      into strict v_code_name
      from cm_code_detail a
     where a.cm_code_type_id = p_code_type
       and a.detail_code_id = p_code;

    return v_code_name;
end; $function$
;;


--sf_get_emp_name
create or replace function sf_get_emp_name(p_emp_no character varying)
 returns character varying
 language plpgsql
as $function$
declare
    v_emp_name                  varchar(50);
begin
    begin
        select a.emp_name
          into strict v_emp_name
          from cm_employee a
         where a.emp_no = p_emp_no;
    exception when no_data_found then
        v_emp_name := null;
    end;

    return v_emp_name;
end; $function$
;;


--sf_get_attach_filename
create or replace function sf_get_attach_filename(p_attach_uid character varying)
 returns character varying
 language plpgsql
as $function$
declare
    v_result                varchar(200);
begin
    begin
        select (case when count(*) = 1 then max(a.file_name)
                     else max(a.file_name) || ' 외 ' || trim(to_char(count(*) - 1, '990')) || '건'
                     end) as attach_filename
           into strict v_result
           from cm_attach a
         where a.attach_uid = p_attach_uid
         group by a.attach_uid;
    exception when no_data_found then
        v_result := null;
    end;

    return v_result;
end; $function$
;;


--sf_get_attach_group_filename
create or replace function sf_get_attach_group_filename(p_attach_group_uid character varying)
 returns character varying
 language plpgsql
as $function$
declare
    v_result                varchar(200);
begin
    begin
        select (case when count(*) = 1 then max(a.file_name)
                     else max(a.file_name) || ' 외 ' || trim(to_char(count(*) - 1, '990')) || '건'
                     end) as attach_file_name
           into strict v_result
           from cm_attach a
         where a.attach_uid = p_attach_group_uid
           and a.file_status = 'A'
         group by a.attach_uid;
    exception when no_data_found then
        v_result := null;
    end;

    return v_result;
end; $function$
;;


--------------------------------------------------------------------------------
-- Procedure
--------------------------------------------------------------------------------
--sp_get_sequence
create or replace function sp_get_sequence(p_seq_name character varying, p_prefix character varying, p_padding integer, out p_seq_value character varying)
 returns character varying
 language plpgsql
 security definer
as $function$
declare
    c_initial_value     integer     := 1;
    c_interval          integer     := 1;
    c_default_prefix    varchar     := 'default';
    c_default_padding   integer     := 4;
    v_seq_value         integer;
begin
	p_prefix = coalesce(p_prefix, c_default_prefix);
	p_padding = coalesce(p_padding, c_default_padding);

    begin
        select coalesce(a.last_value, 0) + 1
          into strict v_seq_value
          from cm_sequence a
         where a.seq_name = p_seq_name
           and a.prefix = p_prefix
           for update;
    exception when no_data_found then
        v_seq_value := c_initial_value;

        insert into cm_sequence
               ( seq_name
               , prefix
               , padding
               , last_value
               )
        values ( p_seq_name
               , p_prefix
               , p_padding
               , c_initial_value
               );
        return;
    end;

    if p_prefix = 'default' then
		p_seq_value := lpad(v_seq_value::character varying, p_padding, '0');
	else
    	p_seq_value := p_prefix || lpad(v_seq_value::character varying, p_padding, '0');
    end if;

    update cm_sequence
       set   last_value = v_seq_value
           , padding = p_padding
     where seq_name = p_seq_name
       and prefix = p_prefix;

    --commit;
end;
$function$
;;


--sp_create_exec_log
create or replace function sp_create_exec_log(p_exec_pgm character varying, p_remark character varying, out p_result character varying)
 returns character varying
 language plpgsql
 security definer
as $function$
declare
    v_current_time  timestamp;
begin
    v_current_time := now();
    p_result := to_char(v_current_time, 'YYYY-MM-DD HH24:MI:SS.MS');
    insert into cm_exec_log(exec_time, exec_pgm, remark)
    values (v_current_time, p_exec_pgm, p_remark);
end;
$function$
;;
