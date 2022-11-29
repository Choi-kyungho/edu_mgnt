from django.urls import path

from apps.bzcm.views.BZCM020E10 import BZCM020E10
from apps.bzcm.views.EDU010E01 import EDU010E01
from apps.bzcm.views.EDU000E04 import EDU000E04
from apps.bzcm.views.EDU000E03 import EDU000E03
from apps.bzcm.views.EDU000E02 import EDU000E02
from apps.bzcm.views.EDU000E01 import EDU000E01
from apps.bzcm.views.EDU020E01 import EDU020E01
from apps.bzcm.views.EDU020E02 import EDU020E02
from apps.bzcm.views.EDU020E04 import EDU020E04
from apps.bzcm.views.EDU040E01 import EDU040E01
from apps.bzcm.views.EDU000E05 import EDU000E05
from apps.bzcm.views.EDU000E06 import EDU000E06

urlpatterns = [
    # 'BZCM020E10/list/' 이 url의 호출이 있으면 BZCM020E10라는 뷰에 get_list 함수를 호출한다
    path('BZCM020E10/list/', BZCM020E10.as_view({'post': 'get_list'})),
    path('BZCM020E10/sublist/', BZCM020E10.as_view({'post': 'get_sublist'})),
    path('BZCM020E10/', BZCM020E10.as_view({'post': 'save'})),

    #교육계획
    path('EDU010E01/list/', EDU010E01.as_view({'post': 'get_list'})),
    path('EDU010E01/sublist/', EDU010E01.as_view({'post': 'get_sublist'})),
    path('EDU010E01/', EDU010E01.as_view({'post': 'save'})),
    path('EDU010E01/getMaxEduSchedule/', EDU010E01.as_view({'post': 'get_max_edu_schedule'})),
    path('EDU010E01/getEmpInfo/', EDU010E01.as_view({'post': 'get_emp_info'})),

    #교육일정
    path('EDU000E04/schdlList/', EDU000E04.as_view({'post': 'get_list'})),
    path('EDU000E04/', EDU000E04.as_view({'post': 'save'})),

    #부서관리
    path('EDU000E03/deptList/', EDU000E03.as_view({'post': 'get_list'})),
    path('EDU000E03/', EDU000E03.as_view({'post': 'save'})),

    #사원관리
    path('EDU000E02/empList/', EDU000E02.as_view({'post': 'get_list'})),
    path('EDU000E02/', EDU000E02.as_view({'post': 'save'})),

    #교육기관등록
    path('EDU000E05/list/', EDU000E05.as_view({'post': 'get_master'})),
    path('EDU000E05/sublist/', EDU000E05.as_view({'post': 'get_detail'})),
    path('EDU000E05/', EDU000E05.as_view({'post': 'save'})),

    #교육비예산등록
    path('EDU000E06/list/', EDU000E06.as_view({'post': 'get_list'})),
    path('EDU000E06/', EDU000E06.as_view({'post': 'save'})),
    path('EDU000E06/listGraphFirst/', EDU000E06.as_view({'post': 'get_list'})),
    path('EDU000E06/listGraph/', EDU000E06.as_view({'post': 'get_list'})),

    #공통코드관리
    path('EDU000E01/codeList/', EDU000E01.as_view({'post': 'get_list'})),
    path('EDU000E01/', EDU000E01.as_view({'post': 'save'})),

    #인원현황
    path('EDU020E01/empCountlist/', EDU020E01.as_view({'post': 'get_list'})),
    path('EDU020E01/empByJobCountlist/', EDU020E01.as_view({'post': 'get_list'})),
    path('EDU020E01/empByRespCountlist/', EDU020E01.as_view({'post': 'get_list'})),
    path('EDU020E01/emplistGrid/', EDU020E01.as_view({'post': 'get_list'})),

    #교육현황
    path('EDU020E02/byYearEduList/', EDU020E02.as_view({'post': 'get_list'})),
    path('EDU020E02/byDeptEduList/', EDU020E02.as_view({'post': 'get_list'})),
    path('EDU020E02/byEmpEduRankList/', EDU020E02.as_view({'post': 'get_list'})),
    path('EDU020E02/byDeptEduRankList/', EDU020E02.as_view({'post': 'get_list'})),
    #교육현황-그리드
    path('EDU020E02/eduListGrid/', EDU020E02.as_view({'post': 'get_list'})),
    path('EDU020E02/eduEmailSend/', EDU020E02.as_view({'post': 'sendMail'})),


    #교육비현황
    path('EDU020E04/byEmpEduCostList/', EDU020E04.as_view({'post': 'get_list'})),
    path('EDU020E04/byYearEduCostList/', EDU020E04.as_view({'post': 'get_list'})),
    path('EDU020E04/byDeptEduCostList/', EDU020E04.as_view({'post': 'get_list'})),

    path('EDU020E04/byYearEduCostList_Grid1/', EDU020E04.as_view({'post': 'get_list'})),
    path('EDU020E04/byDeptEduCostList_Grid1/', EDU020E04.as_view({'post': 'get_list'})),

    path('EDU020E04/eduCostList_ModalGrid/', EDU020E04.as_view({'post': 'get_list'})),

    #크롤링테스트
    path('EDU040E01/crawlingList/', EDU040E01.as_view({'post': 'get_list'})),

]