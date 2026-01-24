from django.core.cache import cache
from rest_framework.response import Response
from collections import OrderedDict
from goods.models import GoodsChannel 

def get_categories():
    """
    獲取商品類別的三級分類選單
    """
    # 用來存放分類資料的三級目錄字典（有順序）
    categories = OrderedDict()
    
    # 查詢所有頂層類別對應的頻道資訊，依據 group_id 和 sequence 排序
    channels = GoodsChannel.objects.order_by('group_id', 'sequence')

    for channel in channels:
        group_id = channel.group_id

        # 如果是第一次遇到該 group_id，則初始化其分類結構
        if group_id not in categories:
            categories[group_id] = {
                'channels': [],   # 一級分類清單
                'sub_cats': []    # 二級分類清單(裝物件)（每個二級分類會包含其三級分類）
            }

        # 取得當前頻道對應的一級分類（頂層分類）實例
        cat1 = channel.category

        # 將一級分類資訊加入對應 group 的 channels 清單
        categories[group_id]['channels'].append({
            'id': cat1.id,
            'name': cat1.name,
            'url': channel.url
        })

        # 查詢該一級分類下的所有二級分類（透過自關聯取得子分類）
        cat2_qs = cat1.goodscategory_set.all()

        for cat2 in cat2_qs:
            # 為每個二級分類新增一個臨時屬性 sub_cats，用來存放其三級分類
            cat2.sub_cats = []

            # 查詢並加入三級分類（cat2 的子分類）
            for cat3 in cat2.goodscategory_set.all():
                cat2.sub_cats.append(cat3)

            # 將這個包含三級分類的二級分類實例加入到 sub_cats 清單中
            categories[group_id]['sub_cats'].append(cat2)

    return categories


class RedisCacheListMixin:

    def get_cache_key(self):
        path = self.request.get_full_path()
        return f"cache:{path}"  # 建立快取用的 key，例如：cache:/categories/115/skus/?page=1&page_size=5

    def list(self, request, *args, **kwargs):
        cache_key = self.get_cache_key()

        result = cache.get(cache_key)  # 嘗試從 Redis 取出快取資料
        if result:
            return Response(result)  # 如果有快取結果，直接回傳，不查資料庫

        # 如果 Redis 中沒有資料，呼叫父類別的 list 方法，從資料庫查資料

        # 父類別的 list 方法會進行以下步驟：
        # 1. self.get_queryset()：取得查詢集
        # 2. self.filter_queryset(...)：執行 filter_backends 的排序、搜尋等操作
        # 3. self.paginate_queryset(...)：執行分頁邏輯（如果有啟用 pagination）
        # 4. self.get_serializer(...)：將查詢集轉換為 JSON 可序列化的資料格式
        # 5. self.get_paginated_response(...)：回傳 RESTful 樣式的 Response 實例（包含 count、next、results 等欄位）
        response = super().list(request, *args, **kwargs)

        # 把序列化後的資料寫入 Redis 快取，設定有效時間為 60 秒
        cache.set(cache_key, response.data, timeout=60)

        return response  # 回傳查詢結果（已快取）
