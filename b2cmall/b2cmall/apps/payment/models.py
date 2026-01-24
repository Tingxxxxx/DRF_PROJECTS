from django.db import models

from orders.models import OrderInfo
from b2cmall.utils.models import BaseModel


# Create your models here.
class ECPayTransaction(BaseModel):

    STATUS_ENUM = {
        '待付款': 0,
        '已付款': 1,
        '付款失敗': 2,
    }

    STATUS_CHOICES = (
        (0, '待付款'),
        (1, '已付款'),
        (2, '付款失敗'),
    )

    order = models.ForeignKey(
        OrderInfo,
        on_delete=models.CASCADE,
        related_name="ecpay_transactions",
        verbose_name="關聯訂單"
    )

    status = models.SmallIntegerField(
        choices=STATUS_CHOICES,
        default=STATUS_ENUM['待付款'], # 支援超商繳費等延遲付款方式時，方便記錄狀態
        verbose_name="綠界訂單狀態"
    )

    merchant_trade_no = models.CharField(
        max_length=32,
        unique=True,
        verbose_name="特店訂單編號（MerchantTradeNo）"
    )

    trade_no = models.CharField(
        max_length=32,
        blank=True,
        null=True,
        verbose_name="綠界交易編號（TradeNo）"
    )

    rtn_code = models.CharField(
        max_length=10,
        blank=True,
        null=True,
        verbose_name="交易結果代碼（RtnCode）"
    )

    rtn_msg = models.TextField(
        blank=True,
        null=True,
        verbose_name="交易結果訊息（RtnMsg）"
    )

    payment_type = models.CharField(
        max_length=32,
        blank=True,
        null=True,
        verbose_name="付款方式（PaymentType）"
    )

    payment_date = models.DateTimeField(
        null=True,
        blank=True,
        verbose_name="付款完成時間（PaymentDate）"
    )

    payment_type_charge_fee = models.IntegerField(
        null=True,
        blank=True,
        verbose_name="手續費（PaymentTypeChargeFee）"
    )

    trade_amt = models.IntegerField(   # 綠界中金額一定是整數，故不用decimal
        verbose_name="實際付款金額（TradeAmt）"
    )

    simulate_paid = models.BooleanField(
        default=False,
        verbose_name="是否為模擬付款（SimulatePaid）"  # 1 為模擬，0 為正式
    )

    class Meta:
        verbose_name = "綠界交易紀錄"
        verbose_name_plural = "綠界交易紀錄"
        ordering = ['-create_time']

    def __str__(self):
        return f"{self.merchant_trade_no} - {self.trade_amt} 元"
