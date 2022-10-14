import logging

from vntg_wdk_core.business import BusinessNode
from vntg_wdk_core.helper.file_helper import SqlFileHelper
from vntg_wdk_core.views.baseview import BaseSqlApiView

from apps.bzcm.models import PangEmpInfo

# 인원현황
class EDU020E01(BaseSqlApiView):

    # region 노드 정의
    # endregion
    def define_nodes(self):
        '''비즈니스 로직 실행(조회/저장)에 필요한 노드 정의 '''

        self._sql_helper = SqlFileHelper(__package__)

        # 인원현황 - 전체
        node_empCount_list = BusinessNode()
        node_empCount_list.node_name = 'empCountlist'
        node_empCount_list.sql_filename = '100_EMPCOUNT_list'
        node_empCount_list.model = PangEmpInfo
        node_empCount_list.table_name = 'pang_emp_info'
        node_empCount_list.key_columns = ['emp_no']
        node_empCount_list.update_columns = ['emp_no', 'user_id', 'emp_name', 'dept_code', 'email', 'phon_number', 'posit', 'responsi', 'use_yn']

        self._append_node(node_empCount_list)

        # 인원현황 - 직무별
        node_empByJobCount_list = BusinessNode()
        node_empByJobCount_list.node_name = 'empByJobCountlist'
        node_empByJobCount_list.sql_filename = '100_EMPBYJOBCOUNT_list'
        node_empByJobCount_list.model = PangEmpInfo
        node_empByJobCount_list.table_name = 'pang_emp_info'
        node_empByJobCount_list.key_columns = ['emp_no']
        node_empByJobCount_list.update_columns = ['emp_no', 'user_id', 'emp_name', 'dept_code', 'email', 'phon_number',
                                             'posit', 'responsi', 'use_yn']

        self._append_node(node_empByJobCount_list)

        # 인원현황 - 직책별
        node_empByRespCount_list = BusinessNode()
        node_empByRespCount_list.node_name = 'empByRespCountlist'
        node_empByRespCount_list.sql_filename = '100_EMPBYRESPCOUNT_list'
        node_empByRespCount_list.model = PangEmpInfo
        node_empByRespCount_list.table_name = 'pang_emp_info'
        node_empByRespCount_list.key_columns = ['emp_no']
        node_empByRespCount_list.update_columns = ['emp_no', 'user_id', 'emp_name', 'dept_code', 'email', 'phon_number',
                                                  'posit', 'responsi', 'use_yn']

        self._append_node(node_empByRespCount_list)


    # region 조회
    # endregion

    def _create_filter(self, node: BusinessNode, parameter_list=None, request_data=None, include_all=False):
        # 조회조건을 추가하기 위해 오버라이딩
        filter_data = None

        # 업무일지 목록 조회조건
        if node.node_name == 'empCountlist' or node.node_name == 'empByJobCountlist' or node.node_name == 'empByRespCountlist':
            if len(request_data) == 0:
                return None

            filter_data = {
                'p_use_yn': request_data.get('p_use_yn', '%')
            }
        return filter_data

    def get_list(self, request):
        """
        업무일지 등록 목록 조회



        """

        return self._exec_get(request)

