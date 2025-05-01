from django.db import models
from django.contrib.auth.models import AbstractUser, UserManager

"""
用戶模型僅針對資料庫層級進行驗證，例如資料型別、唯一性、是否允許為空等。

其他如：
- 密碼強度驗證
- 手機號碼與電子信箱格式
- 使用者名稱規則

這類格式與邏輯驗證，統一交由序列化器處理。

⚠️ 建議：
對於重要欄位（如手機、信箱等），即使在序列化器中已有驗證，仍建議在模型中加上：
    null=False, blank=False
以確保資料庫層與表單層級都不會允許空值，提升整體資料一致性與安全性。
"""

# 覆寫內建的用戶模型
class User(AbstractUser):
    mobile = models.CharField(
        verbose_name='手機',
        max_length=10,
        unique=True,  # 唯一
        blank=False,  # 表單驗證時此欄位不能為空（前端驗證）
        null=False)   # 資料庫層級，此欄位不能為 NULL（後端驗證）
    
    email = models.EmailField(
        max_length=254,
        verbose_name='電子信箱',
        unique=True,
        blank=False,
        null=False
    )
    # 新增一個信箱激活狀態欄
    # 注意:資料庫表中已經有數據在時，後添加的欄位要設默認值或允許為空(null=True, blank=True)，才不會報錯
    email_is_active = models.BooleanField(
        verbose_name='信箱狀態',
        default=False)
    
    # 明確指定使用預設的 UserManager 才能在自訂義的模型中使用
    objects = UserManager()      
    # 1. create_user()
    # 2. create_superuser()

    class Meta:
        db_table = 'users'
        verbose_name = "用戶"
        verbose_name_plural = verbose_name
    