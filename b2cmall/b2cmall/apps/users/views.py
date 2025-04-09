from .models import User # 導入自訂義的用戶模型
from rest_framework.views import APIView
from rest_framework.generics import CreateAPIView
from rest_framework.response import Response
from .serializers import CreateUserSerializer
from rest_framework.permissions import AllowAny
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