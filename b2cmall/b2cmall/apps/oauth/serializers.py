import logging
from rest_framework import serializers
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth import get_user_model
from .models import UserSocialAccount
from .utils import hash_uid
from .constants import *
import re

# 設定 logger
logger = logging.getLogger('django')  # 使用 django 或自定義 logger

User = get_user_model()

class GoogleQuickRigisterSerializer(serializers.ModelSerializer):
    """驗證 Google 登入快速註冊本站帳號"""
    allow = serializers.BooleanField(label='同意條款', write_only=True)  # 用戶必須同意條款，僅用於接收資料，不會存入資料庫
    access = serializers.CharField(label='access_token', read_only=True)  # 自訂欄位，返回給前端使用，不會存到資料庫
    refresh = serializers.CharField(label='refresh_token', read_only=True)  # 自訂欄位，返回給前端使用，不會存到資料庫
    uid = serializers.CharField(write_only=True)  # 前端傳來的uid,只做反序列化
    

    # 驗證uid是否有值
    def validate_uid(self, value):
        """此時前端傳來的UID已經加密過了"""
        if not value:
            logger.error("未提供 Google UID")
            raise serializers.ValidationError('未提供google_uid')
        
        logger.info(f"接收到 Google UID: {value}")
        return value
    
    # 驗證用戶是否同意條款
    def validate_allow(self, value):
        if not value:
            logger.warning("用戶未同意條款")
            raise serializers.ValidationError('必須同意條款才能註冊')
        logger.info("用戶同意了條款")
        return value
    
    # 驗證 email 格式
    def validate_email(self, value):
        if not re.match(EMAIL_REGEX, value):
            logger.error(f"無效的 email 格式: {value}")
            raise serializers.ValidationError('無效的 email 格式')
        logger.info(f"有效的 email 格式: {value}")
        return value

    # 驗證手機格式
    def validate_mobile(self, value):
        if not re.match(MOBILE_REGX, value):  # 確保手機號碼符合台灣手機格式
            logger.error(f"無效的手機格式: {value}")
            raise serializers.ValidationError('手機格式不正確（範例：0912345678）')
        logger.info(f"有效的手機格式: {value}")
        return value

    # 複寫 create 方法，自訂新增邏輯
    def create(self, validated_data):
        """新增用戶，且設置無法使用的密碼"""

        # 先移除創建用戶時不需要的欄位，後續**解包才部會出錯
        del validated_data['allow']  # 刪除
        uid = validated_data.pop('uid') # 取出，後續可用

        try:
            # 傳入驗證後的資料並新增用戶
            user = User.objects.create(**validated_data)  # 不能用create_user()因為預設會自動加密密碼，但此時無提供
            print('用戶創建成功')
            user.set_unusable_password()  # 設定為無法使用的密碼，適用於使用 Google 登入的用戶
            logger.info(f"用戶創建成功: {user.username}, {user.email}")
            
            # 綁定社交帳號
            if not UserSocialAccount.objects.filter(user=user, uid=uid, provider='google').exists():
                UserSocialAccount.objects.create(user=user, email=user.email, uid=uid, provider='google')
                logger.info(f"Google 帳號 {uid} 綁定至用戶 {user.username}")
            
            # 生成 jwt token
            refresh = RefreshToken.for_user(user)
            user.access = str(refresh.access_token)
            user.refresh = str(refresh)

            return user
        
        except Exception as e:
            logger.error(f"創建用戶時發生錯誤: {e}")
            raise serializers.ValidationError(f"註冊過程中出現錯誤: {e}")

    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'mobile', 'allow', 'uid', 'access', 'refresh']  # 註冊所需的欄位
        extra_kwargs = {
            'username': {
                'min_length': 5,  # 用戶名最少需要 5 個字元
                'max_length': 20,  # 用戶名最多 20 個字元
                'error_messages': {
                    'min_length': '用戶名需介於 5~20 個字元',  # 如果用戶名少於 5 個字元，顯示此錯誤消息
                    'max_length': '用戶名需介於 5~20 個字元'   # 如果用戶名多於 20 個字元，顯示此錯誤消息
                },
            }
        }
