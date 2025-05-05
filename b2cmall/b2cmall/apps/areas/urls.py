from django.urls import path
from .views import AreasListViwe


urlpatterns = [
    path('', AreasListViwe.as_view(), name='address-list' ), # 個人中心 收貨地址GET查詢接口
]
