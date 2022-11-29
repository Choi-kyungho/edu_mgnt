import logging

from vntg_wdk_core.business import BusinessNode
from vntg_wdk_core.enums import UpdateType
from vntg_wdk_core.helper.date_helper import string_to_date, date_to_ym
from vntg_wdk_common.utils import get_next_seq_value
from vntg_wdk_core.helper.file_helper import SqlFileHelper
from vntg_wdk_core.views.baseview import BaseSqlApiView

from apps.bzcm.models import PangDeptInfo

LOGGER = logging.getLogger(__name__)

# 부서관리 API
class EDU000E03(BaseSqlApiView):
    # region 노드 정의
    # endregion
    def define_nodes(self):
        '''비즈니스 로직 실행(조회/저장)에 필요한 노드 정의 '''

        self._sql_helper = SqlFileHelper(__package__)

        # 부서 등록
        node_deptList = BusinessNode()
        node_deptList.node_name = 'deptList'
        node_deptList.sql_filename = '100_dept_list'
        node_deptList.model = PangDeptInfo
        node_deptList.table_name = 'pang_dept_info'
        node_deptList.key_columns = ['dept_code']
        node_deptList.update_columns = ['dept_code', 'dept_name', 'use_yn', 'valid_start_date', 'valid_end_date',
                                        'parent_dept_code','first_rg_yms',
                                        'first_rg_idf', 'last_update_yms', 'last_update_idf']
        self._append_node(node_deptList)

    # region 조회
    # endregion

    def _create_filter(self, node: BusinessNode, parameter_list=None, request_data=None, include_all=False):
        # 조회조건을 추가하기 위해 오버라이딩
        filter_data = None

        # 사원 목록 조회조건
        if node.node_name == 'deptList':
            if len(request_data) == 0:
                return None

            filter_data = {
                'p_dept_name': request_data.get('p_dept_name', '%'),
            }

        return filter_data

    def get_list(self, request):
        return self._exec_get(request)


    def _pre_update(self, node: BusinessNode, update_type: UpdateType, update_data: list, req_data) -> None:

        if node.node_name == 'deptList' and update_type == UpdateType.Insert:
            for row in update_data:

                prefix = 'A'


                new_dept_code = get_next_seq_value(name=f'{node.table_name}.dept_code',
                                                   prefix=prefix,
                                                   padding=3)
                # key 값 변경
                node.change_key_values(target_row=row, new_key_data={'dept_code': new_dept_code})


    def get_sublist(self, request):
        return self._exec_get(request)

    def save(self, request):
        return self._exec_save(request)

