from rest_framework.serializers import ModelSerializer
from .models import Region

class AreasListSerializer(ModelSerializer):
    """用戶地址查LIST視圖序列化器"""
    class Meta:
        model = Region
        fields = ['id', 'name']

