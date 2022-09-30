# Base 이미지
FROM python:3.9.6-slim-buster

# 컨테이너 내에서 코드가 실행될 경로 설정
WORKDIR /usr/src/app

# requirements.txt에 명시된 종속 package 설치
COPY ./src/requirements/ ./
RUN pip install --upgrade pip
RUN pip install -r requirements_dev.txt

# Project 소스를 WORK_DIR로 복사
COPY ./src ./

# Collect static files
RUN mkdir ./static
RUN mkdir ./staticfiles
RUN python manage.py collectstatic --noinput

# 포트 설정 -> 배포시 제외(or 주석처리) 요망
# EXPOSE 8000

# gunicorn 실행 -> 배포시 제외(or 주석처리) 요망
# CMD ["gunicorn", "--bind", "0.0.0.0:8000", "config.wsgi:application"]
# CMD ["bash", "-c", "python manage.py collectstatic --noinput --settings=config.settings.dev && gunicorn config.wsgi:application --bind 0.0.0.0:8000 --env DJANGO_SETTINGS_MODULE=config.settings.dev"]
