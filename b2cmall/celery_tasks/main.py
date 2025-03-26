# 此為celery 異步任務的啟動文件

# # 1. 導包
import os
from celery import Celery
from celery import Celery 
# 設置默認的 Django 配置模組
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'b2cmall.settings.dev')




# 2. 建立 celery實例物件
celery_app = Celery("django") # ""內為取別名，也可不寫

# 3.加載設定檔文件
celery_app.config_from_object('celery_tasks.config')

# 4. 自動註冊異步任務
# 注意:任務資料夾寫在[]裡，如有複數則[a,b,....]
celery_app.autodiscover_tasks(['celery_tasks.verifycode']) # 註冊verifycode包內的所有異步任務
