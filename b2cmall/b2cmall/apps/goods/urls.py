from django.urls import path, include
from .views import SKUListView, CategoryView


urlpatterns = [
    # SKU商品列表清單
    path('categories/<int:category_id>/skus/', SKUListView.as_view(), name="sku-list"),
    # 麵包屑商品分類
    path('categories/<int:pk>/', CategoryView.as_view(), name="sku-list"),
]
