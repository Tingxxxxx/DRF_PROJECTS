from django.shortcuts import render
from django_redis import get_redis_connection
from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from goods.models import SKU
from .serializers import Cartserializer
from .constants import CART_COOKIE_EXPIRES
import pickle
import base64
# Create your views here.

class CartView(APIView):
    def perform_authentication(self, request):
        """
        覆寫 DRF 的預設認證機制，實現延遲認證：
        - 預設情況下 DRF 會在 dispatch 階段自動認證 request.user
        - 改為 pass 後，只有在實際存取 request.user 或 request.auth 時才會啟動認證流程
        """
        pass

    def post(self, request):
        # 1️⃣ 建立序列化器，並執行反序列化與資料驗證
        serializer = Cartserializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        # 2️⃣ 從 validated_data 取得資料
        sku_id = serializer.validated_data.get('sku_id')
        count = serializer.validated_data.get('count')
        selected = serializer.validated_data.get('selected')

        # 3️⃣ 建立回應物件（預設回傳序列化後資料）
        response = Response(serializer.data, status=status.HTTP_201_CREATED)

        # 4️⃣ 嘗試觸發認證流程，讀取 request.user（此時才真正執行 JWT 驗證）
        user = request.user

        # # 5️⃣ 登入使用者的邏輯：資料存到 Redis
        if user.is_authenticated:
            # Redis 中購物車資料結構設計：
            # Hash: {user_id:cart} => {sku_id: count}
            # Set:  {user_id:selected} => {sku_id1, sku_id2, ...}

            redis_conn = get_redis_connection("cart")
            pipe = redis_conn.pipeline()

            cart_key = f"{user.id}:cart"
            selected_key = f"{user.id}:selected"

            # 將商品數量做「增量加總」
            # HINCRBY：key 存在 → 增加數量；key 不存在 → 建立 key 與欄位
            pipe.hincrby(cart_key, sku_id, count)

            # 判斷是否勾選商品，加入 selected set
            if selected:
                pipe.sadd(selected_key, sku_id)

            # 執行 Redis 操作
            pipe.execute()

        # 6️⃣ 未登入使用者邏輯：資料存到 Cookie
        else:
            """
            Cookie 中 cart 資料格式說明：
            key = 'cart'
            value = base64(pickle(dict))
            dict 結構：
            {
                sku_id1: { "count": 3, "selected": True },
                sku_id2: { "count": 1, "selected": False }
            }
            """

            # 獲取購物車資料: 嘗試取得 Cookie 中 cart 的字串值（str）
            cart_str = request.COOKIES.get('cart')  # 類型：str 或 None

            if cart_str:
                # 將 str 轉成 base64 的 bytes 型別
                cart_str_bytes = cart_str.encode()  # str → bytes（base64格式）

                # 解碼 base64 → 原始 pickle bytes
                cart_bytes = base64.b64decode(cart_str_bytes)

                # 還原為 Python 字典
                cart_dict = pickle.loads(cart_bytes)  # bytes → dict
            else:
                # 若沒有任何購物車資料，初始化空字典
                cart_dict = {}

            # 若該 sku_id 已存在，進行數量累加
            if sku_id in cart_dict:
                origin_count = cart_dict[sku_id]['count']
                count += origin_count

            # 更新或新增購物車商品資料
            cart_dict[sku_id] = {
                'count': count,
                'selected': selected
            }

            # 序列化成可寫入 Cookie 的格式
            cart_bytes = pickle.dumps(cart_dict)                 # dict → bytes
            cart_str_bytes = base64.b64encode(cart_bytes)        # bytes → base64 bytes
            cart_str = cart_str_bytes.decode()                   # base64 bytes → str

            # 購物車 寫入 Cookie，有效期為 3 月（秒數）
            response.set_cookie('cart', cart_str, expires=CART_COOKIE_EXPIRES)

        # 7️⃣ 最終回傳 Response（登入與未登入邏輯共用）
        return response
    
    def get(self, request):
        print('111')
        return Response('sss')


    def put(self, request):
        pass

    def delete(self, request):
        pass