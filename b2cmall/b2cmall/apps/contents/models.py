from django.db import models
from b2cmall.utils.models import BaseModel

# Create your models here.
class ContentCategory(BaseModel):
    """
    廣告分組類
    """
    name = models.CharField(max_length=50, verbose_name='名稱')
    key = models.CharField(max_length=50, verbose_name='類別鍵名')

    class Meta:
        db_table = 'tb_content_category'
        verbose_name = '廣告分組類'
        verbose_name_plural = verbose_name

    def __str__(self):
        return self.name


class Content(BaseModel):
    """
    廣告具體內容類
    """
    category = models.ForeignKey(ContentCategory, on_delete=models.PROTECT, verbose_name='類別')
    title = models.CharField(max_length=100, verbose_name='標題')
    url = models.CharField(max_length=300, verbose_name='內容連結')
    image = models.ImageField(null=True, blank=True, verbose_name='圖片')
    text = models.TextField(null=True, blank=True, verbose_name='內容')
    sequence = models.IntegerField(verbose_name='排序') # 播放順序
    status = models.BooleanField(default=True, verbose_name='是否顯示') # 邏輯刪除

    class Meta:
        db_table = 'tb_content'
        verbose_name = '廣告內容'
        verbose_name_plural = verbose_name

    def __str__(self):
        return self.category.name + ': ' + self.title
