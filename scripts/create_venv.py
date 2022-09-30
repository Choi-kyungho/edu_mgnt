"""
"""
# import subprocess


# def create_venv(project_src_path):
#     import os
#     # 가상환경 경로
#     venv_path = os.path.join(project_src_path, 'venv')
#
#     print('')
#     print('python 가상 환경을 생성합니다.')
#     print('')
#     print(f'가상환경 생성 경로: {venv_path}')
#     print('python -m venv venv')
#     print('')
#
#     # 가상환경 생성
#     os.system('python -m venv venv')
#
#
# def install_package(project_src_path):
#     import os
#     # 가상환경 및 가상환경의 pip 명령어 경로
#     venv_path = os.path.join(project_src_path, 'venv')
#     pip_path = ''
#
#     # 운영체제 확인 - Windows, Mac
#     if os.name == 'nt':
#         pip_path = os.path.join(venv_path, 'scripts', 'pip')
#     else:
#         pip_path = os.path.join(venv_path, 'bin', 'pip')
#     # requirements 파일 경로
#     req_file_name = os.path.join(
#         project_src_path, 'requirements', 'requirements_dev.txt')
#
#     print('')
#     print('패키지를 가상환경에 설치합니다.')
#     print('')
#     print(f'패키지 설치 대상 파일: {req_file_name}')
#     print(f'''{pip_path} install -r {req_file_name}''')
#     print('')
#
#     # 가상환경에 패키지 설치
#     subprocess.call(f'''{pip_path} install -r {req_file_name}''')
#
#
# if __name__ == '__main__':
#     # 프로젝트 소스 경로(Python/Django 프로젝트 루트, Repository 루트 아님)
#     project_src_path = 'D:\\Temp\\test_venv'
#
#     print('')
#     print('가상환경 생성하고, 필요한 패키지를 설치합니다.')
#     print('')
#
#     create_venv(project_src_path)
#
#     install_package(project_src_path)
#
#     print('')
#     print('작업 완료.')
#     print('  - 추후 필요한 패키지는 가상환경(venv)에 설치해주시고, requirements.txt에 반영하세요.')
#     print('')
