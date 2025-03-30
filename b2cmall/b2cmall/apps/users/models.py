from django.db import models
from django.contrib.auth.models import AbstractUser, UserManager

"""
用戶模型僅針對資料庫層級進行驗證(資料類型、唯一、是否允許空白)
其他如密碼強度驗證、用戶、手機、信箱等格式要求則由序列化器處理

"""
# 覆寫內建的用戶模型
class User(AbstractUser):
    mobile = models.CharField(
        max_length=10,
        unique=True,
        blank=False,
        null=False)
    
    # 明確指定使用預設的 UserManager 才能在自訂義的模型中使用
    objects = UserManager()      
    # 1. create_user()
    # 2. create_superuser()

    class Meta:
        db_table = 'users'
        verbose_name = "用戶"
        verbose_name_plural = verbose_name
    