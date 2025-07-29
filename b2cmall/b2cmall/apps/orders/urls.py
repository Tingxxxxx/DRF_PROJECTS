from django.urls import path, include
from .views import OrderSettlementView, CommitOrderView, OrderInfoListView


urlpatterns = [
    # SKU商品列表清單
    path('settlement/', OrderSettlementView.as_view(), name='order_settlement'), # 訂單結算 /orders/settlement/
    path('', CommitOrderView.as_view(), name='order_commit'), # 訂單提交 /orders/
    path('status/me/', OrderInfoListView.as_view(), name='orderlist_status'), # 訂單狀態 /orders/status/me    
]
