from django.urls import path, include
from .views import SKUListView


urlpatterns = [
    path('categories/<int:category_id>/skus/', SKUListView.as_view(), name="sku-list")
]
