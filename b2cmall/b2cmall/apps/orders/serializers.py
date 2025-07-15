from rest_framework import serializers
from goods.models import SKU

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