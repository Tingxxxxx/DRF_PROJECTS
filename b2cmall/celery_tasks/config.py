# celery 異步任務的設定文件

# 指定任務隊列的存放位置(redis資料庫)
broker_url = 'redis://127.0.0.1:6379/3'

# 設定結果後端 (可以是 Redis)
result_backend = 'redis://127.0.0.1:6379/0'  # 使用 Redis 的第 0 號資料庫存放結果