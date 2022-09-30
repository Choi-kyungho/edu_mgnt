from .base import *

# 실행 모드(local, dev, prod)를 참고하기 위한 설정 변수
SETTINGS_ENV_NAME = 'local'

config = Config(RepositoryEnv(f'./app_settings/settings_{SETTINGS_ENV_NAME}.ini'))

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

# Database
# https://docs.djangoproject.com/en/3.2/ref/settings/#databases

# 데이터베이스 연결 정보
# Settings.ini 파일 참조
DATABASES = {
    'default': {
        'ENGINE': db_engines[config('DB_KIND')],
        'NAME': config('DB_NAME'),
        'USER': config('DB_USER'),
        'PASSWORD': config('DB_PASSWORD'),
        'HOST': config('DB_HOST'),
        'PORT': config('DB_PORT'),
    }
}

# # 이메일 보내기 서비스 URL
# EMAIL_SERVICE_URL = config('EMAIL_SERVICE_URL')
#
# # SHE 리포트 PDF 다운로드 URL
# REPORT_DOWNLOAD_URL = config('REPORT_DOWNLOAD_URL')
