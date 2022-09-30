import logging

from vntg_wdk_core.business import BusinessNode
from vntg_wdk_core.helper.file_helper import SqlFileHelper
from vntg_wdk_core.views.baseview import BaseSqlApiView

from apps.bzcm.models import PangComCode

LOGGER = logging.getLogger(__name__)

# 공통코드관리
class EDU000E01(BaseSqlApiView):

    # region 노드 정의
    # endregion
    def define_nodes(self):
        '''비즈니스 로직 실행(조회/저장)에 필요한 노드 정의 '''

        self._sql_helper = SqlFileHelper(__package__)

        # 공통코드 등록
        node_codeList = BusinessNode()
        node_codeList.node_name = 'codeList'
        node_codeList.sql_filename = '100_CODE_list'
        node_codeList.model = PangComCode
        node_codeList.table_name = 'pang_com_code'
        node_codeList.key_columns = ['code']
        node_codeList.update_columns = ['code', 'code_name', 'up_code', 'rmk', 'use_yn']
        self._append_node(node_codeList)

    # region 조회
    # endregion

    def _create_filter(self, node: BusinessNode, parameter_list=None, request_data=None, include_all=False):
        # 조회조건을 추가하기 위해 오버라이딩
        filter_data = None

        # 업무일지 목록 조회조건
        if node.node_name == 'codeList':
            if len(request_data) == 0:
                return None

            filter_data = {
                'p_code': request_data.get('p_code'),
                'p_name': request_data.get('p_name'),
                'p_use_yn': request_data.get('p_use_yn'),
            }

        return filter_data

    def get_list(self, request):
        return self._exec_get(request)

    def get_sublist(self, request):
        return self._exec_get(request)

    # region 저장
    #
    # def _pre_update(self, node: BusinessNode, update_type: UpdateType, update_data: list, req_data) -> None:
    #     """변경된 데이터를 저장하기 전 호출되는 메서드입니다.
    #
    #     """
    #     # region _pre_update : 신규
    #
    #     if node.node_name == 'list' and update_type == UpdateType.Insert:
    #         # 업무일지등록시 업무일지번호(report_no)를 설정합니다.
    #         for row in update_data:
    #             # 등록일자
    #             report_write_date = string_to_date(row['report_write_date'])
    #             # 등록년도
    #             write_date = date_to_ym(report_write_date)
    #             # 식별번호
    #             prefix = f"{write_date}"
    #
    #             # 업무일지 번호 생성 = 날짜 6자리(6) + 일련번호(3)
    #             # 키를 새로 생성하는 경우 요청데이터를 함께 변경하기 위해 change_key() 함수를 사용한다.
    #             new_report_no = get_next_seq_value(name=f'{node.table_name}.report_no',
    #                                                prefix=prefix,
    #                                                padding=3)
    #             # key 값 변경
    #             node.change_key_values(target_row=row, new_key_data={'report_no': new_report_no})
    #
    #     elif node.node_name == 'sublist' and update_type == UpdateType.Insert:
    #         # 업무일지 상세등록시 업무일지 일련번호(report_sno)를 설정합니다.
    #         for row in update_data:
    #             # 업무일지 일련번호
    #             new_report_sno = get_next_seq_value(name=f'{node.table_name}.report_sno',
    #                                                 prefix=row['report_no'],
    #                                                 padding=-1)
    #             # key 값 변경
    #             node.change_key_values(target_row=row, new_key_data={'report_no': row['report_no'],
    #                                                                  'report_sno': new_report_sno})

    def save(self, request):
        return self._exec_save(request)