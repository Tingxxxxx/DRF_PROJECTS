from elasticsearch import Elasticsearch
from rest_framework.filters import OrderingFilter
from rest_framework.generics import ListAPIView, GenericAPIView
from rest_framework.permissions import AllowAny
from rest_framework.views import APIView
from rest_framework.response import Response
from django_elasticsearch_dsl_drf.viewsets import DocumentViewSet
from elasticsearch_dsl.query import MultiMatch
from elasticsearch import Elasticsearch, ConnectionError
from django_elasticsearch_dsl_drf.filter_backends import (
    OrderingFilterBackend,
    FilteringFilterBackend,
    CompoundSearchFilterBackend )

from .serializers import SKUSerializer, CategorySerializer, ChannelSerializer, HotSKUSerializer, GoodsDocumentSerializer
from .models import SKU, GoodsCategory
from .utils import RedisCacheListMixin 
from .documents import GoodsDocument
from b2cmall.utils.paginations import StandardResultsSetPagination


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
    
    
class CategoryView(GenericAPIView):
    """
    商品列表頁麵包屑導航 API
    根據當前分類 ID，回傳其分類層級資訊（cat1、cat2、cat3）
    """

    # 指定查詢集
    queryset = GoodsCategory.objects.all()
    permission_classes = [AllowAny]
    
    def get(self, request, pk=None):
        """
        根據傳入的分類 PK，回傳對應的分類層級資訊（最多至第 3 級）

        分類層級回傳範例：
        
        - 若為第 1 級分類：
            {
                "cat1": {id, category_name, url},
                "cat2": "",
                "cat3": ""
            }
        
        - 若為第 2 級分類：
            {
                "cat1": {id, category_name, url},
                "cat2": {id, name},
                "cat3": ""
            }

        - 若為第 3 級分類：
            {
                "cat1": {id, category_name, url},
                "cat2": {id, name},
                "cat3": {id, name}
            }
        """
        # 初始化返回結果
        ret = {
            'cat1': '',
            'cat2': '',
            'cat3': ''
        }

        # 根據 pk 取得當前分類實例（GoodsCategory 類）
        category = self.get_object()

        # 第 1 級分類：無上層分類（parent 為 None）
        if category.parent is None:
            # 根據外鍵取得對應的 Channel（GoodsChannel）
            channel = category.goodschannel_set.first()
            if channel:
                # 使用 ChannelSerializer 序列化第 1 級分類資訊
                ret['cat1'] = ChannelSerializer(channel).data

        # 第 3 級分類：無下層子分類
        elif category.goodscategory_set.count() == 0:
            # 往上找到第 1 級分類（parent 的 parent）
            cat1 = category.parent.parent
            if cat1:
                channel = cat1.goodschannel_set.first()
                if channel:
                    ret['cat1'] = ChannelSerializer(channel).data

            # 序列化第 2 級與第 3 級分類資訊
            ret['cat2'] = CategorySerializer(category.parent).data
            ret['cat3'] = CategorySerializer(category).data

        # 第 2 級分類：有父分類，也有子分類
        else:
            cat1 = category.parent
            channel = cat1.goodschannel_set.first()
            if channel:
                ret['cat1'] = ChannelSerializer(channel).data

            # 序列化第 2 級分類資訊
            ret['cat2'] = CategorySerializer(category).data

        return Response(ret)


class HotSKUListView(RedisCacheListMixin, ListAPIView):
    """當前商品分類中熱銷商品清單視圖"""
    permission_classes = [AllowAny]
    serializer_class = HotSKUSerializer

    def get_queryset(self):
        category_id = self.kwargs['category_id']
        return SKU.objects.filter(category_id=category_id).order_by('-sales')[:2] # 取得指定分類下，銷量最高的前2筆商品資料，避免一次查出全部


class SKUSearchViewSet(DocumentViewSet):
    """
        商品搜尋 ViewSet，基於 Elasticsearch 實現的全文檢索與篩選功能。

        可以在瀏覽器或 API 工具透過以下方式訪問：
        GET /skus/search/?search=關鍵字            # 透過 search 參數模糊搜尋 name 和 caption
        GET /skus/search/?name=精確名稱            # 透過 name 精確篩選
        GET /skus/search/?ordering=-sales          # 依銷量降序排序
        GET /skus/search/?search=關鍵字&ordering=price&name=精確名稱 # 多條件組合查詢

        其他可用參數：
        - filter_fields 中定義的欄位可直接當 query string 篩選
        - search_fields 支援全文模糊搜尋
        - ordering_fields 支援排序，使用 ordering=欄位名 或 ordering=-欄位名(降序)
        - 支援分頁，使用 page 和 page_size 參數控制

        範例：
        http://localhost:8000/skus/search/?search=MacBook&page=1&page_size=5&ordering=-price
    """
    document = GoodsDocument # 指定索引文件
    serializer_class = GoodsDocumentSerializer
    pagination_class = StandardResultsSetPagination
    filter_backends = [
        FilteringFilterBackend,
        OrderingFilterBackend,
        CompoundSearchFilterBackend ,
    ]

    # 可以用來精確匹配篩選(注意:dict)
    filter_fields = {
        'name': 'name.keyword', # 對應到doument中定義的keyword子欄位
    }

    # 模糊搜尋支援欄位(注意:tuple）
    search_fields = (
        'name',  # 對應到doument中定義的TextField
        'caption',
    )

    # 可用的排序欄位(注意:dict)
    ordering_fields = {
        'category': 'category',
        'price': 'price',
        'sales': 'sales',
        'create_time': 'create_time',
    }

    def get_queryset(self):
        # 取得 elasticsearch-dsl 的 Search 物件
        search = super().get_queryset()
        
        # 加入條件：只搜尋 is_launched=True 的商品 
        # 'term':精確匹配  'match':模糊搜尋
        search = search.filter('term', is_launched=True)  # 搜尋物件.filter()執行過濾  
        
        # 取得使用者輸入的搜尋關鍵字
        query = self.request.query_params.get('search') # ?search=....
        
        # 如果有輸入關鍵字，執行 MultiMatch 搜尋，提高 name 欄位權重
        if query:
            search = search.query(  # 搜尋物件.query()執行搜索
                MultiMatch(
                    query=query,
                    fields=['name^10', 'caption'], # 提高name欄位權重
                    type='most_fields', # 綜合多欄位評分
                    )
                )
        # 回傳修改過的 Search 物件
        return search

# 建立 Elasticsearch 連線
es = Elasticsearch()

class GoodsNameSuggestView(APIView):
    """
    商品名稱自動補全 API
    GET /skus/suggestions/?q=關鍵字

    回傳格式：
    {
        "suggest": ["建議詞1", "建議詞2"]
    }
    """

    def get(self, request):
        # 從查詢參數中取得關鍵字，並去除前後空白
        keyword = request.query_params.get('q', '').strip()

        # 若關鍵字為空，直接回傳空列表
        if not keyword:
            return Response({"suggest": []})

        # Elasticsearch 補全查詢 body
        body = {
            "suggest": {  # ES 固定參數名
                "name_suggest": {  # 自訂的補全查詢名稱（之後取結果要用這個 key）
                    "prefix": keyword,  # 使用者輸入的前綴詞
                    "completion": {     # completion suggester 設定
                        "field": "name_suggest",  # 對應 ES 索引中設為 CompletionField 的欄位
                        "size": 5,                # 限制回傳的建議數量
                        "fuzzy": {                # 開啟模糊匹配（處理拼寫錯誤）
                            "fuzziness": 2,       # 最大可容忍的編輯距離
                            "min_length": 5,      # 只對長度>=5的詞套用 fuzzy
                            "prefix_length": 1    # 前綴必須正確匹配的字數
                        }
                    }
                }
            }
        }

        try:
            # 向 Elasticsearch 發送查詢請求
            result = es.search(index='goods', body=body) # 查詢名為goods的索引

            # 從回傳結果中取得 name_suggest 的建議列表
            # ES 回傳格式：
            # "suggest": {
            #   "name_suggest": [
            #     {
            #       "options": [
            #         {"text": "建議詞1", ...},
            #         {"text": "建議詞2", ...}
            #       ]
            #     }
            #   ]
            # }
            name_suggest_list = result.get("suggest", {}).get("name_suggest", [])

            if not name_suggest_list:
                return Response({"suggest": []})

            # 取出所有建議詞的文字部分
            options = name_suggest_list[0].get("options", [])
            suggestions = [opt.get("text", "") for opt in options]

        except ConnectionError:
            # ES 連線失敗時回傳 500 錯誤
            return Response({"error": "Elasticsearch connection failed"}, status=500)

        # 回傳建議結果
        return Response({"suggest": suggestions})
    
