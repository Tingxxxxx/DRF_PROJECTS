from django.urls import path
from .views import GoogleLoginAPIView, BindGoogleAPIView

urlpatterns = [
    path('google-login/', GoogleLoginAPIView.as_view(), name='google-login'),
    path('bind-google/', BindGoogleAPIView.as_view(), name='bind-google'),
]