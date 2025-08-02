from django_elasticsearch_dsl import Document, fields
from django_elasticsearch_dsl.registries import registry

from .models import SKU


@registry.register_document
class GoodsDocument(Document):
    # 定義 Elasticsearch 欄位
    name = fields.TextField(
        # name 欄位同時支援模糊搜尋與精確匹配
        analyzer='ik_max_word_analyzer',
        fields={
            'keyword': fields.KeywordField()  # KeywordField 類型，用於精確匹配
        }
    )
    caption = fields.TextField(
        # caption 欄位適合全文檢索，搭配分詞器實現模糊搜尋
        analyzer='ik_max_word_analyzer'
    )
    
    # 進階篩選與排序用欄位，需要先轉換的寫在這裡，其他可直接在下面Django類中導入
    category = fields.KeywordField()
    price = fields.FloatField()

    # 自動補全欄位
    name_suggest = fields.CompletionField()

    # 以下欄位為資料庫是外鍵或特殊型別，需要覆寫 prepare 方法進行轉換

    def prepare_category(self, instance):
        """
        Elasticsearch 無法自動處理外鍵或複雜物件，
        因此需手動轉成字串或其他基本型態
        """
        return str(instance.category)

    def prepare_price(self, instance):
        """
        資料庫中 price 是 Decimal，
        需轉成 float 才能匯入 Elasticsearch
        """
        return float(instance.price)

    def prepare_name_suggest(self, instance):
        """
        自動補全欄位需覆寫此方法，
        告訴 Elasticsearch 基於什麼資料來做補全
        """
        return [instance.name]

    class Index:
        # Elasticsearch 中索引名稱
        name = 'goods'
        settings = {
            # 將索引切成 1 個主要分片，適合小型或開發環境
            'number_of_shards': 1,
            # 不建立副本分片，資料沒有備份，速度較快但資料安全較低
            'number_of_replicas': 0,
            'analysis': {
                'analyzer': {
                    # 使用 IK 分詞器（ik_max_word）
                    'ik_max_word_analyzer': {
                        'type': 'custom',
                        'tokenizer': 'ik_max_word'
                    }
                }
            }
        }

    class Django:
        model = SKU
        # 基本型態欄位 (str, int, datetime 等) 可直接放這裡自動匯入
        # 若有分詞需求或外鍵欄位則需手動定義並覆寫 prepare 方法
        # 'sales', 'create_time', 'is_launched' 是方便篩選與排序用
        fields = ['id', 'default_image_url', 'comments', 'sales', 'create_time', 'is_launched']

    