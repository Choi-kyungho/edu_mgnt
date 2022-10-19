import logging

from django.db.models import Q
from drf_yasg.utils import swagger_auto_schema
from rest_framework.decorators import action

from vntg_wdk_core.business import BusinessNode
from vntg_wdk_core.enums import UpdateType
from vntg_wdk_core.views.baseview import BaseModelApiView

from vntg_wdk_common.models.basecode import CmCodeMaster, CmCodeDetail
from vntg_wdk_common.serializers.basecode import CmCodeMasterSerializer, CmCodeDetailSerializer

from vntg_wdk_comm.serializers import COMM020E01MasterQuerySerializer, \
    COMM020E01DetailQuerySerializer, COMM020E01PostSerializer, COMM020E01ResponseSerializer, \
    COMM020E01MasterResponseSerializer, COMM020E01DetailResponseSerializer, BaseResponseSerializer

LOGGER = logging.getLogger(__name__)


class EDU000E05(BaseModelApiView):
    """공통코드 관리
    """

    # region 노드 정의

    def define_nodes(self):
        """비즈니스 로직 실행(조회/저장)에 필요한 노드 정의"""
        # 메뉴
        node_master = BusinessNode()
        node_master.node_name = 'list'
        node_master.model = CmCodeMaster
        node_master.table_name = 'cm_code_master'
        node_master.serializer = CmCodeMasterSerializer
        node_master.key_columns = ['cm_code_type_id']
        node_master.update_columns = ['cm_code_type_id', 'cm_code_type_name', 'parent_code_type_id', 'cm_code_length',
                                      'system_yn', 'remark', 'delete_yn',
                                      'first_rg_yms', 'first_rg_idf', 'last_update_yms', 'last_update_idf']
        node_master.sort_columns = ['cm_code_type_id']
        self._append_node(node_master)

        # 프로그램
        node_detail = BusinessNode()
        node_detail.node_name = 'sublist'
        node_detail.model = CmCodeDetail
        node_detail.table_name = 'cm_code_detail'
        node_detail.serializer = CmCodeDetailSerializer
        node_detail.key_columns = ['cm_code_type_id', 'detail_code_id']
        node_detail.update_columns = ['cm_code_type_id', 'detail_code_id', 'detail_code_name', 'sort_seq', 'sort_seq',
                                      'use_yn', 'etc_ctnt1', 'etc_ctnt2', 'etc_ctnt3', 'etc_ctnt4', 'etc_ctnt5',
                                      'etc_desc', 'valid_start_date', 'valid_end_date',
                                      'first_rg_yms', 'first_rg_idf', 'last_update_yms', 'last_update_idf']
        node_detail.sort_columns = ['cm_code_type_id', 'sort_seq']
        self._append_node(node_master, node_detail)

    # endregion

    # region 조회

    def _create_filter(self, node: BusinessNode, parameter_list=None, request_data=None, include_all=False):
        # 조회조건을 추가하기 위해 오버라이딩
        filter_data = None

        if node.node_name == 'list':
            if len(request_data) == 0:
                return None

            # Q 객체를 이용하여 파라미터 생성
            filter_data = Q()
            if 'parent_code_type_id' in request_data and request_data.get('parent_code_type_id') != '%':
                filter_data.add(Q(parent_code_type_id=request_data.get('parent_code_type_id')), Q.AND)
            if 'system_yn' in request_data and request_data.get('system_yn') != '%':
                filter_data.add(Q(system_yn=request_data.get('system_yn')), Q.AND)
            if 'search_text' in request_data and request_data.get('search_text') != '%':
                filter_data.add(Q(cm_code_type_id__contains=request_data.get('search_text'))
                                | Q(cm_code_type_name__contains=request_data.get('search_text'))
                                | Q(parent_code_type_id__contains=request_data.get('search_text'))
                                | Q(remark__contains=request_data.get('search_text')),
                                Q.AND)
        elif node.node_name == 'sublist':
            # dict 타입으로 파라미터 생성
            filter_data = {
                'cm_code_type_id': request_data.get('cm_code_type_id', None)
            }
            # 불필요한 파라미터 제거
            filter_data = {key: val for key, val in filter_data.items() if val is not None and val != '%'}
            # 디테일은 마스터 키 조건이 없으면 조회 불가
            if len(filter_data) == 0:
                raise Exception('조회조건이 누락되어 조회할 수 없습니다.')

        return filter_data

    def get_master(self, request, *args, **kwargs):
        return self._exec_get(request)

    def get_detail(self, request, *args, **kwargs):
        return self._exec_get(request)

    # endregion

    # region 저장

    def _pre_update(self, node: BusinessNode, update_type: UpdateType, update_data: list, req_data) -> None:

        if node.node_name == 'list' and update_type == UpdateType.Insert:
            for row in update_data:
                # db 확인 - cm_code_type_id가 이미 있는지 확인 필요
                found = self._get_row_by_key(CmCodeMaster, {'cm_code_type_id': row['cm_code_type_id']})
                if found is not None:
                    raise Exception(f'''이미 등록된 공통코드유형ID({row['cm_code_type_id']})입니다.''')

        elif node.node_name == 'sublist' and update_type == UpdateType.Insert:
            for row in update_data:
                # db 확인 - detail_code_id가 이미 있는지 확인 필요
                found = self._get_row_by_key(CmCodeDetail,
                                             {'cm_code_type_id': row['cm_code_type_id'],
                                              'detail_code_id': row['detail_code_id']})
                if found is not None:
                    raise Exception(f"공통코드유형ID({row['cm_code_type_id']})에 "
                                    f"이미 등록된 상세코드ID({row['detail_code_id']})입니다.")

    def save(self, request, *args, **kwargs):
        return self._exec_save(request)

    # endregion
