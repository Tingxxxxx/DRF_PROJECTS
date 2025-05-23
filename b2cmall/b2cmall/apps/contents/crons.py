from collections import OrderedDict
from django.conf import settings
from django.template.loader import render_to_string
import os
import time
from goods.models import GoodsChannel
from .models import ContentCategory



def generate_static_index_html():
    """生成靜態的主頁html文件"""

    print('%s: ✅ 開始執行 generate_static_index_html' % time.ctime())

    # 用來存放分類資料的三級目錄字典（有順序）
    categories = OrderedDict()
    
    # 查詢所有頂層類別對應的頻道資訊，依據 group_id 和 sequence 排序
    channels = GoodsChannel.objects.order_by('group_id', 'sequence')

    for channel in channels:
        group_id = channel.group_id

        # 如果是第一次遇到該 group_id，則初始化其分類結構
        if group_id not in categories:
            categories[group_id] = {
                'channels': [],   # 一級分類清單
                'sub_cats': []    # 二級分類清單(裝物件)（每個二級分類會包含其三級分類）
            }

        # 取得當前頻道對應的一級分類（頂層分類）實例
        cat1 = channel.category

        # 將一級分類資訊加入對應 group 的 channels 清單
        categories[group_id]['channels'].append({
            'id': cat1.id,
            'name': cat1.name,
            'url': channel.url
        })

        # 查詢該一級分類下的所有二級分類（透過自關聯取得子分類）
        cat2_qs = cat1.goodscategory_set.all()

        for cat2 in cat2_qs:
            # 為每個二級分類新增一個臨時屬性 sub_cats，用來存放其三級分類
            cat2.sub_cats = []

            # 查詢並加入三級分類（cat2 的子分類）
            for cat3 in cat2.goodscategory_set.all():
                cat2.sub_cats.append(cat3)

            # 將這個包含三級分類的二級分類實例加入到 sub_cats 清單中
            categories[group_id]['sub_cats'].append(cat2)

    # 廣告內容區塊資料
    contents = {}

    # 獲取所有廣告分類（例如首頁輪播、首頁活動、首頁新品等區塊）
    content_categories = ContentCategory.objects.all()

    for cat in content_categories:
        # 透過反向關聯 cat.content_set 取得該分類下所有的廣告內容
        # 接著篩選出啟用狀態（status=True）的內容，並依據 sequence 排序
        content_list = cat.content_set.filter(status=True).order_by('sequence')

        # 使用該分類的 key 當作字典鍵，對應一份廣告內容清單（QuerySet）
        contents[cat.key] = content_list


    # 組合模板所需的上下文資料
    context = {
        'categories': categories,
        'contents': contents
    }

    # 將 'index.html' 模板用 context 資料渲染成 html_text
    html_text = render_to_string('index.html', context=context)
    
    # 將渲染結果輸出為靜態 HTML 檔案
    file_path = os.path.join(settings.GENERATED_STATIC_HTML_FILES_DIR, 'index.html')
    print(f'💾 輸出 HTML 到: {file_path}')
    with open(file_path, 'w', encoding='utf-8') as f: # w模式:文件不存在自動新增，存在則覆寫
        f.write(html_text)
