from django_ratelimit.decorators import ratelimit
from rest_framework.views import APIView
from rest_framework.viewsets import GenericViewSet
from rest_framework.mixins import UpdateModelMixin, RetrieveModelMixin
from rest_framework.generics import CreateAPIView
from rest_framework.response import Response
from rest_framework.throttling import UserRateThrottle
from .serializers import CreateUserSerializer
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework_simplejwt.views import TokenObtainPairView
from .serializers import MyTokenObtainPairSerializer, UserDetailSerializer
from celery_tasks.verifycode.tasks import send_verification_email
from .models import User # 導入自訂義的用戶模型
from .throttles import EmailRateThrottle
import logging

logger = logging.getLogger('django')

# 註冊 API 的視圖，繼承自通用類視圖(快速實現POST請求)
class UserView(CreateAPIView):
    """用戶註冊"""
    permission_classes = [AllowAny]
    serializer_class = CreateUserSerializer  # 指定序列化器


class UsernameCountView(APIView):
    """判斷用戶名是否重複註冊"""
    permission_classes = [AllowAny]

    def get(self, request, username):
        # 查詢users表，並使用.count() 計算這個 QuerySet 中有幾筆資料（回傳一個整數）。
        # count=0 則不重複，count=1代表有重複 
        count = User.objects.filter(username=username).count()

        # 生成響應資料
        data = {
            'username':username,
            'count':count
        }

        return Response(data)
    

class MobileCountView(APIView):
    """判斷手機是否重複註冊"""
    permission_classes = [AllowAny]
    def get(self, request, mobile):
        # count=0 則不重複，count=1代表有重複 
        count = User.objects.filter(mobile=mobile).count()

        # 生成響應資料
        data = {
            'mobile':mobile,
            'count':count
        }
        
        return Response(data)


class MyTokenObtainPairView(TokenObtainPairView):
    """重寫simple_jwt登入視圖, 擴展響應內容"""
    serializer_class = MyTokenObtainPairSerializer # 使用自訂義的序列化器(加入了user相關響應)

# 只需 GET 查詢當前用戶 / PATCH 更新當前用戶的EMAIL  故不用ModelViewSet
class UserInfoViewSet(UpdateModelMixin, RetrieveModelMixin, GenericViewSet): # GenericViewSet 提供基礎ViewSet功能，且繼承一定要在最後
    """
    用戶個人中心的視圖集
    GET: 個人中心的當前用戶資料顯示
    PATCH: 個人中心修改信箱，並發送認證連結
    """
    permission_classes = [IsAuthenticated]
    serializer_class = UserDetailSerializer

    def get_object(self):
        """
        重寫該方法以取得目前登入的用戶實例
        避免從 URL 取得 PK 查找，直接回傳 request.user 對象
        """
        return self.request.user
    def get_throttles(self):
        """動態獲取限流策略"""
        if self.request.method == 'PATCH':
             return [EmailRateThrottle()]
        return []
    
    def partial_update(self, request, *args, **kwargs):
        """重寫PATCH請求的方法，新增寄信邏輯邏輯"""

        logger.info(f'使用者{request.user}嘗試更新資料')

        # 保留原本的更新邏輯
        response = super().partial_update(request, *args, **kwargs)
        
        # 新增發送驗證郵件功能
        email = request.data.get('email')
        if email:
            logger.info(f"使用者 {request.user} 修改信箱為 {email}, 發送驗證郵件")  # 記錄修改的信箱與發信紀錄
            send_verification_email.delay(email,'激活連結')
        
        # 可以加入一些額外的 response 資料
        response.data['message'] = '信箱修改成功，請檢查您的電子郵件以完成驗證。'  # 自定義的訊息
        logger.info(f"更新後的 response: {response.data}")  # 記錄 response 內容

        return response

"""
為防止用戶短時間內一直發信，UserInfoViewSet此視圖集的PATCH需要限流,可通過:
1. 在settings設置全局限流策略，搭配 throttle_classes:

def get_throttles(self):
    if self.request.method == 'PATCH':
        return [UserRateThrottle()]  # 只在 PATCH 請求時進行限流
    return []  # GET 請求不進行限流

    
2. 使用 django_ratelimit模組的 @ratelimit() 但只能用在函數視圖上 類視圖不能用!
@ratelimit(key='user', rate='5/m', method='PATCH', block=True) # 當前用戶 5次/分 超標自動返回429T oo Many Requests（請求過多）

# 檢查請求是否超出限流限制
    if getattr(request, 'limited', False):
        return Response(
            {"detail": "請求過於頻繁，請稍後再試"},
            status=status.HTTP_429_TOO_MANY_REQUESTS,
        )

key='user 或 'ip'  針對當前用戶/當前ip 限流
rate='5/m.s.h.d 速率
method = 哪些方法限流
block=True 直接返回 429 錯誤，用戶拿不到內容(就不用if....)

"""



# GET請求 查單一
# class UserDetailView(RetrieveAPIView):  # 通用類視圖 RetrieveAPIView(GET查單一) 、 ListAPIView(GET查全部)
#     """用戶中心詳情"""
#     permission_classes = [IsAuthenticated]  # 只有登入用戶才能訪問
#     serializer_class = UserDetailSerializer
#     # queryset = User.objects.all() # 設定查詢集，直接指定 User.objects.all() 需要路由需要用 users/1，通過pk才能查
    
#     # 不直接指定 queryset，因為這樣會查詢所有用戶，消耗性能
#     # 而我們只需要返回當前登錄用戶的資料

#     def get_object(self):
#         return self.request.user  # 直接返回當前登錄用戶（通過 request.user）

    
"""
RetrieveAPIView 工作流程與基本運作:

1. 當發送 GET 請求時，Django 會調用 get() 方法。

def get(self, request, *args, **kwargs):
    return self.retrieve(request, *args, **kwargs)

2. 而get方法又會去調用 retrieve()方法如下:   
         
3. retrieve() 方法會獲取對象（通常是根據 pk 查詢對象），並返回該對象的序列化數據。

def retrieve(self, request, *args, **kwargs):
    instance = self.get_object()  # 獲取模型實例
    serializer = self.get_serializer(instance)  # 序列化該實例
    return Response(serializer.data)  # 返回序列化後的數據

4. retrieve() 會調用 get_object() 方法來獲取模型的實例。這個實例是根據 URL 中的 pk 參數從 queryset 查詢得到的。

def get_object(self):

    queryset = self.get_queryset()  # 這裡獲取查詢集
    lookup_url_kwarg = self.lookup_url_kwarg  # 獲取 URL 中的關鍵字，默認是 'pk'
    assert lookup_url_kwarg in self.kwargs  # 確保 URL 參數中有 'pk' 或設定的查詢關鍵字
        
    # 通過 URL 中的參數來查找對應的對象
    filter_kwargs = {self.lookup_field: self.kwargs[lookup_url_kwarg]}
    return generics.get_object_or_404(queryset, **filter_kwargs)  # 查詢對象，如果沒有找到，會返回 404


5. 基於以上原因，可自定義 get_object() 來定製查詢邏輯，例如基於登錄用戶來返回資料

def get_object(self):
    return self.request.user  # 返回當前登錄用戶

"""

# # PUT請求 更新原有資料
# class UpdateEmialView(UpdateAPIView):
#     permission_classes = [IsAuthenticated]
#     serializer_class = EmailSerializer

#     def get_object(self):
#         """重寫方法,直接從登入用戶取對應模型實例"""
#         return self.request.user
