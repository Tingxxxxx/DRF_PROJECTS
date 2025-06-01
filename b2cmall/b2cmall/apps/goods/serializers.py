from  rest_framework.serializers import ModelSerializer
from .models import SKU

class SKUSerializer(ModelSerializer):
    """商品列表序列化器"""

    class Meta:
        model = SKU
        fields = ['id', 'name', 'price', 'default_image_url', 'comments']
