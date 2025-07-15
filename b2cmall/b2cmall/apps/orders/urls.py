from django.urls import path, include
from .views import OrderSettlementView


urlpatterns = [
    # SKU商品列表清單
    path('settlement/', OrderSettlementView.as_view(), name='order_settlement'),
    
]
