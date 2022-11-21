import logging

from vntg_wdk_core.business import BusinessNode
from vntg_wdk_core.helper.file_helper import SqlFileHelper
from vntg_wdk_core.views.baseview import BaseSqlApiView

from apps.bzcm.models import PangEduPlanMgnt

# 교육비 현황
class EDU020E04(BaseSqlApiView):

    # region 노드 정의
    # endregion
    def define_nodes(self):
        '''비즈니스 로직 실행(조회/저장)에 필요한 노드 정의 '''

        self._sql_helper = SqlFileHelper(__package__)

        # 연도별 교육비 현황
        node_by_year_edu_cost_list = BusinessNode()
        node_by_year_edu_cost_list.node_name = 'byYearEduCostList'
        node_by_year_edu_cost_list.sql_filename = '100_byYearEduCost'
        node_by_year_edu_cost_list.model = PangEduPlanMgnt
        node_by_year_edu_cost_list.table_name = 'pang_edu_plan_mgnt'
        node_by_year_edu_cost_list.key_columns = ['edu_plan_no']
        node_by_year_edu_cost_list.update_columns = ['edu_plan_no', 'edu_schedule_no', 'edu_name', 'emp_no',
                                    'edu_time', 'edu_type', 'edu_supervision', 'edu_location',
                                    'edu_rate', 'edu_cmplt_yn', 'edu_absence_reason', 'rmk',
                                    'edu_large_class', 'edu_middle_class', 'edu_from_dt', 'edu_to_dt',
                                    'edu_attach_id', 'edu_absence_yn', 'edu_cost', 'std_year', 'dept_code']
        self._append_node(node_by_year_edu_cost_list)

        # 연도별 교육비 현황 그리드
        node_by_year_edu_cost_list = BusinessNode()
        node_by_year_edu_cost_list.node_name = 'byYearEduCostList_Grid1'
        node_by_year_edu_cost_list.sql_filename = '100_byYearEduCost_Grid1'
        node_by_year_edu_cost_list.model = PangEduPlanMgnt
        node_by_year_edu_cost_list.table_name = 'pang_edu_plan_mgnt'
        node_by_year_edu_cost_list.key_columns = ['edu_plan_no']
        node_by_year_edu_cost_list.update_columns = ['edu_plan_no', 'edu_schedule_no', 'edu_name', 'emp_no',
                                                     'edu_time', 'edu_type', 'edu_supervision', 'edu_location',
                                                     'edu_rate', 'edu_cmplt_yn', 'edu_absence_reason', 'rmk',
                                                     'edu_large_class', 'edu_middle_class', 'edu_from_dt', 'edu_to_dt',
                                                     'edu_attach_id', 'edu_absence_yn', 'edu_cost', 'std_year',
                                                     'dept_code']
        self._append_node(node_by_year_edu_cost_list)

        # 부서별 교육비 현황
        node_by_dept_edu_cost_list = BusinessNode()
        node_by_dept_edu_cost_list.node_name = 'byDeptEduCostList'
        node_by_dept_edu_cost_list.sql_filename = '100_byDeptEduCost'
        node_by_dept_edu_cost_list.model = PangEduPlanMgnt
        node_by_dept_edu_cost_list.table_name = 'pang_edu_plan_mgnt'
        node_by_dept_edu_cost_list.key_columns = ['edu_plan_no']
        node_by_dept_edu_cost_list.update_columns = ['edu_plan_no', 'edu_schedule_no', 'edu_name', 'emp_no',
                                                'edu_time', 'edu_type', 'edu_supervision', 'edu_location',
                                                'edu_rate', 'edu_cmplt_yn', 'edu_absence_reason', 'rmk',
                                                'edu_large_class', 'edu_middle_class', 'edu_from_dt', 'edu_to_dt',
                                                'edu_attach_id', 'edu_absence_yn', 'edu_cost', 'std_year', 'dept_code']
        self._append_node(node_by_dept_edu_cost_list)

        # 부서별 교육비 현황
        node_by_dept_edu_cost_grid_list = BusinessNode()
        node_by_dept_edu_cost_grid_list.node_name = 'byDeptEduCostList_Grid1'
        node_by_dept_edu_cost_grid_list.sql_filename = '100_byDeptEduCost_Grdi1'
        node_by_dept_edu_cost_grid_list.model = PangEduPlanMgnt
        node_by_dept_edu_cost_grid_list.table_name = 'pang_edu_plan_mgnt'
        node_by_dept_edu_cost_grid_list.key_columns = ['edu_plan_no']
        node_by_dept_edu_cost_grid_list.update_columns = ['edu_plan_no', 'edu_schedule_no', 'edu_name', 'emp_no',
                                                     'edu_time', 'edu_type', 'edu_supervision', 'edu_location',
                                                     'edu_rate', 'edu_cmplt_yn', 'edu_absence_reason', 'rmk',
                                                     'edu_large_class', 'edu_middle_class', 'edu_from_dt', 'edu_to_dt',
                                                     'edu_attach_id', 'edu_absence_yn', 'edu_cost', 'std_year',
                                                     'dept_code']
        self._append_node(node_by_dept_edu_cost_grid_list)

        # 사원별 교육비 현황
        node_by_emp_edu_cost_list = BusinessNode()
        node_by_emp_edu_cost_list.node_name = 'byEmpEduCostList'
        node_by_emp_edu_cost_list.sql_filename = '100_byEmpEduCost'
        node_by_emp_edu_cost_list.model = PangEduPlanMgnt
        node_by_emp_edu_cost_list.table_name = 'pang_edu_plan_mgnt'
        node_by_emp_edu_cost_list.key_columns = ['edu_plan_no']
        node_by_emp_edu_cost_list.update_columns = ['edu_plan_no', 'edu_schedule_no', 'edu_name', 'emp_no',
                                                    'edu_time', 'edu_type', 'edu_supervision', 'edu_location',
                                                    'edu_rate', 'edu_cmplt_yn', 'edu_absence_reason', 'rmk',
                                                    'edu_large_class', 'edu_middle_class', 'edu_from_dt', 'edu_to_dt',
                                                    'edu_attach_id', 'edu_absence_yn', 'edu_cost', 'std_year',
                                                    'dept_code']
        self._append_node(node_by_emp_edu_cost_list)

    # region 조회
    # endregion

    def _create_filter(self, node: BusinessNode, parameter_list=None, request_data=None, include_all=False):
        # 조회조건을 추가하기 위해 오버라이딩
        filter_data = None

        # 연도별 교육 현황
        if node.node_name == 'byYearEduCostList' or node.node_name == 'byDeptEduCostList' or node.node_name == 'byEmpEduCostList' or node.node_name == 'byYearEduCostList_Grid1' or node.node_name == 'byDeptEduCostList_Grid1':
            if len(request_data) == 0:
                return None

            filter_data = {
                'p_edu_absence_yn': request_data.get('p_edu_absence_yn', '%'),
                'p_edu_year': request_data.get('p_edu_year', '%')
            }
        return filter_data

    def get_list(self, request):

        return self._exec_get(request)

