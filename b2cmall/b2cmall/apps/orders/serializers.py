import logging
from decimal import Decimal

from django.utils import timezone
from django.db import transaction, DatabaseError
from django.db.models import F
from django_redis import get_redis_connection
from rest_framework import serializers

from .models import OrderGoods, OrderInfo
from goods.models import SKU, Goods

# 常數定義
MAX_RETRY_TIME = 5  # 訂單提交最大可重試次數

# Logger 設定
logger = logging.getLogger('django')


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


# class CommitOrderSerializer(serializers.ModelSerializer):
#     """提交訂單使用的序列化器"""

#     class Meta:
#         model = OrderInfo
#         fields = ['order_id', 'address', 'pay_method']
#         read_only_fields = ['order_id'] # 訂單編號只做序列化輸出
#         extra_kwargs = {  # 只做反序列化，不會輸出給前端
#             'address':{
#                 'write_only':True
#                 },
#             'pay_method':{
#                 'write_only':True
#                 }
#         }

#     def create(self, validated_data):
#         """
#         建立訂單的核心邏輯方法。

#         操作步驟如下:
#         1. 產生唯一訂單編號（由當前時間與 user.id 組成）。
#         2. 根據傳入 address 與 pay_method 建立 OrderInfo 初始資料。
#         3. 從 Redis 中取得購物車勾選商品與數量。
#         4. 對每一項商品：
#             - 驗證庫存是否足夠。
#             - 使用樂觀鎖（compare-and-update）方式更新 SKU 表中的庫存與銷量，以避免高併發下的資源搶奪。
#             - 累計商品總數與總金額。
#             - 建立 OrderGoods 記錄。
#             - 同步更新對應 Goods 總銷量。
#         5. 所有操作包裹於 `transaction.atomic()` 交易區塊中，並設定保存點以便回滾。
#         6. 若中途任何商品庫存不足，或資料庫錯誤，則回滾保存點並拋出錯誤。
#         7. 若無錯誤，提交交易，並從 Redis 購物車中移除已下單商品。

#         交易控制與一致性策略:
#         ----------------
#         - 使用 Django 的 `transaction.atomic()` 實現顯式資料庫交易。
#         - 透過 `transaction.savepoint()` 設定手動保存點，便於中間回滾。
#         - 資料庫隔離級別為「讀已提交（Read Committed）」，可避免「髒讀」，
#         且在搭配樂觀鎖時，可較有效降低資源競爭風險。  
#         """

#         # 獲取用戶
#         user = self.context['request'].user
#         logger.info(f'用戶:{user.username}:嘗試下單')

#         # 生成訂單編號
#         order_id = timezone.localtime().strftime('%Y%m%d%H%M%S') + '%08d' % user.id # ex: 2025071522593 + 00000042(不足8位補0)
#         logger.info(f'用戶:{user.username}，生成訂單編號:{order_id}')

#         # 獲取收貨地址與付款方式
#         address = validated_data.get('address')
#         pay_method = validated_data.get('pay_method')

#         # 判斷訂單狀態
#         status = (OrderInfo.ORDER_STATUS_ENUM['UNPAID'] # 線上支付，則訂單狀態為待支付
#                   if pay_method == OrderInfo.PAY_METHOD_ENUM['ONLINE'] 
#                   else OrderInfo.ORDER_STATUS_ENUM['UNSEND'] # 貨到付款，則訂單狀態為待出貨
#                   )
#         logger.info(f'用戶:{user.username}開啟交易')
#         # 手動開啟交易
#         with transaction.atomic():

#             # 創建交易回滾點
#             save_point = transaction.savepoint()

#             # 捕獲異常，出現則交易回滾
#             try:   
#                 # 創建OrderInfo訂單模型
#                 order_info = OrderInfo.objects.create(
#                     order_id = order_id,
#                     user = user,
#                     address = address,
#                     total_count = 0, # 暫賦為0，後續查redis再改
#                     total_amount = Decimal('0.00'), # 暫賦為0，後續查redis再改
#                     freight = Decimal('60.00'),
#                     pay_method = pay_method,
#                     status = status
#                 )

#                 # 查詢redis中 hash跟set
#                 cart_key = f'{user.id}:cart'
#                 selected_key = f'{user.id}:selected'
#                 redis_conn = get_redis_connection('cart')

#                 redis_cart = redis_conn.hgetall(cart_key)
#                 selected_ids = redis_conn.smembers(selected_key)

#                 if not selected_ids:
#                     raise serializers.ValidationError('當前購物車無勾選商品')
            
#                 # 遍歷購物車勾選的商品
#                 for sku_id_bytes in selected_ids:

#                     retry_count=0 # 嘗試次數
#                     while MAX_RETRY_TIME > retry_count:

#                         # 注意:不要直接使用.filter(id__in=...)全查出，而是用一個取一個，來保證數據都是最新的，避免資源搶奪
#                         sku_id = int(sku_id_bytes)
#                         sku = SKU.objects.get(id=sku_id)

#                         want_buy = int(redis_cart[sku_id_bytes]) # 購買數量
#                         # 提前將要用到的欄位都先查出，避免後續交易出錯資料庫被鎖定查無
#                         goodname = sku.name
#                         price = sku.price
#                         spu_id = sku.goods_id
#                         origin_stock = sku.stock
#                         origin_sales = sku.sales

#                         # 判斷庫存
#                         if origin_stock < want_buy:    
#                             raise serializers.ValidationError(f"庫存不足: {goodname}")
                        
#                         # 修改SKU表(此寫法會有資源搶奪問題)
#                         # new_stock = origin_stock - want_buy
#                         # new_sales = origin_sales + want_buy
#                         # sku.stock = new_stock
#                         # sku.sales = new_sales
#                         # sku.save()

#                         # 使用樂觀鎖解決資源搶奪問題，在正式修改表的資料前，在查一次數據
#                         # 數據與前次相同: 無資源搶奪問題，可直接修改
#                         # 數據與前次不同: 有資源有爭搶，則不修改
#                         # 累加計算商品數量與總價
#                         update_count = SKU.objects.filter(id=sku_id, stock=origin_stock, sales=origin_sales).update(
#                             stock=F('stock') - want_buy, # 使用F表達式確保資料庫數據是最新的
#                             sales=F('sales') + want_buy
#                         ) 
#                         # .update()會返回更新幾條紀錄
#                         if update_count ==0:
#                             retry_count +=1 
#                             logger.info(f"{goodname}:  第{retry_count}次重試下單")
#                             continue # 如果無更新紀錄，跳出此輪，繼續下一輪while嘗試下單
                        
#                         # 累計SPU總銷量
#                         Goods.objects.filter(id=spu_id).update(
#                             sales=F('sales')+want_buy
#                         )
#                         # 訂單總價與商品總數量
#                         order_info.total_amount += (price * want_buy)
#                         order_info.total_count += want_buy

#                         # 創建訂單商品模型
#                         OrderGoods.objects.create(
#                             order = order_info,
#                             sku = sku,
#                             count = want_buy,
#                             price = price
#                         )

#                         # 更新成功，跳出循環  
#                         logger.info(f"訂單商品細項建立成功!")
#                         break 

#                     # 如果 while 結束但沒有 break，代表超過重試次數
#                     else:
#                         transaction.savepoint_rollback(save_point)  # 回滾
#                         raise serializers.ValidationError(f"商品 {goodname} 庫存緊張，請稍後重試")

#                 # 加入運費金額並保存訂單資訊
#                 order_info.total_amount += order_info.freight
#                 order_info.save()
#                 logger.info(f"訂單建立成功!")

#             # 庫存不足
#             except serializers.ValidationError:
#                 logger.error('交易中出現異常，回滾保存點')
#                 transaction.savepoint_rollback(save_point) # 回滾
#                 raise # 一定要寫，為了把原本捕捉到的 ValidationError 重新拋出

#             except DatabaseError as db_err:
#                 transaction.savepoint_rollback(save_point) # 回滾
#                 logger.error(f"資料庫錯誤: {db_err}")
#                 raise serializers.ValidationError('系統繁忙，請稍後重試')
                        
#             # 其他異常
#             except Exception as e:
#                 transaction.savepoint_rollback(save_point) # 回滾
#                 logger.exception('訂單建立異常')
#                 raise serializers.ValidationError('訂單建立時發生未知錯誤，請稍後重試')

#             else:
#                 # 沒有異常則commit提交
#                 transaction.savepoint_commit(save_point) 
#                 logger.info('當前交易已提交，清除已結算的購物車商品')
#                 # 清除購物車中已結算商品
#                 pipe = redis_conn.pipeline()
#                 pipe.hdel(cart_key, *selected_ids)
#                 pipe.srem(selected_key, *selected_ids)
#                 pipe.execute()

#         return order_info


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

    def _generate_order_id(self,user):
        order_id = timezone.localtime().strftime('%Y%m%d%H%M%S') + str(user.id).zfill(4) # 
        logger.info(f'用戶:{user.username}，生成訂單編號:{order_id}')
        return order_id
    
    def _get_cart_from_redis(self, user):
        redis_conn = get_redis_connection('cart')
        redis_cart = redis_conn.hgetall(f'{user.id}:cart')
        selected_ids = redis_conn.smembers(f'{user.id}:selected')
        return redis_cart, selected_ids
    
    def _clear_cart(self, user, selected_ids):
        try:
            redis_conn = get_redis_connection('cart')
            pipe = redis_conn.pipeline()
            pipe.hdel(f'{user.id}:cart', *selected_ids)
            pipe.srem(f'{user.id}:selected', *selected_ids)
            pipe.execute()
        except Exception as e:
            logger.warning(f"清除購物車時失敗: {e}")
    
    def _commit_single_sku(self, sku_id_bytes, redis_cart, order_info, save_point):
        retry_count=0 # 嘗試次數
        sku_id = int(sku_id_bytes)
        goodname = f"ID:{sku_id}"  # fallback 名稱（預防while出錯，未成功取得 sku.name）

        while MAX_RETRY_TIME > retry_count: # 嘗試建立當前商品訂單

            try:
                sku = SKU.objects.get(id=sku_id) # 不要直接 id__in=...全查出，保持數據即時性
                
            except SKU.DoesNotExist:
                transaction.savepoint_rollback(save_point)
                raise serializers.ValidationError(f"商品 {goodname} 不存在，請重新整理頁面")
            
            # 提前將要用到的欄位都先查出，避免後續交易出錯資料庫被鎖定
            want_buy = int(redis_cart[sku_id_bytes].decode()) 
            logger.info(f"{goodname} 欲購買數量: {want_buy}")
            goodname = sku.name
            price = sku.price
            spu_id = sku.goods_id
            origin_stock = sku.stock
            origin_sales = sku.sales

            # 庫存不足則拋出異常
            if origin_stock < want_buy:    
                raise serializers.ValidationError(f"庫存不足: {goodname}")

            # 庫存充足，則修改sku、spu表庫存與銷量
            # 使用樂觀鎖解決資源搶奪問題，在正式修改表的資料前，在查一次數據
            # 數據與前次相同: 無資源搶奪問題，可直接修改
            # 數據與前次不同: 有資源有爭搶，則不修改
            # 累加計算商品數量與總價
            update_count = SKU.objects.filter(
                id=sku_id, stock=origin_stock, sales=origin_sales).update(
                stock=F('stock') - want_buy, # 使用F表達式更新欄位確保資料庫數據是最新的
                sales=F('sales') + want_buy
            )

            # 判斷當前sku是否發生資源搶奪(更新0筆數據)
            if update_count ==0:
                retry_count +=1 
                logger.info(f"{goodname}:  第{retry_count}次重試下單")
                continue # 跳過當前循環，繼續下一輪嘗試
 
            # 如順利更新SKU表，則累計SPU總銷量
            Goods.objects.filter(id=spu_id).update(
                sales=F('sales')+want_buy
            )

            # 更新訂單總價與商品總數量
            order_info.total_amount += (price * want_buy)
            order_info.total_count += want_buy

            # 創建購買訂單商品模型
            OrderGoods.objects.create(
                order = order_info,
                sku = sku,
                count = want_buy,
                price = price
            )

            logger.info(f"商品:{goodname}，訂單建立成功!")
            break  # 跳出當前商品下單循環，進入下一個商品結算

        # MAX_RETRY_TIME 次，當前商品下單都沒成功
        else:
            transaction.savepoint_rollback(save_point)  # 回滾
            raise serializers.ValidationError(f"商品 {goodname} 庫存緊張，請稍後重試")

    def create(self, validated_data):

        # 獲取用戶
        user = self.context['request'].user
        logger.info(f'用戶:{user.username}:嘗試下單')

        # 生成訂單編號
        order_id = self._generate_order_id(user)

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
            logger.info(f'用戶:{user.username}開啟交易')

            # 創建交易回滾點
            save_point = transaction.savepoint()

            # 創建訂單
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

                # 獲取redis購物車資料
                redis_cart, selected_ids = self._get_cart_from_redis(user)
                
                if not selected_ids: # 如果set 為空
                    raise serializers.ValidationError('當前購物車無勾選商品')

                # 取出勾選的商品
                for sku_id_bytes in selected_ids:
                    # 修改SPU、SKU，新增訂單商品模型
                    self._commit_single_sku(sku_id_bytes, redis_cart, order_info, save_point) # 如調用此方法出現異常會被捕獲

                # 所有訂單商品都已完成，加入運費到訂單總價中
                order_info.total_amount += order_info.freight
                order_info.save() 
                logger.info(f"訂單編號:{order_id}建立成功!")

            # 庫存不足、購物車結帳商品為空
            except serializers.ValidationError:
                logger.error('交易中出現異常，回滾保存點')
                transaction.savepoint_rollback(save_point) # 回滾
                raise # 一定要寫，為了把原本捕捉到的 ValidationError 重新拋出
            
            except DatabaseError as db_err:
                transaction.savepoint_rollback(save_point) # 回滾
                logger.error(f"資料庫錯誤: {db_err}")
                raise serializers.ValidationError('系統繁忙，請稍後重試')
                        
            # 其他異常
            except Exception as e:
                transaction.savepoint_rollback(save_point) # 回滾
                logger.exception(f'訂單遍號:{order_id} 建立時出現異常')
                raise serializers.ValidationError('訂單建立時發生未知錯誤，請稍後重試')
            
            # 沒有異常，則commit提交
            else:
                transaction.savepoint_commit(save_point)  # 提交交易
                logger.info('當前交易已提交，清除已結算的購物車商品')
                # 清除購物車中已結算商品
                self._clear_cart(user, selected_ids)

        return order_info

