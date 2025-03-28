from django.shortcuts import render
from django.core.mail import send_mail
from django_redis import get_redis_connection
from django.core.cache import caches
from django.conf import settings
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import AllowAny
from celery_tasks.verifycode.tasks import send_email_task
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
    redis_client = get_redis_connection('verify')
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

        # 使用celery異步任務發驗證信
        try:
            # 使用 Redis Pipeline 優化請求
            pipe = self.redis_client.pipeline()        
            pipe.set(f'verify_code_{email}', code, ex=EMAIL_CODE_TIMEOUT)
        
            # 將發送任務添加到celery隊列中--->函數名.delay(傳參...)
            send_email_task.delay(recipient_email=email, verification_code=code) # celery任務，如發信失敗會拋出異常

            # 設置冷卻時間，防止短時間內重複請求
            pipe.set(f'email_{email}_cooldown', 1, ex=RE_SEND_TIMEOUT)
            pipe.execute()  # 批量執行 Redis 命令

        # 驗證信發送失敗
        except Exception as e:
            return Response({'error': '郵件發送任務處理失敗'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


        return Response({'success': '驗證碼已提交發送，請稍候查收郵件'}, status=status.HTTP_200_OK)

