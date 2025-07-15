from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from django_redis import get_redis_connection
from rest_framework.response import Response
from rest_framework import status
from decimal import Decimal

from goods.models import SKU
from .serializers import OrderSettlementSerializer

# Create your views here.
class OrderSettlementView(APIView):
    """訂單結算頁視圖"""
    permission_classes = [IsAuthenticated]

    def get(self, request):
        """
        獲取勾選的商品資料：
        - 包含 SKU ID、價格、數量
        - 並返回運費與商品序列化結果
        """
        
        # 獲取當前用戶(只有登入用戶能結算)
        user = request.user

        # 組合 redis key
        cart_key = f'{user.id}:cart'            # 購物車 (hash)：{sku_id: count}
        selected_key = f'{user.id}:selected'    # 勾選商品 (set)：{sku_id}

        # redis連接
        redis_conn = get_redis_connection('cart')

        # 取得 Redis 資料（皆為 bytes 類型）
        redis_cart = redis_conn.hgetall(cart_key)
        sku_ids = redis_conn.smembers(selected_key)

        # 綜合 Redis資料 整理成python字典：{sku_id: count}，並轉換為 int
        cart_dict = {  
            int(sku_id):int(redis_cart[sku_id]) 
            for sku_id in sku_ids
        }  # {1: 2, 2: 10, 3:7....) 都是int類型

        # 查出勾選商品的查詢集
        skus = SKU.objects.filter(id__in=cart_dict.keys())

        # 為每個 SKU 添加臨時屬性 count（購買數量）
        for sku in skus:
            sku.count = cart_dict[sku.id]

        # 固定運費設定
        freight = Decimal('60.00')

        # 使用自訂的序列化器，把運費和商品資料轉成 JSON 格式
        # 因為是 serializers.Serializer，可以直接傳入字典資料作為instance來序列化（反序列化則用 data={}）
        # 字典裡的 key 要對應序列化器裡定義的欄位
        # 像 skus 這個欄位是商品清單，會自動套用裡面定義好的 CartSKUSerializer 去處理每一筆商品
        serializer  = OrderSettlementSerializer({
            "freight":freight,
            "skus":skus
        })

        return Response(serializer.data, status=status.HTTP_200_OK)