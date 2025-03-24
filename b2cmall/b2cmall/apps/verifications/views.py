from django.shortcuts import render
from django.core.mail import send_mail
from django.core.cache import caches
from django.conf import settings
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import AllowAny
from .constants import *
import logging
import re
import string
import random
from redis import Redis

# 配置日誌輸出
logger = logging.getLogger("django")

class EmailCodeView(APIView):
    """發送email驗證碼"""
    permission_classes = [AllowAny]
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.redis_client = Redis(host='localhost', port=6379, db=0)  # 初始化 Redis 客戶端

    def get(self, request):
        """發送驗證碼"""
        email = request.query_params.get('email')

        # 確保有提供信箱
        if not email:
            return Response({'error': EMAIL_FIELD_REQUIRED_ERROR}, status=status.HTTP_400_BAD_REQUEST)

        # 驗證信箱格式
        if not re.match(EMAIL_REGEX, email):
            return Response({'error': INVALID_EMAIL_ERROR}, status=status.HTTP_400_BAD_REQUEST)

        # 檢查是否在冷卻時間內
        if self.redis_client.get(f'email_{email}_cooldown'):
            return Response({'error': REPEAT_EMAIL_CODE_ERROR}, status=status.HTTP_400_BAD_REQUEST)

        # 生成6位數驗證碼
        code = "".join(random.choices(string.digits, k=6))

        # 使用 Redis Pipeline 優化請求
        pipe = self.redis_client.pipeline()        
        pipe.set(f'verify_code_{email}', code, ex=EMAIL_CODE_TIMEOUT)

        # 發送驗證碼郵件
        email_response = self.send_email_verification_code(email, code)

        # 如果郵件發送失敗，刪除驗證碼，並返回錯誤訊息
        if 'error' in email_response:   
            self.redis_client.delete(f'verify_code_{email}')
            logger.error(f"驗證信發送失敗: {email_response['error']}")
            return Response({'error': email_response['error']}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        # 設置冷卻時間，防止短時間內重複請求
        pipe.set(f'email_{email}_cooldown', 1, ex=RE_SEND_TIMEOUT)
        pipe.execute()  # 批量執行 Redis 命令

        return Response(email_response, status=status.HTTP_200_OK)

    def send_email_verification_code(self, recipient_email, verification_code):
        """發送電子郵件驗證碼"""
        subject = '您的驗證碼'
        message = f'您好！您的驗證碼是：{verification_code}，請在5分鐘內使用。'
        from_email = settings.DEFAULT_FROM_EMAIL  # 確保 settings.py 中有配置

        try:
            send_mail(subject, message, from_email, [recipient_email])
            return {'success': '驗證碼已透過電子郵件發送'}
        except Exception as e:
            logger.error(f'郵件發送錯誤: {str(e)}')  # 記錄詳細錯誤但不返回給用戶
            return {'error': '發送驗證碼失敗，請稍後再試'}
