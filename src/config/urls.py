"""config URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include, re_path
from django.conf import settings
from rest_framework import permissions
from drf_yasg.views import get_schema_view
from drf_yasg import openapi

schema_view = get_schema_view(
    openapi.Info(
        title="edu_mgnt_1",
        default_version='v1',
        description="edu",
        terms_of_service="https://policies.google.com/terms",
        contact=openapi.Contact(name="Kyungho Choi", email="kyungho-choi@example.com"),
        license=openapi.License(name=""),
    ),
    public=True,
    permission_classes=(permissions.AllowAny,),
)


# Sentry 확인용
def trigger_error(request):
    division_by_zero = 1 / 0


urlpatterns = [
    path('admin/', admin.site.urls),

    path('api/', include('vntg_wdk_core.urls')),
    path('api/', include('vntg_wdk_common.login_urls')),

    # 시스템 공통
    path('api/common/', include('vntg_wdk_common.urls')),
    path('api/comm/', include('vntg_wdk_comm.urls')),
    path('api/attach/', include('vntg_wdk_attach.urls')),
    path('api/approval/', include('vntg_wdk_approval.urls')),
    path('api/todo/', include('vntg_wdk_todo.urls')),
    path('api/mail/', include('vntg_wdk_mail.urls')),

    # 업무 모듈 - 업무공통
    path('api/bzcm/', include('apps.bzcm.urls')),

    # Report 모듈
    path('api/report/', include('vntg_wdk_report.urls')),

    # Sentry 확인용
    path('sentry-debug/', trigger_error),
]

# Debug가 허용될때만 swagger 문서가 보이도록 설정
if settings.DEBUG:
    urlpatterns += [
        re_path(r'^swagger(?P<format>\.json|\.yml)$', schema_view.without_ui(cache_timeout=0), name="schema-json"),
        re_path(r'^swagger/$', schema_view.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui'),
        re_path(r'^redoc/$', schema_view.with_ui('redoc', cache_timeout=0), name='schema-redoc'),
    ]
