from rest_framework.filters import OrderingFilter
from rest_framework.generics import ListAPIView, GenericAPIView
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from .serializers import SKUSerializer, CategorySerializer, ChannelSerializer
from .models import SKU, GoodsCategory
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
