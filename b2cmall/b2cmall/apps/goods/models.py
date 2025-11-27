from django.db import models
from b2cmall.utils.models import BaseModel
from ckeditor.fields import RichTextField
from ckeditor_uploader.fields import RichTextUploadingField 
from storages.backends.s3boto3 import S3Boto3Storage

# 對應前端左上方 商品三級分類選單
class GoodsCategory(BaseModel):
    """
    商品類別三級選單(自關聯表)
    """
    name = models.CharField(max_length=10, verbose_name='名稱')
    parent = models.ForeignKey('self', null=True, blank=True, on_delete=models.CASCADE, verbose_name='父類別')

    class Meta:
        db_table = 'tb_goods_category'
        verbose_name = '商品類別'
        verbose_name_plural = verbose_name

    def __str__(self):
        if self.parent:
            return f"{self.parent.name} - {self.name}"
        else:
            return f"{self.name}"

# 將上面商品類別進行分組 ([手機.3C]、[機票、旅遊、生活])
class GoodsChannel(BaseModel):
    """
    商品頻道(只管理商品類別中的頂層選單)
    """
    group_id = models.IntegerField(verbose_name='組號') # 此組類別選單 展示在上到下的第幾行
    category = models.ForeignKey(GoodsCategory, on_delete=models.CASCADE, verbose_name='頂級商品類別')
    url = models.CharField(max_length=50, verbose_name='頻道頁面連結')
    sequence = models.IntegerField(verbose_name='組內順序') # 同一橫行中的順訊

    class Meta:
        db_table = 'tb_goods_channel'
        verbose_name = '商品頻道'
        verbose_name_plural = verbose_name

    def __str__(self):
        return '%s: %s' % (self.group_id, self.category.name)


class Brand(BaseModel):
    """
    品牌(蘋果、三星、小米.....)
    """
    name = models.CharField(max_length=20, verbose_name='名稱')
    logo = models.ImageField(storage=S3Boto3Storage(), verbose_name='Logo圖片')
    first_letter = models.CharField(max_length=1, verbose_name='品牌首字母')

    class Meta:
        db_table = 'tb_brand'
        verbose_name = '品牌'
        verbose_name_plural = verbose_name

    def __str__(self):
        return self.name

# 與品牌表為一(品牌)對多(SPU)關係
class Goods(BaseModel): 
    """
    商品SPU(IPHONE10、IPHONE8....不關心具體顏色、規格等)
    """
    name = models.CharField(max_length=50, verbose_name='名稱')
    brand = models.ForeignKey(Brand, on_delete=models.PROTECT, verbose_name='品牌')
    category1 = models.ForeignKey(GoodsCategory, on_delete=models.PROTECT, related_name='cat1_goods', verbose_name='一級類別')
    category2 = models.ForeignKey(GoodsCategory, on_delete=models.PROTECT, related_name='cat2_goods', verbose_name='二級類別')
    category3 = models.ForeignKey(GoodsCategory, on_delete=models.PROTECT, related_name='cat3_goods', verbose_name='三級類別')
    sales = models.IntegerField(default=0, verbose_name='銷量')
    comments = models.IntegerField(default=0, verbose_name='評價數')

    desc_detail = RichTextUploadingField(default='', verbose_name='產品介紹') # 圖片+文字(html)
    desc_pack = RichTextField(default='', verbose_name='產品包裝內容')        # 僅文字(html)
    desc_service = RichTextUploadingField(default='', verbose_name='售後服務')

    class Meta:
        db_table = 'tb_goods'
        verbose_name = '商品'
        verbose_name_plural = verbose_name

    def __str__(self):
        return self.name


class GoodsSpecification(BaseModel):
    """
    商品規格(標題，EX:顏色、容量、型號....)
    """
    goods = models.ForeignKey(Goods, on_delete=models.CASCADE, verbose_name='商品') # 指向SPU表
    name = models.CharField(max_length=20, verbose_name='規格名稱')

    class Meta:
        db_table = 'tb_goods_specification'
        verbose_name = '商品規格'
        verbose_name_plural = verbose_name

    def __str__(self):
        return '%s: %s' % (self.goods.name, self.name)


class SpecificationOption(BaseModel):
    """
    規格選項(具體選項，EX:紅色、黑色、128G、256G....)
    """
    spec = models.ForeignKey(GoodsSpecification, on_delete=models.CASCADE, verbose_name='規格')
    value = models.CharField(max_length=20, verbose_name='選項值')

    class Meta:
        db_table = 'tb_specification_option'
        verbose_name = '規格選項'
        verbose_name_plural = verbose_name

    def __str__(self):
        return '%s - %s' % (self.spec, self.value)


# 與SPU表(一)對多(SKU)
class SKU(BaseModel):
    """
    商品SKU(實際上架銷售的商品單位)

    假設SPU是 iPhone10 規格選項如下：
    螢幕尺寸(13.3/15.4)
    顏色(紅色/灰色)
    版本("i5/8G/128G" / "i5/8G/256G")

    要先將不同選項的組合都個別獨立存成一筆SKU
    EX (iPhone10: 紅/13.3/128G)、(iPhone10: 灰/15.4/256G)

    每個 SKU實例：
    - 都是一個實際可以被「加入購物車」的商品
    - 都有獨立的庫存、圖片、價格
    - 要能精準對應一組「規格選項」

    """
    name = models.CharField(max_length=50, verbose_name='名稱')
    caption = models.CharField(max_length=100, verbose_name='副標題')
    goods = models.ForeignKey(Goods, on_delete=models.CASCADE, verbose_name='商品')
    category = models.ForeignKey(GoodsCategory, on_delete=models.PROTECT, verbose_name='所屬類別')
    price = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='單價')
    cost_price = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='進價')
    market_price = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='市場價')
    stock = models.IntegerField(default=0, verbose_name='庫存')
    sales = models.IntegerField(default=0, verbose_name='銷量')
    comments = models.IntegerField(default=0, verbose_name='評價數')
    is_launched = models.BooleanField(default=True, verbose_name='是否上架銷售')
    default_image_url = models.CharField(max_length=200, default='', null=True, blank=True, verbose_name='預設圖片')

    class Meta:
        db_table = 'tb_sku'
        verbose_name = '商品SKU'
        verbose_name_plural = verbose_name

    def __str__(self):
        return '%s: %s' % (self.id, self.name)


class SKUImage(BaseModel):
    """
    SKU圖片(點進具體商品頁時，多張產品圖圖片)
    """
    sku = models.ForeignKey(SKU, on_delete=models.CASCADE, verbose_name='SKU')
    image = models.ImageField(storage=S3Boto3Storage(), verbose_name='圖片') # 資料庫只會存檔名，要調用時要使用image.url屬性來獲取S3圖片網址

    class Meta:
        db_table = 'tb_sku_image'
        verbose_name = 'SKU圖片'
        verbose_name_plural = verbose_name

    def __str__(self):
        return '%s %s' % (self.sku.name, self.id)


class SKUSpecification(BaseModel):
    """
    SKU具體規格(點進具體商品頁面時，預設選好的規格標籤選項)
    """
    sku = models.ForeignKey(SKU, on_delete=models.CASCADE, verbose_name='SKU')
    spec = models.ForeignKey(GoodsSpecification, on_delete=models.PROTECT, verbose_name='規格名稱')
    option = models.ForeignKey(SpecificationOption, on_delete=models.PROTECT, verbose_name='規格值')

    class Meta:
        db_table = 'tb_sku_specification'
        verbose_name = 'SKU規格'
        verbose_name_plural = verbose_name

    def __str__(self):
        return '%s: %s - %s' % (self.sku, self.spec.name, self.option.value)



from storages.backends.s3boto3 import S3Boto3Storage

# class Test(BaseModel):
#     """測試S3文件上傳的模型"""
#     image1 = models.ImageField(upload_to='goods/', storage=S3Boto3Storage())

#     class Meta:
#         db_table = 'test_image_upload'