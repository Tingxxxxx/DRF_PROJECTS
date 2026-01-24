from django.urls import path
from .views import CartView,CartSelectAllView

app_name = 'cart'

urlpatterns = [
    path('', CartView.as_view(), name='cart' ), # 購物車增刪改查
    path('selection/', CartSelectAllView.as_view(), name='cart_selection_all' ), # 購物車增刪改查
]
