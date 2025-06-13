from django.conf import settings
from django.template.loader import render_to_string
from celery_tasks.main import celery_app
from goods.utils import get_categories
from goods.models import SKU


import os
import logging

logger = logging.getLogger('django')

@celery_app.task()
def generate_static_list_search_html():
    """
    生成靜態的商品列表頁和搜尋結果頁html檔
    """
    # 獲取三級選單資料
    categories = get_categories()

    # 組合上下文資料
    context = {
        'categories':categories
    }

    # 模板渲染
    html_text = render_to_string('list.html', context=context)

     # 將渲染結果輸出為靜態 HTML 檔案
    file_path = os.path.join(settings.GENERATED_STATIC_HTML_FILES_DIR, 'list.html')
    logger.info(f'💾 輸出 HTML 到: {file_path}')
    with open(file_path, 'w', encoding='utf-8') as f: # w模式:文件不存在自動新增，存在則覆寫
        f.write(html_text)

@celery_app.task()
def generate_static_sku_detail_html(sku_id):
    """
    生成靜態商品詳情頁面
    :param sku_id: 商品的 SKU ID
    使用場景：當商品資料更新（新增 SKU、修改規格等）後，重新生成該商品的靜態詳情頁
    """
    print(f"🚀 開始生成 SKU 詳情頁，SKU ID: {sku_id}")

    # 取得商品的三級分類選單結構
    categories = get_categories()

    # 根據 sku_id 查出 SKU 物件
    sku = SKU.objects.get(id=sku_id)

    # 取得 SKU 所有圖片
    sku.images = sku.skuimage_set.all()

    # 取得對應的 SPU 
    goods = sku.goods # Goods類 模型實例

    # 添加臨時屬性 Channel 儲存分類資訊
    goods.channel = goods.category1.goodschannel_set.first() # 取得所屬一級分類
    
    if goods.channel is None:
        print("⚠️ 無對應的 channel，請檢查資料完整性")
        return

    # 取得目前這個 SKU 的預設"規格選擇"
    sku_specs = sku.skuspecification_set.order_by('spec_id') 

    # 當前瀏覽的SKU商品 規格
    sku_key = []
    for spec in sku_specs:  # 取出的spec為SKUSpecification類實例
        sku_key.append(spec.option.id) # 結果:id->[1, 3, 7] == name->[13.3英吋, 深灰色, 512g]

    # 建立 SKU 規格選項對照表（組合 -> sku_id）
    # 對應表的目的是,如果改了其中一個規格選項要知道跳轉到哪個sku實例
    skus = goods.sku_set.all() # 當前spu下的所有sku商品實例

    spec_sku_map = {}
    # spec_sku_map = {
    #     (規格1選項id, 規格2参数id, 規格3参数id, ...): sku_id,
    #     (規格1選項id, 規格2参数id, 規格3参数id, ...): sku_id,
    #     --->
    #    (紅色, 5吋, 512g) -> sku_id =1的商品
    #    (灰色, 5吋, 256g) -> sku_id =2的商品
    # }

    # 取其他SKU商品的預設規格選擇
    for s in skus: # s為 SKU類 模型實例

        # 每個SKU有自己的預設規格，一筆SKU對應一個 skuspecification類 實例
        # 故有幾個skuspecification類 實例，就等同於該SPU有多少下屬SKU
        # 注意: 一定要記得order_by排序，確保 查詢集每次順序一致 ex：顏色 > 尺寸 > 容量
        s_specs = s.skuspecification_set.order_by('spec_id') # 包含多個 skuspecification類 實例的查詢集

        key = [spec.option.id for spec in s_specs] # for循環取出每個模型實例，再取到option欄位，結果:[1, 4, 7]
        spec_sku_map[tuple(key)] = s.id # 將該SKU的規格選項組合 設為key, sku_id為value

    # print('所有SKU的產品規格表',spec_sku_map) # {(1, 4, 7): 1, (1, 3, 7): 2}

    # 取得SPU所有的規格種類
    # 注意: 一定要order_by排序 確保查詢集每次順序一致
    specs = goods.goodsspecification_set.order_by('id') # EX: SPU 為 iPhone10，可選的規格類型:顏色/尺寸/容量 

    # 若當前 sku_key 長度不一致，結束函數
    # sku_key就是商品預設規格 
    # EX: sku_key=[1, 3, 7]，代表該SKU有三個規格類型，故如果與specs長度不同，代表資料有誤
    if len(sku_key) < len(specs):
        print("⚠️ 當前 SKU 規格不完整，中止生成")
        return

    # 動態產生每一個規格選項的對應 SKU ID，讓前端點選時可自動切換
    for index, spec in enumerate(specs):
        # 每輪取出的spec就是 GoodsSpecification類實例
        key = sku_key[:]   # 複製目前這個 SKU 的規格組合 key，例如 [1, 4, 7]

        # 取出該SPU的每個規格選項，有哪些值可選（例如顏色:可選 紅/灰）
        options = spec.specificationoption_set.all() # SpecificationOption類實例

        # 內層循環為模擬前端使用者選擇每一個規格選項，像是顏色、大小時，會對應出什麼 SKU。
        for option in options:
            # 當前處理的規格 ex: key[1]代表顏色 、 key[2]代表大小.... 
            # 循環替換選項值，得到所有排列組合
            key[index] = option.id  # ex : [1,4,7] [2,4,7]......

            # 到前面做好的對照表去查這個組合對應哪個 SKU 
            # 為 SpecificationOption類實例 添加一個臨時屬性 sku_id
            # ex: 選項值=紅色->對應商品1 、選項值=黑色->對應商品2
            option.sku_id = spec_sku_map.get(tuple(key)) # 即每個實例都有三欄 spec(外鍵)、value(選項值)、sku_id(商品)

        # 為 GoodsSpecification 添加臨時屬性 options
        # 將上面新增過欄位的 SpecificationOption類實例 覆值給這個屬性
        spec.options = options # 存的值是 QuerySet


    # 組合模板上下文資料
    context = {
        'categories': categories,  
        'goods': goods, # Goods模型實例
        'specs': specs, # GoodsSpecification模型實例
        'sku': sku # SKU模型實例
    }
    
    # 渲染模板為 HTML
    html_text = render_to_string('detail.html', context=context)

    # 定義輸出路徑
    file_path = os.path.join(settings.GENERATED_STATIC_HTML_FILES_DIR, 'goods/' + str(sku_id) + '.html')
    # print(f"💾 準備輸出 HTML 到：{file_path}")

    # 寫入檔案
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(html_text)

    print(f"✅ 靜態頁已成功寫入！文件位置：{file_path}\n")

"""
context[specs]取到的GoodsSpecification模型實例，內容如下

{
    'id': 4,
    'name': '顏色',
    'goods_id': 2,
    'create_time': datetime.datetime(2018, 4, 14, 2, 10, 32, 810681, tzinfo=datetime.timezone.utc),
    'update_time': datetime.datetime(2018, 4, 14, 2, 10, 32, 810728, tzinfo=datetime.timezone.utc),
    'options': <QuerySet [
        <SpecificationOption: Apple iPhone 8 Plus: 顏色 - 金色>,
        <SpecificationOption: Apple iPhone 8 Plus: 顏色 - 深空灰>,
        <SpecificationOption: Apple iPhone 8 Plus: 顏色 - 銀色>
    ]>
}
    

"""