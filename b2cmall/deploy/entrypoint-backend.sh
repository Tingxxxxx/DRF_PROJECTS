#!/bin/bash
set -e

# 等待 Elasticsearch 可用
until curl -s http://elasticsearch:9200 >/dev/null; do
  echo "等待 Elasticsearch 啟動..."
  sleep 2
done

echo "📌 執行 Django migrate..."
python manage.py migrate

echo "📌 初始化 Elasticsearch 索引..."
python manage.py search_index --rebuild -f
python manage.py search_index --populate

echo "📌 啟動 uWSGI..."
exec "$@"
