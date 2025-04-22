# views.py
from django.conf import settings
from django.contrib.auth import authenticate
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.permissions import AllowAny
from rest_framework.exceptions import ValidationError, AuthenticationFailed
from rest_framework import status
from google.oauth2 import id_token
from google.auth.transport import requests as google_requests
from google.auth.exceptions import GoogleAuthError
from users.models import User  # 自定義 User model
from .models import UserSocialAccount
from .utils import jwt_response # 自定義的 jwt 響應數據
import logging

logger = logging.getLogger('django')  # 使用 django 或自定義 logger

class GoogleLoginAPIView(APIView):
    """google帳號登入"""
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

            try:
                social_account = UserSocialAccount.objects.filter(uid=google_uid, provider='google').first()

                # ✅ 已綁定帳號
                if social_account:
                    user = social_account.user
                    refresh = RefreshToken.for_user(user)

                    logger.info(f'用戶 {user.username} 登入成功，已有綁定 Google 社交帳號')

                    # 使用自訂義的jwt響數據生成函數
                    response = jwt_response(user, refresh, message='登入成功（已有綁定）')

                    return Response(response, status=status.HTTP_200_OK)

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
                    'status': 'quick-rigister',
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
    """google登入並綁定本站對應信箱帳號"""
    permission_classes = [AllowAny]
    def post(self, request):
        username = request.data.get('username')
        email = request.data.get('email')
        google_uid = request.data.get('uid')
        password = request.data.get('password')

        # 檢查前端提交的資料是否都有值
        if not all([username, email, google_uid, password]):  # all() 檢查可迭代對象（例如列表、元組、集合等）中的每個元素是否都為真
            logger.warning('缺少必要的用戶資料')

            return ValidationError({
                'code':'invalid_user_info',
                'message':'無效的用戶資料'
            })

        # 驗證用戶名與密碼
        user = authenticate(username=username, password=password) # 成功返回user 失敗返回None
        if not user:
            logger.warning(f'使用者{username} 帳密驗證失敗')  # 因user無效，故使用 username，而非 user.username
            return AuthenticationFailed({
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

        response = jwt_response(user, refresh, message='已成功綁定 Google 帳號')
        # 使用自訂義的jwt響數據生成函數
        return Response(response, status=status.HTTP_200_OK)
        
   