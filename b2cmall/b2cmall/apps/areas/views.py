from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.generics import ListAPIView
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.renderers import JSONRenderer, JSONOpenAPIRenderer # 返回 json(預設) 或 restful 風格的json
from rest_framework_extensions.cache.mixins import ListCacheResponseMixin
from .serializers import AreasListSerializer
from .models import Region

# Create your views here.
class AreasListView(ListCacheResponseMixin, ListAPIView):
    """
    用於前端顯示三級行政區的資料選單（城市 → 區 → 郵遞區號）：

    前端操作流程：
    1. 用戶選擇城市後，根據城市的 id 查詢下層區域
    2. 用戶選擇區域後，再查詢其對應的郵遞區號

    API 設計思路:
    1. GET /areas/?level= city : 在前端選單查詢並顯示所有城市名
    2. GET /areas/?parent=pk&level=district : 透過 parent=城市的pk 查詢並顯示其下所屬的行政區
    3. GET /areas/?parent=pk&level=postal_code : 透過 parent=區域的pk 查詢並顯示其下的郵遞區號(只有一個)
    
    說明:
    filter_backends = [DjangoFilterBackend]  # 透過指定篩選器，允許使用 URL 查詢參數篩選模型欄位
    filterset_fields = []  # 可篩選欄位，可組合多個查詢（使用 & 串接）
    renderer_classes = [] # 指定響應的格式，一般不寫就是JSON,前端在HTML+VUE中不特別指定也可,但直接在瀏覽器訪問則要加
    """
    permission_classes = [IsAuthenticated]
    serializer_class = AreasListSerializer
    queryset = Region.objects.all()
    filter_backends = [DjangoFilterBackend] # 允許通過模型欄位篩選
    filterset_fields = ['parent', 'level']
    renderer_classes = [JSONRenderer]  # 直接在瀏覽器訪問記得加,不然會報錯(用JSONRenderer也可)


