--------------------------------------------------------------------------------
-- 사용자 테이블
--------------------------------------------------------------------------------
CREATE TABLE cm_user (
	user_id varchar(20) NOT NULL, -- 사용자 ID-unique
	user_name varchar(100) NOT NULL, -- 사용자 명
	pwd varchar(200) NOT NULL, -- 비밀번호
	system_type varchar(10) NOT NULL, -- 시스템 유형(SHE,협력사)
	user_level int4 NULL DEFAULT 5, -- 사용자 레벨 (0:Admin, 1:개발/운영, 5~:일반)
	use_yn bpchar(1) NULL DEFAULT 'N'::bpchar, -- 사용 여부
	emp_no varchar(20) NULL, -- 사원 번호
	tel_no varchar(20) NULL, -- 전화 번호
	email varchar(100) NULL, -- 이메일
	remark varchar(500) NULL, -- 비고
	first_rg_yms timestamp NULL, -- 최초 등록 일시
	first_rg_idf varchar(20) NULL, -- 최초 등록 식별자
	last_update_yms timestamp NULL, -- 최종 업데이트 일시
	last_update_idf varchar(20) NULL, -- 최종 업데이트 식별자
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
	id serial4 NOT NULL,
	"name" varchar(150) NOT NULL,
	CONSTRAINT uidx_auth_group_name UNIQUE (name),
	CONSTRAINT pk_auth_group PRIMARY KEY (id)
);
CREATE INDEX idx_auth_group_name_like ON auth_group USING btree (name varchar_pattern_ops);


CREATE TABLE django_content_type (
	id serial4 NOT NULL,
	app_label varchar(100) NOT NULL,
	model varchar(100) NOT NULL,
	CONSTRAINT uidx_django_content_type_app_label_model UNIQUE (app_label, model),
	CONSTRAINT pk_django_content_type PRIMARY KEY (id)
);


CREATE TABLE auth_permission (
	id serial4 NOT NULL,
	"name" varchar(255) NOT NULL,
	content_type_id int4 NOT NULL,
	codename varchar(100) NOT NULL,
	CONSTRAINT uidx_auth_permission_content_type_id_codename UNIQUE (content_type_id, codename),
	CONSTRAINT pk_auth_permission PRIMARY KEY (id),
	CONSTRAINT fk_auth_permission_content_type_id_django_co FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED
);
CREATE INDEX idx_auth_permission_content_type_id ON auth_permission USING btree (content_type_id);


CREATE TABLE auth_group_permissions (
	id bigserial NOT NULL,
	group_id int4 NOT NULL,
	permission_id int4 NOT NULL,
	CONSTRAINT uidx_auth_group_permissions_group_id_permission_id UNIQUE (group_id, permission_id),
	CONSTRAINT pk_auth_group_permissions PRIMARY KEY (id),
	CONSTRAINT fk_auth_group_permissio_permission_id_auth_perm FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED,
	CONSTRAINT fk_auth_group_permissions_group_id_auth_group_id FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED
);
CREATE INDEX idx_auth_group_permissions_group_id ON auth_group_permissions USING btree (group_id);
CREATE INDEX idx_auth_group_permissions_permission_id ON auth_group_permissions USING btree (permission_id);


CREATE TABLE django_migrations (
	id bigserial NOT NULL,
	app varchar(255) NOT NULL,
	"name" varchar(255) NOT NULL,
	applied timestamptz NOT NULL,
	CONSTRAINT pk_django_migrations PRIMARY KEY (id)
);


CREATE TABLE django_session (
	session_key varchar(40) NOT NULL,
	session_data text NOT NULL,
	expire_date timestamptz NOT NULL,
	CONSTRAINT pk_django_session PRIMARY KEY (session_key)
);
CREATE INDEX idx_django_session_expire_date ON django_session USING btree (expire_date);
CREATE INDEX idx_django_session_session_key_like ON django_session USING btree (session_key varchar_pattern_ops);


CREATE TABLE django_admin_log (
	id serial4 NOT NULL,
	action_time timestamptz NOT NULL,
	object_id text NULL,
	object_repr varchar(200) NOT NULL,
	action_flag int2 NOT NULL,
	change_message text NOT NULL,
	content_type_id int4 NULL,
	user_id varchar(20) NOT NULL,
	CONSTRAINT ck_django_admin_log_action_flag CHECK ((action_flag >= 0)),
	CONSTRAINT pk_django_admin_log PRIMARY KEY (id),
	CONSTRAINT fk_django_admin_log_content_type_id_django_co FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED,
	CONSTRAINT fk_django_admin_log_user_id_cm_user_user_id FOREIGN KEY (user_id) REFERENCES cm_user(user_id) DEFERRABLE INITIALLY DEFERRED
);
CREATE INDEX idx_django_admin_log_content_type_id ON django_admin_log USING btree (content_type_id);
CREATE INDEX idx_django_admin_log_user_id ON django_admin_log USING btree (user_id);
CREATE INDEX idx_django_admin_log_user_id_like ON django_admin_log USING btree (user_id varchar_pattern_ops);


CREATE TABLE django_apscheduler_djangojob (
	id varchar(255) NOT NULL,
	next_run_time timestamptz NULL,
	job_state bytea NOT NULL,
	CONSTRAINT pk_django_apscheduler_djangojob PRIMARY KEY (id)
);
CREATE INDEX idx_django_apscheduler_djangojob_next_run_time ON django_apscheduler_djangojob USING btree (next_run_time);


CREATE TABLE django_apscheduler_djangojobexecution (
	id bigserial NOT NULL,
	status varchar(50) NOT NULL,
	run_time timestamptz NOT NULL,
	duration numeric(15, 2) NULL,
	finished numeric(15, 2) NULL,
	"exception" varchar(1000) NULL,
	traceback text NULL,
	job_id varchar(255) NOT NULL,
	CONSTRAINT pk_django_apscheduler_djangojobexecution PRIMARY KEY (id),
	CONSTRAINT uidx_job_executions UNIQUE (job_id, run_time),
	CONSTRAINT fk_django_apscheduler_djangojobexecution_job_id FOREIGN KEY (job_id) REFERENCES django_apscheduler_djangojob(id) DEFERRABLE INITIALLY DEFERRED
);
CREATE INDEX idx_django_apscheduler_djangojobexecution_job_id ON django_apscheduler_djangojobexecution USING btree (job_id);
CREATE INDEX idx_django_apscheduler_djangojobexecution_run_time ON django_apscheduler_djangojobexecution USING btree (run_time);


--------------------------------------------------------------------------------
-- WDK 공통 코드 테이블
--------------------------------------------------------------------------------
CREATE TABLE cm_code_master (
	cm_code_type_id varchar(10) NOT NULL, -- 공통코드유형 식별자
	cm_code_type_name varchar(100) NOT NULL, -- 공통코드유형명
	parent_code_type_id varchar(10) NULL, -- 공통코드의 상위 공통코드ID
	cm_code_length int4 NULL DEFAULT 0, -- 공통코드의 상세코드 길이
	system_yn bpchar(1) NULL DEFAULT 'N'::bpchar, -- 시스템여부
	remark varchar(500) NULL, -- 비고
	first_rg_yms timestamp NULL, -- 최초 등록 일시
	first_rg_idf varchar(20) NULL, -- 최초 등록 식별자
	last_update_yms timestamp NULL, -- 최종 업데이트 일시
	last_update_idf varchar(20) NULL, -- 최종 업데이트 식별자
	delete_yn bpchar(1) NULL DEFAULT 'N'::bpchar,
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
	cm_code_type_id varchar(10) NOT NULL, -- 공통 코드 유형 ID
	detail_code_id varchar(10) NOT NULL, -- 상세 코드 ID
	detail_code_name varchar(100) NOT NULL, -- 상세 코드 명
	sort_seq int4 NULL, -- 정렬 순서
	use_yn bpchar(1) NOT NULL DEFAULT 'N'::bpchar, -- 사용 여부
	etc_ctnt1 varchar(100) NULL, -- 기타 내용1
	etc_ctnt2 varchar(100) NULL, -- 기타 내용2
	etc_ctnt3 varchar(100) NULL, -- 기타 내용3
	etc_ctnt4 varchar(100) NULL, -- 기타 내용4
	etc_ctnt5 varchar(100) NULL, -- 기타 내용5
	etc_desc varchar(1000) NULL, -- 기타 설명
	valid_start_date date NULL, -- 유효 시작 일자
	valid_end_date date NULL, -- 유효 종료 일자
	first_rg_yms timestamp NULL, -- 최초 등록 일시
	first_rg_idf varchar(20) NULL, -- 최초 등록 식별자
	last_update_yms timestamp NULL, -- 최종 업데이트 일시
	last_update_idf varchar(20) NULL, -- 최종 업데이트 식별자
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
	corp_code varchar(10) NOT NULL, -- 법인 코드
	corp_no varchar(13) NULL, -- 법인 번호
	corp_name varchar(50) NULL, -- 법인 이름
	corp_name_en varchar(100) NULL, -- 법인 이름(en)
	corp_sht_name varchar(50) NULL, -- 법인 이름(약어)
	rep_corp_yn bpchar(1) NULL,
	president varchar(50) NULL, -- 대표자
	president_en varchar(100) NULL, -- 대표자(en)
	prsd_sec_no varchar(13) NULL, -- 대표자 번호
	biz_type varchar(50) NULL, -- 업태
	biz_item varchar(50) NULL, -- 업종
	tel_no varchar(25) NULL, -- 전화 번호
	fax_no varchar(25) NULL, -- 팩스 번호
	zip_code varchar(6) NULL, -- 우편 번호
	addr varchar(200) NULL, -- 주소
	addr_en varchar(300) NULL, -- 주소(en)
	foundation_date timestamp NULL, -- 설립 일자
	remark varchar(100) NULL, -- 비고
	first_rg_yms timestamp NULL,
	first_rg_idf varchar(20) NULL,
	last_update_yms timestamp NULL,
	last_update_idf varchar(20) NULL,
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
	corp_code varchar(10) NOT NULL, -- 법인 코드
	busi_place varchar(10) NOT NULL, -- 사업장 코드
	business_no varchar(13) NULL, -- 사업자 등록 번호
	busi_place_name varchar(50) NULL, -- 사업장 이름
	busi_place_name_en varchar(100) NULL, -- 사업장 이름(en)
	busi_place_sht_name varchar(50) NULL, -- 사업장 이름(약어)
	rep_busi_place_yn bpchar(1) NULL,
	president varchar(50) NULL, -- 대표자
	president_en varchar(100) NULL, -- 대표자(en)
	biz_type varchar(100) NULL, -- 업태
	biz_item varchar(100) NULL, -- 업종
	zip_code varchar(6) NULL, -- 우편 번호
	addr varchar(200) NULL, -- 주소
	addr_en varchar(300) NULL, -- 주소(en)
	tel_no varchar(25) NULL, -- 전화 번호
	fax_no varchar(25) NULL, -- 팩스 번호
	tax_office_code varchar(4) NULL, -- 세무서 코드
	hometax_id varchar(20) NULL, -- 국세청 ID
	slave_busi_no varchar(4) NULL, -- 종속 사업자 번호
	sum_recog_no varchar(7) NULL,
	prsd_sec_no varchar(13) NULL,
	homepage varchar(100) NULL,
	cust_code varchar(10) NULL, -- 거래처 코드
	item_code varchar(6) NULL, -- 종목 코드
	biz_date timestamp NULL,
	remark varchar(100) NULL, -- 비고
	first_rg_yms timestamp NULL,
	first_rg_idf varchar(20) NULL,
	last_update_yms timestamp NULL,
	last_update_idf varchar(20) NULL,
	busi_part varchar(10) NULL,
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
	dept_code varchar(20) NOT NULL, -- 부서 코드
	corp_code varchar(10) NOT NULL, -- 법인 코드
	busi_place varchar(10) NOT NULL, -- 사업장
	dept_name varchar(50) NOT NULL, -- 부서 명
	parent_dept_code varchar(9) NULL, -- 상위 부서 코드
	dept_type varchar(10) NULL, -- 부서 구분(실/팀/파트 등)
	term_fr timestamp NULL, -- 기간_시작
	term_to timestamp NULL, -- 기간_종료
	print_seq numeric NULL, -- 출력 순서
	first_rg_yms timestamp NULL, -- 최초 등록 일시
	first_rg_idf varchar(20) NULL, -- 최초 등록 식별자
	last_update_yms timestamp NULL, -- 최종 업데이트 일시
	last_update_idf varchar(20) NULL, -- 최종 업데이트 식별자
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
	emp_no varchar(10) NOT NULL, -- 사원 번호
	corp_code varchar(10) NOT NULL, -- 법인 코드
	busi_place varchar(10) NOT NULL, -- 사업장
	emp_name varchar(50) NOT NULL, -- 사원 명
	emp_name_en varchar(100) NULL, -- 사원 명(EN)
	emp_name_cn varchar(20) NULL, -- 사원 명(한자)
	dept_code varchar(20) NULL, -- 부서 코드
	unit_work_no varchar(20) NULL, -- 단위 작업 번호, 부서/공장,직무 관리
	plant_code varchar(10) NULL, -- 공장 코드, 공통코드: CM10
	equip_code varchar(10) NULL, -- 설비 코드, 공통코드: CM11
	unit_work_code varchar(10) NULL, -- 단위 작업 코드, 공통코드: CM12
	emp_grd varchar(10) NULL, -- 직급
	"position" varchar(10) NULL, -- 직위
	responsi varchar(10) NULL, -- 직책
	duty varchar(10) NULL, -- 직무
	occup_kind varchar(10) NULL, -- 직종
	ent_code varchar(10) NULL, -- 입사 코드
	ent_date timestamp NULL, -- 입사 일자
	grp_ent_date timestamp NULL, -- 그룹 일사 일자
	curr_stat varchar(10) NULL, -- 현재 상태
	curr_stat_date timestamp NULL, -- 현재 상태 일자
	retire_code varchar(10) NULL, -- 퇴사 코드
	retire_date timestamp NULL, -- 퇴사 일자
	retire_calc_date timestamp NULL, -- 퇴사 계산 일자
	on_work_yn bpchar(1) NULL DEFAULT 'Y'::bpchar, -- 재직 여부
	personal_sec_no varchar(13) NULL, -- 주민등록번호
	gender varchar(10) NULL, -- 성별
	birthday timestamp NULL, -- 생년월일
	birthday_type varchar(10) NULL, -- 생년월일 구분
	zipcode varchar(6) NULL, -- 우편번호
	addr varchar(100) NULL, -- 주소
	tel_no varchar(20) NULL, -- 전화 번호
	mobile_no varchar(20) NULL, -- 휴대전화 번호
	email varchar(100) NULL, -- 이메일
	live_nation_code varchar(10) NULL, -- 국적 코드
	foreigner_type varchar(10) NULL, -- 외국인 구분
	user_id varchar(20) NULL, -- 사용자 ID
	first_rg_yms timestamp NULL, -- 최초 등록 일시
	first_rg_idf varchar(20) NULL, -- 최초 등록 식별자
	last_update_yms timestamp NULL, -- 최종 업데이트 일시
	last_update_idf varchar(20) NULL, -- 최종 업데이트 식별자
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
COMMENT ON COLUMN cm_employee."position" IS '직위';
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
	pgm_id varchar(20) NOT NULL, -- 프로그램 ID-unique
	pgm_name varchar(100) NOT NULL, -- 프로그램 명
	system_code varchar(10) NOT NULL, -- 시스템 코드
	pgm_type varchar(10) NOT NULL, -- 프로그램 유형-등록,조회,배치,리포트,팝업
	pgm_url varchar(200) NULL, -- 프로그램 URL
	use_yn bpchar(1) NULL DEFAULT 'N'::bpchar, -- 사용 여부
	first_rg_yms timestamp NULL, -- 최초 등록 일시
	first_rg_idf varchar(20) NULL, -- 최초 등록 식별자
	last_update_yms timestamp NULL, -- 최종 업데이트 일시
	last_update_idf varchar(20) NULL, -- 최종 업데이트 식별자
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
	menu_sno int4 NOT NULL, -- 메뉴 일련번호
	menu_name varchar(100) NOT NULL, -- 메뉴 명
	system_type varchar(10) NOT NULL, -- 시스템 유형(SHE,협력사)
	parent_menu_sno int4 NULL, -- 부모 메뉴 일련번호
	sort_seq int4 NULL, -- 정렬 순서
	use_yn bpchar(1) NULL DEFAULT 'N'::bpchar, -- 사용 여부
	first_rg_yms timestamp NULL, -- 최초 등록 일시
	first_rg_idf varchar(20) NULL, -- 최초 등록 식별자
	last_update_yms timestamp NULL, -- 최종 업데이트 일시
	last_update_idf varchar(20) NULL, -- 최종 업데이트 식별자
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
	run_sno int4 NOT NULL, -- 실행 일련번호
	run_name varchar(100) NOT NULL, -- 실행 명(기본-프로그램 명)
	menu_sno int4 NOT NULL, -- 메뉴 일련번호
	pgm_id varchar(20) NOT NULL, -- 프로그램 ID
	sort_seq int4 NULL, -- 정렬 순서
	use_yn bpchar(1) NULL DEFAULT 'N'::bpchar, -- 사용 여부
	first_rg_yms timestamp NULL, -- 최초 등록 일시
	first_rg_idf varchar(20) NULL, -- 최초 등록 식별자
	last_update_yms timestamp NULL, -- 최종 업데이트 일시
	last_update_idf varchar(20) NULL, -- 최종 업데이트 식별자
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
	run_sno int4 NOT NULL, -- 실행 일련번호
	param_name varchar(100) NOT NULL, -- 파라미터 명
	param_value varchar(100) NULL, -- 파라미터 값
	remark varchar(500) NULL, -- 비고
	first_rg_yms timestamp NULL, -- 최초 등록 일시
	first_rg_idf varchar(20) NULL, -- 최초 등록 식별자
	last_update_yms timestamp NULL, -- 최종 업데이트 일시
	last_update_idf varchar(20) NULL, -- 최종 업데이트 식별자
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
	user_id varchar(20) NOT NULL, -- 사용자 ID
	menu_sno int4 NOT NULL, -- 메뉴 일련번호
	menu_name varchar(100) NOT NULL, -- 메뉴 명
	parent_menu_sno int4 NULL, -- 부모 메뉴 일련번호
	sort_seq int4 NULL, -- 정렬 순서
	first_rg_yms timestamp NULL, -- 최초 등록 일시
	first_rg_idf varchar(20) NULL, -- 최초 등록 식별자
	last_update_yms timestamp NULL, -- 최종 업데이트 일시
	last_update_idf varchar(20) NULL, -- 최종 업데이트 식별자
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
	user_id varchar(20) NOT NULL, -- 사용자 ID
	menu_sno int4 NOT NULL, -- 메뉴 일련번호
	run_sno int4 NOT NULL, -- 실행 일련번호
	run_name varchar(100) NOT NULL, -- 실행 명
	sort_seq int4 NULL, -- 정렬 순서
	first_rg_yms timestamp NULL, -- 최초 등록 일시
	first_rg_idf varchar(20) NULL, -- 최초 등록 식별자
	last_update_yms timestamp NULL, -- 최종 업데이트 일시
	last_update_idf varchar(20) NULL, -- 최종 업데이트 식별자
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
	group_sno int4 NOT NULL, -- 그룹 일련번호
	group_name varchar(100) NOT NULL, -- 그룹 명
	system_type varchar(10) NOT NULL, -- 시스템 유형(SHE,협력사)
	use_yn bpchar(1) NULL DEFAULT 'N'::bpchar, -- 사용 여부
	remark varchar(500) NULL, -- 비고
	first_rg_yms timestamp NULL, -- 최초 등록 일시
	first_rg_idf varchar(20) NULL, -- 최초 등록 식별자
	last_update_yms timestamp NULL, -- 최종 업데이트 일시
	last_update_idf varchar(20) NULL, -- 최종 업데이트 식별자
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
	group_sno int4 NOT NULL, -- 그룹 일련번호
	user_id varchar(20) NOT NULL, -- 사용자 ID
	first_rg_yms timestamp NULL, -- 최초 등록 일시
	first_rg_idf varchar(20) NULL, -- 최초 등록 식별자
	last_update_yms timestamp NULL, -- 최종 업데이트 일시
	last_update_idf varchar(20) NULL, -- 최종 업데이트 식별자
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
	role_no varchar(20) NOT NULL, -- Role 번호
	role_type varchar(20) NOT NULL, -- Role 유형 - AA14
	role_name varchar(100) NOT NULL, -- Role 명
	system_yn bpchar(1) NULL DEFAULT 'N'::bpchar, -- 시스템 여부
	use_yn bpchar(1) NULL DEFAULT 'N'::bpchar, -- 사용 여부
	remark varchar(500) NULL, -- 비고
	first_rg_yms timestamp NULL, -- 최초 등록 일시
	first_rg_idf varchar(20) NULL, -- 최초 등록 식별자
	last_update_yms timestamp NULL, -- 최종 업데이트 일시
	last_update_idf varchar(20) NULL, -- 최종 업데이트 식별자
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
	user_id varchar(20) NOT NULL, -- 사용자 ID
	role_no varchar(20) NOT NULL, -- Role 번호
	first_rg_yms timestamp NULL, -- 최초 등록 일시
	first_rg_idf varchar(20) NULL, -- 최초 등록 식별자
	last_update_yms timestamp NULL, -- 최종 업데이트 일시
	last_update_idf varchar(20) NULL, -- 최종 업데이트 식별자
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
	group_sno int4 NOT NULL, -- 그룹 일련번호
	run_sno int4 NOT NULL, -- 실행 일련번호
	use_yn bpchar(1) NULL DEFAULT 'N'::bpchar, -- 사용 여부
	select_yn bpchar(1) NULL DEFAULT 'N'::bpchar, -- 조회/선택 여부
	save_yn bpchar(1) NULL DEFAULT 'N'::bpchar, -- 저장 여부
	print_yn bpchar(1) NULL DEFAULT 'N'::bpchar, -- 인쇄 여부
	custom_yn bpchar(1) NULL DEFAULT 'N'::bpchar, -- 커스텀 여부
	first_rg_yms timestamp NULL, -- 최초 등록 일시
	first_rg_idf varchar(20) NULL, -- 최초 등록 식별자
	last_update_yms timestamp NULL, -- 최종 업데이트 일시
	last_update_idf varchar(20) NULL, -- 최종 업데이트 식별자
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
	user_id varchar(20) NOT NULL, -- 사용자 ID
	run_sno int4 NOT NULL, -- 실행 일련번호
	use_yn bpchar(1) NULL DEFAULT 'N'::bpchar, -- 사용 여부
	select_yn bpchar(1) NULL DEFAULT 'N'::bpchar, -- 조회선택 여부
	save_yn bpchar(1) NULL DEFAULT 'N'::bpchar, -- 저장 여부
	print_yn bpchar(1) NULL DEFAULT 'N'::bpchar, -- 인쇄 여부
	custom_yn bpchar(1) NULL DEFAULT 'N'::bpchar, -- 커스텀 여부
	first_rg_yms timestamp NULL, -- 최초 등록 일시
	first_rg_idf varchar(20) NULL, -- 최초 등록 식별자
	last_update_yms timestamp NULL, -- 최종 업데이트 일시
	last_update_idf varchar(20) NULL, -- 최종 업데이트 식별자
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
	user_id varchar(20) NOT NULL, -- 사용자 ID
	menu_tree_sno varchar(10) NOT NULL,
	parent_menu_tree_sno varchar(10) NOT NULL, -- 부모 메뉴 트리 일련번호
	menu_sno int4 NOT NULL, -- 메뉴 일련번호
	run_sno int4 NOT NULL, -- 실행 일련번호
	menu_path varchar(100) NULL,
	menu_name varchar(100) NOT NULL, -- 실행 메뉴 명
	system_type varchar(10) NOT NULL, -- 시스템 유형(SHE,협력사)
	system_code varchar(10) NULL, -- 시스템 코드
	pgm_id varchar(20) NULL, -- 프로그램 ID-unique
	pgm_type varchar(10) NULL, -- 프로그램 유형-등록,조회,배치,리포트,팝업
	pgm_url varchar(200) NULL, -- 프로그램 URL
	pgm_param varchar(500) NULL, -- 파라미터 명, 파라미터 값
	sort_seq int4 NULL, -- 정렬 순서
	tree_level int4 NULL, -- 트리 레벨
	use_yn bpchar(1) NULL DEFAULT 'N'::bpchar, -- 사용 여부
	select_yn bpchar(1) NULL DEFAULT 'N'::bpchar, -- 조회/선택 여부
	save_yn bpchar(1) NULL DEFAULT 'N'::bpchar, -- 저장 여부
	print_yn bpchar(1) NULL DEFAULT 'N'::bpchar, -- 인쇄 여부
	custom_yn bpchar(1) NULL DEFAULT 'N'::bpchar, -- 커스텀 여부
	auth_kind varchar(10) NULL, -- 권한 유형(G: 그룹, U:사용자)
	menu_type varchar(10) NULL, -- 메뉴 유형-폴더,프로그램
	first_rg_yms timestamp NULL, -- 최초 등록 일시
	first_rg_idf varchar(20) NULL, -- 최초 등록 식별자
	last_update_yms timestamp NULL, -- 최종 업데이트 일시
	last_update_idf varchar(20) NULL, -- 최종 업데이트 식별자
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
	apprv_line_id varchar(36) NOT NULL, -- 결재 선 ID, UUID
	corp_code varchar(10) NOT NULL, -- 법인 코드
	busi_place varchar(10) NOT NULL, -- 사업장
	apprv_line_name varchar(100) NOT NULL, -- 결재 선 명
	run_sno int4 NOT NULL, -- 실행 일련번호
	rg_user_id varchar(20) NOT NULL, -- 등록 사용자 ID
	rg_emp_no varchar(20) NOT NULL, -- 등록 사번
	rg_date timestamp NOT NULL, -- 등록 일자
	todo_type varchar(10) NOT NULL, -- TODO 유형
	fix_yn bpchar(1) NOT NULL DEFAULT 'N'::bpchar, -- 고정 여부
	first_rg_yms timestamp NULL, -- 최초 등록 일시
	first_rg_idf varchar(20) NULL, -- 최초 등록 식별자
	last_update_yms timestamp NULL, -- 최종 업데이트 일시
	last_update_idf varchar(20) NULL, -- 최종 업데이트 식별자
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
	apprv_line_id varchar(36) NOT NULL, -- 결재 선 ID, UUID
	apprv_line_sno int4 NOT NULL, -- 결재 선 일련번호
	apprv_step varchar(10) NOT NULL, -- 결재 단계
	apprv_role_type varchar(10) NOT NULL, -- 결재 ROLE 유형, 공통코드: CM19
	apprv_role_no varchar(20) NULL, -- 결재 ROLE 번호, CM19가 R(ROLE) 인 경우
	apprv_user_id varchar(20) NULL, -- 결재 사용자 ID, CM19가 U(USER) 인 경우
	apprv_emp_no varchar(20) NULL, -- 결재 사원 번호, CM19가 U(USER) 인 경우
	apprv_plant_code varchar(20) NULL, -- 결재 공장 코드, CM19가 T(team) 인 경우
	apprv_fix_yn bpchar(1) NOT NULL DEFAULT 'N'::bpchar, -- 고정 여부
	first_rg_yms timestamp NULL, -- 최초 등록 일시
	first_rg_idf varchar(20) NULL, -- 최초 등록 식별자
	last_update_yms timestamp NULL, -- 최종 업데이트 일시
	last_update_idf varchar(20) NULL, -- 최종 업데이트 식별자
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
	apprv_id varchar(20) NOT NULL, -- 결재 ID, 번호체계(년월일+일련번호(3))
	apprv_date timestamp NOT NULL, -- 결재 일자
	apprv_time timestamp NOT NULL, -- 결재 시간
	rfa_user_id varchar(20) NOT NULL, -- 상신 사용자 ID
	rfa_emp_no varchar(20) NOT NULL, -- 상신 사원 번호
	rfa_emp_dept varchar(20) NOT NULL, -- 상신 사원 부서
	apprv_stat varchar(10) NOT NULL, -- 결재 상태, 공통코드: CM03
	curr_apprv_step varchar(10) NOT NULL, -- 현재 결재 단계
	next_apprv_step varchar(10) NOT NULL, -- 다음 결재 단계
	apprv_step_cnt int4 NOT NULL, -- 결재 단계 수
	last_apprv_yn bpchar(1) NOT NULL DEFAULT 'N'::bpchar, -- 최종 결재 여부
	run_sno int4 NOT NULL, -- 실행 일련번호, 실행 일련번호
	table_unique_id varchar(5000) NOT NULL, -- 테이블 고유 ID, { KEY: VALUE }
	todo_type varchar(10) NOT NULL, -- TODO 유형
	fix_yn bpchar(1) NOT NULL DEFAULT 'N'::bpchar, -- 고정 여부
	first_rg_yms timestamp NULL, -- 최초 등록 일시
	first_rg_idf varchar(20) NULL, -- 최초 등록 식별자
	last_update_yms timestamp NULL, -- 최종 업데이트 일시
	last_update_idf varchar(20) NULL, -- 최종 업데이트 식별자
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
	apprv_id varchar(20) NOT NULL, -- 결재 ID, 번호체계(년월일+일련번호(3))
	apprv_sno int4 NOT NULL, -- 결재 일련번호
	apprv_step varchar(10) NOT NULL, -- 결재 단계
	apprv_stat varchar(10) NULL, -- 결재 상태, 공통코드: CM03
	apprv_date timestamp NULL, -- 결재 일자
	apprv_time timestamp NULL, -- 결재 시간
	apprv_role_type varchar(10) NULL, -- 결재 ROLE 유형, 공통코드: CM19
	apprv_role_no varchar(20) NULL, -- 결재 ROLE 번호
	apprv_user_id varchar(20) NULL, -- 결재 사용자 ID
	apprv_plant_code varchar(20) NULL, -- 결재 공장 코드
	apprv_fix_yn bpchar(1) NOT NULL DEFAULT 'N'::bpchar, -- 고정 여부
	apprv_emp_no varchar(20) NULL, -- 결재 사원 번호
	apprv_emp_dept varchar(20) NULL, -- 결재 사원 부서
	remark varchar(500) NULL, -- 비고
	first_rg_yms timestamp NULL, -- 최초 등록 일시
	first_rg_idf varchar(20) NULL, -- 최초 등록 식별자
	last_update_yms timestamp NULL, -- 최종 업데이트 일시
	last_update_idf varchar(20) NULL, -- 최종 업데이트 식별자
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
	apprv_history_id int8 NOT NULL GENERATED BY DEFAULT AS IDENTITY, -- 결재 이력 ID, 순번 자동 증가, BIGINT
	apprv_id varchar(20) NOT NULL, -- 결재 ID
	apprv_sno int4 NOT NULL, -- 결재 일련번호
	apprv_step varchar(10) NOT NULL, -- 결재 단계
	apprv_stat varchar(10) NOT NULL, -- 결재 상태
	apprv_date timestamp NOT NULL, -- 결재 일자
	apprv_user_id varchar(20) NOT NULL, -- 결재 사용자 ID
	apprv_emp_no varchar(20) NOT NULL, -- 결재 사원 번호
	remark varchar(500) NULL, -- 비고
	first_rg_yms timestamp NULL, -- 최초 등록 일시
	first_rg_idf varchar(20) NULL, -- 최초 등록 식별자
	last_update_yms timestamp NULL, -- 최종 업데이트 일시
	last_update_idf varchar(20) NULL, -- 최종 업데이트 식별자
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
	file_uid varchar(36) NOT NULL, -- 첨부파일 UID
	attach_uid varchar(36) NOT NULL, -- 첨부 UID-첨부 대상 묶음용
	attach_type varchar(10) NOT NULL, -- 첨부 유형
	attach_date timestamp NOT NULL, -- 첨부 일자
	user_id varchar(20) NOT NULL, -- 첨부 사용자 ID
	multi_yn bpchar(1) NULL DEFAULT 'N'::bpchar, -- 다중 첨부 여부
	file_path varchar(200) NULL, -- 최초 파일 경로
	file_name varchar(100) NULL, -- 파일 명
	file_size numeric(22, 4) NULL, -- 파일 사이즈
	file_type varchar(10) NULL, -- 파일 유형
	server_path varchar(200) NULL, -- 서버 경로
	server_file_name varchar(100) NULL, -- 서버 파일 명
	thumbnail_path varchar(200) NULL, -- 썸네일 경로(파일명 포함)
	thumbnail_file_name varchar(100) NULL, -- 썸네일 파일 명
	thumbnail_data text NULL, -- 썸네일(base64)
	ref_table_name varchar(50) NULL, -- 관련 테이블 명
	ref_column_names varchar(50) NULL, -- 관련 칼럼 명(,로 연결)
	ref_key_values varchar(100) NULL, -- 관련 데이터 키값(,로 연결)
	file_status varchar(10) NULL, -- 파일상태(T-임시 업로드, A-정상, D-삭제 대기)
	delete_yn bpchar(1) NULL DEFAULT 'N'::bpchar, -- 삭제 여부
	first_rg_yms timestamp NULL, -- 최초 등록 일시
	first_rg_idf varchar(20) NULL, -- 최초 등록 식별자
	last_update_yms timestamp NULL, -- 최종 업데이트 일시
	last_update_idf varchar(20) NULL, -- 최종 업데이트 식별자
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
	mgt_sno int4 NOT NULL GENERATED BY DEFAULT AS IDENTITY, -- 관리 일련번호, 자동채번
	rg_date timestamp NULL, -- 등록 일자
	ctnt varchar(500) NULL, -- 내용
	rg_emp_no varchar(20) NULL, -- 등록 사번, 공통 코드
	email_attach_no varchar(20) NULL, -- 메일 첨부 번호, 특정 메일 발송시 첨부하기 위한 참고 번호
	attach_id varchar(36) NULL, -- 첨부 ID
	remark varchar(500) NULL, -- 비고
	first_rg_yms timestamp NULL,
	first_rg_idf varchar(20) NULL,
	last_update_yms timestamp NULL,
	last_update_idf varchar(20) NULL,
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
	send_sno int4 NOT NULL GENERATED BY DEFAULT AS IDENTITY, -- 전송 일련번호, 자동채번
	send_date timestamp NULL, -- 전송 일자
	send_time timestamp NULL, -- 전송 일시
	email_type varchar(10) NULL, -- 메일 유형, 공통 코드
	sender varchar(50) NULL, -- 송신자
	receiver varchar(500) NULL, -- 수신자
	title varchar(100) NULL, -- 제목, 공통코드: SF02
	first_rg_yms timestamp NULL,
	first_rg_idf varchar(20) NULL,
	last_update_yms timestamp NULL,
	last_update_idf varchar(20) NULL,
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
	todo_no varchar(20) NOT NULL, -- TODO 번호
	corp_code varchar(10) NOT NULL, -- 법인 코드
	busi_place varchar(10) NOT NULL, -- 사업장
	user_id varchar(20) NOT NULL, -- 사용자 ID
	create_date timestamp NOT NULL, -- 생성 일자
	todo_group_no varchar(20) NULL, -- TODO 그룹 번호, 같은 TODO를 여러 명에게 할당할 경우 동일 그룹번호 부여
	todo_type varchar(10) NULL, -- TODO 유형, 공통코드: CM06
	todo_ctnt varchar(200) NULL, -- TODO 내용
	related_id varchar(20) NULL, -- 관련 화면 ID
	related_param varchar(5000) NULL, -- 관련 파라미터
	complete_yn bpchar(1) NULL DEFAULT 'N'::bpchar, -- 완료 여부
	email_send_yn bpchar(1) NULL DEFAULT 'N'::bpchar, -- 메일 전송 여부
	first_rg_yms timestamp NULL, -- 최초 등록 일시
	first_rg_idf varchar(20) NULL, -- 최초 등록 식별자
	last_update_yms timestamp NULL, -- 최종 업데이트 일시
	last_update_idf varchar(20) NULL, -- 최종 업데이트 식별자
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
	log_sno int8 NOT NULL GENERATED BY DEFAULT AS IDENTITY, -- 로그 일련번호(자동 채번)
	log_date timestamp NULL, -- 로그 일시
	"level" varchar(100) NULL, -- 로그 레벨(debug, info, warning, error, criticial, exception)
	logger varchar(100) NULL, -- 로거
	message text NULL, -- 로그 메시지
	function_name varchar(100) NULL, -- 함수 명
	file_name varchar(500) NULL, -- 파일 명
	line_no int4 NULL, -- 라인 번호
	traceback text NULL, -- traceback
	request_path varchar(500) NULL,
	remote_addr varchar(100) NULL,
	user_id varchar(100) NULL,
	CONSTRAINT pk_cm_log PRIMARY KEY (log_sno)
);

-- Column comments
COMMENT ON COLUMN cm_log.log_sno IS '로그 일련번호(자동 채번)';
COMMENT ON COLUMN cm_log.log_date IS '로그 일시';
COMMENT ON COLUMN cm_log."level" IS '로그 레벨(debug, info, warning, error, criticial, exception)';
COMMENT ON COLUMN cm_log.logger IS '로거';
COMMENT ON COLUMN cm_log.message IS '로그 메시지';
COMMENT ON COLUMN cm_log.function_name IS '함수 명';
COMMENT ON COLUMN cm_log.file_name IS '파일 명';
COMMENT ON COLUMN cm_log.line_no IS '라인 번호';
COMMENT ON COLUMN cm_log.traceback IS 'traceback';


CREATE TABLE cm_log_login (
	log_sno int4 NOT NULL GENERATED BY DEFAULT AS IDENTITY, -- 로그 sno
	log_date timestamp NOT NULL DEFAULT now(), -- 로그 기록 일시
	user_id varchar(20) NOT NULL, -- 사용자 ID
	login_date timestamp NULL, -- 로그인 일자
	http_user_agent varchar(1000) NULL, -- request.META.HTTP_USER_AGENT
	remote_addr varchar(50) NULL, -- request.META.REMOTE_ADDR
	remote_host varchar(100) NULL, -- request.META.REMOTE_HOST
	remote_user varchar(100) NULL, -- request.META.REMOTE_USER
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
	id int8 NOT NULL GENERATED BY DEFAULT AS IDENTITY,
	exec_time timestamp NOT NULL,
	exec_pgm varchar(100) NULL,
	remark varchar(500) NULL
);

--------------------------------------------------------------------------------
-- WDK 기타 테이블
--------------------------------------------------------------------------------
CREATE TABLE cm_sequence (
	seq_name varchar(100) NOT NULL, -- Sequence_이름
	prefix varchar(50) NOT NULL, -- Seq_접두사
	padding int4 NULL DEFAULT 4, -- Seq_Padding
	"last_value" int4 NULL, -- 마지막_Seq_값
	first_rg_yms timestamp NULL,
	first_rg_idf varchar(20) NULL,
	last_update_yms timestamp NULL,
	last_update_idf varchar(20) NULL,
	CONSTRAINT pk_cm_sequence PRIMARY KEY (seq_name, prefix)
);
COMMENT ON TABLE cm_sequence IS '채번';

-- Column comments
COMMENT ON COLUMN cm_sequence.seq_name IS 'Sequence_이름';
COMMENT ON COLUMN cm_sequence.prefix IS 'Seq_접두사';
COMMENT ON COLUMN cm_sequence.padding IS 'Seq_Padding';
COMMENT ON COLUMN cm_sequence."last_value" IS '마지막_Seq_값';


CREATE TABLE cm_copyt (
	"no" int4 NOT NULL,
	no2 varchar(10) NULL
);
COMMENT ON TABLE cm_copyt IS 'copyt';
