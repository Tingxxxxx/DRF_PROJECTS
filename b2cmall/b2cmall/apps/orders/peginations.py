from rest_framework.pagination import PageNumberPagination

class OrderStatusPagination(PageNumberPagination):
    page_size = 2  # 預設每頁顯示 2 筆
    page_size_query_param = 'page_size'  # 允許前端透過 ?page_size=? 動態調整
    max_page_size = 5  # 最多不能超過 5 筆