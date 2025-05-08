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
        default=False,
        null=True,  # 後加的欄位，資料庫不強制一定要有值，避免有時遷移時產生問題
    )
    
    # 新增一個用戶默認收件地址欄
    default_address = models.OneToOneField(
        'users.UserAddress', # 關連到用戶收件地址表
        related_name='default_user', # 可透過  useraddress.default_user 獲取該筆地址屬於哪個用戶
        on_delete=models.SET_NULL, # 對應的收件地址刪除時,將用戶預設地址改為空
        null=True, # 允許為空
        blank=True, # 允許為空
        verbose_name='預設收件地址'
    )
    
    
    # 明確指定使用預設的 UserManager 才能在自訂義的模型中使用
    objects = UserManager()      
    # 1. create_user()
    # 2. create_superuser()

    class Meta:
        db_table= 'users'
        verbose_name = "用戶"
        verbose_name_plural = verbose_name


class UserAddress(models.Model):
    """管理用戶收件地址的模型表"""
    user = models.ForeignKey(
        User,                      # 關聯到User模型
        on_delete=models.CASCADE,  # 用戶刪除則所屬地址也刪除
        related_name='addresses',  # 可透過 user.addresses 查到用戶所有收件地址
        verbose_name='所屬用戶')
    
    title = models.CharField(
        max_length= 20,
        verbose_name='收件地址標題',
        null=True, # 允須資料庫為空
        blank=True # 允許前端表單為空
    )

    receiver = models.CharField(
        max_length=20,
        verbose_name='收件人',
        )  

    postal_code = models.ForeignKey(
        # 直接寫字符串"應用名.模型名",取代只寫 Region 可以省去導入模組步驟
        'areas.Region',  # 指向 Region 的 郵遞區號，因為可以直接藉此推算上面兩層
        on_delete=models.PROTECT, # 當某個 Region（地區）已被使用時，不允許該地區被刪除
        related_name='useraddresses', # 可通過region.useraddresses 快速統計用戶收件地址區域分布 
        verbose_name='郵遞區號'
    )      
    
    place = models.CharField(
        max_length=50,
        verbose_name='詳細地址'
    )

    mobile = models.CharField(
        max_length=10,
        verbose_name='手機'
    )

    tel = models.CharField(
        max_length=20,
        verbose_name='市話',
        null = True, # 允許為空
        blank= True  # 允許為空
    )

    email = models.EmailField(
        max_length=254,
        verbose_name='電子信箱',
        null = True, # 允許為空
        blank= True  # 允許為空
    )

    is_deleted = models.BooleanField(
        default=False,
        verbose_name='邏輯刪除'
    )

    created_at = models.DateTimeField(
        auto_now_add=True,
        verbose_name='創建時間')
    
    updated_at = models.DateTimeField(
        auto_now=True,
        verbose_name='更新時間'
    )

    def __str__(self):
        return f'{self.receiver}: {self.postal_code} {self.place}'
    
    def full_address(self):
        """通過郵遞區號回推完整地址,方便之後在序列化器中進行序列化時調用(響應給前端)"""

        # 確保郵遞區號與詳細地址都有值
        if not self.postal_code or not self.place:
            return "地址資料不完整" # 或回傳 "地址不完整"
        
        r = self.postal_code # 取到關聯的 郵遞區號 Region實例
        full_addr = []

        # 如果r有值,共循環三輪，直到r為城市時停止
        while r:
            full_addr.append(r.name) # 最終結果: ['702', '南區', '台南市]
            r = r.parent # 取上級， 郵遞區號--->區域, 區域--->城市, 城市--->無上級,
            
        postal_code = full_addr[0] # '702'
        others = full_addr[1:][::-1]# 先切片['南區', '台南市'],在反轉--->['台南市','南區']
        detail_addr = self.place # ex: 'xx路xx號'

        # 組裝並返回完整地址
        return " ".join([postal_code]+others+[detail_addr])  # 同為[]才能相加 結果 "702 台南市 南區 xx路xx號"
        
    class Meta:
        db_table= 'useraddresses'
        verbose_name = '用戶收件地址'
        verbose_name_plural = verbose_name
        ordering = ['updated_at']  # 最近有更新的放前面