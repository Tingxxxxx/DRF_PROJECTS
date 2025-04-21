from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()

# Create your models here.
class UserSocialAccount(models.Model):
    """第三方社交登入的模型表"""

    # 設定 PROVIDER 欄位可用的選項
    # 前面為資料實際存進資料庫的值，後面為 Django 管理後台顯示給使用者的選項文字
    PROVIDER_CHOICES = (
        ('google', 'Google'),
        ('facebook', 'Facebook')
    )

    # 外鍵關連到 User 模型，用來表示這個社交帳號屬於哪一個使用者（User）
    # on_delete=models.CASCADE：如果該使用者被刪除，這個社交帳號資料也會一併刪除
    # related_name='social_accounts'：可以透過 user.social_accounts.all() 拿到該用戶的所有綁定帳號
    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='social_accounts',
        verbose_name='所屬用戶'
    )

    # 儲存登入平台名稱，使用 choices 讓後台出現下拉選單
    provider = models.CharField(
        max_length=20,
        choices=PROVIDER_CHOICES,
        verbose_name='登入平台',
        help_text="例如 Google 或 Facebook"
    )

    # uid 是從第三方登入平台來的唯一識別碼，unique=True 確保資料唯一
    uid = models.CharField(
        max_length=255,
        unique=True,
        verbose_name='唯一識別碼'
    )

    # 社交平台回傳的信箱欄位，null=True 表示資料庫欄位可為 NULL，blank=True 表示表單允許空白
    email = models.EmailField(
        null=True,
        blank=True,
        verbose_name='信箱'
    )

    # 自動更新的時間戳記，每次儲存資料時會自動更新
    update_at = models.DateTimeField(auto_now=True, verbose_name='更新時間')

    # 資料建立的時間戳記，只在建立時設定一次
    create_at = models.DateTimeField(auto_now_add=True, verbose_name='創建時間')

    def __str__(self):
        # 在後台或 shell 中列出資料時顯示的平台與 uid
        return f"{self.provider} - {self.uid}"

    def __repr__(self):
        # 提供清晰的開發者 debug 顯示
        return f"<UserSocialAccount {self.provider}:{self.uid}>"

    class Meta:
        # 後台顯示名稱（單數/複數）
        verbose_name = '社交帳號'
        verbose_name_plural = verbose_name

        # 預設排序：以建立時間遞減排序（新的資料在上面）
        ordering = ['-create_at']
        # 對應mysql的複合唯一約束
        unique_together = ('user', 'provider')  # 同一使用者不可重複綁定同一平台