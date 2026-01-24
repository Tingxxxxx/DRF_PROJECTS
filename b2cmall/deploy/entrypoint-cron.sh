#!/bin/bash
set -e

echo "📌 註冊 django-crontab 任務..."

# 移除舊的 crontab 任務（允許失敗）
python manage.py crontab remove || true

# 新增 crontab 任務
python manage.py crontab add

echo "📌 啟動 cron 前景服務..."

# 前景模式啟動 cron，確保 Docker 容器 PID 1 不退出
# 使用 www-data 用戶啟動（Dockerfile 已指定 USER www-data）
cron -f
