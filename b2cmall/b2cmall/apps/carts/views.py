from django.shortcuts import render
from django_redis import get_redis_connection
from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from goods.models import SKU
from .serializers import Cartserializer, SKUCartserializer,CartDeleteSerializer
from .constants import CART_COOKIE_EXPIRES
import pickle
import base64
# Create your views here.

class CartView(APIView):
    """
    購物車商品 增刪改查
    URL統一為 /cart/
    """
    def perform_authentication(self, request):
        """
        覆寫 DRF 的預設認證機制，實現延遲認證：
        - 預設情況下 DRF 會在 dispatch 階段自動認證 request.user
        - 改為 pass 後，只有在實際存取 request.user 或 request.auth 時才會啟動認證流程
        """
        pass

    def post(self, request):
        """新增商品到購物車"""
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
        # -  若使用者未登入或 token 無效，會進入 except 區塊，不會拋出 401
        try:
            user = request.user  # 有可能是 AnonymousUser 或 user_id
        
        except Exception:
            user = None

        # 5️⃣ 登入使用者的邏輯：資料存到 Redis
        if user and user.is_authenticated:
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
        """查詢購物車資料"""

        # 1️⃣ 初始化購物車字典（統一格式 登入/未登入用戶格式）
        cart_dict = {}
        """
        目標格式:
            {
                sku_id1: { "count": 3, "selected": True },
                sku_id2: { "count": 1, "selected": False }
            }
        """

        # 2️⃣ 嘗試觸發認證流程（JWT 驗證）：request.user 可能是登入者或 AnonymousUser
        # -  若使用者未登入或 token 無效，會進入 except 區塊，不會拋出 401
        try:
            user = request.user
           
        except Exception:   
            user = None

        # 3️⃣ 登入用戶邏輯：資料來自 Redis
        if user and user.is_authenticated:
            # 建立 Redis 連線
            redis_conn = get_redis_connection('cart')

            # 拼接 Redis 的 key 名稱
            cart_key = f"{user.id}:cart"         # 儲存購物車商品數量的 Hash
            selected_key = f"{user.id}:selected" # 儲存選中商品 ID 的 Set

            # 從 Redis 取出購物車資料（皆為 bytes 型別）
            cart_data = redis_conn.hgetall(cart_key)       # 取得 Hash：{b'sku_id': b'count'}
            selected_data = redis_conn.smembers(selected_key)  # 取得 Set：{b'sku_id1', b'sku_id2'}

            # 備註：若 Redis 內部原本為空，也會正常返回空 dict / set，無需額外判斷

            #  將 Redis 中 取出的資料，拼接成cart_dict目標格式
            for sku_id_bytes, count_bytes in cart_data.items(): # items()-> 鍵值對形式 (tuple) -> 並直接兩個變量解包
                # redis取出時為bytes，故要先轉成int
                sku_id = int(sku_id_bytes) 
                count = int(count_bytes)
                cart_dict[sku_id] = {
                    'count': count,
                    'selected': sku_id_bytes in selected_data # 記得兩邊都要用bytes類型比
                }

        # 4️⃣ 未登入用戶邏輯：資料來自 Cookie
        else:
            # 嘗試從 Cookie 中取得購物車資料（str 或 None）
            cart_str = request.COOKIES.get('cart') # 記得用get(),不要用['key']避免 KeyError

            if cart_str:
                # 將 base64 字串轉回原始 dict 結構
                cart_str_bytes = cart_str.encode()               # str → bytes(base64)
                cart_bytes = base64.b64decode(cart_str_bytes)    # base64 → pickle bytes
                cart_dict = pickle.loads(cart_bytes)             # bytes → dict

            else:
                # 若無購物車資料，直接回應提示訊息
                return Response({'message': '購物車當前沒有添加任何商品'}, status=400)

        # 5️⃣ 從資料庫查詢購物車中所有商品的 SKU 模型
        sku_ids = cart_dict.keys()  # 返回cart_dict的所有key,即sku_id 整數列表
        sku_queryset = SKU.objects.filter(id__in=sku_ids)  # 一次查出所有商品模型，filter()返回的是查詢集

        # 6️⃣ 為每個 SKU 模型物件動態添加 count 和 selected 屬性
        for sku in sku_queryset:
            sku.count = cart_dict[sku.id]['count']
            sku.selected = cart_dict[sku.id]['selected']

        # 7️⃣ 建立序列化器並序列化資料
        serializer = SKUCartserializer(sku_queryset, many=True)

        # 8️⃣ 回傳購物車資料
        return Response(serializer.data)

    def put(self, request):
        """修改購物車中資料"""

        # 1️⃣ 建立序列化器並進行資料驗證（反序列化）
        serializer = Cartserializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        # 2️⃣ 從驗證後的資料中取得欄位值
        sku_id = serializer.validated_data.get('sku_id')
        count = serializer.validated_data.get('count')
        selected = serializer.validated_data.get('selected')

        # 3️⃣ 預先建立回應對象
        response  = Response(serializer.data)

        # 4️⃣ 嘗試取得用戶資訊（觸發 DRF 延遲認證）
        try:
            user = request.user
        except Exception:
            user = None

        # 5️⃣ 判斷是否登入
        if user and user.is_authenticated:
            # ➤ 登入狀態：操作 Redis

            # 設定 Redis 中的 key 名稱
            cart_key = f'{user.id}:cart'         # Hash：商品數量
            selected_key = f'{user.id}:selected' # Set：勾選狀態

            # 建立 Redis pipeline
            redis_conn = get_redis_connection('cart')
            pipe = redis_conn.pipeline()

            # 修改購物車中商品數量（直接覆蓋）
            pipe.hset(cart_key, sku_id, count)
            
            # 根據勾選狀態新增／移除商品
            if selected:
                pipe.sadd(selected_key, sku_id)
            else:
                pipe.srem(selected_key, sku_id)
            
            # 一次執行所有 Redis 操作
            pipe.execute() 

            return response

        else:
            # ➤ 未登入狀態：操作 Cookie

             # 嘗試從 cookie 中獲取購物車資料
            cart_str = request.COOKIES.get('cart')
            
            if cart_str is not None:
                # 將 base64 字串轉回原始 dict 結構
                cart_str_bytes = cart_str.encode()               # str → bytes(base64)
                cart_bytes = base64.b64decode(cart_str_bytes)    # base64 → pickle bytes
                cart_dict = pickle.loads(cart_bytes)             # bytes → dict

            else:

                cart_dict = {}

            
            # 更新對應商品的數量與勾選狀態
            cart_dict[sku_id] = {
                'count': count,
                'selected': selected
            }

            # 序列化成可寫入 Cookie 的格式
            cart_bytes = pickle.dumps(cart_dict)                 # dict → bytes
            cart_str_bytes = base64.b64encode(cart_bytes)        # bytes → base64 bytes
            cart_str = cart_str_bytes.decode()                   # base64 bytes → str

            # 設定 cookie，將更新後的 cart 存回
            response.set_cookie('cart', cart_str, expires=CART_COOKIE_EXPIRES)

            return response

    def delete(self, request):
        """刪除購物車中的指定商品"""

        # 1️⃣ 驗證請求資料（反序列化）
        serializer = CartDeleteSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        sku_id = serializer.validated_data.get('sku_id')

        # 2️⃣ 建立預設回應物件（204 No Content）
        response = Response(status=status.HTTP_204_NO_CONTENT)

        # 3️⃣ 延遲認證
        try:
            user = request.user
        except Exception:
            user = None

        # 4️⃣ 登入使用者：使用 Redis 操作購物車
        if user and user.is_authenticated:
            # 組合 Redis 的購物車與勾選商品 key
            cart_key = f'{user.id}:cart'
            selected_key = f'{user.id}:selected'

            redis_conn = get_redis_connection('cart')
            pipe = redis_conn.pipeline()

            # 從 Redis 中刪除購物車指定商品及其勾選狀態
            pipe.hdel(cart_key, sku_id)
            pipe.srem(selected_key, sku_id)
            pipe.execute()

        # 5️⃣ 未登入使用者：操作 Cookie 中的購物車資料
        else:            
            # 嘗試從 Cookie 中取得購物車資料
            cart_str = request.COOKIES.get('cart')
            
            if cart_str is not None:
                # 購物車有值則將資料由str->python字典方便後續刪除
                cart_bytes = base64.b64decode(cart_str.encode())
                cart_dict = pickle.loads(cart_bytes)

            else: 
                # 未獲取購物車資料，直接響應
                return Response({'message': '未獲取到 cookie 資料'}, status=status.HTTP_400_BAD_REQUEST)

            # 若指定商品存在於購物車中，則刪除
            if sku_id in cart_dict:
                # 刪除該商品sku_id 的 key
                del cart_dict[sku_id]
            else:
                return Response({'message': '指定商品不在購物車中'}, status=status.HTTP_400_BAD_REQUEST)

            # 判斷是否還有商品：若有 → 更新 Cookie；若無 → 刪除 Cookie
            if cart_dict:
                # 重新設置，更新後的cookie
                new_cart_str = base64.b64encode(pickle.dumps(cart_dict)).decode()
                response.set_cookie('cart', new_cart_str)
            else:
                # 刪除整個cookie
                response.delete_cookie('cart')

        # 6️⃣ 回傳刪除成功的回應
        return response
