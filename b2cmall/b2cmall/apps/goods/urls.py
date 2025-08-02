from django.urls import path, include
from .views import SKUListView, CategoryView, HotSKUListView, SKUSearchViewSet
from rest_framework.routers import DefaultRouter

router = DefaultRouter()
router.register(r'skus/search', SKUSearchViewSet, basename='sku-search')

urlpatterns = [
    # 當前商品分類中 SKU 商品清單
    path('categories/<int:category_id>/skus/', SKUListView.as_view(), name="category-sku-list"),
    
    # 商品分類資訊
    path('categories/<int:pk>/', CategoryView.as_view(), name="category-detail"),

    # 當前商品分類中 熱銷 SKU 清單
    path('categories/<int:category_id>/skus/hot/', HotSKUListView.as_view(), name="category-hotskus"),

    # 全站商品搜索(使用Elasticsearch)
    path('',include(router.urls))
] 

