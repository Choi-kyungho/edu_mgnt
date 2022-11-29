import logging

from django.db.models import Q
from vntg_wdk_core.business import BusinessNode
from vntg_wdk_core.helper.file_helper import SqlFileHelper
from vntg_wdk_core.views.baseview import BaseSqlApiView
from vntg_wdk_core.enums import UpdateType
from vntg_wdk_common.utils import get_next_seq_value
from rest_framework.response import Response
from rest_framework import status
from apps.bzcm.models import PangEduPlanMgnt, PangDeptInfo, PangEduSchdlMgnt, PangEduCustInfo, PangBugtPlanMgnt

LOGGER = logging.getLogger(__name__)

# 부서관리
class EDU000E06(BaseSqlApiView):

    # region 노드 정의

    def define_nodes(self):
        '''비즈니스 로직 실행(조회/저장)에 필요한 노드 정의 '''

        self._sql_helper = SqlFileHelper(__package__)

        # 프로그램
        node_bugtPlanMgntList = BusinessNode()
        node_bugtPlanMgntList.node_name = 'list'
        node_bugtPlanMgntList.sql_filename = '100_BUGT_PLAN_MGNT'
        node_bugtPlanMgntList.model = PangBugtPlanMgnt
        node_bugtPlanMgntList.table_name = 'pang_bugt_plan_mgnt'
        node_bugtPlanMgntList.key_columns = ['bugt_year','dept_code']
        node_bugtPlanMgntList.update_columns = ['bugt_year', 'dept_code', 'bugt_amt', 'use_amt', 'remain_amt',
                                         'remark', 'use_yn','first_rg_yms', 'first_rg_idf', 'last_update_yms', 'last_update_idf']
        self._append_node(node_bugtPlanMgntList)

        # 첫조회 (전체)
        node_listGraphFirst = BusinessNode()
        node_listGraphFirst.node_name = 'listGraphFirst'
        node_listGraphFirst.sql_filename = 'EDU000E06_listGraphFirst'
        node_listGraphFirst.model = PangBugtPlanMgnt
        node_listGraphFirst.table_name = 'pang_bugt_plan_mgnt'
        node_listGraphFirst.key_columns = ['bugt_year', 'dept_code']
        node_listGraphFirst.update_columns = ['bugt_year', 'dept_code', 'bugt_amt', 'use_amt', 'remain_amt',
                                         'remark', 'use_yn', 'first_rg_yms', 'first_rg_idf', 'last_update_yms',
                                         'last_update_idf']
        self._append_node(node_listGraphFirst)

        # 프로그램
        node_listGraph = BusinessNode()
        node_listGraph.node_name = 'listGraph'
        node_listGraph.sql_filename = 'EDU000E06_listGraph'
        node_listGraph.model = PangBugtPlanMgnt
        node_listGraph.table_name = 'pang_bugt_plan_mgnt'
        node_listGraph.key_columns = ['bugt_year', 'dept_code']
        node_listGraph.update_columns = ['bugt_year', 'dept_code', 'bugt_amt', 'use_amt', 'remain_amt',
                                                'remark', 'use_yn', 'first_rg_yms', 'first_rg_idf', 'last_update_yms',
                                                'last_update_idf']
        self._append_node(node_listGraph)

    # region 조회
    # endregion

    def _create_filter(self, node: BusinessNode, parameter_list=None, request_data=None, include_all=False):
        # 조회조건을 추가하기 위해 오버라이딩
        filter_data = None

        if node.node_name == 'list' or node.node_name == 'listGraph':
            if len(request_data) == 0:
                return None
            # Q 객체를 이용하여 파라미터 생성
            filter_data = {
                'p_bugt_year': request_data.get('p_bugt_year'),
                'p_dept_code': request_data.get('p_dept_code'),
            }
        elif node.node_name == 'listGraphFirst':
            if len(request_data) == 0:
                return None
            # Q 객체를 이용하여 파라미터 생성
            filter_data = {
                'p_bugt_year': request_data.get('p_bugt_year'),
            }

        return filter_data

    def _pre_update(self, node: BusinessNode, update_type: UpdateType, update_data: list, req_data) -> None:

        if node.node_name == 'list' and update_type == UpdateType.Insert:
            for row in update_data:
                row['remain_amt'] = row['bugt_amt'] - row['use_amt']

        elif node.node_name == 'list' and update_type == UpdateType.Update:
            for row in update_data:
                row['remain_amt'] = row['bugt_amt'] - row['use_amt']

    def get_list(self, request):
        return self._exec_get(request)

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
