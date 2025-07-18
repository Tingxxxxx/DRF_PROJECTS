from django.urls import path, include
from .views import OrderSettlementView, CommitOrderView


urlpatterns = [
    # SKU商品列表清單
    path('settlement/', OrderSettlementView.as_view(), name='order_settlement'),
    path('', CommitOrderView.as_view(), name='order_commit'),
    
]
