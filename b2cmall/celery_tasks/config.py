import os

# celery 異步任務的設定文件

# 指定任務隊列的存放位置(redis資料庫)
broker_url = os.getenv("CELERY_BROKER_URL", "redis://127.0.0.1:6379/2")
result_backend = os.getenv("CELERY_RESULT_BACKEND", "redis://127.0.0.1:6379/2")

