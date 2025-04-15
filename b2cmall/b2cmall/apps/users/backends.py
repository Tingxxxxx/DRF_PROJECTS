from django.contrib.auth.backends import ModelBackend
from .models import User
from django.db.models import Q
import logging

logger = logging.getLogger('django')  

class UsernameMobileAuthBackend(ModelBackend):
    """自定義認證後端：允許用戶以帳號或手機登入"""
    
    def authenticate(self, request, username=None, password=None, **kwargs):
        # 根據前端傳來的 username(手機或用戶名)，獲取對應模型實例
        user = get_user_by_account(username)
        
        if user: 
            if user.check_password(password):
                logger.info(f"使用者:{user.username}（ID:{user.id}）登入成功")
                return user
            else:
                logger.warning(f"使用者:{user.username} 密碼錯誤")
        else:
            logger.warning(f"登入嘗試失敗，帳號或手機不存在: {username}")

        return None

def get_user_by_account(account):
    """
    根據帳號或手機號取得 User 
    return User實例或是None
    """
    return User.objects.filter(Q(username=account) | Q(mobile=account)).first() # 使用first()避免用戶名與手機完全相同的情況
