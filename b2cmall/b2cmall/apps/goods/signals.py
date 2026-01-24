import logging

from django.db.models.signals import post_save, post_delete
from django.dispatch import receiver

from goods.documents import GoodsDocument
from celery_tasks.html.tasks import generate_static_sku_detail_html
from .models import (
    GoodsCategory, GoodsChannel, Goods, GoodsSpecification,
    SpecificationOption, SKU, SKUImage, SKUSpecification
)

logger = logging.getLogger('django')

def safe_signal_handler(func):
    """
    裝飾器：包裹 signal handler 函數，捕捉並記錄異常，避免信號觸發時中斷整體流程。
    被裝飾函數出錯時，會將錯誤寫入日誌。
    """
    def inner(sender, instance, **kwargs):
        try:
            func(sender, instance, **kwargs)
        except Exception as e:
            logger.error(f"Signal error in {func.__name__}: {e}")
    return inner

def get_all_skus():
    """.iterator() 方法回傳生成器，逐筆讀取資料庫的資料而不是一次性載入"""
    return SKU.objects.iterator()


# 注意:裝飾器是由下往上執行
# 先執行@safe_signal_handler添加異常處理，然後再當將得到的新函數使用@receiver註冊信號使用
@receiver([post_save, post_delete], sender=GoodsCategory)
@safe_signal_handler
def GoodsCategory_changed_callback(sender, instance, **kwargs):
    """
    商品分類改動時，重新生成所有SKU詳情頁，
    以確保左上角的三級選單保持最新。
    """
    for sku in get_all_skus():
        generate_static_sku_detail_html.delay(sku.id)

@receiver([post_save, post_delete], sender=GoodsChannel)
@safe_signal_handler
def GoodsChannel_changed_callback(sender, instance, **kwargs):
    """
    商品頻道改動時，重新生成所有SKU詳情頁，
    保證左上角三級選單資料同步更新。
    """
    for sku in get_all_skus():
        generate_static_sku_detail_html.delay(sku.id)

@receiver([post_save, post_delete], sender=Goods)
@safe_signal_handler
def Goods_changed_callback(sender, instance, **kwargs):
    """
    Goods（SPU）新增/修改/刪除時觸發。
    SPU異動後，旗下所有SKU的詳情頁須重新生成，保持頁面資料同步。
    """
    for sku in instance.sku_set.all():
        generate_static_sku_detail_html.delay(sku.id)

@receiver([post_save, post_delete], sender=GoodsSpecification)
@safe_signal_handler
def GoodsSpecification_changed_callback(sender, instance, **kwargs):
    """
    GoodsSpecification（商品規格）新增/修改/刪除時觸發。
    商品規格變更後，重新生成該商品下所有SKU的詳情頁。
    """
    for sku in instance.goods.sku_set.all():
        generate_static_sku_detail_html.delay(sku.id)

@receiver([post_save, post_delete], sender=SpecificationOption)
@safe_signal_handler
def SpecificationOption_changed_callback(sender, instance, **kwargs):
    """
    SpecificationOption（規格選項）新增/修改/刪除時觸發。
    某個規格選項變更，重新生成該規格所屬商品下所有SKU詳情頁。
    """
    spu_spec = instance.spec
    for sku in spu_spec.goods.sku_set.all():
        generate_static_sku_detail_html.delay(sku.id)

@receiver([post_save], sender=SKU)
@safe_signal_handler
def SKU_changed_callback(sender, instance, **kwargs):
    """
    SKU（具體商品）新增或修改時觸發。
    由於執行邏輯刪除，故只監聽 post_save 訊號，
    當SKU變動時直接生成該SKU的靜態詳情頁。
    """
    generate_static_sku_detail_html.delay(instance.id)

@receiver([post_save, post_delete], sender=SKUImage)
@safe_signal_handler
def SKUImage_changed_callback(sender, instance, **kwargs):
    """
    SKUImage（SKU圖片）新增/修改/刪除時觸發。
    1. 若該SKU尚未設定預設圖片，則將當前新增的圖片設為預設。
    2. 重新生成該SKU的詳情頁。
    """
    sku = instance.sku

    # 如果沒有設定預設圖片，則把當前圖片設為預設圖片
    if not sku.default_image_url:
        sku.default_image_url = instance.image.url
        sku.save(update_fields=['default_image_url'])  # 精準更新欄位

    generate_static_sku_detail_html.delay(sku.id)

@receiver([post_save, post_delete], sender=SKUSpecification)
@safe_signal_handler
def SKUSpecification_changed_callback(sender, instance, **kwargs):
    """
    SKUSpecification（SKU規格）新增/修改/刪除時觸發。
    SKU規格變動後，重新生成該SKU的詳情頁。
    """
    generate_static_sku_detail_html.delay(instance.sku.id)


# ----- Elasticsearch 索引同步信號區塊 -----

# 當 SKU 模型資料被新增或更新時，自動同步到 Elasticsearch 索引中
@receiver([post_save], sender=SKU)
def update_goods_document(sender, instance, **kwargs):
    # 使用 django-elasticsearch-dsl 提供的 update 方法：
    # 若該資料已存在於 Elasticsearch 索引中 → 執行更新；
    # 若資料不存在於索引中 → 自動新增。
    GoodsDocument().update(instance)
    logger.info(f'商品:{instance.name} 資料異動，更新索引')


# 當 SKU 模型資料被刪除時，自動從 Elasticsearch 索引中移除對應文件
@receiver([post_delete], sender=SKU)
def delete_goods_document(sender, instance, **kwargs):
    # 使用 delete 方法將該資料從 Elasticsearch 中移除
    GoodsDocument().delete(instance)
    logger.info(f'商品:{instance.name} 資料異動，更新索引')

