import logging

from vntg_wdk_common.utils import get_next_seq_value
from vntg_wdk_core.business import BusinessNode
from vntg_wdk_core.enums import UpdateType
from vntg_wdk_core.helper.date_helper import string_to_date, date_to_ym
from vntg_wdk_core.helper.file_helper import SqlFileHelper
from vntg_wdk_core.views.baseview import BaseSqlApiView

from apps.bzcm.models import Bzcm02010A2, Bzcm02011A2

LOGGER = logging.getLogger(__name__)


class BZCM020E10(BaseSqlApiView):
    '''업무일지등록
    '''

    # region 노드 정의
    # endregion
    def define_nodes(self):
        '''비즈니스 로직 실행(조회/저장)에 필요한 노드 정의 '''

        self._sql_helper = SqlFileHelper(__package__)

        # 업무일지 등록
        node_list = BusinessNode()
        node_list.node_name = 'list'
        node_list.sql_filename = '100_BZCM020E10_list'
        node_list.model = Bzcm02010A2
        node_list.table_name = 'bzcm02010_a2'
        node_list.key_columns = ['report_no']
        node_list.update_columns = ['report_no', 'report_write_date', 'emp_name', 'exec_ctnt', 'plan_ctnt', 'remark',
                                    'first_rg_yms', 'first_rg_idf', 'last_update_yms', 'last_update_idf']

        self._append_node(node_list)

        # 업무일지 목록 상세
        node_sublist = BusinessNode()
        node_sublist.node_name = 'sublist'
        node_sublist.sql_filename = '110_BZCM020E10_sublist'
        node_sublist.model = Bzcm02011A2
        node_sublist.table_name = 'bzcm02011_a2'
        node_sublist.key_columns = ['report_no', 'report_sno']
        node_sublist.update_columns = ['report_no', 'report_sno', 'work_start_time', 'work_end_time', 'detail_ctnt',
                                       'remark', 'first_rg_yms', 'first_rg_idf', 'last_update_yms', 'last_update_idf']
        self._append_node(node_list, node_sublist)

    # region 조회
    # endregion

    def _create_filter(self, node: BusinessNode, parameter_list=None, request_data=None, include_all=False):
        # 조회조건을 추가하기 위해 오버라이딩
        filter_data = None


        # 업무일지 목록 조회조건
        if node.node_name == 'list':
            if len(request_data) == 0:
                return None

            filter_data = {
                'p_report_write_date_fr': request_data.get('p_report_write_date_fr'),
                'p_report_write_date_to': request_data.get('p_report_write_date_to'),
                'p_emp_name': request_data.get('p_emp_name', '%'),
            }

        elif node.node_name == 'sublist':
            filter_data = {
                'p_report_no': request_data.get('p_report_no'),
            }
        return filter_data

    def get_list(self, request):
        """
        업무일지 등록 목록 조회

        요청 파라미터
        report_write_date_fr: 등록시작일자, 일수
        report_write_date_to: 등록종료일자, 일수
        emp_name : 담당자


        """
        return self._exec_get(request)

    def get_sublist(self, request):

        """
        업무일지 등록 상세 조회

        요청파라미터
        report_no : 업무일지번호, 필수

        Parameters
        ----------
        self
        request

        Returns
        -------

        """
        return self._exec_get(request)


    # region 저장

    def _pre_update(self, node: BusinessNode, update_type: UpdateType, update_data: list, req_data) -> None:
        """변경된 데이터를 저장하기 전 호출되는 메서드입니다.

        """
        # region _pre_update : 신규

        if node.node_name == 'list' and update_type == UpdateType.Insert:
            # 업무일지등록시 업무일지번호(report_no)를 설정합니다.
            for row in update_data:
                # 등록일자
                report_write_date = string_to_date(row['report_write_date'])
                # 등록년도
                write_date = date_to_ym(report_write_date)
                # 식별번호
                prefix = f"{write_date}"

                # 업무일지 번호 생성 = 날짜 6자리(6) + 일련번호(3)
                # 키를 새로 생성하는 경우 요청데이터를 함께 변경하기 위해 change_key() 함수를 사용한다.
                new_report_no = get_next_seq_value(name=f'{node.table_name}.report_no',
                                                   prefix=prefix,
                                                   padding=3)
                # key 값 변경
                node.change_key_values(target_row=row, new_key_data={'report_no': new_report_no})

        elif node.node_name == 'sublist' and update_type == UpdateType.Insert:
            # 업무일지 상세등록시 업무일지 일련번호(report_sno)를 설정합니다.
            for row in update_data:
                # 업무일지 일련번호
                new_report_sno = get_next_seq_value(name=f'{node.table_name}.report_sno',
                                                    prefix=row['report_no'],
                                                    padding=-1)
                # key 값 변경
                node.change_key_values(target_row=row, new_key_data={'report_no': row['report_no'],
                                                                     'report_sno': new_report_sno})

    def save(self, request):
        """
        업무일지 등록 저장

        신규행일 경우 report_no, sno 채번
        """

        return self._exec_save(request)
    # endregion