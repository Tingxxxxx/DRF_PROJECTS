from django.conf import settings
from django.template.loader import render_to_string
from celery_tasks.main import celery_app
from goods.utils import get_categories
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
