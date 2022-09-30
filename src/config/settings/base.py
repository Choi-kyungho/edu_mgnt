"""
Django settings for config project.

Generated by 'django-admin startproject' using Django 3.2.5.

For more information on this file, see
https://docs.djangoproject.com/en/3.2/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/3.2/ref/settings/
"""
import datetime
import os
from pathlib import Path

from decouple import config, RepositoryEnv, Config

# Build paths inside the project like this: BASE_DIR / 'subdir'.
# Backend root 경로(manage.py 모듈이 있는 경로)
BASE_DIR = Path(__file__).resolve().parent.parent.parent

config = Config(RepositoryEnv('./app_settings/settings_base.ini'))

# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/3.2/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
# SECRET_KEY = 'django-insecure-*yuo9irr++y#ll-l3a@e%fqn=xelg=5epsr28o0%an9t&6)&7t'
SECRET_KEY = config('SECRET_KEY')

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

# 실행 모드(local, dev, prod)를 참고하기 위한 설정 변수
SETTINGS_ENV_NAME = 'base'

ALLOWED_HOSTS = ['*']

# Application definition

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',

    # DRF, JWT, Swagger
    'rest_framework',
    'rest_framework_simplejwt',
    'drf_yasg',

    # CORS 관련 추가
    'corsheaders',

    # Django admin 커스터마이징 모듈
    'vntg_wdk_core',

    # 공통 모듈
    'vntg_wdk_common',
    'vntg_wdk_comm',
    'vntg_wdk_attach',
    'vntg_wdk_approval',
    'vntg_wdk_todo',
    'vntg_wdk_mail',

    # 업무 모듈 - 업무공통 커밋,푸쉬 테스트2222222222
    'apps.bzcm',


    # Report 모듈
    'vntg_wdk_report',

    # Scheduler 앱 - 업무 모듈 뒤에 등록
    # 'apps.scheduler',
]

# 커스텀 User Model 등록 - Django 기본인 Auth.User를 쓰는게 아니라 setting.AUTH_USER_MODEL에 정의한 모델 사용
AUTH_USER_MODEL = 'vntg_wdk_core.User'

MIDDLEWARE = [
    # CORS 관련 추가
    'corsheaders.middleware.CorsMiddleware',
    # Django
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    # Django-CRUM 추가 - Current Request User Middleware
    'crum.CurrentRequestUserMiddleware',
]

ROOT_URLCONF = 'config.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'config.wsgi.application'

# Password validation
# https://docs.djangoproject.com/en/3.2/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]

# Internationalization
# https://docs.djangoproject.com/en/3.2/topics/i18n/

LANGUAGE_CODE = 'ko-kr'

TIME_ZONE = 'Asia/Seoul'

USE_I18N = True

USE_L10N = True

USE_TZ = False

# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/3.2/howto/static-files/
# URL로 제공하는 static 경로
STATIC_URL = '/be_static/'
# static 파일들이 모이는/모여있는 실제 경로
# 개발 과정(Debug=True)이면 STATIC_ROOT가 적용되지 않음
STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')
STATICFILES_DIRS = [
    os.path.join(BASE_DIR, 'static'),
]

# 첨부 업로드 설정
UPLOAD_ROOT = os.path.join(BASE_DIR, 'upload')

# Default primary key field type
# https://docs.djangoproject.com/en/3.2/ref/settings/#default-auto-field

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

# CORS 관련 추가
CORS_ORIGIN_WHITELIST = [
    'http://127.0.0.1:3000',
    'http://localhost:3000',
    'http://172.17.100.106',
    'http://172.17.100.106:3000',
    'http://172.17.100.106:9000',
]

CORS_ALLOW_CREDENTIALS = True
CORS_ORIGIN_ALLOW_ALL = True

# 브라우저에 노출될 HTTP 헤더 목록
CORS_EXPOSE_HEADERS = [
    'Content-Disposition',
]

# 로깅설정
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    # 형식정의
    'formatters': {
        'format1': {'format': '[%(asctime)s] %(levelname)s %(message)s', 'datefmt': "%Y-%m-%d %H:%M:%S"},
        'format2': {'format': '%(levelname)s %(message)s [%(name)s:%(lineno)s]'},
    },
    'handlers': {
        # 파일저장
        'file': {
            'level': 'INFO',
            'class': 'logging.handlers.RotatingFileHandler',
            'filename': BASE_DIR / 'logs/backend.log',
            'encoding': 'UTF-8',
            'maxBytes': 1024 * 1024 * 5,  # 5 MB
            'backupCount': 5,
            'formatter': 'format1',
        },
        # 콘솔(터미널)에 출력
        'console': {
            # 'level': 'INFO',
            'level': 'DEBUG',
            'class': 'logging.StreamHandler',
            'formatter': 'format2',
        },
        # DB에 저장 - LogToDBHandler클래스는 warning 이상만 저장
        'db': {
            'level': 'INFO',
            'class': 'vntg_wdk_common.handlers.log_handler.LogToDBHandler',
            'formatter': 'format2',
        },
    },
    'loggers': {
        # 종류
        'django.server': {
            'handlers': ['file', 'console'],
            'propagate': False,
            'level': 'INFO',
        },
        'django.request': {
            'handlers': ['file', 'console'],
            'propagate': False,
            'level': 'DEBUG',
        },
        '': {
            'level': 'DEBUG',
            'handlers': ['file', 'console', 'db'],
            'propagate': True,
        },
    },
}

# JWT 설정
REST_FRAMEWORK = {
    # 로그인과 관련된 클래스 설정
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ),
    # 로그인 여부를 확인하는 클래스 설정
    # Permissions: AllowAny, IsAuthenticated, IsAdminUser, IsAuthenticatedOrReadOnly
    'DEFAULT_PERMISSION_CLASSES': (
        'rest_framework.permissions.IsAuthenticated',  # 인증된 사용자만 접근 가능
        'rest_framework.permissions.IsAdminUser',  # 관리자만 접근 가능
        'rest_framework.permissions.AllowAny',  # 누구나 접근 가능 -> 배포시 제외할 것
    ),
    'DEFAULT_RENDERER_CLASSES': (
        # 자동으로 json으로 바꿔줌
        'rest_framework.renderers.JSONRenderer',
        'rest_framework.renderers.BrowsableAPIRenderer',
    ),
    # 날짜 포맷
    'DATETIME_FORMAT': '%Y-%m-%d %H:%M:%S',
}

# JWT 설정
# JWT_AUTH = {
#     'JWT_SECRET_KEY': SECRET_KEY,
#     'JWT_ALGORITHM': 'HS256',  # 암호화 알고리즘
#     'JWT_EXPIRATION_DELTA': datetime.timedelta(days=1),  # 유효기간 설정
#     'JWT_ALLOW_REFRESH': True,  # refresh 사용 여부
#     'JWT_REFRESH_EXPIRATION_DELTA': datetime.timedelta(days=7),  # JWT 토큰 갱신 유효기간
# }

# SIMPLE_JWT 설정
SIMPLE_JWT = {
    'ACCESS_TOKEN_LIFETIME': datetime.timedelta(days=1),
    'REFRESH_TOKEN_LIFETIME': datetime.timedelta(days=3),
    'ROTATE_REFRESH_TOKENS': False,
    'BLACKLIST_AFTER_ROTATION': True,
    'UPDATE_LAST_LOGIN': False,

    'ALGORITHM': 'HS256',
    'SIGNING_KEY': SECRET_KEY,
    'VERIFYING_KEY': None,
    'AUDIENCE': None,
    'ISSUER': None,

    'AUTH_HEADER_TYPES': ('Bearer', 'JWT',),
    'AUTH_HEADER_NAME': 'HTTP_AUTHORIZATION',
    'USER_ID_FIELD': 'user_id',
    'USER_ID_CLAIM': 'user_id',
    'USER_AUTHENTICATION_RULE': 'rest_framework_simplejwt.authentication.default_user_authentication_rule',

    'AUTH_TOKEN_CLASSES': ('rest_framework_simplejwt.tokens.AccessToken',),
    'TOKEN_TYPE_CLAIM': 'token_type',

    'JTI_CLAIM': 'jti',

    'SLIDING_TOKEN_REFRESH_EXP_CLAIM': 'refresh_exp',
    'SLIDING_TOKEN_LIFETIME': datetime.timedelta(days=1),
    'SLIDING_TOKEN_REFRESH_LIFETIME': datetime.timedelta(days=3),
}

SWAGGER_SETTINGS = {
    'SHOW_REQUEST_HEADERS': True,
    'SECURITY_DEFINITIONS': {
        'Bearer': {
            'type': 'apiKey',
            'name': 'Authorization',
            'in': 'header',
        }
    },
    'USE_SESSION_AUTH': False,
    'JSON_EDITOR': True,
}

# 데이터베이스 관련
db_engines = {
    'postgresql': 'django.db.backends.postgresql',
    'oracle': 'django.db.backends.oracle',
}
