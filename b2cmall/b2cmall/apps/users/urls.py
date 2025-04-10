from django.urls import path, re_path
from .views import UserView, MobileCountView, UsernameCountView
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

app_name = 'users'

urlpatterns = [
    # JWT Token 路由
    path('token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),  # 登入，並取得 access & refresh token
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),  # 重新取得 access token
    # 用戶註冊 API
    path('', UserView.as_view(), name='register'),
    # 檢查用戶名是否重複
    re_path(r'^username/(?P<username>\w{5,20})/$', UsernameCountView.as_view(), name='check_username'),
    # 檢查手機號碼是否重複
    re_path(r'^mobile/(?P<mobile>09\d{8})/$', MobileCountView.as_view(), name='check_mobile'),

    # re_path() 寫法說明：
    # - 使用正則表達式來定義 URL 路由模式
    # - r'' 是 Python 的「原始字串」語法，可避免跳脫字元混亂（如 \w 不會被轉義）
    # - ^ 表示匹配 URL 的開頭
    # - $ 表示匹配 URL 的結尾
    # - (?P<變量名>規則) 是命名捕獲組，會將 URL 中的變量傳入 view 函式中作為參數

]