"""
데이터베이스 구성요소를 생성합니다.
1. 테이블 생성
2. View, Stored Function, Stored Procedure 생성
3. 기초 데이터 등록
"""
import os
import sys
import cx_Oracle


# Cookiecutter에 의해 이 스크립트가 호출되며, exec_info에 해당하는 파라미터가 전달됩니다.
# exec_info = {'repository_path': '', 'database_kind': '', 'host': '', 'port': '', 'name': '', 'user': '', 'password': ''}
exec_info = {}


def convert_parameter(query: str) -> str:
    """파라미터 명 변환
    PostgreSQL 파라미터를 Python 파라미터로 변환합니다.

    Python named parameter - %(p_system_code)s 형태로 사용
    postgresql :p_system_code -> %(p_system_code)s 로 변경
    파라미터 명은 반드시 ':'로 시작해야 합니다.

    :param query: PostgreSQL 파라미터르르 사용하는 원시 쿼리
    :return: 변환된 파라미터가 적용된 쿼리
    """
    import re
    # 파라미터 정규식 검색 패턴
    pattern_string = ':p_[a-zA-Z0-9_]+'

    # 정규식으로 변환 대상 파라미터 찾기
    regex = re.compile(pattern_string)
    found = regex.findall(query)

    if len(found) == 0:
        return query

    # 정규식으로 찾은 파라미터를 중복제거하고, Python named parameter로 변환
    parameter_data = dict((parameter, parameter.replace(':', ''))
                          for parameter in found)
    parameter_data = dict((key, f'%({value})s')
                          for key, value in parameter_data.items())

    # query 내에 있는 파라미터 적용 - :p_parameter -> %(p_parameter)s
    for key, value in parameter_data.items():
        query = query.replace(key, value)

    return query


def split_script(script_file_path, delimeter) -> list:
    # 테이블생성 스크립트 파일을 ';'로 분리하여 각각의 스크립트를 리스트에 담아 반환한다.
    query_list = []
    with open(script_file_path, 'r', encoding='UTF-8') as script_file:
        script = []
        for src_line in script_file:
            src_line = src_line.rstrip()
            if src_line.endswith(delimeter):
                script.append(src_line.replace(';', ''))
                # 빈 문자열 제거
                script = list(filter(len, script))
                query_list.append(str.join('\n', script))
                # 개별 스크립트 초기화
                script.clear()
            else:
                script.append(src_line)

    return query_list


def dict_key_upper(data):
    """사전(dict) 키를 대문자로 변경합니다."""
    if isinstance(data, dict):
        return {k.upper(): dict_key_upper(v) for k, v in data.items()}
    elif isinstance(data, list):
        return [dict_key_upper(v) for v in data]
    else:
        return data


def dict_key_lower(data):
    """사전(dict) 키를 소문자로 변경합니다."""
    if isinstance(data, dict):
        return {k.lower(): dict_key_lower(v) for k, v in data.items()}
    elif isinstance(data, list):
        return [dict_key_lower(v) for v in data]
    else:
        return data


def get_conn_string():
    conn_string = f'''{exec_info['user']}/{exec_info['password']}@{exec_info['host']}:{exec_info['port']}/{exec_info['name']}'''

    return conn_string


def get_data(query):
    conn_string = get_conn_string()

    conn = cx_Oracle.connect(conn_string)
    cursor = conn.cursor()

    # SQL 실행
    cursor.execute(query)

    # 칼럼 정보 가져오기
    columns = cursor.description

    # 행 추출 및 결과 생성 = 칼럼 정보 + 행
    rows = cursor.fetchall()
    result_data = [
        dict(zip([column[0] for column in columns], row)) for row in rows]

    # 키값을 소문자로 변경하여 반환(오라클은 대문자 키값을 반환함)
    result_data = dict_key_lower(result_data)
    return result_data


def exec_command(conn, query, is_commit=False):
    if conn is None:
        conn_string = get_conn_string()
        conn = cx_Oracle.connect(conn_string)

    cursor = conn.cursor()

    # SQL 실행
    print('<query>\n', query)
    cursor.execute(query)

    if is_commit:
        conn.commit()


def exec_commands(query_list):
    conn_string = get_conn_string()
    conn = cx_Oracle.connect(conn_string)

    for query in query_list:
        exec_command(conn, query, is_commit=False)

    conn.commit()


def check_db_connection() -> bool:
    try:
        conn_string = get_conn_string()

        print('DB 접속을 점검합니다.')
        print(f'연결문자열: {conn_string}')

        query = 'select sysdate as current_datetime from dual'
        result_data = get_data(query)

        print(result_data)

        return True
    except Exception as ex:
        print(ex)
        return False


def check_db_objects() -> bool:
    print('DB Object 생성여부를 확인합니다.')

    # 다음 테이블이 하나라도 있는지 확인
    # DJANGO%, CM% (대문자 사용)
    query = '''
select count(*) as table_qty
  from user_tables a
 where a.table_name like 'DJANGO%'
    or a.table_name like 'CM%'
'''
    result_data = get_data(query)
    if result_data[0]['table_qty'] > 0:
        # 테이블 있음
        return False

    return True


def create_tables():
    print('테이블을 생성합니다.')
    repository_path = exec_info['repository_path']
    create_table_script = os.path.join(repository_path, 'scripts', 'create_db_tables_ora.sql')

    # 테이블생성 스크립트 파일을 ';'로 분리하여 실행한다.
    script_list = split_script(create_table_script, ';')

    if len(script_list) > 0:
        exec_commands(script_list)


def create_objects():
    print('View, Function, Procedure를 생성합니다.')
    repository_path = exec_info['repository_path']
    create_ojbect_script = os.path.join(repository_path, 'scripts', 'create_db_objects_ora.sql')

    # Object 생성 스크립트 파일을 ';;'로 분리하여 실행한다.
    script_list = split_script(create_ojbect_script, ';;')

    if len(script_list) > 0:
        exec_commands(script_list)


def insert_data():
    print('기초 데이터를 등록합니다.')
    repository_path = exec_info['repository_path']
    create_data_script = os.path.join(repository_path, 'scripts', 'create_db_data_ora.sql')

    # 기초 데이터 등록 스크립트 파일을 ';'로 분리하여 실행한다.
    script_list = split_script(create_data_script, ';')

    if len(script_list) > 0:
        exec_commands(script_list)


def main():
    """
    """
    # Template이 적용되는 Repository root 실제 경로
    repository_path = exec_info['repository_path']
    project_src_path = os.path.join(repository_path, "src")
    database_kind = exec_info['database_kind']

    print(f'repository_path: {repository_path}')
    print(f'database_kind: {database_kind}')

    # 데이터베이스 접속 확인
    if not check_db_connection():
        print('데이터베이스에 접속할 수 없습니다.')
        return

    # 데이터베이스 구성요소 확인
    if not check_db_objects():
        print('이미 관련 요소(테이블 외)가 데이터베이스에 생성되어 있습니다.')
        return

    # 테이블 생성
    create_tables()
    # View, Func, Proc 생성
    create_objects()
    # 기초 데이터 등록
    insert_data()


if __name__ == '__main__':
    # 실행에 필요한 정보가 args로 넘어와야한다.
    # args: repository_path, database_kind, host, port, name, user, password

    # 파라미터 추출
    args = sys.argv
    exec_info.clear()
    for arg in args[1:]:
        arg_items = arg.split('=')
        exec_info[arg_items[0]] = arg_items[1]

    if len(exec_info) == 0:
        print('파라미터가 누락되어 실행할 수 없습니다.')
    else:
        main()
