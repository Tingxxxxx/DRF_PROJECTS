from django.urls import path,include
from .views import EmailCodeView

app_name = 'verifications'  # 設定命名空間

urlpatterns = [
    path('code/', EmailCodeView.as_view(), name='email_code'),
]