from django.utils.http import urlsafe_base64_decode
from django.contrib.auth.tokens import default_token_generator
from django.db.models import Case, When, Value, IntegerField # 排序用
from rest_framework.views import APIView
from rest_framework.viewsets import GenericViewSet
from rest_framework.mixins import UpdateModelMixin, RetrieveModelMixin
from rest_framework.generics import CreateAPIView
from rest_framework.response import Response
from rest_framework.decorators import action
from rest_framework import status
from .serializers import CreateUserSerializer
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework_simplejwt.views import TokenObtainPairView
from .serializers import MyTokenObtainPairSerializer, UserDetailSerializer, UserAddressSerializer, TitleOnlySerializer
from celery_tasks.verifycode.tasks import send_verification_email
from .models import User, UserAddress # 導入自訂義的用戶模型
from .throttles import EmailRateThrottle
from .utlis import generate_activation_link
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
        
        user = request.user # 當前用戶
        email = request.data.get('email') # 修改的信箱

        # 如果確實有修改信箱，則將該用戶的信箱狀態改為未激活
        if email and email != user.email:
            user.email_is_active = False

            try:
                user.save()
                logger.info(f"使用者 {user} 修改信箱為 {email}")

            # 如果信箱激活狀態更新失敗，後續寄信與用戶信箱更新就都不會執行(避免資料不一致)
            except Exception as e:
                logger.error(f"保存用戶資料時發生錯誤: {e}")
                return Response({'message':'更新用戶資料失敗'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        # 調用父類方法更新信箱
        response = super().partial_update(request, *args, **kwargs)

        # 新增發送驗證郵件功能
        logger.info(f"使用者 {user} 信箱:{email} 發送驗證信") 
        activate_link = generate_activation_link(user)
        send_verification_email.delay(email, activate_link)
        
        # 可以加入一些額外的 response 資料
        response.data['message'] = '信箱修改成功，請檢查您的電子郵件以完成驗證。'  # 自定義的訊息

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


class ActivateEmailView(APIView):
    """驗證寄給用戶的email激活連結"""
    permission_classes = [AllowAny] # 因為用戶打開信箱中的連結時應該是未登入狀態
    def get(self, request):
        # 嘗試取得 query string 中的 code，例如 ?code=123-abc
        code = request.query_params.get('code')

        try:
            # 可能錯誤：
            # - AttributeError：code 為 None 時無法 strip()
            # - ValueError：split 後不是兩段（無法拆成 uid, token）
            uid, token = code.strip().split('-', 1) # 1代表分割1次
            uid = urlsafe_base64_decode(uid) # 解碼回整數
        

            # 嘗試取得該 uid 對應的使用者
            # 可能錯誤：
            # - User.DoesNotExist：使用者不存在
            # - ValueError：uid 格式錯誤（例如非整數）
            user = User.objects.get(pk=uid)

        except (AttributeError, ValueError, User.DoesNotExist):
            logger.error('驗證碼格式錯誤或使用者不存在')
            return Response({
                'status': 'error',
                'message': '驗證碼格式錯誤或使用者不存在'
            }, status=status.HTTP_400_BAD_REQUEST)

        # 驗證 token 是否有效
        if default_token_generator.check_token(user, token):
            user.email_is_active = True # 修改信箱狀態欄
            user.save()  # 記得儲存變更
            logger.info(f'使用者:{user.username}，信箱{user.email}已激活')

            return Response({
                'status': 'success',
                'message': 'Email 已成功驗證'
            }, status=status.HTTP_200_OK)

        # token 驗證失敗（可能已過期或已使用）
        logger.error(f'使用者:{user.username}的驗證連結已失效')
        return Response({
            'status': 'error',
            'message': '驗證連結已失效'
        }, status=status.HTTP_400_BAD_REQUEST)


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


class UserAddressViewSet(UpdateModelMixin, GenericViewSet):
    """
    用戶收件地址視圖集（增、刪、改、查列表）
    
    提供以下 API：
    - GET    /users/addresses/           → list()
    - POST   /users/addresses/           → create()
    - PUT    /users/addresses/{pk}/      → update()
    - PATCH  /users/addresses/{pk}/      → update()
    - DELETE /users/addresses/{pk}/      → destroy()

    使用@action 自訂額外的的API(預設路由同函數名)
    - PATCH  /users/addresses/{pk}/title/       → title()    
    - PATCH  /users/addresses/{pk}/set_default/ → set_default()    
    
    不提供 retrieve() 詳情查詢
    """
    permission_classes = [IsAuthenticated]
    serializer_class = UserAddressSerializer  

    def get_queryset(self):
        """
        只返回當前登入用戶自己的地址，且必須未被邏輯刪除 (is_deleted=False)
        """
        return UserAddress.objects.filter(user=self.request.user, is_deleted=False)
    
    # GET /users/addresses/
    def list(self, request, *args, **kwargs):
        """
        列出當前使用者的所有地址（不含已刪除的）
        加上預設地址ID與地址上限限制資訊

        補充知識:
        Case(
            When(條件, then=Value(值)),  # 當條件符合時，返回指定的值
            default=Value(默認值),  # 當條件不符合時，返回默認值
            output_field=字段類型  # 設定返回值的類型，這通常是 IntegerField 或其他類型
        )

        """
        user = self.request.user
        queryset = self.get_queryset()

        # 使用 Case When 來根據是否是默認地址進行排序
        queryset = queryset.annotate(
        is_default_case=Case(
            When(id=user.default_address.id, then=Value(1)),  # 默認地址為 1
            default=Value(0),  # 其他地址為 0
            output_field=IntegerField()
            )
        ).order_by('-is_default_case', '-updated_at')  # -為大到小，故默認地址在最前面，更新時間排序

        serializer = self.get_serializer(queryset, many=True) # 序列化多筆資料故,many=True

        return Response({
            'user_id':user.id,
            # 如果直接返回.id,但資料庫user.default_address為Null就會報錯，故要記得加判斷
            'default_address_id':user.default_address.id if user.default_address else None, 
            'limit':20,
            'addresses':serializer.data # 用戶名下地址列表
        }, status=status.HTTP_200_OK)

    # POST /users/addresses/
    def create(self, request, *args, **kwargs):
        """
        建立一筆新的收件地址
        - 限制最多只能有 20 筆
        - 透過序列化器進行資料驗證與儲存
        """

        user = request.user
        count = user.addresses.all().count()  # 通過 related_name 查詢用戶名下幾個收件地址

        if count >= 20:
            return Response(
                {'message': '收件地址數量不能超過20個'},
                status=status.HTTP_400_BAD_REQUEST
    )
        # 小於20,則創建序列化器並進行驗證
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True) # 較驗資料
        serializer.save() # 調用序列化器的create方法 

        return Response(serializer.data, status=status.HTTP_201_CREATED)
   
    def destroy(self, request, *args, **kwargs):
        """
        邏輯刪除指定地址（將 is_deleted 設為 True）
        - 不進行真正的 delete
        - get_object() 若找不到會自動回傳 404
        """
        instance = self.get_object() # 找不到指定pk的物件，則get_object()會自動拋404,故不用再判斷
        instance.is_deleted = True
        instance.save()

        return Response({
            'status': 'success',
            'message': '地址已成功刪除（邏輯刪除）'
        }, status=status.HTTP_200_OK)
    
    @action(detail=True, methods=['PATCH'])
    def title(self, request, *args, **kwargs):
        """
        自訂 action：僅更新地址標題欄位
        - 使用專用的 TitleOnlySerializer
        """
        useraddress = self.get_object()
        serializer = TitleOnlySerializer(instance=useraddress, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        serializer.save()

        return Response(serializer.data)

    @action(detail=True, methods=['PATCH'])
    def set_default(self, request, *args, **kwargs):
        """
        自訂 action：設定指定地址為使用者的預設地址
        - 若本來就是預設地址則不變更
        """
        user = self.request.user
        useraddress = self.get_object()

        if user.default_address != useraddress:
            user.default_address = useraddress
            user.save()

        return Response(
            {'message':'預設地址設定成功'}, 
            status=status.HTTP_200_OK)
