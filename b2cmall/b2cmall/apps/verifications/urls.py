from django.urls import path,include
from .views import EmailCodeView

urlpatterns = [
    path('code/', EmailCodeView.as_view(), name='email_code'),
]