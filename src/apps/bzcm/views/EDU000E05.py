import logging

from django.db.models import Q
from vntg_wdk_core.business import BusinessNode
from vntg_wdk_core.helper.file_helper import SqlFileHelper
from vntg_wdk_core.views.baseview import BaseSqlApiView
from vntg_wdk_core.enums import UpdateType
from vntg_wdk_common.utils import get_next_seq_value
from rest_framework.response import Response
from rest_framework import status
from apps.bzcm.models import PangEduPlanMgnt, PangDeptInfo, PangEduSchdlMgnt, PangEduCustInfo

LOGGER = logging.getLogger(__name__)

# 부서관리
class EDU000E05(BaseSqlApiView):

    # region 노드 정의

    def define_nodes(self):
        '''비즈니스 로직 실행(조회/저장)에 필요한 노드 정의 '''

        self._sql_helper = SqlFileHelper(__package__)

        # 프로그램
        node_educustList = BusinessNode()
        node_educustList.node_name = 'list'
        node_educustList.sql_filename = '100_EDU_CUST_LIST'
        node_educustList.model = PangEduCustInfo
        node_educustList.table_name = 'pang_edu_cust_info'
        node_educustList.key_columns = ['edu_code_id']
        node_educustList.update_columns = ['edu_code_id', 'edu_code_name', 'cm_code_type_id', 'url', 'addr',
                                         'business_no', 'president', 'tel_no', 'remarks', 'use_yn', 'sort_seq',
                                         'first_rg_yms', 'first_rg_idf', 'last_update_yms', 'last_update_idf']
        self._append_node(node_educustList)

    # region 조회
    # endregion

    def _create_filter(self, node: BusinessNode, parameter_list=None, request_data=None, include_all=False):
        # 조회조건을 추가하기 위해 오버라이딩
        filter_data = None

        if node.node_name == 'list':
            if len(request_data) == 0:
                return None
            # Q 객체를 이용하여 파라미터 생성
            filter_data = {
                # 'cm_code_type_id': "EDU06",
                'p_edu_code_id': request_data.get('p_edu_code_id'),
                'p_edu_code_name': request_data.get('p_edu_code_name'),
            }

        return filter_data

    def get_list(self, request):
        return self._exec_get(request)

    def _pre_update(self, node: BusinessNode, update_type: UpdateType, update_data: list, req_data) -> None:

        if node.node_name == 'list' and update_type == UpdateType.Insert:
            for row in update_data:

                prefix = 'A'

                # 교육일정번호 번호 생성 = schdl + 일련번호(5)
                # 키를 새로 생성하는 경우 요청데이터를 함께 변경하기 위해 change_key() 함수를 사용한다.
                new_edu_code_id = get_next_seq_value(name=f'{node.table_name}.edu_code_id',
                                                   prefix=prefix,
                                                   padding=4)
                # key 값 변경
                node.change_key_values(target_row=row, new_key_data={'edu_code_id': new_edu_code_id})


    def save(self, request, *args, **kwargs):

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
        # return self._exec_save(request)