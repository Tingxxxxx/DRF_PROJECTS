from rest_framework import serializers
from rest_framework.serializers import ModelSerializer

from .models import SKU, GoodsCategory, GoodsChannel

class SKUSerializer(ModelSerializer):
    """商品列表序列化器"""

    class Meta:
        model = SKU
        fields = ['id', 'name', 'price', 'default_image_url', 'comments']


class CategorySerializer(ModelSerializer):
    """商品分類類別序列化器"""
    class Meta:
        model = GoodsCategory
        fields = ['id', 'name']


class ChannelSerializer(ModelSerializer):
    """商品頻道序列化器(管理一級類別)"""
    category_name = serializers.CharField(source='category.name', read_only=True)

    class Meta:
        model = GoodsChannel
        fields = ['id', 'category_name', 'url']


class HotSKUSerializer(ModelSerializer):
    """當前商品類別中熱銷商品的序列化器"""
    class Meta:
        model = SKU
        fields = ['id', 'name', 'category', 'sales', 'price', 'default_image_url']
