from .models import User # 導入自訂義的用戶模型
from rest_framework.generics import CreateAPIView
from .serializers import CreateUserSerializer
from rest_framework.permissions import AllowAny
# 註冊 API 的視圖，繼承自通用類視圖(快速實現POST請求)
class UserView(CreateAPIView):
    """用戶註冊"""
    permission_classes = [AllowAny]
    serializer_class = CreateUserSerializer  # 指定序列化器
    