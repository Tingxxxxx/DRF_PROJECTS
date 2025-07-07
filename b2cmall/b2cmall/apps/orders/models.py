from django.db import models
from b2cmall.utils.models import BaseModel
from users.models import User, UserAddress
from goods.models import SKU

# Create your models here.
class OrderInfo(BaseModel):
    """
    OrderInfo 模型說明：

    - order_id：自訂主鍵（訂單編號），避免使用預設整數主鍵
    - user / address：訂單關聯的用戶與收件地址，使用 PROTECT 防止誤刪
    - total_count / total_amount / freight：商品總數、商品總價、運費（使用 DecimalField 儲存金額）
    - pay_method：支付方式，使用 ENUM + CHOICES 設定
    - status：訂單狀態，使用 ENUM + CHOICES 設定
    - __str__：顯示訂單編號與中文狀態名稱
    """

    PAY_METHOD_ENUM = {
        'CASH':1,
        'ONLINE':2
    }

    PAY_METHOD_CHOICES = (
        (1, '貨到付款'),
        (2, '線上支付')
    )

    ORDER_STATUS_ENUM  = {
        "UNPAID": 1,
        "UNSEND": 2,
        "UNRECEIVED": 3,
        "UNCOMMENT": 4,
        "FINISHED": 5,
        "CANCELED":6
    }

    ORDER_STATUS_CHOICES = (
        (1, "待付款"),
        (2, "待出貨"),
        (3, "待收貨"),
        (4, "待評價"),
        (5, "已完成"),
        (6, "已取消"),
    )

    order_id = models.CharField(max_length=64, primary_key=True, verbose_name='訂單編號') # 設為主鍵，不用DRF自訂ID為主鍵
    user = models.ForeignKey(User, on_delete=models.PROTECT, verbose_name='用戶') # PROTECT-> 防止刪除還有訂單綁定的用戶或地址
    address = models.ForeignKey(UserAddress, on_delete=models.PROTECT, verbose_name='收件地址') # 同上
    total_count = models.IntegerField(default=1, verbose_name='訂購商品總數')
    total_amount = models.DecimalField(max_digits=10, decimal_places=2, default=0, verbose_name='商品總價')
    freight = models.DecimalField(max_digits=10, decimal_places=2, default=0, verbose_name="運費")
    pay_method = models.SmallIntegerField(choices=PAY_METHOD_CHOICES, default=PAY_METHOD_ENUM['CASH'], verbose_name='支付方式')
    status = models.SmallIntegerField(choices=ORDER_STATUS_CHOICES, default=ORDER_STATUS_ENUM["UNPAID"], verbose_name='訂單狀態')
        
    def __str__(self):
        return f"訂單 {self.order_id} - 狀態 {self.get_status_display()}" # get_status_display為欄位有用choices=xxx時，Django自訂義好的顯示方法
    
    class Meta:
        db_table = 'order_info'
        verbose_name = '訂單基本資訊'
        verbose_name_plural = verbose_name
        indexes = [ # 添加索引
        models.Index(fields=['user', 'status']),  # user 與 status 的複合索引
        models.Index(fields=['status']),          # 單欄位索引（可選）
    ]


class OrderGoods(BaseModel):
    """
    訂單商品模型 (OrderGoods)

    欄位說明：
    - order: 關聯訂單，防止訂單刪除時誤刪訂單商品
    - sku: 商品 SKU，防止刪除仍有訂單綁定
    - count: 商品數量
    - price: 商品當時單價，保存歷史價格資訊
    - comment: 商品評價內容，允許空白
    - score: 商品評分，0~5 星，可為空（未評分）
    - is_anonymous: 是否匿名評價
    - is_commented: 是否已評價（方便查詢）
    """

    SCORE_CHOICES = (
        (0, '0星'),
        (1, '1星'),
        (2, '2星'),
        (3, '3星'),
        (4, '4星'),
        (5, '5星'),
    )

    order = models.ForeignKey(OrderInfo, on_delete=models.PROTECT, related_name='order_goods' , verbose_name='所屬訂單')
    sku = models.ForeignKey(SKU, on_delete=models.PROTECT, verbose_name='訂單商品')
    count = models.IntegerField(default=1 , verbose_name='商品數量')
    price = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='單價')
    comment = models.TextField(default="", blank=True, verbose_name='評價') # blank=True前端表單允許空白，資料庫則用默認值
    score = models.SmallIntegerField(choices=SCORE_CHOICES, null=True, blank=True, default=None, verbose_name='滿意度評分')
    is_anonymous = models.BooleanField(default=False, verbose_name='是否匿名評價')
    is_commented = models.BooleanField(default=False, verbose_name='是否已評價')

    def __str__(self):
        return f"訂單 {self.order.order_id} - 商品 {self.sku.name} - 數量 {self.count}"
    
    class Meta:
        db_table = 'order_goods'
        verbose_name = '訂單商品'
        verbose_name_plural = verbose_name