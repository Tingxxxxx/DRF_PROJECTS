from django.shortcuts import render
from rest_framework.filters import OrderingFilter
from rest_framework.generics import ListAPIView
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework import status
from django.core.cache import cache
from .serializers import SKUSerializer
from .models import SKU
from .utils import RedisCacheListMixin 
import json
# Create your views here.


class SKUListView(RedisCacheListMixin, ListAPIView):
    """用戶點選類別的商品清單視圖"""
    serializer_class = SKUSerializer
    permission_classes = [AllowAny]
    filter_backends = [OrderingFilter]
    ordering_fields = ['-create_time', 'price', 'sales']

    def get_queryset(self):
        """過濾查詢集，只返回上架中且用戶當前瀏覽類別的商品"""
        # 通過 self.kwargs 可取得路徑參數
        category_id = self.kwargs['category_id']
        return  SKU.objects.filter(is_launched=True, category_id = category_id).order_by('id')
    
    