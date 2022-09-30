--------------------------------------------------------------------------------
-- 사용자 테이블
--------------------------------------------------------------------------------
CREATE TABLE cm_user (
    user_id nvarchar2(20) NOT NULL, -- 사용자 ID-unique
    user_name nvarchar2(100) NOT NULL, -- 사용자 명
    pwd nvarchar2(200) NOT NULL, -- 비밀번호
    system_type nvarchar2(10) NOT NULL, -- 시스템 유형(SHE,협력사)
    user_level NUMBER(11,0) DEFAULT 5, -- 사용자 레벨 (0:Admin, 1:개발/운영, 5~:일반)
    use_yn nchar(1) DEFAULT 'N', -- 사용 여부
    emp_no nvarchar2(20), -- 사원 번호
    tel_no nvarchar2(20), -- 전화 번호
    email nvarchar2(100), -- 이메일
    remark nvarchar2(500), -- 비고
    first_rg_yms date, -- 최초 등록 일시
    first_rg_idf nvarchar2(20), -- 최초 등록 식별자
    last_update_yms date, -- 최종 업데이트 일시
    last_update_idf nvarchar2(20), -- 최종 업데이트 식별자
    CONSTRAINT pk_cm_user PRIMARY KEY (user_id)
);
COMMENT ON TABLE cm_user IS '사용자';

-- Column comments
COMMENT ON COLUMN cm_user.user_id IS '사용자 ID-unique';
COMMENT ON COLUMN cm_user.user_name IS '사용자 명';
COMMENT ON COLUMN cm_user.pwd IS '비밀번호';
COMMENT ON COLUMN cm_user.system_type IS '시스템 유형(SHE,협력사)';
COMMENT ON COLUMN cm_user.user_level IS '사용자 레벨 (0:Admin, 1:개발/운영, 5~:일반)';
COMMENT ON COLUMN cm_user.use_yn IS '사용 여부';
COMMENT ON COLUMN cm_user.emp_no IS '사원 번호';
COMMENT ON COLUMN cm_user.tel_no IS '전화 번호';
COMMENT ON COLUMN cm_user.email IS '이메일';
COMMENT ON COLUMN cm_user.remark IS '비고';
COMMENT ON COLUMN cm_user.first_rg_yms IS '최초 등록 일시';
COMMENT ON COLUMN cm_user.first_rg_idf IS '최초 등록 식별자';
COMMENT ON COLUMN cm_user.last_update_yms IS '최종 업데이트 일시';
COMMENT ON COLUMN cm_user.last_update_idf IS '최종 업데이트 식별자';


--------------------------------------------------------------------------------
-- Django 관리 테이블
--------------------------------------------------------------------------------
CREATE TABLE auth_group (
    id number(11, 0) GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOT NULL ENABLE,
    name nvarchar2(150) NOT NULL,
    CONSTRAINT uidx_auth_group_name UNIQUE (name),
    CONSTRAINT pk_auth_group PRIMARY KEY (id)
);


CREATE TABLE django_content_type (
    id number(11, 0) GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOT NULL ENABLE,
    app_label nvarchar2(100) NOT NULL,
    model nvarchar2(100) NOT NULL,
    CONSTRAINT uidx_django_content_type1 UNIQUE (app_label, model),
    CONSTRAINT pk_django_content_type PRIMARY KEY (id)
);


CREATE TABLE auth_permission (
    id number(11, 0) GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOT NULL ENABLE,
    name nvarchar2(255) NOT NULL,
    content_type_id NUMBER(11,0) NOT NULL,
    codename nvarchar2(100) NOT NULL,
    CONSTRAINT uidx_auth_permission1 UNIQUE (content_type_id, codename),
    CONSTRAINT pk_auth_permission PRIMARY KEY (id),
    CONSTRAINT fk_auth_pms_ctnt_type FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED
);
CREATE INDEX idx_auth_pms_ctnt_type ON auth_permission (content_type_id);


CREATE TABLE auth_group_permissions (
    id number(19, 0) GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOT NULL ENABLE,
    group_id NUMBER(11,0) NOT NULL,
    permission_id NUMBER(11,0) NOT NULL,
    CONSTRAINT uidx_auth_grp_permissions1 UNIQUE (group_id, permission_id),
    CONSTRAINT pk_auth_grp_pms PRIMARY KEY (id),
    CONSTRAINT fk_auth_grp_pms_auth_pms FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT fk_auth_grp_pms_auth_grp FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED
);
CREATE INDEX idx_auth_grp_pms1 ON auth_group_permissions (group_id);
CREATE INDEX idx_auth_grp_pms2 ON auth_group_permissions (permission_id);


CREATE TABLE django_migrations (
    id number(19, 0) GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOT NULL ENABLE,
    app nvarchar2(255) NOT NULL,
    name nvarchar2(255) NOT NULL,
    applied date NOT NULL,
    CONSTRAINT pk_django_migrations PRIMARY KEY (id)
);


CREATE TABLE django_session (
    session_key nvarchar2(40) NOT NULL,
    session_data clob NOT NULL,
    expire_date date NOT NULL,
    CONSTRAINT pk_django_session PRIMARY KEY (session_key)
);
CREATE INDEX idx_django_session1 ON django_session (expire_date);


CREATE TABLE django_admin_log (
    id number(11, 0) GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOT NULL ENABLE,
    action_time date NOT NULL,
    object_id clob NULL,
    object_repr nvarchar2(200) NOT NULL,
    action_flag number(11, 0) NOT NULL,
    change_message clob NOT NULL,
    content_type_id NUMBER(11,0),
    user_id nvarchar2(20) NOT NULL,
    CONSTRAINT ck_django_admin_log1 CHECK ((action_flag >= 0)),
    CONSTRAINT pk_django_admin_log PRIMARY KEY (id),
    CONSTRAINT fk_dj_admin_log_django_ctnt FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT fk_dj_admin_log_cm_user FOREIGN KEY (user_id) REFERENCES cm_user(user_id) DEFERRABLE INITIALLY DEFERRED
);
CREATE INDEX idx_django_admin_log1 ON django_admin_log (content_type_id);
CREATE INDEX idx_django_admin_log2 ON django_admin_log (user_id);


CREATE TABLE django_apscheduler_djangojob (
    id nvarchar2(255) NOT NULL,
    next_run_time date,
    job_state blob NOT NULL,
    CONSTRAINT pk_django_apscheduler PRIMARY KEY (id)
);
CREATE INDEX idx_django_apscheduler1 ON django_apscheduler_djangojob (next_run_time);


CREATE TABLE django_sch_exec (
    id number(19, 0) GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOT NULL ENABLE,
    status nvarchar2(50) NOT NULL,
    run_time date NOT NULL,
    duration numeric(15, 2),
    finished numeric(15, 2),
    exception nvarchar2(1000),
    traceback clob NULL,
    job_id nvarchar2(255) NOT NULL,
    CONSTRAINT pk_django_sch_exec PRIMARY KEY (id),
    CONSTRAINT uidx_job_executions UNIQUE (job_id, run_time),
    CONSTRAINT fk_django_sch_job FOREIGN KEY (job_id) REFERENCES django_apscheduler_djangojob(id) DEFERRABLE INITIALLY DEFERRED
);
CREATE INDEX idx_django_sch1 ON django_sch_exec (job_id);
CREATE INDEX idx_django_sch2 ON django_sch_exec (run_time);


--------------------------------------------------------------------------------
-- WDK 공통 코드 테이블
--------------------------------------------------------------------------------
CREATE TABLE cm_code_master (
    cm_code_type_id nvarchar2(10) NOT NULL, -- 공통코드유형 식별자
    cm_code_type_name nvarchar2(100) NOT NULL, -- 공통코드유형명
    parent_code_type_id nvarchar2(10), -- 공통코드의 상위 공통코드ID
    cm_code_length NUMBER(11,0) DEFAULT 0, -- 공통코드의 상세코드 길이
    system_yn nchar(1) DEFAULT 'N', -- 시스템여부
    remark nvarchar2(500), -- 비고
    first_rg_yms date, -- 최초 등록 일시
    first_rg_idf nvarchar2(20), -- 최초 등록 식별자
    last_update_yms date, -- 최종 업데이트 일시
    last_update_idf nvarchar2(20), -- 최종 업데이트 식별자
    delete_yn nchar(1) DEFAULT 'N',
    CONSTRAINT pk_ PRIMARY KEY (cm_code_type_id)
);
COMMENT ON TABLE cm_code_master IS '공통코드 기본';

-- Column comments
COMMENT ON COLUMN cm_code_master.cm_code_type_id IS '공통코드유형 식별자';
COMMENT ON COLUMN cm_code_master.cm_code_type_name IS '공통코드유형명';
COMMENT ON COLUMN cm_code_master.parent_code_type_id IS '공통코드의 상위 공통코드ID';
COMMENT ON COLUMN cm_code_master.cm_code_length IS '공통코드의 상세코드 길이';
COMMENT ON COLUMN cm_code_master.system_yn IS '시스템여부';
COMMENT ON COLUMN cm_code_master.remark IS '비고';
COMMENT ON COLUMN cm_code_master.first_rg_yms IS '최초 등록 일시';
COMMENT ON COLUMN cm_code_master.first_rg_idf IS '최초 등록 식별자';
COMMENT ON COLUMN cm_code_master.last_update_yms IS '최종 업데이트 일시';
COMMENT ON COLUMN cm_code_master.last_update_idf IS '최종 업데이트 식별자';


CREATE TABLE cm_code_detail (
    cm_code_type_id nvarchar2(10) NOT NULL, -- 공통 코드 유형 ID
    detail_code_id nvarchar2(10) NOT NULL, -- 상세 코드 ID
    detail_code_name nvarchar2(100) NOT NULL, -- 상세 코드 명
    sort_seq NUMBER(11,0), -- 정렬 순서
    use_yn nchar(1) DEFAULT 'N', -- 사용 여부
    etc_ctnt1 nvarchar2(100), -- 기타 내용1
    etc_ctnt2 nvarchar2(100), -- 기타 내용2
    etc_ctnt3 nvarchar2(100), -- 기타 내용3
    etc_ctnt4 nvarchar2(100), -- 기타 내용4
    etc_ctnt5 nvarchar2(100), -- 기타 내용5
    etc_desc nvarchar2(1000), -- 기타 설명
    valid_start_date date, -- 유효 시작 일자
    valid_end_date date, -- 유효 종료 일자
    first_rg_yms date, -- 최초 등록 일시
    first_rg_idf nvarchar2(20), -- 최초 등록 식별자
    last_update_yms date, -- 최종 업데이트 일시
    last_update_idf nvarchar2(20), -- 최종 업데이트 식별자
    CONSTRAINT pk_cm_code_detail PRIMARY KEY (cm_code_type_id, detail_code_id)
);
COMMENT ON TABLE cm_code_detail IS '공통코드 상세';


-- Column comments
COMMENT ON COLUMN cm_code_detail.cm_code_type_id IS '공통 코드 유형 ID';
COMMENT ON COLUMN cm_code_detail.detail_code_id IS '상세 코드 ID';
COMMENT ON COLUMN cm_code_detail.detail_code_name IS '상세 코드 명';
COMMENT ON COLUMN cm_code_detail.sort_seq IS '정렬 순서';
COMMENT ON COLUMN cm_code_detail.use_yn IS '사용 여부';
COMMENT ON COLUMN cm_code_detail.etc_ctnt1 IS '기타 내용1';
COMMENT ON COLUMN cm_code_detail.etc_ctnt2 IS '기타 내용2';
COMMENT ON COLUMN cm_code_detail.etc_ctnt3 IS '기타 내용3';
COMMENT ON COLUMN cm_code_detail.etc_ctnt4 IS '기타 내용4';
COMMENT ON COLUMN cm_code_detail.etc_ctnt5 IS '기타 내용5';
COMMENT ON COLUMN cm_code_detail.etc_desc IS '기타 설명';
COMMENT ON COLUMN cm_code_detail.valid_start_date IS '유효 시작 일자';
COMMENT ON COLUMN cm_code_detail.valid_end_date IS '유효 종료 일자';
COMMENT ON COLUMN cm_code_detail.first_rg_yms IS '최초 등록 일시';
COMMENT ON COLUMN cm_code_detail.first_rg_idf IS '최초 등록 식별자';
COMMENT ON COLUMN cm_code_detail.last_update_yms IS '최종 업데이트 일시';
COMMENT ON COLUMN cm_code_detail.last_update_idf IS '최종 업데이트 식별자';


--------------------------------------------------------------------------------
-- WDK 조직 관련 테이블
--------------------------------------------------------------------------------
CREATE TABLE cm_corporation (
    corp_code nvarchar2(10) NOT NULL, -- 법인 코드
    corp_no nvarchar2(13), -- 법인 번호
    corp_name nvarchar2(50), -- 법인 이름
    corp_name_en nvarchar2(100), -- 법인 이름(en)
    corp_sht_name nvarchar2(50), -- 법인 이름(약어)
    rep_corp_yn nchar(1),
    president nvarchar2(50), -- 대표자
    president_en nvarchar2(100), -- 대표자(en)
    prsd_sec_no nvarchar2(13), -- 대표자 번호
    biz_type nvarchar2(50), -- 업태
    biz_item nvarchar2(50), -- 업종
    tel_no nvarchar2(25), -- 전화 번호
    fax_no nvarchar2(25), -- 팩스 번호
    zip_code nvarchar2(6), -- 우편 번호
    addr nvarchar2(200), -- 주소
    addr_en nvarchar2(300), -- 주소(en)
    foundation_date date, -- 설립 일자
    remark nvarchar2(100), -- 비고
    first_rg_yms date,
    first_rg_idf nvarchar2(20),
    last_update_yms date,
    last_update_idf nvarchar2(20),
    CONSTRAINT pk_cm_corporation PRIMARY KEY (corp_code)
);
COMMENT ON TABLE cm_corporation IS '법인 정보';

-- Column comments
COMMENT ON COLUMN cm_corporation.corp_code IS '법인 코드';
COMMENT ON COLUMN cm_corporation.corp_no IS '법인 번호';
COMMENT ON COLUMN cm_corporation.corp_name IS '법인 이름';
COMMENT ON COLUMN cm_corporation.corp_name_en IS '법인 이름(en)';
COMMENT ON COLUMN cm_corporation.corp_sht_name IS '법인 이름(약어)';
COMMENT ON COLUMN cm_corporation.president IS '대표자';
COMMENT ON COLUMN cm_corporation.president_en IS '대표자(en)';
COMMENT ON COLUMN cm_corporation.prsd_sec_no IS '대표자 번호';
COMMENT ON COLUMN cm_corporation.biz_type IS '업태';
COMMENT ON COLUMN cm_corporation.biz_item IS '업종';
COMMENT ON COLUMN cm_corporation.tel_no IS '전화 번호';
COMMENT ON COLUMN cm_corporation.fax_no IS '팩스 번호';
COMMENT ON COLUMN cm_corporation.zip_code IS '우편 번호';
COMMENT ON COLUMN cm_corporation.addr IS '주소';
COMMENT ON COLUMN cm_corporation.addr_en IS '주소(en)';
COMMENT ON COLUMN cm_corporation.foundation_date IS '설립 일자';
COMMENT ON COLUMN cm_corporation.remark IS '비고';



CREATE TABLE cm_busiplace (
    corp_code nvarchar2(10) NOT NULL, -- 법인 코드
    busi_place nvarchar2(10) NOT NULL, -- 사업장 코드
    business_no nvarchar2(13), -- 사업자 등록 번호
    busi_place_name nvarchar2(50), -- 사업장 이름
    busi_place_name_en nvarchar2(100), -- 사업장 이름(en)
    busi_place_sht_name nvarchar2(50), -- 사업장 이름(약어)
    rep_busi_place_yn nchar(1),
    president nvarchar2(50), -- 대표자
    president_en nvarchar2(100), -- 대표자(en)
    biz_type nvarchar2(100), -- 업태
    biz_item nvarchar2(100), -- 업종
    zip_code nvarchar2(6), -- 우편 번호
    addr nvarchar2(200), -- 주소
    addr_en nvarchar2(300), -- 주소(en)
    tel_no nvarchar2(25), -- 전화 번호
    fax_no nvarchar2(25), -- 팩스 번호
    tax_office_code nvarchar2(4), -- 세무서 코드
    hometax_id nvarchar2(20), -- 국세청 ID
    slave_busi_no nvarchar2(4), -- 종속 사업자 번호
    sum_recog_no nvarchar2(7),
    prsd_sec_no nvarchar2(13),
    homepage nvarchar2(100),
    cust_code nvarchar2(10), -- 거래처 코드
    item_code nvarchar2(6), -- 종목 코드
    biz_date date,
    remark nvarchar2(100), -- 비고
    first_rg_yms date,
    first_rg_idf nvarchar2(20),
    last_update_yms date,
    last_update_idf nvarchar2(20),
    busi_part nvarchar2(10),
    CONSTRAINT pk_cm_busiplace PRIMARY KEY (corp_code, busi_place),
    CONSTRAINT uid_cm_busiplace UNIQUE (busi_place)
);
COMMENT ON TABLE cm_busiplace IS '사업장 정보';

-- Column comments
COMMENT ON COLUMN cm_busiplace.corp_code IS '법인 코드';
COMMENT ON COLUMN cm_busiplace.busi_place IS '사업장 코드';
COMMENT ON COLUMN cm_busiplace.business_no IS '사업자 등록 번호';
COMMENT ON COLUMN cm_busiplace.busi_place_name IS '사업장 이름';
COMMENT ON COLUMN cm_busiplace.busi_place_name_en IS '사업장 이름(en)';
COMMENT ON COLUMN cm_busiplace.busi_place_sht_name IS '사업장 이름(약어)';
COMMENT ON COLUMN cm_busiplace.president IS '대표자';
COMMENT ON COLUMN cm_busiplace.president_en IS '대표자(en)';
COMMENT ON COLUMN cm_busiplace.biz_type IS '업태';
COMMENT ON COLUMN cm_busiplace.biz_item IS '업종';
COMMENT ON COLUMN cm_busiplace.zip_code IS '우편 번호';
COMMENT ON COLUMN cm_busiplace.addr IS '주소';
COMMENT ON COLUMN cm_busiplace.addr_en IS '주소(en)';
COMMENT ON COLUMN cm_busiplace.tel_no IS '전화 번호';
COMMENT ON COLUMN cm_busiplace.fax_no IS '팩스 번호';
COMMENT ON COLUMN cm_busiplace.tax_office_code IS '세무서 코드';
COMMENT ON COLUMN cm_busiplace.hometax_id IS '국세청 ID';
COMMENT ON COLUMN cm_busiplace.slave_busi_no IS '종속 사업자 번호';
COMMENT ON COLUMN cm_busiplace.cust_code IS '거래처 코드';
COMMENT ON COLUMN cm_busiplace.item_code IS '종목 코드';
COMMENT ON COLUMN cm_busiplace.remark IS '비고';


CREATE TABLE cm_department (
    dept_code nvarchar2(20) NOT NULL, -- 부서 코드
    corp_code nvarchar2(10) NOT NULL, -- 법인 코드
    busi_place nvarchar2(10) NOT NULL, -- 사업장
    dept_name nvarchar2(50) NOT NULL, -- 부서 명
    parent_dept_code nvarchar2(9), -- 상위 부서 코드
    dept_type nvarchar2(10), -- 부서 구분(실/팀/파트 등)
    term_fr date, -- 기간_시작
    term_to date, -- 기간_종료
    print_seq numeric NULL, -- 출력 순서
    first_rg_yms date, -- 최초 등록 일시
    first_rg_idf nvarchar2(20), -- 최초 등록 식별자
    last_update_yms date, -- 최종 업데이트 일시
    last_update_idf nvarchar2(20), -- 최종 업데이트 식별자
    CONSTRAINT pk_cm_department PRIMARY KEY (dept_code)
);
COMMENT ON TABLE cm_department IS '부서정보';

-- Column comments
COMMENT ON COLUMN cm_department.dept_code IS '부서 코드';
COMMENT ON COLUMN cm_department.corp_code IS '법인 코드';
COMMENT ON COLUMN cm_department.busi_place IS '사업장';
COMMENT ON COLUMN cm_department.dept_name IS '부서 명';
COMMENT ON COLUMN cm_department.parent_dept_code IS '상위 부서 코드';
COMMENT ON COLUMN cm_department.dept_type IS '부서 구분(실/팀/파트 등)';
COMMENT ON COLUMN cm_department.term_fr IS '기간_시작';
COMMENT ON COLUMN cm_department.term_to IS '기간_종료';
COMMENT ON COLUMN cm_department.print_seq IS '출력 순서';
COMMENT ON COLUMN cm_department.first_rg_yms IS '최초 등록 일시';
COMMENT ON COLUMN cm_department.first_rg_idf IS '최초 등록 식별자';
COMMENT ON COLUMN cm_department.last_update_yms IS '최종 업데이트 일시';
COMMENT ON COLUMN cm_department.last_update_idf IS '최종 업데이트 식별자';


CREATE TABLE cm_employee (
    emp_no nvarchar2(10) NOT NULL, -- 사원 번호
    corp_code nvarchar2(10) NOT NULL, -- 법인 코드
    busi_place nvarchar2(10) NOT NULL, -- 사업장
    emp_name nvarchar2(50) NOT NULL, -- 사원 명
    emp_name_en nvarchar2(100), -- 사원 명(EN)
    emp_name_cn nvarchar2(20), -- 사원 명(한자)
    dept_code nvarchar2(20), -- 부서 코드
    unit_work_no nvarchar2(20), -- 단위 작업 번호, 부서/공장,직무 관리
    plant_code nvarchar2(10), -- 공장 코드, 공통코드: CM10
    equip_code nvarchar2(10), -- 설비 코드, 공통코드: CM11
    unit_work_code nvarchar2(10), -- 단위 작업 코드, 공통코드: CM12
    emp_grd nvarchar2(10), -- 직급
    position nvarchar2(10), -- 직위
    responsi nvarchar2(10), -- 직책
    duty nvarchar2(10), -- 직무
    occup_kind nvarchar2(10), -- 직종
    ent_code nvarchar2(10), -- 입사 코드
    ent_date date, -- 입사 일자
    grp_ent_date date, -- 그룹 일사 일자
    curr_stat nvarchar2(10), -- 현재 상태
    curr_stat_date date, -- 현재 상태 일자
    retire_code nvarchar2(10), -- 퇴사 코드
    retire_date date, -- 퇴사 일자
    retire_calc_date date, -- 퇴사 계산 일자
    on_work_yn nchar(1) DEFAULT 'Y', -- 재직 여부
    personal_sec_no nvarchar2(13), -- 주민등록번호
    gender nvarchar2(10), -- 성별
    birthday date, -- 생년월일
    birthday_type nvarchar2(10), -- 생년월일 구분
    zipcode nvarchar2(6), -- 우편번호
    addr nvarchar2(100), -- 주소
    tel_no nvarchar2(20), -- 전화 번호
    mobile_no nvarchar2(20), -- 휴대전화 번호
    email nvarchar2(100), -- 이메일
    live_nation_code nvarchar2(10), -- 국적 코드
    foreigner_type nvarchar2(10), -- 외국인 구분
    user_id nvarchar2(20), -- 사용자 ID
    first_rg_yms date, -- 최초 등록 일시
    first_rg_idf nvarchar2(20), -- 최초 등록 식별자
    last_update_yms date, -- 최종 업데이트 일시
    last_update_idf nvarchar2(20), -- 최종 업데이트 식별자
    CONSTRAINT pk_cm_employee PRIMARY KEY (emp_no)
);
COMMENT ON TABLE cm_employee IS '사원정보';

-- Column comments
COMMENT ON COLUMN cm_employee.emp_no IS '사원 번호';
COMMENT ON COLUMN cm_employee.corp_code IS '법인 코드';
COMMENT ON COLUMN cm_employee.busi_place IS '사업장';
COMMENT ON COLUMN cm_employee.emp_name IS '사원 명';
COMMENT ON COLUMN cm_employee.emp_name_en IS '사원 명(EN)';
COMMENT ON COLUMN cm_employee.emp_name_cn IS '사원 명(한자)';
COMMENT ON COLUMN cm_employee.dept_code IS '부서 코드';
COMMENT ON COLUMN cm_employee.unit_work_no IS '단위 작업 번호, 부서/공장,직무 관리';
COMMENT ON COLUMN cm_employee.plant_code IS '공장 코드, 공통코드: CM10';
COMMENT ON COLUMN cm_employee.equip_code IS '설비 코드, 공통코드: CM11';
COMMENT ON COLUMN cm_employee.unit_work_code IS '단위 작업 코드, 공통코드: CM12';
COMMENT ON COLUMN cm_employee.emp_grd IS '직급';
COMMENT ON COLUMN cm_employee.position IS '직위';
COMMENT ON COLUMN cm_employee.responsi IS '직책';
COMMENT ON COLUMN cm_employee.duty IS '직무';
COMMENT ON COLUMN cm_employee.occup_kind IS '직종';
COMMENT ON COLUMN cm_employee.ent_code IS '입사 코드';
COMMENT ON COLUMN cm_employee.ent_date IS '입사 일자';
COMMENT ON COLUMN cm_employee.grp_ent_date IS '그룹 일사 일자';
COMMENT ON COLUMN cm_employee.curr_stat IS '현재 상태';
COMMENT ON COLUMN cm_employee.curr_stat_date IS '현재 상태 일자';
COMMENT ON COLUMN cm_employee.retire_code IS '퇴사 코드';
COMMENT ON COLUMN cm_employee.retire_date IS '퇴사 일자';
COMMENT ON COLUMN cm_employee.retire_calc_date IS '퇴사 계산 일자';
COMMENT ON COLUMN cm_employee.on_work_yn IS '재직 여부';
COMMENT ON COLUMN cm_employee.personal_sec_no IS '주민등록번호';
COMMENT ON COLUMN cm_employee.gender IS '성별';
COMMENT ON COLUMN cm_employee.birthday IS '생년월일';
COMMENT ON COLUMN cm_employee.birthday_type IS '생년월일 구분';
COMMENT ON COLUMN cm_employee.zipcode IS '우편번호';
COMMENT ON COLUMN cm_employee.addr IS '주소';
COMMENT ON COLUMN cm_employee.tel_no IS '전화 번호';
COMMENT ON COLUMN cm_employee.mobile_no IS '휴대전화 번호';
COMMENT ON COLUMN cm_employee.email IS '이메일';
COMMENT ON COLUMN cm_employee.live_nation_code IS '국적 코드';
COMMENT ON COLUMN cm_employee.foreigner_type IS '외국인 구분';
COMMENT ON COLUMN cm_employee.user_id IS '사용자 ID';
COMMENT ON COLUMN cm_employee.first_rg_yms IS '최초 등록 일시';
COMMENT ON COLUMN cm_employee.first_rg_idf IS '최초 등록 식별자';
COMMENT ON COLUMN cm_employee.last_update_yms IS '최종 업데이트 일시';
COMMENT ON COLUMN cm_employee.last_update_idf IS '최종 업데이트 식별자';


--------------------------------------------------------------------------------
-- WDK 메뉴 관련 테이블
--------------------------------------------------------------------------------
CREATE TABLE cm_program (
    pgm_id nvarchar2(20) NOT NULL, -- 프로그램 ID-unique
    pgm_name nvarchar2(100) NOT NULL, -- 프로그램 명
    system_code nvarchar2(10) NOT NULL, -- 시스템 코드
    pgm_type nvarchar2(10) NOT NULL, -- 프로그램 유형-등록,조회,배치,리포트,팝업
    pgm_url nvarchar2(200), -- 프로그램 URL
    use_yn nchar(1) DEFAULT 'N', -- 사용 여부
    first_rg_yms date, -- 최초 등록 일시
    first_rg_idf nvarchar2(20), -- 최초 등록 식별자
    last_update_yms date, -- 최종 업데이트 일시
    last_update_idf nvarchar2(20), -- 최종 업데이트 식별자
    CONSTRAINT pk_cm_program PRIMARY KEY (pgm_id)
);
COMMENT ON TABLE cm_program IS '프로그램 목록';

-- Column comments
COMMENT ON COLUMN cm_program.pgm_id IS '프로그램 ID-unique';
COMMENT ON COLUMN cm_program.pgm_name IS '프로그램 명';
COMMENT ON COLUMN cm_program.system_code IS '시스템 코드';
COMMENT ON COLUMN cm_program.pgm_type IS '프로그램 유형-등록,조회,배치,리포트,팝업';
COMMENT ON COLUMN cm_program.pgm_url IS '프로그램 URL';
COMMENT ON COLUMN cm_program.use_yn IS '사용 여부';
COMMENT ON COLUMN cm_program.first_rg_yms IS '최초 등록 일시';
COMMENT ON COLUMN cm_program.first_rg_idf IS '최초 등록 식별자';
COMMENT ON COLUMN cm_program.last_update_yms IS '최종 업데이트 일시';
COMMENT ON COLUMN cm_program.last_update_idf IS '최종 업데이트 식별자';


CREATE TABLE cm_menu (
    menu_sno NUMBER(11,0) NOT NULL, -- 메뉴 일련번호
    menu_name nvarchar2(100) NOT NULL, -- 메뉴 명
    system_type nvarchar2(10) NOT NULL, -- 시스템 유형(SHE,협력사)
    parent_menu_sno NUMBER(11,0), -- 부모 메뉴 일련번호
    sort_seq NUMBER(11,0), -- 정렬 순서
    use_yn nchar(1) DEFAULT 'N', -- 사용 여부
    first_rg_yms date, -- 최초 등록 일시
    first_rg_idf nvarchar2(20), -- 최초 등록 식별자
    last_update_yms date, -- 최종 업데이트 일시
    last_update_idf nvarchar2(20), -- 최종 업데이트 식별자
    CONSTRAINT pk_cm_menu PRIMARY KEY (menu_sno)
);
COMMENT ON TABLE cm_menu IS '메뉴 정의';

-- Column comments
COMMENT ON COLUMN cm_menu.menu_sno IS '메뉴 일련번호';
COMMENT ON COLUMN cm_menu.menu_name IS '메뉴 명';
COMMENT ON COLUMN cm_menu.system_type IS '시스템 유형(SHE,협력사)';
COMMENT ON COLUMN cm_menu.parent_menu_sno IS '부모 메뉴 일련번호';
COMMENT ON COLUMN cm_menu.sort_seq IS '정렬 순서';
COMMENT ON COLUMN cm_menu.use_yn IS '사용 여부';
COMMENT ON COLUMN cm_menu.first_rg_yms IS '최초 등록 일시';
COMMENT ON COLUMN cm_menu.first_rg_idf IS '최초 등록 식별자';
COMMENT ON COLUMN cm_menu.last_update_yms IS '최종 업데이트 일시';
COMMENT ON COLUMN cm_menu.last_update_idf IS '최종 업데이트 식별자';


CREATE TABLE cm_menu_pgm (
    run_sno NUMBER(11,0) NOT NULL, -- 실행 일련번호
    run_name nvarchar2(100) NOT NULL, -- 실행 명(기본-프로그램 명)
    menu_sno NUMBER(11,0) NOT NULL, -- 메뉴 일련번호
    pgm_id nvarchar2(20) NOT NULL, -- 프로그램 ID
    sort_seq NUMBER(11,0), -- 정렬 순서
    use_yn nchar(1) DEFAULT 'N', -- 사용 여부
    first_rg_yms date, -- 최초 등록 일시
    first_rg_idf nvarchar2(20), -- 최초 등록 식별자
    last_update_yms date, -- 최종 업데이트 일시
    last_update_idf nvarchar2(20), -- 최종 업데이트 식별자
    CONSTRAINT pk_cm_menu_pgm PRIMARY KEY (run_sno)
);
COMMENT ON TABLE cm_menu_pgm IS '메뉴별 프로그램';

-- Column comments
COMMENT ON COLUMN cm_menu_pgm.run_sno IS '실행 일련번호';
COMMENT ON COLUMN cm_menu_pgm.run_name IS '실행 명(기본-프로그램 명)';
COMMENT ON COLUMN cm_menu_pgm.menu_sno IS '메뉴 일련번호';
COMMENT ON COLUMN cm_menu_pgm.pgm_id IS '프로그램 ID';
COMMENT ON COLUMN cm_menu_pgm.sort_seq IS '정렬 순서';
COMMENT ON COLUMN cm_menu_pgm.use_yn IS '사용 여부';
COMMENT ON COLUMN cm_menu_pgm.first_rg_yms IS '최초 등록 일시';
COMMENT ON COLUMN cm_menu_pgm.first_rg_idf IS '최초 등록 식별자';
COMMENT ON COLUMN cm_menu_pgm.last_update_yms IS '최종 업데이트 일시';
COMMENT ON COLUMN cm_menu_pgm.last_update_idf IS '최종 업데이트 식별자';


CREATE TABLE cm_menu_param (
    run_sno NUMBER(11,0) NOT NULL, -- 실행 일련번호
    param_name nvarchar2(100) NOT NULL, -- 파라미터 명
    param_value nvarchar2(100), -- 파라미터 값
    remark nvarchar2(500), -- 비고
    first_rg_yms date, -- 최초 등록 일시
    first_rg_idf nvarchar2(20), -- 최초 등록 식별자
    last_update_yms date, -- 최종 업데이트 일시
    last_update_idf nvarchar2(20), -- 최종 업데이트 식별자
    CONSTRAINT pk_cm_menu_param PRIMARY KEY (run_sno, param_name)
);
COMMENT ON TABLE cm_menu_param IS '메뉴 프로그램 상세';

-- Column comments
COMMENT ON COLUMN cm_menu_param.run_sno IS '실행 일련번호';
COMMENT ON COLUMN cm_menu_param.param_name IS '파라미터 명';
COMMENT ON COLUMN cm_menu_param.param_value IS '파라미터 값';
COMMENT ON COLUMN cm_menu_param.remark IS '비고';
COMMENT ON COLUMN cm_menu_param.first_rg_yms IS '최초 등록 일시';
COMMENT ON COLUMN cm_menu_param.first_rg_idf IS '최초 등록 식별자';
COMMENT ON COLUMN cm_menu_param.last_update_yms IS '최종 업데이트 일시';
COMMENT ON COLUMN cm_menu_param.last_update_idf IS '최종 업데이트 식별자';


CREATE TABLE cm_user_menu (
    user_id nvarchar2(20) NOT NULL, -- 사용자 ID
    menu_sno NUMBER(11,0) NOT NULL, -- 메뉴 일련번호
    menu_name nvarchar2(100) NOT NULL, -- 메뉴 명
    parent_menu_sno NUMBER(11,0), -- 부모 메뉴 일련번호
    sort_seq NUMBER(11,0), -- 정렬 순서
    first_rg_yms date, -- 최초 등록 일시
    first_rg_idf nvarchar2(20), -- 최초 등록 식별자
    last_update_yms date, -- 최종 업데이트 일시
    last_update_idf nvarchar2(20), -- 최종 업데이트 식별자
    CONSTRAINT pk_cm_user_menu PRIMARY KEY (user_id, menu_sno)
);
COMMENT ON TABLE cm_user_menu IS '개인 메뉴';

-- Column comments
COMMENT ON COLUMN cm_user_menu.user_id IS '사용자 ID';
COMMENT ON COLUMN cm_user_menu.menu_sno IS '메뉴 일련번호';
COMMENT ON COLUMN cm_user_menu.menu_name IS '메뉴 명';
COMMENT ON COLUMN cm_user_menu.parent_menu_sno IS '부모 메뉴 일련번호';
COMMENT ON COLUMN cm_user_menu.sort_seq IS '정렬 순서';
COMMENT ON COLUMN cm_user_menu.first_rg_yms IS '최초 등록 일시';
COMMENT ON COLUMN cm_user_menu.first_rg_idf IS '최초 등록 식별자';
COMMENT ON COLUMN cm_user_menu.last_update_yms IS '최종 업데이트 일시';
COMMENT ON COLUMN cm_user_menu.last_update_idf IS '최종 업데이트 식별자';


CREATE TABLE cm_user_menu_pgm (
    user_id nvarchar2(20) NOT NULL, -- 사용자 ID
    menu_sno NUMBER(11,0) NOT NULL, -- 메뉴 일련번호
    run_sno NUMBER(11,0) NOT NULL, -- 실행 일련번호
    run_name nvarchar2(100) NOT NULL, -- 실행 명
    sort_seq NUMBER(11,0), -- 정렬 순서
    first_rg_yms date, -- 최초 등록 일시
    first_rg_idf nvarchar2(20), -- 최초 등록 식별자
    last_update_yms date, -- 최종 업데이트 일시
    last_update_idf nvarchar2(20), -- 최종 업데이트 식별자
    CONSTRAINT pk_cm_user_menu_pgm PRIMARY KEY (user_id, menu_sno, run_sno)
);
COMMENT ON TABLE cm_user_menu_pgm IS '개인 메뉴 프로그램 상세';

-- Column comments
COMMENT ON COLUMN cm_user_menu_pgm.user_id IS '사용자 ID';
COMMENT ON COLUMN cm_user_menu_pgm.menu_sno IS '메뉴 일련번호';
COMMENT ON COLUMN cm_user_menu_pgm.run_sno IS '실행 일련번호';
COMMENT ON COLUMN cm_user_menu_pgm.run_name IS '실행 명';
COMMENT ON COLUMN cm_user_menu_pgm.sort_seq IS '정렬 순서';
COMMENT ON COLUMN cm_user_menu_pgm.first_rg_yms IS '최초 등록 일시';
COMMENT ON COLUMN cm_user_menu_pgm.first_rg_idf IS '최초 등록 식별자';
COMMENT ON COLUMN cm_user_menu_pgm.last_update_yms IS '최종 업데이트 일시';
COMMENT ON COLUMN cm_user_menu_pgm.last_update_idf IS '최종 업데이트 식별자';


--------------------------------------------------------------------------------
-- WDK 권한 관련 테이블
--------------------------------------------------------------------------------
CREATE TABLE cm_group (
    group_sno NUMBER(11,0) NOT NULL, -- 그룹 일련번호
    group_name nvarchar2(100) NOT NULL, -- 그룹 명
    system_type nvarchar2(10) NOT NULL, -- 시스템 유형(SHE,협력사)
    use_yn nchar(1) DEFAULT 'N', -- 사용 여부
    remark nvarchar2(500), -- 비고
    first_rg_yms date, -- 최초 등록 일시
    first_rg_idf nvarchar2(20), -- 최초 등록 식별자
    last_update_yms date, -- 최종 업데이트 일시
    last_update_idf nvarchar2(20), -- 최종 업데이트 식별자
    CONSTRAINT pk_cm_group PRIMARY KEY (group_sno)
);
COMMENT ON TABLE cm_group IS '그룹';

-- Column comments
COMMENT ON COLUMN cm_group.group_sno IS '그룹 일련번호';
COMMENT ON COLUMN cm_group.group_name IS '그룹 명';
COMMENT ON COLUMN cm_group.system_type IS '시스템 유형(SHE,협력사)';
COMMENT ON COLUMN cm_group.use_yn IS '사용 여부';
COMMENT ON COLUMN cm_group.remark IS '비고';
COMMENT ON COLUMN cm_group.first_rg_yms IS '최초 등록 일시';
COMMENT ON COLUMN cm_group.first_rg_idf IS '최초 등록 식별자';
COMMENT ON COLUMN cm_group.last_update_yms IS '최종 업데이트 일시';
COMMENT ON COLUMN cm_group.last_update_idf IS '최종 업데이트 식별자';


CREATE TABLE cm_group_users (
    group_sno NUMBER(11,0) NOT NULL, -- 그룹 일련번호
    user_id nvarchar2(20) NOT NULL, -- 사용자 ID
    first_rg_yms date, -- 최초 등록 일시
    first_rg_idf nvarchar2(20), -- 최초 등록 식별자
    last_update_yms date, -- 최종 업데이트 일시
    last_update_idf nvarchar2(20), -- 최종 업데이트 식별자
    CONSTRAINT pk_cm_group_users PRIMARY KEY (group_sno, user_id)
);
COMMENT ON TABLE cm_group_users IS '그룹별 사용자';

-- Column comments
COMMENT ON COLUMN cm_group_users.group_sno IS '그룹 일련번호';
COMMENT ON COLUMN cm_group_users.user_id IS '사용자 ID';
COMMENT ON COLUMN cm_group_users.first_rg_yms IS '최초 등록 일시';
COMMENT ON COLUMN cm_group_users.first_rg_idf IS '최초 등록 식별자';
COMMENT ON COLUMN cm_group_users.last_update_yms IS '최종 업데이트 일시';
COMMENT ON COLUMN cm_group_users.last_update_idf IS '최종 업데이트 식별자';


CREATE TABLE cm_role (
    role_no nvarchar2(20) NOT NULL, -- Role 번호
    role_type nvarchar2(20) NOT NULL, -- Role 유형 - AA14
    role_name nvarchar2(100) NOT NULL, -- Role 명
    system_yn nchar(1) DEFAULT 'N', -- 시스템 여부
    use_yn nchar(1) DEFAULT 'N', -- 사용 여부
    remark nvarchar2(500), -- 비고
    first_rg_yms date, -- 최초 등록 일시
    first_rg_idf nvarchar2(20), -- 최초 등록 식별자
    last_update_yms date, -- 최종 업데이트 일시
    last_update_idf nvarchar2(20), -- 최종 업데이트 식별자
    CONSTRAINT pk_cm_role PRIMARY KEY (role_no)
);
COMMENT ON TABLE cm_role IS 'Role';

-- Column comments
COMMENT ON COLUMN cm_role.role_no IS 'Role 번호';
COMMENT ON COLUMN cm_role.role_type IS 'Role 유형 - AA14';
COMMENT ON COLUMN cm_role.role_name IS 'Role 명';
COMMENT ON COLUMN cm_role.system_yn IS '시스템 여부';
COMMENT ON COLUMN cm_role.use_yn IS '사용 여부';
COMMENT ON COLUMN cm_role.remark IS '비고';
COMMENT ON COLUMN cm_role.first_rg_yms IS '최초 등록 일시';
COMMENT ON COLUMN cm_role.first_rg_idf IS '최초 등록 식별자';
COMMENT ON COLUMN cm_role.last_update_yms IS '최종 업데이트 일시';
COMMENT ON COLUMN cm_role.last_update_idf IS '최종 업데이트 식별자';


CREATE TABLE cm_user_role (
    user_id nvarchar2(20) NOT NULL, -- 사용자 ID
    role_no nvarchar2(20) NOT NULL, -- Role 번호
    first_rg_yms date, -- 최초 등록 일시
    first_rg_idf nvarchar2(20), -- 최초 등록 식별자
    last_update_yms date, -- 최종 업데이트 일시
    last_update_idf nvarchar2(20), -- 최종 업데이트 식별자
    CONSTRAINT pk_cm_user_role PRIMARY KEY (user_id, role_no)
);
COMMENT ON TABLE cm_user_role IS '사용자 Role';

-- Column comments
COMMENT ON COLUMN cm_user_role.user_id IS '사용자 ID';
COMMENT ON COLUMN cm_user_role.role_no IS 'Role 번호';
COMMENT ON COLUMN cm_user_role.first_rg_yms IS '최초 등록 일시';
COMMENT ON COLUMN cm_user_role.first_rg_idf IS '최초 등록 식별자';
COMMENT ON COLUMN cm_user_role.last_update_yms IS '최종 업데이트 일시';
COMMENT ON COLUMN cm_user_role.last_update_idf IS '최종 업데이트 식별자';


CREATE TABLE cm_group_auth (
    group_sno NUMBER(11,0) NOT NULL, -- 그룹 일련번호
    run_sno NUMBER(11,0) NOT NULL, -- 실행 일련번호
    use_yn nchar(1) DEFAULT 'N', -- 사용 여부
    select_yn nchar(1) DEFAULT 'N', -- 조회/선택 여부
    save_yn nchar(1) DEFAULT 'N', -- 저장 여부
    print_yn nchar(1) DEFAULT 'N', -- 인쇄 여부
    custom_yn nchar(1) DEFAULT 'N', -- 커스텀 여부
    first_rg_yms date, -- 최초 등록 일시
    first_rg_idf nvarchar2(20), -- 최초 등록 식별자
    last_update_yms date, -- 최종 업데이트 일시
    last_update_idf nvarchar2(20), -- 최종 업데이트 식별자
    CONSTRAINT pk_cm_group_auth PRIMARY KEY (group_sno, run_sno)
);
COMMENT ON TABLE cm_group_auth IS '그룹 메뉴 권한';

-- Column comments
COMMENT ON COLUMN cm_group_auth.group_sno IS '그룹 일련번호';
COMMENT ON COLUMN cm_group_auth.run_sno IS '실행 일련번호';
COMMENT ON COLUMN cm_group_auth.use_yn IS '사용 여부';
COMMENT ON COLUMN cm_group_auth.select_yn IS '조회/선택 여부';
COMMENT ON COLUMN cm_group_auth.save_yn IS '저장 여부';
COMMENT ON COLUMN cm_group_auth.print_yn IS '인쇄 여부';
COMMENT ON COLUMN cm_group_auth.custom_yn IS '커스텀 여부';
COMMENT ON COLUMN cm_group_auth.first_rg_yms IS '최초 등록 일시';
COMMENT ON COLUMN cm_group_auth.first_rg_idf IS '최초 등록 식별자';
COMMENT ON COLUMN cm_group_auth.last_update_yms IS '최종 업데이트 일시';
COMMENT ON COLUMN cm_group_auth.last_update_idf IS '최종 업데이트 식별자';


CREATE TABLE cm_user_auth (
    user_id nvarchar2(20) NOT NULL, -- 사용자 ID
    run_sno NUMBER(11,0) NOT NULL, -- 실행 일련번호
    use_yn nchar(1) DEFAULT 'N', -- 사용 여부
    select_yn nchar(1) DEFAULT 'N', -- 조회선택 여부
    save_yn nchar(1) DEFAULT 'N', -- 저장 여부
    print_yn nchar(1) DEFAULT 'N', -- 인쇄 여부
    custom_yn nchar(1) DEFAULT 'N', -- 커스텀 여부
    first_rg_yms date, -- 최초 등록 일시
    first_rg_idf nvarchar2(20), -- 최초 등록 식별자
    last_update_yms date, -- 최종 업데이트 일시
    last_update_idf nvarchar2(20), -- 최종 업데이트 식별자
    CONSTRAINT pk_cm_user_auth PRIMARY KEY (user_id, run_sno)
);
COMMENT ON TABLE cm_user_auth IS '사용자 메뉴 권한';

-- Column comments
COMMENT ON COLUMN cm_user_auth.user_id IS '사용자 ID';
COMMENT ON COLUMN cm_user_auth.run_sno IS '실행 일련번호';
COMMENT ON COLUMN cm_user_auth.use_yn IS '사용 여부';
COMMENT ON COLUMN cm_user_auth.select_yn IS '조회선택 여부';
COMMENT ON COLUMN cm_user_auth.save_yn IS '저장 여부';
COMMENT ON COLUMN cm_user_auth.print_yn IS '인쇄 여부';
COMMENT ON COLUMN cm_user_auth.custom_yn IS '커스텀 여부';
COMMENT ON COLUMN cm_user_auth.first_rg_yms IS '최초 등록 일시';
COMMENT ON COLUMN cm_user_auth.first_rg_idf IS '최초 등록 식별자';
COMMENT ON COLUMN cm_user_auth.last_update_yms IS '최종 업데이트 일시';
COMMENT ON COLUMN cm_user_auth.last_update_idf IS '최종 업데이트 식별자';


CREATE TABLE cm_user_menu_auth (
    user_id nvarchar2(20) NOT NULL, -- 사용자 ID
    menu_tree_sno nvarchar2(10) NOT NULL,
    parent_menu_tree_sno nvarchar2(10) NOT NULL, -- 부모 메뉴 트리 일련번호
    menu_sno NUMBER(11,0) NOT NULL, -- 메뉴 일련번호
    run_sno NUMBER(11,0) NOT NULL, -- 실행 일련번호
    menu_path nvarchar2(100),
    menu_name nvarchar2(100) NOT NULL, -- 실행 메뉴 명
    system_type nvarchar2(10) NOT NULL, -- 시스템 유형(SHE,협력사)
    system_code nvarchar2(10), -- 시스템 코드
    pgm_id nvarchar2(20), -- 프로그램 ID-unique
    pgm_type nvarchar2(10), -- 프로그램 유형-등록,조회,배치,리포트,팝업
    pgm_url nvarchar2(200), -- 프로그램 URL
    pgm_param nvarchar2(500), -- 파라미터 명, 파라미터 값
    sort_seq NUMBER(11,0), -- 정렬 순서
    tree_level NUMBER(11,0), -- 트리 레벨
    use_yn nchar(1) DEFAULT 'N', -- 사용 여부
    select_yn nchar(1) DEFAULT 'N', -- 조회/선택 여부
    save_yn nchar(1) DEFAULT 'N', -- 저장 여부
    print_yn nchar(1) DEFAULT 'N', -- 인쇄 여부
    custom_yn nchar(1) DEFAULT 'N', -- 커스텀 여부
    auth_kind nvarchar2(10), -- 권한 유형(G: 그룹, U:사용자)
    menu_type nvarchar2(10), -- 메뉴 유형-폴더,프로그램
    first_rg_yms date, -- 최초 등록 일시
    first_rg_idf nvarchar2(20), -- 최초 등록 식별자
    last_update_yms date, -- 최종 업데이트 일시
    last_update_idf nvarchar2(20), -- 최종 업데이트 식별자
    CONSTRAINT pk_cm_user_menu_auth PRIMARY KEY (user_id, menu_tree_sno)
);
COMMENT ON TABLE cm_user_menu_auth IS '사용자별 메뉴 권한 정보';

-- Column comments
COMMENT ON COLUMN cm_user_menu_auth.user_id IS '사용자 ID';
COMMENT ON COLUMN cm_user_menu_auth.parent_menu_tree_sno IS '부모 메뉴 트리 일련번호';
COMMENT ON COLUMN cm_user_menu_auth.menu_sno IS '메뉴 일련번호';
COMMENT ON COLUMN cm_user_menu_auth.run_sno IS '실행 일련번호';
COMMENT ON COLUMN cm_user_menu_auth.menu_name IS '실행 메뉴 명';
COMMENT ON COLUMN cm_user_menu_auth.system_type IS '시스템 유형(SHE,협력사)';
COMMENT ON COLUMN cm_user_menu_auth.system_code IS '시스템 코드';
COMMENT ON COLUMN cm_user_menu_auth.pgm_id IS '프로그램 ID-unique';
COMMENT ON COLUMN cm_user_menu_auth.pgm_type IS '프로그램 유형-등록,조회,배치,리포트,팝업';
COMMENT ON COLUMN cm_user_menu_auth.pgm_url IS '프로그램 URL';
COMMENT ON COLUMN cm_user_menu_auth.pgm_param IS '파라미터 명, 파라미터 값';
COMMENT ON COLUMN cm_user_menu_auth.sort_seq IS '정렬 순서';
COMMENT ON COLUMN cm_user_menu_auth.tree_level IS '트리 레벨';
COMMENT ON COLUMN cm_user_menu_auth.use_yn IS '사용 여부';
COMMENT ON COLUMN cm_user_menu_auth.select_yn IS '조회/선택 여부';
COMMENT ON COLUMN cm_user_menu_auth.save_yn IS '저장 여부';
COMMENT ON COLUMN cm_user_menu_auth.print_yn IS '인쇄 여부';
COMMENT ON COLUMN cm_user_menu_auth.custom_yn IS '커스텀 여부';
COMMENT ON COLUMN cm_user_menu_auth.auth_kind IS '권한 유형(G: 그룹, U:사용자)';
COMMENT ON COLUMN cm_user_menu_auth.menu_type IS '메뉴 유형-폴더,프로그램';
COMMENT ON COLUMN cm_user_menu_auth.first_rg_yms IS '최초 등록 일시';
COMMENT ON COLUMN cm_user_menu_auth.first_rg_idf IS '최초 등록 식별자';
COMMENT ON COLUMN cm_user_menu_auth.last_update_yms IS '최종 업데이트 일시';
COMMENT ON COLUMN cm_user_menu_auth.last_update_idf IS '최종 업데이트 식별자';


--------------------------------------------------------------------------------
-- WDK 확장 기능 관련 테이블 (결재)
--------------------------------------------------------------------------------
CREATE TABLE cm_apprv_line_main (
    apprv_line_id nvarchar2(36) NOT NULL, -- 결재 선 ID, UUID
    corp_code nvarchar2(10) NOT NULL, -- 법인 코드
    busi_place nvarchar2(10) NOT NULL, -- 사업장
    apprv_line_name nvarchar2(100) NOT NULL, -- 결재 선 명
    run_sno NUMBER(11,0) NOT NULL, -- 실행 일련번호
    rg_user_id nvarchar2(20) NOT NULL, -- 등록 사용자 ID
    rg_emp_no nvarchar2(20) NOT NULL, -- 등록 사번
    rg_date date NOT NULL, -- 등록 일자
    todo_type nvarchar2(10) NOT NULL, -- TODO 유형
    fix_yn nchar(1) DEFAULT 'N', -- 고정 여부
    first_rg_yms date, -- 최초 등록 일시
    first_rg_idf nvarchar2(20), -- 최초 등록 식별자
    last_update_yms date, -- 최종 업데이트 일시
    last_update_idf nvarchar2(20), -- 최종 업데이트 식별자
    CONSTRAINT xpk_cm_apprv_line_main PRIMARY KEY (apprv_line_id)
);
COMMENT ON TABLE cm_apprv_line_main IS '결재선 관리 메인';

-- Column comments
COMMENT ON COLUMN cm_apprv_line_main.apprv_line_id IS '결재 선 ID, UUID';
COMMENT ON COLUMN cm_apprv_line_main.corp_code IS '법인 코드';
COMMENT ON COLUMN cm_apprv_line_main.busi_place IS '사업장';
COMMENT ON COLUMN cm_apprv_line_main.apprv_line_name IS '결재 선 명';
COMMENT ON COLUMN cm_apprv_line_main.run_sno IS '실행 일련번호';
COMMENT ON COLUMN cm_apprv_line_main.rg_user_id IS '등록 사용자 ID';
COMMENT ON COLUMN cm_apprv_line_main.rg_emp_no IS '등록 사번';
COMMENT ON COLUMN cm_apprv_line_main.rg_date IS '등록 일자';
COMMENT ON COLUMN cm_apprv_line_main.todo_type IS 'TODO 유형';
COMMENT ON COLUMN cm_apprv_line_main.fix_yn IS '고정 여부';
COMMENT ON COLUMN cm_apprv_line_main.first_rg_yms IS '최초 등록 일시';
COMMENT ON COLUMN cm_apprv_line_main.first_rg_idf IS '최초 등록 식별자';
COMMENT ON COLUMN cm_apprv_line_main.last_update_yms IS '최종 업데이트 일시';
COMMENT ON COLUMN cm_apprv_line_main.last_update_idf IS '최종 업데이트 식별자';


CREATE TABLE cm_apprv_line_detail (
    apprv_line_id nvarchar2(36) NOT NULL, -- 결재 선 ID, UUID
    apprv_line_sno NUMBER(11,0) NOT NULL, -- 결재 선 일련번호
    apprv_step nvarchar2(10) NOT NULL, -- 결재 단계
    apprv_role_type nvarchar2(10) NOT NULL, -- 결재 ROLE 유형, 공통코드: CM19
    apprv_role_no nvarchar2(20), -- 결재 ROLE 번호, CM19가 R(ROLE) 인 경우
    apprv_user_id nvarchar2(20), -- 결재 사용자 ID, CM19가 U(USER) 인 경우
    apprv_emp_no nvarchar2(20), -- 결재 사원 번호, CM19가 U(USER) 인 경우
    apprv_plant_code nvarchar2(20), -- 결재 공장 코드, CM19가 T(team) 인 경우
    apprv_fix_yn nchar(1) DEFAULT 'N', -- 고정 여부
    first_rg_yms date, -- 최초 등록 일시
    first_rg_idf nvarchar2(20), -- 최초 등록 식별자
    last_update_yms date, -- 최종 업데이트 일시
    last_update_idf nvarchar2(20), -- 최종 업데이트 식별자
    CONSTRAINT xpk_cm_apprv_line_detail PRIMARY KEY (apprv_line_id, apprv_line_sno)
);
COMMENT ON TABLE cm_apprv_line_detail IS '결재선 관리 상세';

-- Column comments
COMMENT ON COLUMN cm_apprv_line_detail.apprv_line_id IS '결재 선 ID, UUID';
COMMENT ON COLUMN cm_apprv_line_detail.apprv_line_sno IS '결재 선 일련번호';
COMMENT ON COLUMN cm_apprv_line_detail.apprv_step IS '결재 단계';
COMMENT ON COLUMN cm_apprv_line_detail.apprv_role_type IS '결재 ROLE 유형, 공통코드: CM19';
COMMENT ON COLUMN cm_apprv_line_detail.apprv_role_no IS '결재 ROLE 번호, CM19가 R(ROLE) 인 경우';
COMMENT ON COLUMN cm_apprv_line_detail.apprv_user_id IS '결재 사용자 ID, CM19가 U(USER) 인 경우';
COMMENT ON COLUMN cm_apprv_line_detail.apprv_emp_no IS '결재 사원 번호, CM19가 U(USER) 인 경우';
COMMENT ON COLUMN cm_apprv_line_detail.apprv_plant_code IS '결재 공장 코드, CM19가 T(team) 인 경우';
COMMENT ON COLUMN cm_apprv_line_detail.apprv_fix_yn IS '고정 여부';
COMMENT ON COLUMN cm_apprv_line_detail.first_rg_yms IS '최초 등록 일시';
COMMENT ON COLUMN cm_apprv_line_detail.first_rg_idf IS '최초 등록 식별자';
COMMENT ON COLUMN cm_apprv_line_detail.last_update_yms IS '최종 업데이트 일시';
COMMENT ON COLUMN cm_apprv_line_detail.last_update_idf IS '최종 업데이트 식별자';


CREATE TABLE cm_apprv_main (
    apprv_id nvarchar2(20) NOT NULL, -- 결재 ID, 번호체계(년월일+일련번호(3))
    apprv_date date NOT NULL, -- 결재 일자
    apprv_time date NOT NULL, -- 결재 시간
    rfa_user_id nvarchar2(20) NOT NULL, -- 상신 사용자 ID
    rfa_emp_no nvarchar2(20) NOT NULL, -- 상신 사원 번호
    rfa_emp_dept nvarchar2(20) NOT NULL, -- 상신 사원 부서
    apprv_stat nvarchar2(10) NOT NULL, -- 결재 상태, 공통코드: CM03
    curr_apprv_step nvarchar2(10) NOT NULL, -- 현재 결재 단계
    next_apprv_step nvarchar2(10) NOT NULL, -- 다음 결재 단계
    apprv_step_cnt NUMBER(11,0) NOT NULL, -- 결재 단계 수
    last_apprv_yn nchar(1) DEFAULT 'N', -- 최종 결재 여부
    run_sno NUMBER(11,0) NOT NULL, -- 실행 일련번호, 실행 일련번호
    table_unique_id nvarchar2(2000) NOT NULL, -- 테이블 고유 ID, { KEY: VALUE }
    todo_type nvarchar2(10) NOT NULL, -- TODO 유형
    fix_yn nchar(1) DEFAULT 'N', -- 고정 여부
    first_rg_yms date, -- 최초 등록 일시
    first_rg_idf nvarchar2(20), -- 최초 등록 식별자
    last_update_yms date, -- 최종 업데이트 일시
    last_update_idf nvarchar2(20), -- 최종 업데이트 식별자
    CONSTRAINT xpk_cm_apprv_main PRIMARY KEY (apprv_id)
);
COMMENT ON TABLE cm_apprv_main IS '결재 관리 메인';

-- Column comments
COMMENT ON COLUMN cm_apprv_main.apprv_id IS '결재 ID, 번호체계(년월일+일련번호(3))';
COMMENT ON COLUMN cm_apprv_main.apprv_date IS '결재 일자';
COMMENT ON COLUMN cm_apprv_main.apprv_time IS '결재 시간';
COMMENT ON COLUMN cm_apprv_main.rfa_user_id IS '상신 사용자 ID';
COMMENT ON COLUMN cm_apprv_main.rfa_emp_no IS '상신 사원 번호';
COMMENT ON COLUMN cm_apprv_main.rfa_emp_dept IS '상신 사원 부서';
COMMENT ON COLUMN cm_apprv_main.apprv_stat IS '결재 상태, 공통코드: CM03';
COMMENT ON COLUMN cm_apprv_main.curr_apprv_step IS '현재 결재 단계';
COMMENT ON COLUMN cm_apprv_main.next_apprv_step IS '다음 결재 단계';
COMMENT ON COLUMN cm_apprv_main.apprv_step_cnt IS '결재 단계 수';
COMMENT ON COLUMN cm_apprv_main.last_apprv_yn IS '최종 결재 여부';
COMMENT ON COLUMN cm_apprv_main.run_sno IS '실행 일련번호, 실행 일련번호';
COMMENT ON COLUMN cm_apprv_main.table_unique_id IS '테이블 고유 ID, { KEY: VALUE }';
COMMENT ON COLUMN cm_apprv_main.todo_type IS 'TODO 유형';
COMMENT ON COLUMN cm_apprv_main.fix_yn IS '고정 여부';
COMMENT ON COLUMN cm_apprv_main.first_rg_yms IS '최초 등록 일시';
COMMENT ON COLUMN cm_apprv_main.first_rg_idf IS '최초 등록 식별자';
COMMENT ON COLUMN cm_apprv_main.last_update_yms IS '최종 업데이트 일시';
COMMENT ON COLUMN cm_apprv_main.last_update_idf IS '최종 업데이트 식별자';


CREATE TABLE cm_apprv_detail (
    apprv_id nvarchar2(20) NOT NULL, -- 결재 ID, 번호체계(년월일+일련번호(3))
    apprv_sno NUMBER(11,0) NOT NULL, -- 결재 일련번호
    apprv_step nvarchar2(10) NOT NULL, -- 결재 단계
    apprv_stat nvarchar2(10), -- 결재 상태, 공통코드: CM03
    apprv_date date, -- 결재 일자
    apprv_time date, -- 결재 시간
    apprv_role_type nvarchar2(10), -- 결재 ROLE 유형, 공통코드: CM19
    apprv_role_no nvarchar2(20), -- 결재 ROLE 번호
    apprv_user_id nvarchar2(20), -- 결재 사용자 ID
    apprv_plant_code nvarchar2(20), -- 결재 공장 코드
    apprv_fix_yn nchar(1) DEFAULT 'N', -- 고정 여부
    apprv_emp_no nvarchar2(20), -- 결재 사원 번호
    apprv_emp_dept nvarchar2(20), -- 결재 사원 부서
    remark nvarchar2(500), -- 비고
    first_rg_yms date, -- 최초 등록 일시
    first_rg_idf nvarchar2(20), -- 최초 등록 식별자
    last_update_yms date, -- 최종 업데이트 일시
    last_update_idf nvarchar2(20), -- 최종 업데이트 식별자
    CONSTRAINT xpk_cm_apprv_detail PRIMARY KEY (apprv_id, apprv_sno)
);
COMMENT ON TABLE cm_apprv_detail IS '결재 관리 상세';

-- Column comments
COMMENT ON COLUMN cm_apprv_detail.apprv_id IS '결재 ID, 번호체계(년월일+일련번호(3))';
COMMENT ON COLUMN cm_apprv_detail.apprv_sno IS '결재 일련번호';
COMMENT ON COLUMN cm_apprv_detail.apprv_step IS '결재 단계';
COMMENT ON COLUMN cm_apprv_detail.apprv_stat IS '결재 상태, 공통코드: CM03';
COMMENT ON COLUMN cm_apprv_detail.apprv_date IS '결재 일자';
COMMENT ON COLUMN cm_apprv_detail.apprv_time IS '결재 시간';
COMMENT ON COLUMN cm_apprv_detail.apprv_role_type IS '결재 ROLE 유형, 공통코드: CM19';
COMMENT ON COLUMN cm_apprv_detail.apprv_role_no IS '결재 ROLE 번호';
COMMENT ON COLUMN cm_apprv_detail.apprv_user_id IS '결재 사용자 ID';
COMMENT ON COLUMN cm_apprv_detail.apprv_plant_code IS '결재 공장 코드';
COMMENT ON COLUMN cm_apprv_detail.apprv_fix_yn IS '고정 여부';
COMMENT ON COLUMN cm_apprv_detail.apprv_emp_no IS '결재 사원 번호';
COMMENT ON COLUMN cm_apprv_detail.apprv_emp_dept IS '결재 사원 부서';
COMMENT ON COLUMN cm_apprv_detail.remark IS '비고';
COMMENT ON COLUMN cm_apprv_detail.first_rg_yms IS '최초 등록 일시';
COMMENT ON COLUMN cm_apprv_detail.first_rg_idf IS '최초 등록 식별자';
COMMENT ON COLUMN cm_apprv_detail.last_update_yms IS '최종 업데이트 일시';
COMMENT ON COLUMN cm_apprv_detail.last_update_idf IS '최종 업데이트 식별자';


CREATE TABLE cm_apprv_history (
    apprv_history_id NUMBER(19, 0) GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOT NULL ENABLE, -- 결재 이력 ID, 순번 자동 증가, BIGINT
    apprv_id nvarchar2(20) NOT NULL, -- 결재 ID
    apprv_sno NUMBER(11,0) NOT NULL, -- 결재 일련번호
    apprv_step nvarchar2(10) NOT NULL, -- 결재 단계
    apprv_stat nvarchar2(10) NOT NULL, -- 결재 상태
    apprv_date date NOT NULL, -- 결재 일자
    apprv_user_id nvarchar2(20) NOT NULL, -- 결재 사용자 ID
    apprv_emp_no nvarchar2(20) NOT NULL, -- 결재 사원 번호
    remark nvarchar2(500), -- 비고
    first_rg_yms date, -- 최초 등록 일시
    first_rg_idf nvarchar2(20), -- 최초 등록 식별자
    last_update_yms date, -- 최종 업데이트 일시
    last_update_idf nvarchar2(20), -- 최종 업데이트 식별자
    CONSTRAINT xpk_cm_apprv_history PRIMARY KEY (apprv_history_id)
);
COMMENT ON TABLE cm_apprv_history IS '결재 이력';

-- Column comments
COMMENT ON COLUMN cm_apprv_history.apprv_history_id IS '결재 이력 ID, 순번 자동 증가, BIGINT';
COMMENT ON COLUMN cm_apprv_history.apprv_id IS '결재 ID';
COMMENT ON COLUMN cm_apprv_history.apprv_sno IS '결재 일련번호';
COMMENT ON COLUMN cm_apprv_history.apprv_step IS '결재 단계';
COMMENT ON COLUMN cm_apprv_history.apprv_stat IS '결재 상태';
COMMENT ON COLUMN cm_apprv_history.apprv_date IS '결재 일자';
COMMENT ON COLUMN cm_apprv_history.apprv_user_id IS '결재 사용자 ID';
COMMENT ON COLUMN cm_apprv_history.apprv_emp_no IS '결재 사원 번호';
COMMENT ON COLUMN cm_apprv_history.remark IS '비고';
COMMENT ON COLUMN cm_apprv_history.first_rg_yms IS '최초 등록 일시';
COMMENT ON COLUMN cm_apprv_history.first_rg_idf IS '최초 등록 식별자';
COMMENT ON COLUMN cm_apprv_history.last_update_yms IS '최종 업데이트 일시';
COMMENT ON COLUMN cm_apprv_history.last_update_idf IS '최종 업데이트 식별자';


--------------------------------------------------------------------------------
-- WDK 확장 기능 관련 테이블 (첨부)
--------------------------------------------------------------------------------
CREATE TABLE cm_attach (
    file_uid nvarchar2(36) NOT NULL, -- 첨부파일 UID
    attach_uid nvarchar2(36) NOT NULL, -- 첨부 UID-첨부 대상 묶음용
    attach_type nvarchar2(10) NOT NULL, -- 첨부 유형
    attach_date date NOT NULL, -- 첨부 일자
    user_id nvarchar2(20) NOT NULL, -- 첨부 사용자 ID
    multi_yn nchar(1) DEFAULT 'N', -- 다중 첨부 여부
    file_path nvarchar2(200), -- 최초 파일 경로
    file_name nvarchar2(100), -- 파일 명
    file_size numeric(22, 4), -- 파일 사이즈
    file_type nvarchar2(10), -- 파일 유형
    server_path nvarchar2(200), -- 서버 경로
    server_file_name nvarchar2(100), -- 서버 파일 명
    thumbnail_path nvarchar2(200), -- 썸네일 경로(파일명 포함)
    thumbnail_file_name nvarchar2(100), -- 썸네일 파일 명
    thumbnail_data clob NULL, -- 썸네일(base64)
    ref_table_name nvarchar2(50), -- 관련 테이블 명
    ref_column_names nvarchar2(50), -- 관련 칼럼 명(,로 연결)
    ref_key_values nvarchar2(100), -- 관련 데이터 키값(,로 연결)
    file_status nvarchar2(10), -- 파일상태(T-임시 업로드, A-정상, D-삭제 대기)
    delete_yn nchar(1) DEFAULT 'N', -- 삭제 여부
    first_rg_yms date, -- 최초 등록 일시
    first_rg_idf nvarchar2(20), -- 최초 등록 식별자
    last_update_yms date, -- 최종 업데이트 일시
    last_update_idf nvarchar2(20), -- 최종 업데이트 식별자
    CONSTRAINT pk_cm_attach PRIMARY KEY (file_uid)
);
COMMENT ON TABLE cm_attach IS '첨부파일';

-- Column comments
COMMENT ON COLUMN cm_attach.file_uid IS '첨부파일 UID';
COMMENT ON COLUMN cm_attach.attach_uid IS '첨부 UID-첨부 대상 묶음용';
COMMENT ON COLUMN cm_attach.attach_type IS '첨부 유형';
COMMENT ON COLUMN cm_attach.attach_date IS '첨부 일자';
COMMENT ON COLUMN cm_attach.user_id IS '첨부 사용자 ID';
COMMENT ON COLUMN cm_attach.multi_yn IS '다중 첨부 여부';
COMMENT ON COLUMN cm_attach.file_path IS '최초 파일 경로';
COMMENT ON COLUMN cm_attach.file_name IS '파일 명';
COMMENT ON COLUMN cm_attach.file_size IS '파일 사이즈';
COMMENT ON COLUMN cm_attach.file_type IS '파일 유형';
COMMENT ON COLUMN cm_attach.server_path IS '서버 경로';
COMMENT ON COLUMN cm_attach.server_file_name IS '서버 파일 명';
COMMENT ON COLUMN cm_attach.thumbnail_path IS '썸네일 경로(파일명 포함)';
COMMENT ON COLUMN cm_attach.thumbnail_file_name IS '썸네일 파일 명';
COMMENT ON COLUMN cm_attach.thumbnail_data IS '썸네일(base64)';
COMMENT ON COLUMN cm_attach.ref_table_name IS '관련 테이블 명';
COMMENT ON COLUMN cm_attach.ref_column_names IS '관련 칼럼 명(,로 연결)';
COMMENT ON COLUMN cm_attach.ref_key_values IS '관련 데이터 키값(,로 연결)';
COMMENT ON COLUMN cm_attach.file_status IS '파일상태(T-임시 업로드, A-정상, D-삭제 대기)';
COMMENT ON COLUMN cm_attach.delete_yn IS '삭제 여부';
COMMENT ON COLUMN cm_attach.first_rg_yms IS '최초 등록 일시';
COMMENT ON COLUMN cm_attach.first_rg_idf IS '최초 등록 식별자';
COMMENT ON COLUMN cm_attach.last_update_yms IS '최종 업데이트 일시';
COMMENT ON COLUMN cm_attach.last_update_idf IS '최종 업데이트 식별자';


CREATE TABLE cm_template (
    mgt_sno NUMBER(11,0) GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOT NULL ENABLE, -- 관리 일련번호, 자동채번
    rg_date date, -- 등록 일자
    ctnt nvarchar2(500), -- 내용
    rg_emp_no nvarchar2(20), -- 등록 사번, 공통 코드
    email_attach_no nvarchar2(20), -- 메일 첨부 번호, 특정 메일 발송시 첨부하기 위한 참고 번호
    attach_id nvarchar2(36), -- 첨부 ID
    remark nvarchar2(500), -- 비고
    first_rg_yms date,
    first_rg_idf nvarchar2(20),
    last_update_yms date,
    last_update_idf nvarchar2(20),
    CONSTRAINT pk_cm_template PRIMARY KEY (mgt_sno)
);
COMMENT ON TABLE cm_template IS '양식 파일 관리';

-- Column comments
COMMENT ON COLUMN cm_template.mgt_sno IS '관리 일련번호, 자동채번';
COMMENT ON COLUMN cm_template.rg_date IS '등록 일자';
COMMENT ON COLUMN cm_template.ctnt IS '내용';
COMMENT ON COLUMN cm_template.rg_emp_no IS '등록 사번, 공통 코드';
COMMENT ON COLUMN cm_template.email_attach_no IS '메일 첨부 번호, 특정 메일 발송시 첨부하기 위한 참고 번호';
COMMENT ON COLUMN cm_template.attach_id IS '첨부 ID';
COMMENT ON COLUMN cm_template.remark IS '비고';


--------------------------------------------------------------------------------
-- WDK 확장 기능 관련 테이블 (메일)
--------------------------------------------------------------------------------
CREATE TABLE cm_mail_history (
    send_sno NUMBER(11,0) GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOT NULL ENABLE, -- 전송 일련번호, 자동채번
    send_date date, -- 전송 일자
    send_time date, -- 전송 일시
    email_type nvarchar2(10), -- 메일 유형, 공통 코드
    sender nvarchar2(50), -- 송신자
    receiver nvarchar2(500), -- 수신자
    title nvarchar2(100), -- 제목, 공통코드: SF02
    first_rg_yms date,
    first_rg_idf nvarchar2(20),
    last_update_yms date,
    last_update_idf nvarchar2(20),
    CONSTRAINT pk_cm_mail_history PRIMARY KEY (send_sno)
);
COMMENT ON TABLE cm_mail_history IS '메일 전송 이력';

-- Column comments
COMMENT ON COLUMN cm_mail_history.send_sno IS '전송 일련번호, 자동채번';
COMMENT ON COLUMN cm_mail_history.send_date IS '전송 일자';
COMMENT ON COLUMN cm_mail_history.send_time IS '전송 일시';
COMMENT ON COLUMN cm_mail_history.email_type IS '메일 유형, 공통 코드';
COMMENT ON COLUMN cm_mail_history.sender IS '송신자';
COMMENT ON COLUMN cm_mail_history.receiver IS '수신자';
COMMENT ON COLUMN cm_mail_history.title IS '제목, 공통코드: SF02';


--------------------------------------------------------------------------------
-- WDK 확장 기능 관련 테이블 (TODO)
--------------------------------------------------------------------------------
CREATE TABLE cm_todo (
    todo_no nvarchar2(20) NOT NULL, -- TODO 번호
    corp_code nvarchar2(10) NOT NULL, -- 법인 코드
    busi_place nvarchar2(10) NOT NULL, -- 사업장
    user_id nvarchar2(20) NOT NULL, -- 사용자 ID
    create_date date NOT NULL, -- 생성 일자
    todo_group_no nvarchar2(20), -- TODO 그룹 번호, 같은 TODO를 여러 명에게 할당할 경우 동일 그룹번호 부여
    todo_type nvarchar2(10), -- TODO 유형, 공통코드: CM06
    todo_ctnt nvarchar2(200), -- TODO 내용
    related_id nvarchar2(20), -- 관련 화면 ID
    related_param nvarchar2(2000), -- 관련 파라미터
    complete_yn nchar(1) DEFAULT 'N', -- 완료 여부
    email_send_yn nchar(1) DEFAULT 'N', -- 메일 전송 여부
    first_rg_yms date, -- 최초 등록 일시
    first_rg_idf nvarchar2(20), -- 최초 등록 식별자
    last_update_yms date, -- 최종 업데이트 일시
    last_update_idf nvarchar2(20), -- 최종 업데이트 식별자
    CONSTRAINT pk_cm_todo PRIMARY KEY (todo_no)
);
COMMENT ON TABLE cm_todo IS '내 할 일 관리';

-- Column comments
COMMENT ON COLUMN cm_todo.todo_no IS 'TODO 번호';
COMMENT ON COLUMN cm_todo.corp_code IS '법인 코드';
COMMENT ON COLUMN cm_todo.busi_place IS '사업장';
COMMENT ON COLUMN cm_todo.user_id IS '사용자 ID';
COMMENT ON COLUMN cm_todo.create_date IS '생성 일자';
COMMENT ON COLUMN cm_todo.todo_group_no IS 'TODO 그룹 번호, 같은 TODO를 여러 명에게 할당할 경우 동일 그룹번호 부여';
COMMENT ON COLUMN cm_todo.todo_type IS 'TODO 유형, 공통코드: CM06';
COMMENT ON COLUMN cm_todo.todo_ctnt IS 'TODO 내용';
COMMENT ON COLUMN cm_todo.related_id IS '관련 화면 ID';
COMMENT ON COLUMN cm_todo.related_param IS '관련 파라미터';
COMMENT ON COLUMN cm_todo.complete_yn IS '완료 여부';
COMMENT ON COLUMN cm_todo.email_send_yn IS '메일 전송 여부';
COMMENT ON COLUMN cm_todo.first_rg_yms IS '최초 등록 일시';
COMMENT ON COLUMN cm_todo.first_rg_idf IS '최초 등록 식별자';
COMMENT ON COLUMN cm_todo.last_update_yms IS '최종 업데이트 일시';
COMMENT ON COLUMN cm_todo.last_update_idf IS '최종 업데이트 식별자';


--------------------------------------------------------------------------------
-- WDK 로그 관련 테이블
--------------------------------------------------------------------------------
CREATE TABLE cm_log (
    log_sno NUMBER(19, 0) GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOT NULL ENABLE, -- 로그 일련번호(자동 채번)
    log_date date, -- 로그 일시
    log_level nvarchar2(100), -- 로그 레벨(debug, info, warning, error, criticial, exception)
    logger nvarchar2(100), -- 로거
    message clob NULL, -- 로그 메시지
    function_name nvarchar2(100), -- 함수 명
    file_name nvarchar2(500), -- 파일 명
    line_no NUMBER(11,0), -- 라인 번호
    traceback clob NULL, -- traceback
    request_path nvarchar2(500),
    remote_addr nvarchar2(100),
    user_id nvarchar2(100),
    CONSTRAINT pk_cm_log PRIMARY KEY (log_sno)
);

-- Column comments
COMMENT ON COLUMN cm_log.log_sno IS '로그 일련번호(자동 채번)';
COMMENT ON COLUMN cm_log.log_date IS '로그 일시';
COMMENT ON COLUMN cm_log.log_level IS '로그 레벨(debug, info, warning, error, criticial, exception)';
COMMENT ON COLUMN cm_log.logger IS '로거';
COMMENT ON COLUMN cm_log.message IS '로그 메시지';
COMMENT ON COLUMN cm_log.function_name IS '함수 명';
COMMENT ON COLUMN cm_log.file_name IS '파일 명';
COMMENT ON COLUMN cm_log.line_no IS '라인 번호';
COMMENT ON COLUMN cm_log.traceback IS 'traceback';


CREATE TABLE cm_log_login (
    log_sno NUMBER(11,0) GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOT NULL ENABLE, -- 로그 sno
    log_date date DEFAULT SYSDATE, -- 로그 기록 일시
    user_id nvarchar2(20) NOT NULL, -- 사용자 ID
    login_date date, -- 로그인 일자
    http_user_agent nvarchar2(1000), -- request.META.HTTP_USER_AGENT
    remote_addr nvarchar2(50), -- request.META.REMOTE_ADDR
    remote_host nvarchar2(100), -- request.META.REMOTE_HOST
    remote_user nvarchar2(100), -- request.META.REMOTE_USER
    CONSTRAINT pk_cm_log_login PRIMARY KEY (log_sno)
);

-- Column comments
COMMENT ON COLUMN cm_log_login.log_sno IS '로그 sno';
COMMENT ON COLUMN cm_log_login.log_date IS '로그 기록 일시';
COMMENT ON COLUMN cm_log_login.user_id IS '사용자 ID';
COMMENT ON COLUMN cm_log_login.login_date IS '로그인 일자';
COMMENT ON COLUMN cm_log_login.http_user_agent IS 'request.META.HTTP_USER_AGENT';
COMMENT ON COLUMN cm_log_login.remote_addr IS 'request.META.REMOTE_ADDR';
COMMENT ON COLUMN cm_log_login.remote_host IS 'request.META.REMOTE_HOST';
COMMENT ON COLUMN cm_log_login.remote_user IS 'request.META.REMOTE_USER';


CREATE TABLE cm_exec_log (
    id NUMBER(19, 0) GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOT NULL ENABLE,
    exec_time date NOT NULL,
    exec_pgm nvarchar2(100),
    remark nvarchar2(500)
);

--------------------------------------------------------------------------------
-- WDK 기타 테이블
--------------------------------------------------------------------------------
CREATE TABLE cm_sequence (
    seq_name nvarchar2(100) NOT NULL, -- Sequence_이름
    prefix nvarchar2(50) NOT NULL, -- Seq_접두사
    padding NUMBER(11,0) DEFAULT 4, -- Seq_Padding
    last_value NUMBER(11,0), -- 마지막_Seq_값
    first_rg_yms date,
    first_rg_idf nvarchar2(20),
    last_update_yms date,
    last_update_idf nvarchar2(20),
    CONSTRAINT pk_cm_sequence PRIMARY KEY (seq_name, prefix)
);
COMMENT ON TABLE cm_sequence IS '채번';

-- Column comments
COMMENT ON COLUMN cm_sequence.seq_name IS 'Sequence_이름';
COMMENT ON COLUMN cm_sequence.prefix IS 'Seq_접두사';
COMMENT ON COLUMN cm_sequence.padding IS 'Seq_Padding';
COMMENT ON COLUMN cm_sequence.last_value IS '마지막_Seq_값';


CREATE TABLE cm_copyt (
    no NUMBER(11,0) NOT NULL,
    no2 nvarchar2(10)
);
COMMENT ON TABLE cm_copyt IS 'copyt';
