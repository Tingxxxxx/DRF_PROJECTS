from rest_framework.pagination import PageNumberPagination

class StandardResultsSetPagination(PageNumberPagination):
    """前端可透過 GET /api/?page=2&page_size=5格式請求資料"""
    page_size = 5 # 如果前端沒有指定 page_size 參數，預設每頁顯示 5 筆資料
    page_size_query_param = 'page_size'  # 允許前端透過查詢參數 ?page_size=數字，來動態改變每頁資料數量。
    max_page_size = 20 # 限制最大每頁資料數為 20。