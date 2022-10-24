import logging

from vntg_wdk_core.business import BusinessNode
from rest_framework import viewsets, status
from rest_framework.response import Response
from vntg_wdk_core.helper.file_helper import SqlFileHelper
from vntg_wdk_core.views.baseview import BaseSqlApiView

from apps.bzcm.models import PangEduPlanMgnt
from selenium.webdriver.chrome.options import Options

from selenium import webdriver

LOGGER = logging.getLogger(__name__)

# 크롤링 / 교육순위 (인프런)
class EDU040E01(BaseSqlApiView):

    # region 노드 정의
    # endregion
    def define_nodes(self):
        '''비즈니스 로직 실행(조회/저장)에 필요한 노드 정의 '''

        self._sql_helper = SqlFileHelper(__package__)

        # 연도별 교육 현황
        node_crawling = BusinessNode()
        node_crawling.node_name = 'crawlingList'
        node_crawling.sql_filename = '100_BYEMPEDURANK_list'
        node_crawling.model = PangEduPlanMgnt
        node_crawling.table_name = 'pang_edu_plan_mgnt'
        node_crawling.key_columns = ['edu_plan_no']
        node_crawling.update_columns = ['edu_plan_no', 'edu_schedule_no', 'edu_name', 'emp_no',
                                    'edu_time', 'edu_type', 'edu_supervision', 'edu_location',
                                    'edu_rate', 'edu_cmplt_yn', 'edu_absence_reason', 'rmk',
                                    'edu_large_class', 'edu_middle_class', 'edu_from_dt', 'edu_to_dt',
                                    'edu_attach_id', 'edu_absence_yn']
        self._append_node(node_crawling)

    def get_list(self, request):
        #options = Options()
        options = webdriver.ChromeOptions()
        options.add_argument("headless")
        #driver = webdriver.Chrome(executable_path=r'C:\github\chromedriver_win32\chromedriver.exe', options=options)
        # options 추가하고 timeout 나중에 옵션도 같이 넣어주기

        driver = webdriver.Chrome(executable_path=r'C:\github\chromedriver_win32\chromedriver.exe')

        # 인프런
        eduList = list()


        url = 'https://www.inflearn.com/courses/it-programming/web-dev?order=popular'
        driver.get(url)

        i = 0

        while (len(eduList) < 10):
            eduNameList_xpath_id = str('//*[@id="courses_section"]/div/div/div/main/div[3]/div/div[') + str(i) + str(']/div/a/div[2]/div[1]')
            eduCostList_xpath_id = str('//*[@id="courses_section"]/div/div/div/main/div[3]/div/div[') + str(i) + str(']/div/a/div[2]/div[4]')
            eduAuthorList_xpath_id = str('//*[@id="courses_section"]/div/div/div/main/div[3]/div/div[') + str(i) + str(']/div/a/div[2]/div[2]')
            eduReviewList_xpath_id = str('//*[@id="courses_section"]/div/div/div/main/div[3]/div/div[') + str(i) + str(']/div/a/div[2]/div[3]/span')
            eduLinkList_xpath_id = str('//*[@id="courses_section"]/div/div/div/main/div[3]/div/div[') + str(i) + str(']/div/a')

            i += 1
            try:
                # 인기순 top10 교육명
                eduNameFound = driver.find_element("xpath", eduNameList_xpath_id)
                eduDic = {}
                eduDic["seq"] = i-1
                eduDic["eduName"] = eduNameFound.text

                # 인기순 top10 교육비용
                eduCostFound = driver.find_element("xpath", eduCostList_xpath_id)
                eduDic["eduCost"] = eduCostFound.text

                #인기순 top10 저자
                eduAuthorFound = driver.find_element("xpath", eduAuthorList_xpath_id)
                eduDic["eduAuthor"] = eduAuthorFound.text

                # 인기순 top10 리뷰수
                # eduReviewFound = driver.find_element("xpath", eduReviewList_xpath_id)
                #
                # print()
                # print()
                # print()
                # print('eduReviewFound.text=============>', eduReviewFound.text)
                # print()
                # print()
                # print()
                #
                # if(eduReviewFound.text == ""):
                #     eduDic["eduReview"] = 0
                # else:
                #     eduDic["eduReview"] = eduReviewFound.text

                # 인기순 top10 링크
                eduLinkFound = driver.find_element("xpath", eduLinkList_xpath_id)
                eduDic["eduLink"] = eduLinkFound.get_attribute('href')

                eduList.append(eduDic)
            except:
                print("There is no xpath_id like that %s" % eduNameList_xpath_id)
                # 인프런 END

        driver.quit()

        return_data = {'success': True, 'code': 0, 'message': 'OK', 'data': None}
        return_data['data'] = eduList
        return Response(return_data, status.HTTP_200_OK)

