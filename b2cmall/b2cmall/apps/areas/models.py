from django.db import models
from users.models import UserAddress

class Region(models.Model):
    """台灣行政區域靜態三級資料表"""
    # 定義區域層級選項
    LEVEL_CHOICES = (
        ('city', '縣市'),          
        ('district', '區'),        
        ('postal_code', '郵遞區號') 
    )

    # 區域名稱欄位
    name = models.CharField(
        max_length=100, 
        verbose_name='縣市區或郵遞區號'  
    )
    
    # 上級區域欄位（外鍵關聯同模型本身，表示這個區域的上層區域）
    parent = models.ForeignKey(
        'self',              # 外鍵關聯的模型 這裡指向自身
        on_delete=models.CASCADE,  # 當父區域被刪除時，所有子區域也會被刪除
        related_name='subregions',  # 用於從父區域查詢子區域
        verbose_name='上級區域',    
        null=True,            # 允許空值，縣市 不需要父區域
        blank=True            # 允許空值，在 Django 表單中也可以為空
    )
    
    # 區域層級欄位
    level = models.CharField(
        max_length=50,                 
        choices=LEVEL_CHOICES,         # 選項：縣市、區、郵遞區號
        verbose_name='區域層級'         
    )

    # 返回區域名稱，便於顯示和查詢
    def __str__(self):
        return self.name
    
    def save(self, *args, **kwargs):
        """重寫save方法，用於如果行政區資料也變動時，直接更新對應的用戶收件地址資料"""
        # 調用父類方法，這裡的 self 是指正在被保存的 Region 實例
        super().save(*args, **kwargs)  
        
        # 更新所有與該 Region 相關的 UserAddress
        UserAddress.objects.filter(postal_code=self).update(postal_code=self)  # 更新所有關聯的 UserAddress


    class Meta:
        verbose_name = '台灣行政區域'  
        verbose_name_plural = '台灣行政區域'  


