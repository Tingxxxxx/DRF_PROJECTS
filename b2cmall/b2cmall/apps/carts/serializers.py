from rest_framework import serializers
from goods.models import SKU

class Cartserializer(serializers.Serializer):
    """購物車序列化器"""
    sku_id = serializers.IntegerField(min_value=1, label='商品sku_id')
    count = serializers.IntegerField(min_value=1, label='商品數量')
    selected =serializers.BooleanField(default=True, label='是否勾選')

    def validate_sku_id(self, value):
        try:
            SKU.objects.get(id=value)
        
        except SKU.DoesNotExist:
            raise serializers.ValidationError('商品不存在')
        
        return value