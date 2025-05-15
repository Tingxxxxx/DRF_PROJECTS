from django.db import models


class BaseModel(models.Model):
    """為模型類補充默認欄位"""
    create_time = models.DateTimeField(auto_now_add=True, verbose_name="創建時間")
    update_time = models.DateTimeField(auto_now=True, verbose_name="更新時間")

    class Meta:
        abstract = True  # 抽象基類僅用於繼承，資料庫遷移時部會創建到這張表