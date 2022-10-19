from django.db import models

# Create your models here.
from vntg_wdk_core.models import BaseTableModel


class Bzcm02010A2(BaseTableModel):
    report_no = models.CharField(primary_key=True, max_length=20)
    report_write_date = models.DateTimeField()
    emp_name = models.CharField(max_length=10)
    exec_ctnt = models.CharField(max_length=500, blank=True, null=True)
    plan_ctnt = models.CharField(max_length=500, blank=True, null=True)
    remark = models.CharField(max_length=500, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'bzcm02010_a2'


class Bzcm02011A2(BaseTableModel):
    report_no = models.CharField(primary_key=True, max_length=20)
    report_sno = models.IntegerField()
    work_start_time = models.DateTimeField()
    work_end_time = models.DateTimeField()
    detail_ctnt = models.CharField(max_length=500, blank=True, null=True)
    remark = models.CharField(max_length=500, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'bzcm02011_a2'
        constraints = [
            models.UniqueConstraint(fields=['report_no', 'report_sno'], name='pk_bzcm02011')
        ]


class PangComCode(BaseTableModel):
    code = models.CharField(primary_key=True, max_length=50)
    code_name = models.CharField(max_length=50, blank=True, null=True)
    up_code = models.CharField(max_length=50, blank=True, null=True)
    rmk = models.CharField(max_length=500, blank=True, null=True)
    use_yn = models.CharField(max_length=1)

    class Meta:
        managed = False
        db_table = 'pang_com_code'


class PangDeptInfo(BaseTableModel):
    dept_code = models.CharField(primary_key=True, max_length=50)
    dept_name = models.CharField(max_length=50, blank=True, null=True)
    use_yn = models.CharField(max_length=1)

    class Meta:
        managed = False
        db_table = 'pang_dept_info'


class PangEduPlanMgnt(BaseTableModel):
    edu_plan_no = models.CharField(primary_key=True, max_length=50)
    edu_schedule_no = models.CharField(max_length=50)
    edu_name = models.CharField(max_length=100, blank=True, null=True)
    emp_no = models.CharField(max_length=50)
    edu_from_dt = models.DateTimeField(blank=True, null=True)
    edu_to_dt = models.DateTimeField(blank=True, null=True)
    edu_time = models.IntegerField(blank=True, null=True)
    edu_type = models.CharField(max_length=50, blank=True, null=True)
    edu_large_class = models.CharField(max_length=50, blank=True, null=True)
    edu_middle_class = models.CharField(max_length=50, blank=True, null=True)
    edu_supervision = models.CharField(max_length=50, blank=True, null=True)
    edu_location = models.CharField(max_length=50, blank=True, null=True)
    edu_rate = models.IntegerField(blank=True, null=True)
    edu_cmplt_yn = models.CharField(max_length=1, blank=True, null=True)
    edu_absence_yn = models.CharField(max_length=1, blank=True, null=True)
    edu_absence_reason = models.CharField(max_length=200, blank=True, null=True)
    edu_attach_id = models.CharField(max_length=300, blank=True, null=True)
    rmk = models.CharField(max_length=500, blank=True, null=True)
    edu_cost = models.CharField(max_length=500, blank=True, null=True)
    dept_code = models.CharField(max_length=500, blank=True, null=True)
    std_year = models.CharField(max_length=500, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'pang_edu_plan_mgnt'


class PangEduSchdlMgnt(BaseTableModel):
    edu_schedule_no = models.CharField(primary_key=True, max_length=50)
    edu_year = models.CharField(max_length=20)
    edu_from_dt = models.DateTimeField(blank=True, null=True)
    edu_to_dt = models.DateTimeField(blank=True, null=True)
    close_yn = models.CharField(max_length=1, blank=True, null=True)
    rmk = models.CharField(max_length=500, blank=True, null=True)

    # class Meta:
    #     managed = False
    #     db_table = 'pang_edu_schdl_mgnt'
    class Meta:
        managed = False
        db_table = 'pang_edu_schdl_mgnt'
        constraints = [
            models.UniqueConstraint(fields=['edu_plan_no', 'edu_schedule_no'], name='xpk_pang_edu_plan_mgnt1')
        ]


class PangEmpInfo(BaseTableModel):
    emp_no = models.CharField(primary_key=True, max_length=20)
    user_id = models.CharField(max_length=50)
    emp_name = models.CharField(max_length=50)
    dept_code = models.CharField(max_length=50)
    email = models.CharField(max_length=50, blank=True, null=True)
    phon_number = models.CharField(max_length=50, blank=True, null=True)
    job = models.CharField(max_length=50, blank=True, null=True)
    responsi = models.CharField(max_length=50, blank=True, null=True)
    use_yn = models.CharField(max_length=1, blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'pang_emp_info'