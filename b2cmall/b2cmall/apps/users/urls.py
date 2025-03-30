from django.urls import path
from .views import UserView

app_name = 'users'

urlpatterns = [
    # 用戶註冊 API 
    path('', UserView.as_view(), name='register'),
]