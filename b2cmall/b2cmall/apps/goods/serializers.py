from rest_framework import serializers
from rest_framework.serializers import ModelSerializer
from django_elasticsearch_dsl_drf.serializers import DocumentSerializer

from .documents import GoodsDocument
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


class GoodsDocumentSerializer(DocumentSerializer):
    """
    將 Elasticsearch 搜尋結果序列化回傳給前端(ES搜尋結果格式與一般DRF不同)

    注意事項:
    - 繼承自 DocumentSerializer（不是 DRF 的 ModelSerializer）
    - 僅包含要給前端顯示的欄位
    - 排序或搜索用欄位（如 caption、sales、create_time）不需回傳，可不列入 fields
    """
    class Meta:
        document = GoodsDocument 
        # 注意:這裡要用元組
        fields = ( # 會返回給前端看到的欄位
            'id',
            'name',
            'price',
            'default_image_url',
            'comments',
            'name_suggest', 
        ) 


"""
✅ ES 搜尋結果格式(序列化前):
{
  "took": 107,
  "timed_out": false,
  "_shards": {
    "total": 1,
    "successful": 1,
    "skipped": 0,
    "failed": 0
  },
  "hits": {
    "total": {
      "value": 16,
      "relation": "eq"
    },
    "max_score": 1,
    "hits": [ # 重點
      {
        "_index": "goods",
        "_type": "_doc",
        "_id": "1",
        "_score": 1,
        "_source": {
          "name": "Apple MacBook Pro 13.3英吋筆記型電腦 銀色",
          "caption": "【全新2017款】MacBook Pro，一身才華，一觸，即發 了解【黑五返場特惠】 更多產品請點擊【美多官方Apple旗艦店】",
          "category": "電腦整機 - 筆電",
          "price": 11388,
          "name_suggest": [
            "Apple MacBook Pro 13.3英吋筆記型電腦 銀色"
          ],
          "id": 1,
          "default_image_url": "https://drfmall.s3.amazonaws.com/goods008.jpg",
          "comments": 1,
          "sales": 431,
          "create_time": "2018-04-11T17:28:21.804713+00:00",
          "is_launched": true
        }
      },....

✅ 經過 GoodsDocumentSerializer 序列化後：

[
  {
    "id": 1,
    "name": "Apple MacBook Pro 13.3英吋筆記型電腦 銀色",
    "price": 11388.0,
    "default_image_url": "https://drfmall.s3.amazonaws.com/goods008.jpg",
    "comments": 1,
    "name_suggest": [
      "Apple MacBook Pro 13.3英吋筆記型電腦 銀色"
    ]
  },
  ...
]

"""