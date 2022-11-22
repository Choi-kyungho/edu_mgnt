import logging

from vntg_wdk_core.business import BusinessNode
from vntg_wdk_core.helper.file_helper import SqlFileHelper
from vntg_wdk_core.views.baseview import BaseSqlApiView
from rest_framework import viewsets, status
from rest_framework.response import Response

from apps.bzcm.models import PangEduPlanMgnt
from django.core.mail import EmailMessage

# 교육 현황
class EDU020E02(BaseSqlApiView):

    # region 노드 정의
    # endregion
    def define_nodes(self):
        '''비즈니스 로직 실행(조회/저장)에 필요한 노드 정의 '''

        self._sql_helper = SqlFileHelper(__package__)

        # 연도별 교육 현황
        node_by_year_edu_list = BusinessNode()
        node_by_year_edu_list.node_name = 'byYearEduList'
        node_by_year_edu_list.sql_filename = 'EDU020E02_byYearEduList'
        node_by_year_edu_list.model = PangEduPlanMgnt
        node_by_year_edu_list.table_name = 'pang_edu_plan_mgnt'
        node_by_year_edu_list.key_columns = ['edu_plan_no']
        node_by_year_edu_list.update_columns = ['edu_plan_no', 'edu_schedule_no', 'edu_name', 'emp_no',
                                    'edu_time', 'edu_type', 'edu_supervision', 'edu_location',
                                    'edu_rate', 'edu_cmplt_yn', 'edu_absence_reason', 'rmk',
                                    'edu_large_class', 'edu_middle_class', 'edu_from_dt', 'edu_to_dt',
                                    'edu_attach_id', 'edu_absence_yn', 'edu_cost', 'std_year', 'dept_code']
        self._append_node(node_by_year_edu_list)



        # 부서별 교육 현황
        node_by_dept_edu_list = BusinessNode()
        node_by_dept_edu_list.node_name = 'byDeptEduList'
        node_by_dept_edu_list.sql_filename = 'EDU020E02_byDeptEduList'
        node_by_dept_edu_list.model = PangEduPlanMgnt
        node_by_dept_edu_list.table_name = 'pang_edu_plan_mgnt'
        node_by_dept_edu_list.key_columns = ['edu_plan_no']
        node_by_dept_edu_list.update_columns = ['edu_plan_no', 'edu_schedule_no', 'edu_name', 'emp_no',
                                                'edu_time', 'edu_type', 'edu_supervision', 'edu_location',
                                                'edu_rate', 'edu_cmplt_yn', 'edu_absence_reason', 'rmk',
                                                'edu_large_class', 'edu_middle_class', 'edu_from_dt', 'edu_to_dt',
                                                'edu_attach_id', 'edu_absence_yn', 'edu_cost', 'std_year', 'dept_code']
        self._append_node(node_by_dept_edu_list)

        # 사원별 교육 순위
        node_by_emp_edu_rank = BusinessNode()
        node_by_emp_edu_rank.node_name = 'byEmpEduRankList'
        node_by_emp_edu_rank.sql_filename = '100_BYEMPEDURANK_list'
        node_by_emp_edu_rank.model = PangEduPlanMgnt
        node_by_emp_edu_rank.table_name = 'pang_edu_plan_mgnt'
        node_by_emp_edu_rank.key_columns = ['edu_plan_no']
        node_by_emp_edu_rank.update_columns = ['edu_plan_no', 'edu_schedule_no', 'edu_name', 'emp_no',
                                                'edu_time', 'edu_type', 'edu_supervision', 'edu_location',
                                                'edu_rate', 'edu_cmplt_yn', 'edu_absence_reason', 'rmk',
                                                'edu_large_class', 'edu_middle_class', 'edu_from_dt', 'edu_to_dt',
                                                'edu_attach_id', 'edu_absence_yn', 'edu_cost', 'std_year', 'dept_code']
        self._append_node(node_by_emp_edu_rank)

        # 부서별 교육 순위
        node_by_dept_edu_rank = BusinessNode()
        node_by_dept_edu_rank.node_name = 'byDeptEduRankList'
        node_by_dept_edu_rank.sql_filename = '100_BYDEPTEDURANK_list'
        node_by_dept_edu_rank.model = PangEduPlanMgnt
        node_by_dept_edu_rank.table_name = 'pang_edu_plan_mgnt'
        node_by_dept_edu_rank.key_columns = ['edu_plan_no']
        node_by_dept_edu_rank.update_columns = ['edu_plan_no', 'edu_schedule_no', 'edu_name', 'emp_no',
                                                'edu_time', 'edu_type', 'edu_supervision', 'edu_location',
                                                'edu_rate', 'edu_cmplt_yn', 'edu_absence_reason', 'rmk',
                                                'edu_large_class', 'edu_middle_class', 'edu_from_dt', 'edu_to_dt',
                                                'edu_attach_id', 'edu_absence_yn', 'edu_cost', 'std_year', 'dept_code']
        self._append_node(node_by_dept_edu_rank)

        # 교육현황 그리드
        node_edu_list_grid = BusinessNode()
        node_edu_list_grid.node_name = 'eduListGrid'
        node_edu_list_grid.sql_filename = '100_MODALGRID_EduList'
        node_edu_list_grid.model = PangEduPlanMgnt
        node_edu_list_grid.table_name = 'pang_edu_plan_mgnt'
        node_edu_list_grid.key_columns = ['edu_plan_no']
        node_edu_list_grid.update_columns = ['edu_plan_no', 'edu_schedule_no', 'edu_name', 'emp_no',
                                                'edu_time', 'edu_type', 'edu_supervision', 'edu_location',
                                                'edu_rate', 'edu_cmplt_yn', 'edu_absence_reason', 'rmk',
                                                'edu_large_class', 'edu_middle_class', 'edu_from_dt', 'edu_to_dt',
                                                'edu_attach_id', 'edu_absence_yn', 'edu_cost', 'std_year', 'dept_code']
        self._append_node(node_edu_list_grid)

        node_by_emailSend = BusinessNode()
        node_by_emailSend.node_name = 'eduEmailSend'
        node_by_emailSend.sql_filename = '100_MODALGRID_EduList'
        node_by_emailSend.model = PangEduPlanMgnt
        node_by_emailSend.table_name = 'pang_edu_plan_mgnt'
        node_by_emailSend.key_columns = ['edu_plan_no']
        node_by_emailSend.update_columns = ['edu_plan_no', 'edu_schedule_no', 'edu_name', 'emp_no',
                                                'edu_time', 'edu_type', 'edu_supervision', 'edu_location',
                                                'edu_rate', 'edu_cmplt_yn', 'edu_absence_reason', 'rmk',
                                                'edu_large_class', 'edu_middle_class', 'edu_from_dt', 'edu_to_dt',
                                                'edu_attach_id', 'edu_absence_yn', 'edu_cost', 'std_year', 'dept_code']
        self._append_node(node_by_emailSend)

    # region 조회
    # endregion

    def _create_filter(self, node: BusinessNode, parameter_list=None, request_data=None, include_all=False):
        # 조회조건을 추가하기 위해 오버라이딩
        filter_data = None

        # 연도별 교육 현황
        if node.node_name == 'byYearEduList' or node.node_name == 'byDeptEduList'\
                or node.node_name == 'byEmpEduRankList' or node.node_name == 'byDeptEduRankList':

            if len(request_data) == 0:
                return None

            filter_data = {
                'p_edu_absence_yn': request_data.get('p_edu_absence_yn', '%'),
                'p_edu_year': request_data.get('p_edu_year', '%')
            }
        elif node.node_name == 'eduListGrid':
            if len(request_data) == 0:
                return None

            filter_data = {
                'p_edu_year': request_data.get('p_edu_year', '%'),
                'p_emp_name': request_data.get('p_emp_name', '%'),
                'p_dept_code': request_data.get('p_dept_code', '%'),
                'p_cmplt_yn': request_data.get('p_cmplt_yn', '%'),
                'p_emp_no': request_data.get('p_emp_no', '%'),
            }

        elif node.node_name == 'eduEmailSend':
            if len(request_data) == 0:
                return None

            filter_data = {
                'p_email': request_data.get('p_email', '%'),
                'p_edu_year': request_data.get('p_edu_year', '%'),
                'p_edu_plan_hour': request_data.get('p_edu_plan_hour', '%'),
                'p_edu_cmplt_hour': request_data.get('p_edu_cmplt_hour', '%'),
                'p_edu_cmplt_rate': request_data.get('p_edu_cmplt_rate', '%'),
            }

            self.sendMail(filter_data);

            return


        return filter_data

    def get_list(self, request):

        return self._exec_get(request)

    def sendMail(self, request):

        content = ''
        content += '교육 일정 내에 교육수료를 진행해주시기 바랍니다.\n\n'
        content += '□ 기준년도:' + request.data.get('p_edu_year') + '년\n'
        content += '□ 교육계획시간:' + request.data.get('p_edu_plan_hour') + '\n'
        content += '□ 교육실적시간:' + request.data.get('p_edu_cmplt_hour') + '\n'
        content += '□ 교육수료율:' + request.data.get('p_edu_cmplt_rate') + '\n'

        email = EmailMessage(
            '[교육관리시스템]  ',  # 이메일 제목
            content,  # 내용
            #to=['cjhol2107@vntgcorp.com'],  # 받는 이메일
            to=[request.data.get('p_email')],  # 받는 이메일
        )
        email.send()

        return_data = {'success': True, 'code': 0, 'message': 'OK', 'data': None}
        return_data['data'] = 'success'
        return Response(return_data, status.HTTP_200_OK)

