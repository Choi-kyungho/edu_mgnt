import logging

from vntg_wdk_core.business import BusinessNode
from vntg_wdk_core.enums import UpdateType
from vntg_wdk_core.helper.date_helper import string_to_date, date_to_ym
from vntg_wdk_common.utils import get_next_seq_value
from vntg_wdk_core.helper.file_helper import SqlFileHelper
from vntg_wdk_core.views.baseview import BaseSqlApiView

from apps.bzcm.models import PangEmpInfo

LOGGER = logging.getLogger(__name__)

# 사원관리 API
class EDU000E02(BaseSqlApiView):

    # region 노드 정의
    # endregion
    def define_nodes(self):
        '''비즈니스 로직 실행(조회/저장)에 필요한 노드 정의 '''

        self._sql_helper = SqlFileHelper(__package__)

        # 사원 등록
        node_empList = BusinessNode()
        node_empList.node_name = 'empList'
        node_empList.sql_filename = '100_EMP_list'
        node_empList.model = PangEmpInfo
        node_empList.table_name = 'pang_emp_info'
        node_empList.key_columns = ['emp_no']
        node_empList.update_columns = ['emp_no', 'user_id', 'emp_name', 'dept_code', 'email', 'phon_number', 'job', 'responsi', 'use_yn']
        self._append_node(node_empList)

    # region 조회
    # endregion

    def _create_filter(self, node: BusinessNode, parameter_list=None, request_data=None, include_all=False):
        # 조회조건을 추가하기 위해 오버라이딩
        filter_data = None

        # 사원 목록 조회조건
        if node.node_name == 'empList':
            if len(request_data) == 0:
                return None

            filter_data = {
                'p_emp_name': request_data.get('p_emp_name', '%'),
                'p_dept_code': request_data.get('p_dept_code', '%')
            }

        return filter_data

    def get_list(self, request):
        return self._exec_get(request)

    def get_sublist(self, request):
        return self._exec_get(request)

    def save(self, request):
        return self._exec_save(request)