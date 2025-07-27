import logging
from datetime import datetime
from django.utils import timezone
from rest_framework import serializers

from orders.models import OrderInfo
from .models import ECPayTransaction

logger = logging.getLogger('django')


class ECPayPaymentNotifySerializer(serializers.ModelSerializer):
    """
    根據綠界付款結果通知，更新資料庫綠界訂單用的序列化器
    """
    # order 欄位因此時資料庫已經有了，故不定義
    MerchantTradeNo = serializers.CharField(source='merchant_trade_no', label='特店訂單編號')
    TradeNo = serializers.CharField(source='trade_no', label='綠界交易編號')
    RtnCode = serializers.CharField(source='rtn_code', label='交易結果代碼')
    RtnMsg = serializers.CharField(source='rtn_msg', label='交易結果訊息')
    PaymentType = serializers.CharField(source='payment_type', label='付款方式')
    PaymentDate = serializers.CharField(source='payment_date', label='付款完成時間')
    PaymentTypeChargeFee = serializers.CharField(source='payment_type_charge_fee', label='手續費')
    TradeAmt = serializers.CharField(source='trade_amt', label='商品總價')
    SimulatePaid = serializers.CharField(source='simulate_paid', label='是否為模擬付款')

    def validate_PaymentDate(self, value):
        """
        將付款日期從字串轉成 aware datetime，若無效則設為 None。
        """
        try:
            if not value:
                return None
            dt = datetime.strptime(value, '%Y/%m/%d %H:%M:%S') # 將 str轉成 datetime obj
            if dt.year < 1000:  # MySQL 限制日期範圍：1000-01-01 ~ 9999-12-31
                return None
            return timezone.make_aware(dt)
        except Exception as e:
            logger.error(f'validate_PaymentDate 轉換錯誤: {e}，輸入值: {value}')
            raise serializers.ValidationError('資料類型轉換錯誤')

    def validate_PaymentTypeChargeFee(self, value):
        """
        驗證並轉換手續費欄位為整數。
        """
        try:
            return int(value) if value else 0
        except Exception as e:
            logger.error(f'validate_PaymentTypeChargeFee 轉換錯誤: {e}，輸入值: {value}')
            raise serializers.ValidationError('手續費格式錯誤')

    def validate_TradeAmt(self, value):
        """
        驗證付款金額是否與訂單金額相符。
        """
        try:
            # 如果在視圖中有傳instance  ex:MySerializer(data=..., instance=my_obj, partial=True) 那這裡就可以取到self.instance屬性
            if not self.instance or not hasattr(self.instance, 'order'):
                raise serializers.ValidationError('序列化器需綁定 instance 且 instance.order 必須存在')

            order = self.instance.order
            order_amt = int(order.total_amount)
            value = int(value)

            if order_amt != value:
                logger.error(
                    f'付款金額不符: MerchantTradeNo={self.instance.merchant_trade_no}, '
                    f'訂單金額={order_amt}, 傳入金額={value}'
                )
                raise serializers.ValidationError('付款金額與商品訂單不符')

            return value

        except Exception as e:
            logger.error(f'validate_TradeAmt 轉換錯誤: {e}，輸入值: {value}')
            raise serializers.ValidationError('資料類型轉換錯誤')

    def validate_SimulatePaid(self, value):
        """
        將模擬付款字串轉換為 0（正式）或 1（模擬）。
        """
        return 0 if value == '0' else 1

    def update(self, instance, validated_data):
        """
        更新交易資料後，同步變更對應訂單狀態。
        """
        instance = super().update(instance, validated_data)

        order = instance.order
        logger.info(f'交易結果代碼: {instance.rtn_code}')

        if instance.rtn_code == '1':
            instance.status = ECPayTransaction.STATUS_ENUM['已付款']
            order.status = OrderInfo.ORDER_STATUS_ENUM['UNSEND']  # 更新訂單狀態為「待出貨」
        else:
            instance.status = ECPayTransaction.STATUS_ENUM['付款失敗']

        instance.save()
        order.save()

        logger.info(f'更新綠界訂單狀態: {instance.merchant_trade_no}, 新狀態={instance.get_status_display()}')
        logger.info(f'更新站內訂單狀態: {order.order_id}, 新狀態={order.get_status_display()}')

        return instance

    class Meta:
        model = ECPayTransaction
        fields = [
            'MerchantTradeNo', 'TradeNo', 'RtnCode', 'RtnMsg',
            'PaymentType', 'PaymentDate', 'PaymentTypeChargeFee',
            'TradeAmt', 'SimulatePaid'
        ]

