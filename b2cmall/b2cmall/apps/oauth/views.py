# views.py
from django.conf import settings
from django.contrib.auth import authenticate
from rest_framework.views import APIView
from rest_framework.generics import CreateAPIView
from rest_framework.response import Response
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.permissions import AllowAny
from rest_framework.exceptions import ValidationError, AuthenticationFailed
from rest_framework import status
from google.oauth2 import id_token
from google.auth.transport import requests as google_requests
from google.auth.exceptions import GoogleAuthError
from users.models import User  # 自定義 User model
from .serializers import GoogleQuickRigisterSerializer
from .models import UserSocialAccount
from .utils import jwt_response,hash_uid # 自定義的 jwt 響應數據
from carts.utils import merge_cart_cookie_to_redis # 自訂義的合併購物車功能函數
import logging

logger = logging.getLogger('django')  # 使用 django 或自定義 logger

class GoogleLoginAPIView(APIView):
    """
    Google 帳號登入 API

    流程說明：
    1. 接收前端傳來的 Google id_token
    2. 驗證 id_token 是否有效，並確認 email 是否已驗證
    3. 取得 Google uid（sub）並加密後，用於查找本站綁定的社交帳號
    4. 判斷是否已有本站帳號綁定該 Google 帳號：
       - 有綁定：登入成功，發放 JWT Token，並合併 cookie 購物車到 redis 購物車
       - 尚未綁定：
         a) 若本站已有對應 email 的帳號，回傳提示前端導向「綁定帳號」頁面
         b) 若無對應 email，回傳提示前端導向「快速註冊及綁定」頁面
    5. 若驗證失敗或 token 無效，拋出認證失敗異常
    """
    permission_classes = [AllowAny]

    def post(self, request):
        # 接收前端傳來的 google token
        credential = request.data.get('id_token')
        if not credential:
            logger.warning('缺少 id_token')  # 記錄警告
            raise ValidationError({'code': 'missing_token', 'message': '缺少 id_token'})

        try:
            # 驗證 Google token
            idinfo = id_token.verify_oauth2_token(
                credential,
                google_requests.Request(),
                settings.GOOGLE_CLIENT_ID
            )

            logger.info('Google token 驗證成功')  # 記錄成功的 token 驗證

            # 驗證信箱
            if not idinfo.get('email_verified', False):
                logger.warning(f'未驗證的 Google 信箱: {idinfo.get("email")}')
                raise AuthenticationFailed({'code': 'unverified_email', 'message': '未驗證的 Google 信箱'})

            email = idinfo.get('email')
            google_uid = idinfo.get('sub')
            google_uid = hash_uid(google_uid) # 加密uid，避免明文儲存或傳給前端

            try:
                social_account = UserSocialAccount.objects.filter(uid=google_uid, provider='google').first()

                # ✅ 已綁定帳號
                if social_account:
                    user = social_account.user
                    refresh = RefreshToken.for_user(user)

                    logger.info(f'用戶 {user.username} 登入成功，已有綁定 Google 社交帳號')

                    # 使用自訂義的jwt響應數據生成函數
                    response_data = jwt_response(user, refresh, message='登入成功（已有綁定）')

                    # 建立 DRF Response 實例
                    response = Response(response_data, status=status.HTTP_200_OK)
 
                    # 執行合併 cookie購物車到 redis 購物車
                    merge_cart_cookie_to_redis(request, user, response)

                    return response

                # ❗ 尚未綁定，嘗試根據信箱找 User
                user = User.objects.get(email=email) # 找不到會觸發 User.DoesNotExist 異常
                logger.info(f'用戶 {user.username} 已有對應信箱的本站帳號，跳轉到綁定頁完成綁定')

                return Response({
                    'status': 'need-bind',
                    'message': '該信箱已註冊過本站帳號，請登入已完成綁定',
                    'email': email,
                    'uid':google_uid,
                    'provider': 'google'
                }, status=status.HTTP_200_OK)

            except User.DoesNotExist:
                # 本地無此信箱對應帳號，請前往綁定頁
                logger.warning(f'信箱 {email} 未註冊，請前往註冊頁')

                return Response({
                    'status': 'quick-register',
                    'message': '尚未註冊本站帳號，請輸入相關資料完成註冊及綁定',
                    'email': email,
                    'uid':google_uid,
                    'provider': 'google'
                }, status=status.HTTP_200_OK)

        except (ValueError, GoogleAuthError) as e:
            logger.error(f'錯誤訊息: {e}')  # 使用 logger 來記錄錯誤
            raise AuthenticationFailed({'code': 'invalid_credential', 'message': '無效的 Google 憑證'})


"""
google token 驗證後返回的用戶資料如下:
{
    'iss': 'https://accounts.google.com',
    'azp': 'YOUR_GOOGLE_CLIENT_ID',
    'aud': 'YOUR_GOOGLE_CLIENT_ID',
    'sub': '110123456789012345678',       # Google 帳號唯一 ID
    'email': 'user@example.com',
    'email_verified': True,
    'name': '使用者名稱',
    'picture': 'https://example.com/photo.jpg',
    'given_name': '名',
    'family_name': '姓',
    'locale': 'zh-TW',
    'iat': 1713689919,
    'exp': 1713693519
}

"""       


class BindGoogleAPIView(APIView):
    """
    Google 登入並綁定本站對應信箱帳號 API
    
    流程說明：
    1. 前端送來 username、email、Google uid（已加密）及密碼
    2. 檢查資料是否齊全，缺少則回報錯誤
    3. 使用 Django 內建 authenticate 驗證帳密
    4. 若帳密驗證失敗，回傳登入失敗訊息
    5. 確認該 Google uid 尚未被其他帳號綁定，避免重複綁定
    6. 綁定成功後建立 UserSocialAccount 紀錄
    7. 產生 JWT token 回應前端，代表綁定並登入成功
    8. 呼叫合併購物車函數，將 cookie 購物車合併至 redis
    """
    permission_classes = [AllowAny]

    def post(self, request):
        username = request.data.get('username')
        email = request.data.get('email')
        google_uid = request.data.get('uid')  # 此時的uid是經過LoginView加密後返回給前端，前端再傳回的，故不需要再加密
        password = request.data.get('password')

        # 檢查前端提交的資料是否都有值
        if not all([username, email, google_uid, password]):  # all() 檢查可迭代對象（例如列表、元組、集合等）中的每個元素是否都為真
            logger.warning('缺少必要的用戶資料')

            raise  ValidationError({
                'code':'invalid_user_info',
                'message':'無效的用戶資料'
            })

        # 驗證用戶名與密碼
        user = authenticate(username=username, password=password) # 成功返回user 失敗返回None
        if not user:
            logger.warning(f'使用者{username} 帳密驗證失敗')  # 因user無效，故使用 username，而非 user.username
            raise  AuthenticationFailed({
                'code': 'error_userinfo',
                'message':'帳號登入失敗，請確認用戶名及密碼'
            })
        
        # 確保該帳號真的沒綁定過
        if not UserSocialAccount.objects.filter(uid=google_uid).exists():
            
            # 帳密驗證通過，綁定社交帳號
            UserSocialAccount.objects.create(uid=google_uid, user=user, provider='google', email=email)
            logger.info(f'使用者:{user.username} 帳密驗證通過，綁定google帳號並登入')

        # 生成 jwt_token 
        refresh = RefreshToken.for_user(user)

        # 使用自訂義的jwt響應數據生成函數
        response_data = jwt_response(user, refresh, message='已成功綁定 Google 帳號')

        # 建立 DRF Response 實例
        response = Response(response_data, status=status.HTTP_200_OK)
 
        # 執行合併 cookie購物車到 redis 購物車
        merge_cart_cookie_to_redis(request, user, response)

        return response

        

class GoogleQuickRigister(CreateAPIView):
    """google登入快速註冊本站帳號"""
    permission_classes = [AllowAny]
    serializer_class = GoogleQuickRigisterSerializer

    def create(self, request, *args, **kwargs):
        """複寫create方法，添加合併購物車邏輯"""

        # 1️⃣ 建立序列化器並驗證資料
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        # 2️⃣ 執行儲存（觸發 serializer.create()）
        self.perform_create(serializer)

        # 3️⃣ 準備回應資料
        headers = self.get_success_headers(serializer.data)
        response = Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)

        # 4️⃣ 合併購物車
        user = serializer.instance  # ✅ .instance 是剛創建的 user 實體
        merge_cart_cookie_to_redis(request, user, response)

        # 5️⃣ 回傳完整 Response
        return response