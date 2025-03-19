from django.db import models
from django.contrib.auth.models import AbstractUser

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

    class Meta:
        db_table = 'users'
        verbose_name = "用戶"
        verbose_name_plural = verbose_name
    