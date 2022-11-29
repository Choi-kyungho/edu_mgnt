import logging


from rest_framework import status

from rest_framework.response import Response

from vntg_wdk_core.business import BusinessNode
from vntg_wdk_core.helper.file_helper import SqlFileHelper
from vntg_wdk_core.views.baseview import BaseSqlApiView
from vntg_wdk_core.enums import UpdateType
from vntg_wdk_common.utils import get_next_seq_value

from apps.bzcm.models import PangEduPlanMgnt, PangDeptInfo, PangEduSchdlMgnt, PangEmpInfo

LOGGER = logging.getLogger(__name__)

# 교육계획관리
class EDU010E01(BaseSqlApiView):

    # region 노드 정의
    # endregion
    def define_nodes(self):
        '''비즈니스 로직 실행(조회/저장)에 필요한 노드 정의 '''

        self._sql_helper = SqlFileHelper(__package__)

        # 교육계획/실적 등록
        node_list = BusinessNode()
        node_list.node_name = 'list'
        node_list.sql_filename = '100_EDUMGNT_list'
        node_list.model = PangEduPlanMgnt
        node_list.table_name = 'pang_edu_plan_mgnt'
        node_list.key_columns = ['edu_plan_no']
        node_list.update_columns = ['edu_plan_no', 'edu_schedule_no', 'edu_name', 'emp_no',
                                       'edu_time', 'edu_type', 'edu_supervision', 'edu_location',
                                       'edu_rate', 'edu_cmplt_yn', 'edu_absence_reason', 'rmk',
                                       'edu_large_class', 'edu_middle_class', 'edu_from_dt', 'edu_to_dt',
                                       'edu_attach_id', 'edu_absence_yn', 'dept_code', 'edu_cost', 'edu_year',
                                       'first_rg_yms', 'first_rg_idf', 'last_update_yms', 'last_update_idf']

        self._append_node(node_list)

        # 교육일정번호 MAX 값 가져오기
        node_max_list = BusinessNode()
        node_max_list.node_name = 'getMaxEduSchedule'
        node_max_list.sql_filename = '100_GetMaxEduSchedule'
        node_max_list.model = PangEduSchdlMgnt
        node_max_list.table_name = 'pang_edu_schdl_mgnt'
        node_max_list.key_columns = ['edu_schedule_no']
        node_max_list.update_columns = ['edu_schedule_no', 'edu_year', 'edu_from_dt', 'edu_to_dt', 'close_yn', 'rmk']

        self._append_node(node_max_list)

        # 사원정보 가져오기
        node_emp_info = BusinessNode()
        node_emp_info.node_name = 'getEmpInfo'
        node_emp_info.sql_filename = '100_GetEmpInfo'
        node_emp_info.model = PangEmpInfo
        node_emp_info.table_name = 'pang_emp_info'
        node_emp_info.key_columns = ['emp_no']
        node_emp_info.update_columns = ['emp_no', 'user_id', 'emp_name', 'dept_code',
                                        'email', 'phon_number', 'job', 'responsi', 'use_yn']

        self._append_node(node_emp_info)

        # # 교육계획 상세
        # node_sublist = BusinessNode()
        # node_sublist.node_name = 'sublist'
        # node_sublist.sql_filename = '110_EDUMGNT_sublist'
        # node_sublist.model = PangEduPlanMgnt
        # node_sublist.table_name = 'pang_edu_plan_mgnt'
        # node_sublist.key_columns = ['edu_plan_no']
        # node_sublist.update_columns = ['edu_plan_no', 'edu_schedule_no', 'edu_name', 'emp_no',
        #                                'edu_time', 'edu_type', 'edu_supervision', 'edu_location',
        #                                'edu_rate', 'edu_cmplt_yn', 'edu_absence_reason', 'rmk',
        #                                'edu_large_class', 'edu_middle_class', 'edu_from_dt', 'edu_to_dt',
        #                                'edu_attach_id', 'edu_absence_yn']
        # self._append_node(node_list, node_sublist)

    # region 조회
    # endregion

    def _create_filter(self, node: BusinessNode, parameter_list=None, request_data=None, include_all=False):
        # 조회조건을 추가하기 위해 오버라이딩
        filter_data = None

        # 교육계획/실적 목록 조회조건
        if node.node_name == 'list':

            if len(request_data) == 0:
                return None
            filter_data = {
                'p_edu_year': request_data.get('p_edu_year'),
                'p_dept_code': request_data.get('p_dept_code', '%'),
                'p_emp_name': request_data.get('p_emp_name', '%'),
                'p_edu_large_class': request_data.get('p_edu_large_class', '%'),
                'p_edu_middle_class': request_data.get('p_edu_middle_class', '%'),
                'p_edu_supervision': request_data.get('p_edu_supervision', '%'),
                'p_edu_name': request_data.get('p_edu_name', '%'),
                'p_edu_cmplt_yn': request_data.get('p_edu_cmplt_yn', '%'),
            }

        elif node.node_name == 'getMaxEduSchedule':

            if len(request_data) == 0:
                return None
            filter_data = {
                'p_close_yn': request_data.get('p_close_yn', 'N'),
            }

        elif node.node_name == 'getEmpInfo':

            if len(request_data) == 0:
                return None
            filter_data = {
                'p_emp_no': request_data.get('p_emp_no', '%'),
            }

        return filter_data

    def get_list(self, request):
        """
        업무일지 등록 목록 조회



        """
        return self._exec_get(request)

    def get_sublist(self, request):

        """
        업무일지 등록 상세 조회



        """
        return self._exec_get(request)

    def get_max_edu_schedule(self, request):

        """
        업무일지 등록 상세 조회



        """
        return self._exec_get(request)

    def get_emp_info(self, request):

        """
        업무일지 등록 상세 조회



        """
        return self._exec_get(request)

    # region 저장
    #
    def _pre_update(self, node: BusinessNode, update_type: UpdateType, update_data: list, req_data) -> None:
        """변경된 데이터를 저장하기 전 호출되는 메서드입니다.

        """
        # region _pre_update : 신규

        if node.node_name == 'list' and update_type == UpdateType.Insert:
            # 교육계획/실적 등록시 교육계획등록번호(edu_plan_no)를 설정합니다.
            for row in update_data:
                # 교육년도
                edu_year = row['edu_year']
                # 식별번호
                prefix = "plan" + edu_year

                # 교육계획등록번호 = plan + 교육년도(4) + 일련번호(5)
                # 키를 새로 생성하는 경우 요청데이터를 함께 변경하기 위해 change_key() 함수를 사용한다.
                new_edu_plan_no = get_next_seq_value(name=f'{node.table_name}.edu_plan_no',
                                                   prefix=prefix,
                                                   padding=5)
                # key 값 변경
                node.change_key_values(target_row=row, new_key_data={'edu_plan_no': new_edu_plan_no})

    def save(self, request):


        try:
           return_data = self._exec_save(request)

           if return_data.data['success'] == False:
               return Response(
                   {'success': False, 'code': 0, 'message': return_data.data['data'], 'data': False},
                   status.HTTP_200_OK)

           return return_data

        except Exception as ex:

            return Response({'success': False, 'code': 0, 'message': '오류발생', 'data': False},
                            status.HTTP_200_OK)



        # print(request)
        # return self._exec_save(request)


    # endregion