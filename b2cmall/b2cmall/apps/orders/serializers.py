from django.utils import timezone
from rest_framework import serializers
from .models import OrderGoods, OrderInfo
from goods.models import SKU
from decimal import Decimal
from django_redis import get_redis_connection
from django.db import transaction

class CartSKUSerializer(serializers.ModelSerializer):
    """
    訂單中商品基本資料與購買數量的序列化器
    """
    count = serializers.IntegerField(label='商品數量') # 不是原本模型的欄位，是動態添加的購買數量

    class Meta:
        model = SKU
        fields = ('id', 'name', 'default_image_url', 'price', 'count')


class OrderSettlementSerializer(serializers.Serializer):
    """
    訂單完整資料的序列化器

    預期格式:
    {
        "freight": "60.00",
        "skus": [
            {
            "id": 1,
            "name": "商品A",
            "default_image_url": "http://xxx.jpg",
            "price": "100.00",
            "count": 2
            },
            {
            "id": 2,
            "name": "商品B",
            "default_image_url": "http://yyy.jpg",
            "price": "200.00",
            "count": 1
            }
        ]
        }

    """
    freight = serializers.DecimalField(max_digits=10, decimal_places=2, label='運費')
    skus = CartSKUSerializer(many=True) # 調用上面的序列化器


class CommitOrderSerializer(serializers.ModelSerializer):
    """提交訂單使用的序列化器"""

    class Meta:
        model = OrderInfo
        fields = ['order_id', 'address', 'pay_method']
        read_only_fields = ['order_id'] # 訂單編號只做序列化輸出
        extra_kwargs = {  # 只做反序列化，不會輸出給前端
            'address':{
                'write_only':True
                },
            'pay_method':{
                'write_only':True
                }
        }

    def create(self, validated_data):

        # 獲取用戶
        user = self.context['request'].user

        # 生成訂單編號
        order_id = timezone.localtime().strftime('%Y%m%d%H%M%S') + '%08d' % user.id # ex: 2025071522593 + 00000042(不足8位補0)

        # 獲取收貨地址與付款方式
        address = validated_data.get('address')
        pay_method = validated_data.get('pay_method')

        # 判斷訂單狀態
        status = (OrderInfo.ORDER_STATUS_ENUM['UNPAID'] # 線上支付，則訂單狀態為待支付
                  if pay_method == OrderInfo.PAY_METHOD_ENUM['ONLINE'] 
                  else OrderInfo.ORDER_STATUS_ENUM['UNSEND'] # 貨到付款，則訂單狀態為待出貨
                  )
        
        # 手動開啟交易
        with transaction.atomic():

            # 創建交易回滾點
            save_point = transaction.savepoint()

            # 捕獲異常，出現則交易回滾
            try:   
                # 創建OrderInfo訂單模型
                order_info = OrderInfo.objects.create(
                    order_id = order_id,
                    user = user,
                    address = address,
                    total_count = 0, # 暫賦為0，後續查redis再改
                    total_amount = Decimal('0.00'), # 暫賦為0，後續查redis再改
                    freight = Decimal('60.00'),
                    pay_method = pay_method,
                    status = status
                )

                # 查詢redis中 hash跟set
                cart_key = f'{user.id}:cart'
                selected_key = f'{user.id}:selected'
                redis_conn = get_redis_connection('cart')

                redis_cart = redis_conn.hgetall(cart_key)
                selected_ids = redis_conn.smembers(selected_key)
            
                # 遍歷購物車勾選的商品
                for sku_id_bytes in selected_ids:
                    # 逐一取得商品模型
                    # 注意:不要直接使用.filter(id__in=...)全查出，而是用一個取一個，來保證數據都是最新的，避免資源搶奪
                    sku = SKU.objects.get(id=int(sku_id_bytes))

                    want_buy = int(redis_cart[sku_id_bytes])

                    # 判斷庫存
                    if sku.stock < want_buy:    
                        raise serializers.ValidationError(f"庫存不足: {sku.name}!")
                    
                    # 減少庫存，修改SKU表銷量
                    sku.stock -= want_buy
                    sku.sales += want_buy

                    # 修改SPU表銷量
                    spu = sku.goods
                    spu.sales += want_buy

                    spu.save()
                    sku.save()

                    # 累加計算商品數量與總價
                    order_info.total_amount += sku.price * want_buy
                    order_info.total_count += want_buy

                    # 創建訂單商品模型
                    OrderGoods.objects.create(
                        order = order_info,
                        sku = sku,
                        count = want_buy,
                        price = sku.price
                    )

                # 加入運費金額並保存訂單資訊
                order_info.total_amount += order_info.freight
                order_info.save()
            
            # 庫存不足
            except serializers.ValidationError:
                transaction.savepoint_rollback(save_point) # 回滾保存點
                raise # 一定要寫，為了把原本捕捉到的 ValidationError 重新拋出
            
            # 其他異常
            except Exception as e:
                transaction.savepoint_rollback(save_point) # 回滾保存點
                raise serializers.ValidationError(f'訂單建立時出現錯誤:{e}')

            else:
                # 沒有異常則commit提交
                transaction.savepoint_commit(save_point) 
                # 清除購物車中已結算商品
                redis_conn.delete(selected_key)
                redis_conn.hdel(cart_key, *selected_ids)
        
        return order_info