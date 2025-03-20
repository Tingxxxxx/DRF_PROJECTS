from django.shortcuts import render
from django.core.mail import send_mail
from django.conf import settings
from django.core.cache import cache
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import AllowAny
import re
import string
import random

# 常量區
EMAIL_REGEX = r"^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$"
EMAIL_FIELD_REQUIRED_ERROR = 'email欄位為必填'
INVALID_EMAIL_ERROR = '無效的email'

class EmailCodeView(APIView):
    """發送email驗證碼"""
    # 允許所有用戶訪問
    permission_classes = [AllowAny]

    def get(self, request):
        # 1. 接收前端透過查詢字串傳來的信箱
        email = request.query_params.get('email')

        # 2. 確保有提供信箱
        if not email:
            return Response({'error': EMAIL_FIELD_REQUIRED_ERROR}, status=status.HTTP_400_BAD_REQUEST)

        # 3. 正則驗證信箱格式
        if not re.match(EMAIL_REGEX, email):
            return Response({'error': INVALID_EMAIL_ERROR}, status=status.HTTP_400_BAD_REQUEST)

        # 4. 檢查該email是否已請求過驗證碼
        if cache.get(email):
            return Response({'error': '驗證碼已發送，請稍後再試'}, status=status.HTTP_400_BAD_REQUEST)

        # 5. 驗證通過則生成6位數信箱驗證碼
        code = "".join(random.choices(string.digits, k=6))

        # 6. 存到cache中，並設置過期時間
        cache.set(email, code, timeout=60*5)  # 5分鐘過期

        # 7. 發送email邏輯
        email_response = self.send_email_verification_code(email, code)

        if 'error' in email_response:
            return Response({'error': email_response['error']}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        # 8. 返回成功響應
        return Response({'message': '驗證碼已發送，請檢查您的電子郵件'}, status=status.HTTP_200_OK)

    def send_email_verification_code(self, recipient_email, verification_code):
        """
        發送電子郵件驗證碼
        recipient_email (str): 收件人的電子郵件地址
        verification_code (str): 要發送的驗證碼
        返回:
        dict: 返回一個字典
            - 'success': 成功消息，當郵件發送成功時返回
            - 'error': 錯誤消息，當郵件發送失敗時返回錯誤信息
        """
        subject = '您的驗證碼'
        message = f'您好！您的驗證碼是：{verification_code}，請在5分鐘內使用。'
        from_email = settings.DEFAULT_FROM_EMAIL  # 確保您的 settings.py 文件中配置了此項

        try:
            send_mail(subject, message, from_email, [recipient_email])
            return {'success': '驗證碼已透過電子郵件發送'}
        except Exception as e:
            return {'error': f'發送電子郵件失敗，錯誤原因：{str(e)}'}
