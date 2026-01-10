# 🐳 Django Docker 本地模擬正式部署筆記
📌 說明｜本地模擬正式部署

本文件說明如何在本機環境（Local），使用 Docker + Docker Compose，完整模擬一套接近正式（Production）環境的 Django 專案部署架構。

## ✅ 可在本機完整運行的「正式架構」

### 本地電腦將同時運行下列服務容器，並以正式部署方式協同工作：

- **Django Backend（uWSGI）**

    使用 prod settings

    DEBUG=False

    提供正式 API 服務

- **Nginx**

  提供前端靜態頁面

  反向代理後端 API

- **MySQL 主從架構**

  本地主機：Master

  Docker 容器：Slave（唯讀）

- **Redis**

  快取與 Celery Broker

- **Celery Worker**

  處理非同步任務（寄信、產生靜態頁等）

- **Django Crontab**

  定時任務（首頁 / 商品頁靜態化）

- **Elasticsearch**

  商品搜尋與索引服務


### **所有服務皆透過 Docker network 以「服務名稱」互相通訊**

<br>

## 一、Django settings 修改

### 1️⃣ 資料庫與服務連線（改用 Docker 容器名）
📌 說明：
Docker 內部容器彼此通訊 不能使用 127.0.0.1，需改為「服務容器名」
```py
# MySQL 從機
SLAVE_DB_HOST = 'mysql-slave'
SLAVE_DB_PORT = 3306

# Redis
REDIS_HOST = 'redis'
REDIS_PORT = 6379

# Elasticsearch
ELASTICSEARCH_DSL = {
    'default': {
        'hosts': ['http://elasticsearch:9200'],
    }
}
```

### 2️⃣ 跨域與正式環境設定
📌 說明：

- ALLOWED_HOSTS：允許存取 Django 的網域
- CORS_ALLOWED_ORIGINS：前後端跨域請求來源
- 正式環境必須關閉 DEBUG
```py
ALLOWED_HOSTS = [
    'api.meiduo.site',
    'www.meiduo.site',
]

CORS_ALLOWED_ORIGINS = [
    'http://www.meiduo.site',
    'http://api.meiduo.site',
]

DEBUG = False
```
<br>

## 二、靜態檔案（Static Files）設定
### 3️⃣ collectstatic 收集 Django 靜態檔案

📌 說明：

- 收集 Django 專案所有 static 檔案(Django admin、各 app 的 CSS / JS / 圖片)
- 可選擇部署前手動執行，或寫入 Dockerfile，部署時自動執行
- 執行指令:python manage.py collectstatic --noinput

```py
# settings.py
STATIC_URL = 'static/'  
# 瀏覽器透過 /static/... 取得靜態檔案

STATIC_ROOT = BASE_DIR.parent / "static"
# 靜態檔案實體存放位置（給 Nginx / Web Server 使用）
```

<br>

## 三、其他自訂路徑與網址，相關函數、視圖設定檢查
### 4️⃣ 檢查代碼細節，是否能在容器化後運行

📌 說明：
- 重點檢查各 apps view、函數相關邏輯，各種文件、日誌生成路徑、127.0.0.1、localhost連線設定

```py
# 生成的靜態 HTML 檔案目錄
GENERATED_STATIC_HTML_FILES_DIR = BASE_DIR.parent / 'generated_html'

# 前端網址
FRONTEND_URL = 'http://www.meiduo.site/'

# 後端 API 網址
BACKEND_HOST = 'http://api.meiduo.site'


# django-crontab 設定
CRONJOBS = [
    ('*/5 * * * *', 'contents.crons.generate_static_index_html', '>> /app/logs/crontab.log 2>&1')
]

# 建立ES連線，使用容器名，取代127.0.0.1
ES_HOST = getattr(settings, 'ELASTICSEARCH_DSL', {}).get('default', {}).get('hosts', 'localhost:9200')
es = Elasticsearch(ES_HOST)

# Celery_tasks 設定
import os
from celery import Celery
# 設置默認的 Django 配置模組
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'b2cmall.settings.prod')


# 前端專案 host.js 設定
// const host = 'http://127.0.0.1:8000/' 
// const host = 'http://api.meiduo.site:8000/' // 模擬正式部屬時後端域名
const host = 'http://api.meiduo.site/' // 容器化部屬時後端域名

```

<br>

## 四、設定正式環境 settings（prod）

### 5️⃣ 修改 wsgi.py 與 manage.py
📌 說明：
模擬上線環境，從 dev 切換為 prod 設定檔
```py
os.environ.setdefault(
    'DJANGO_SETTINGS_MODULE',
    'b2cmall.settings.prod'
)
```

<br>

## 五、 檢查專案依賴變數的 .env檔
### 6️⃣ 修改敏感變數
📌 說明：
- 確認將secret key 或是帳密等，敏感變數存到虛擬環境，而不是在settings.py明文
```py
# django 自動生成的密鑰
SECRET_KEY=

# 資料庫相關帳密
DB_USER=
DB_PASSWORD=
SLAVE_DB_HOST = 
SLAVE_APP_USER=
SLAVE_APP_PASSWORD
MYSQL_ROOT_PASSWORD=
REDIS_HOST=
REDIS_PORT=
CELERY_BROKER_URL=
CELERY_RESULT_BACKEND=

# 網域相關
ALLOWED_HOSTS=
CORS_ALLOWED_ORIGINS=
CORS_ALLOWED_ORIGINS=

# 第三方功能串聯的密鑰或帳密
EMAIL_HOST_USER=
EMAIL_HOST_PASSWORD=
GOOGLE_CLIENT_ID=
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
MerchantID=
HashKey=
```

<br>

## 六、匯出最新 Python 套件清單
### 7️⃣ 產生 requirements.txt
📌 說明：
- Docker build 時安裝專案所需依賴，確保環境一致性
- 執行命令:pip freeze > requirements.txt

---

<br>

## 七、MySQL 主從同步（Replication）設定準備
### 8️⃣ 準備主機 / 從機設定檔與初始資料
📌說明:
- 準備 MySQL 主機（Master）與從機（Slave）的 .cnf 設定檔
- 匯出主機資料庫資料 `mysqldump -u root -p 資料庫名 > backup.sql`
- 部署時透過 MySQL 官方初始化目錄自動匯入資料 (docker-entrypoint-initdb.d)

🔹主機（Master）設定範例 
```bash
[mysqld]
server-id = 1
bind-address = 0.0.0.0
log_bin = /var/lib/mysql/mysql-bin
binlog_format = ROW
```
🔹從機（Slave）設定範例
```bash
[mysqld]
server-id = 2                 # 主機為 1，從機需不同
relay-log = relay-bin         # Relay log（中繼日誌）檔名前綴
read_only = 1                 # 唯讀（root 例外）
       
```

<br>

## 八、uWSGI 與 Nginx 設定準備
### 9️⃣ 準備 uwsgi.ini 與 nginx.conf

📌 說明：
- Django 後端由 uWSGI 提供服務
- 前端與靜態資源由 Nginx 提供
- 分別在前、後端專案根目錄下創建deploy資料夾，存放相關設定檔
- uwsgi.ini 推薦放於專案根目錄，方便啟動

🧩 uWSGI 設定（uwsgi.ini）
```bash
[uwsgi]

# 監聽 HTTP 請求
http = 0.0.0.0:8000

# Django WSGI 模組
module = b2cmall.wsgi:application

# Master process
master = true

# Worker processes
processes = 4

# 每個 worker 的執行緒數
threads = 2

# 停止時清理資源
vacuum = true

# 容器關閉時正常結束
die-on-term = true

# uWSGI log
logto = /app/logs/uwsgi.log

# 請求 log 格式
log-format = %(addr) - %(user) [%(ltime)] "%(method) %(uri) %(proto)" %(status) %(size) "%(referer)" "%(uagent)"
```

🌐 Nginx 設定（nginx.conf）
```bash
# 前端 www.meiduo.site
server {
    listen 80;
    server_name www.meiduo.site;

    index index.html;

    # 訪問根目錄或其他靜態資源
    location / {
        # 先找 /app/generated_html 裡的檔案
        root /app/generated_html;
        try_files $uri $uri/ @frontend;
    }

    # fallback 到前端原本靜態檔案
    location @frontend {
        root /usr/share/nginx/html;
        try_files $uri $uri/ =404;
    }

    # /goods/ 優先讀 Celery 生成的新商品頁，讀不到則fallback到原始目錄
    location /goods/ {
        
        alias /app/generated_html/goods/;
        try_files $uri @fallback_goods;

        # 避免瀏覽器快取
        add_header Cache-Control "no-cache, no-store, must-revalidate";
        add_header Pragma "no-cache";
        add_header Expires 0;
    }

    # fallback 到前端原始 goods
    location @fallback_goods {
        root /usr/share/nginx/html;
        index index.html;
    }
}

# 後端 api.meiduo.site
server {
    listen 80;
    server_name api.meiduo.site;

    # 提供 Django collectstatic 輸出的靜態檔案
    location /static/ {
        alias /app/static/;  # 訪問static/，會到/app/static/找檔案
    }

    # (一般建議) 上傳媒體檔案(本專案走django-storages=S3，故不用)
    # location /media/ {
    #     alias /app/media/;
    # }

    # 所有 API
    location / {
        proxy_pass http://backend:8000; # 將請求轉給django容器
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

<br>

# 九、撰寫各服務容器的 Dockerfile 與初始化腳本

## 📌 本專案使用的服務容器

* **backend**：Django 後端（uWSGI）

  * 提供 API 服務，處理業務邏輯
  * 對接資料庫、Redis、Elasticsearch、mysql-slave
* **nginx**：前端服務、後端反向代理

  * 提供前端靜態頁面
  * 作為反向代理轉發 API 請求到 backend
* **mysql-slave**：MySQL 從機（主機在本地）

  * 用於讀取查詢操作，主從同步主機資料
* **celery**：非同步任務處理

  * 處理耗時任務，如發送郵件
* **django-crontab**：定時任務

  * 定時執行 Django 任務，例如首頁index.html 定時更新
* **elasticsearch**：搜尋引擎

  * 提供全文搜索能力，用於商品搜尋或資料索引
* **redis**：快取服務

  * 提供高速暫存資料、支援 Celery 任務隊列

---

## ▶ Django 後端容器（backend）

### 📘 Dockerfile.backend

```dockerfile
FROM python:3.10                   # 使用官方 Python 3.10 基礎映像

WORKDIR /app                        # 設定容器工作目錄為 /app

COPY requirements.txt /app/         # 複製依賴檔案

RUN pip install --no-cache-dir -r requirements.txt  # 安裝 Python 套件

COPY . /app/                        # 複製整個 Django 專案

ENV DJANGO_SETTINGS_MODULE=b2cmall.settings.prod  # 設定 Django 正式環境配置

RUN python manage.py collectstatic --noinput --clear  # 收集靜態檔案，避免權限問題

COPY deploy/entrypoint-backend.sh /app/entrypoint-backend.sh  # 複製初始化腳本

RUN chmod +x /app/entrypoint-backend.sh            # 給腳本執行權限

RUN mkdir -p /app/logs && chown -R www-data:www-data /app  # 建立 logs 目錄並修改權限

USER www-data                          # 切換為非 root 用戶

ENTRYPOINT ["/app/entrypoint-backend.sh"]  # 設定容器啟動 entrypoint

CMD ["uwsgi", "--ini", "uwsgi.ini"]      # 容器啟動默認命令，啟動 uWSGI
```

### 📘 entrypoint-backend.sh

📌 功能說明：

* 等待 Elasticsearch 啟動
* 執行 Django migrate 同步資料庫結構
* 建立並填充 Elasticsearch 索引
* 啟動 uWSGI 提供 HTTP 服務

```bash
#!/bin/bash
set -e
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
```

---

## ▶ 前端 Nginx 容器

### 📘 Dockerfile.nginx

📌 功能說明：

* 提供前端靜態頁面服務
* 將 `/static/` 和 `/media/` 靜態檔案提供給用戶訪問
* 反向代理 API 請求到 backend

```dockerfile
FROM nginx:alpine                # 使用輕量版 Nginx 映像

COPY ./ /usr/share/nginx/html/   # 複製前端專案到容器

COPY ./deploy/nginx.conf /etc/nginx/conf.d/default.conf  # 覆蓋預設 Nginx 配置

EXPOSE 80                        # 容器對外開放 80 端口

CMD ["nginx", "-g", "daemon off;"]  # 前景模式啟動 nginx，容器不會退出
```

---

## ▶ Celery 非同步任務容器

### 📘 Dockerfile.celery

📌 功能說明：

* 處理 Django 的異步任務，例如發送郵件、生成報表、清理過期資料

```dockerfile
FROM python:3.10                 # Python 基礎映像

WORKDIR /app                       # 設定容器工作目錄

COPY requirements.txt /app/        # 複製依賴檔案

RUN pip install --no-cache-dir -r requirements.txt  # 安裝依賴

COPY . /app/                        # 複製專案

CMD ["celery", "-A", "celery_tasks.main", "worker", "-l", "info"]  # 啟動 Celery Worker
```

---

## ▶ MySQL 從機初始化（docker-entrypoint-initdb.d）

📌 說明：

* 從機容器初始化時，建立 Django 專用查詢帳號
* 僅授予 SELECT 權限，確保資料安全
* volume 掛載 `deploy/mysql-init/` 到 `/docker-entrypoint-initdb.d`

### 📁 目錄結構

```text
專案根目錄/deploy/mysql-init/
├── 01-backup.sql
└── 02-init_slave.sh
```

### 📘 02-init_slave.sh

📌 功能說明：

* 建立 Django 專用查詢帳號
* 只授予 SELECT 權限
* 透過環境變數讀取帳號密碼

```bash
#!/bin/bash
set -e
mysql -u root -p"$MYSQL_ROOT_PASSWORD" <<-EOSQL
CREATE USER '${SLAVE_APP_USER}'@'%' IDENTIFIED BY '${SLAVE_APP_PASSWORD}';
GRANT SELECT ON drf_mall.* TO '${SLAVE_APP_USER}'@'%';
FLUSH PRIVILEGES;
EOSQL
```

---

## ▶ Django Crontab（定時任務）容器

### 📘 Dockerfile.cron

📌 功能說明：

* 安裝 cron 排程服務
* 啟動容器時自動註冊 Django 定時任務
* 以 foreground 模式執行 cron，保持容器存活

```dockerfile
FROM python:3.10                 # Python 基礎映像

WORKDIR /app                       # 設定容器工作目錄

RUN apt-get update && apt-get install -y cron && rm -rf /var/lib/apt/lists/*  # 安裝 cron

COPY requirements.txt /app/        # 複製依賴檔案

RUN pip install --no-cache-dir -r requirements.txt  # 安裝 專案依賴套件

COPY . /app/                        # 複製專案

RUN mkdir -p /app/logs              # 建立 logs 目錄

COPY deploy/entrypoint-cron.sh /app/entrypoint-cron.sh  # 複製 entrypoint

RUN chmod +x /app/entrypoint-cron.sh

CMD ["/app/entrypoint-cron.sh"]     # 啟動容器時執行 entrypoint
```

### 📘 entrypoint-cron.sh

📌 功能說明：

* 移除舊的 crontab 任務
* 註冊 Django settings.py 裡的 crontab 任務
* 以 foreground 啟動 cron 服務

```bash
#!/bin/bash
set -e

echo "📌 註冊 django-crontab 任務..."
python manage.py crontab remove || true
python manage.py crontab add

echo "📌 啟動 cron 前景服務..."
cron -f
```

<br>

# 📝 Dockerfile 與初始化腳本重點總結

---

## 🔹 1. Dockerfile 撰寫通用規則

### **工作目錄**

```dockerfile
WORKDIR /app
```

* 統一容器內專案路徑，所有檔案與依賴建議放在 `/app`。

---

### **複製專案**

```dockerfile
COPY <來源路徑> <容器內路徑>
```

* `<來源路徑>`：基於 build context（docker-compose.yml `build.context`）
* `<容器內路徑>`：容器內放置位置，例如 `/app/`

例子：

```dockerfile
COPY requirements.txt /app/
COPY . /app/
```

---

### **入口腳本 (ENTRYPOINT)**

```dockerfile
ENTRYPOINT ["/app/entrypoint.sh"]
```

* 用於初始化容器，例如檢查依賴、資料庫 migrate
* 容器啟動時先執行
* 搭配 `exec "$@"` 可呼叫 CMD 指令

---

### **容器啟動指令 (CMD)**

```dockerfile
CMD ["uwsgi", "--ini", "uwsgi.ini"]
CMD ["celery", "-A", "celery_tasks.main", "worker", "-l", "info"]
CMD ["nginx", "-g", "daemon off;"]
```

* 指定容器啟動預設命令，可被 docker run 或 docker-compose 覆寫
* 常搭配 ENTRYPOINT 使用：ENTRYPOINT 負責初始化，CMD 啟動服務

---

### **權限與用戶**

```dockerfile
RUN mkdir -p /app/logs && chown -R www-data:www-data /app
USER www-data
RUN chmod +x /app/entrypoint.sh
```

* 建立非 root 用戶運行應用，避免安全問題
* 初始化資料夾給非 root 用戶權限
* `chmod +x <檔案>`：給檔案**執行權限**，例如 entrypoint 或腳本
* 初始化腳本內可使用環境變數控制帳號密碼，例如 MySQL 從機初始化：

```bash
mysql -u root -p"$MYSQL_ROOT_PASSWORD" <<-EOSQL
CREATE USER '${SLAVE_APP_USER}'@'%' IDENTIFIED BY '${SLAVE_APP_PASSWORD}';
GRANT SELECT ON drf_mall.* TO '${SLAVE_APP_USER}'@'%';
FLUSH PRIVILEGES;
EOSQL
```

---

### **chmod +x 說明**
* `chmod +x <檔案>`：給檔案**執行權限 (execute)**，確保腳本可執行
* 語法：
```bash
chmod +x <檔案>       # 給所有使用者執行權限
chmod u+x <檔案>      # 給檔案擁有者執行權限
chmod g+x <檔案>      # 給群組成員執行權限
chmod o+x <檔案>      # 給其他使用者執行權限
```

* 在 Dockerfile 常用於確保 entrypoint 或其他腳本能被容器執行：

```dockerfile
RUN chmod +x /app/entrypoint.sh
```

---

## 🔹 2. Dockerfile 常用指令

| 指令          | 說明                     | 範例                                      |
|---------------|------------------------|-----------------------------------------|
| **FROM**      | 指定基底映像               | `FROM python:3.10`                       |
| **WORKDIR**   | 設定工作目錄               | `WORKDIR /app`                           |
| **COPY**      | 複製檔案                 | `COPY . /app/`                           |
| **ADD**       | COPY 進階版，可自動解壓 tar | `ADD app.tar.gz /app/`                    |
| **RUN**       | 建置階段執行命令（安裝套件） | `RUN pip install -r requirements.txt`    |
| **ENV**       | 設定環境變數               | `ENV DJANGO_SETTINGS_MODULE=b2cmall.settings.prod` |
| **EXPOSE**    | 宣告容器開放 port          | `EXPOSE 8000`                             |
| **USER**      | 指定容器運行用戶           | `USER www-data`                           |
| **ENTRYPOINT**| 容器啟動初始化腳本          | `ENTRYPOINT ["/app/entrypoint.sh"]`      |
| **CMD**       | 容器啟動預設命令，可被覆寫   | `CMD ["uwsgi", "--ini", "uwsgi.ini"]`    |

<br>

# 十、撰寫 Docker Compose 一鍵部署多服務

## 1️⃣ 基本說明

Docker Compose 可一次啟動多個容器服務，適合開發與生產環境。
容器命名規則：

```
<專案名稱>__<服務名稱>
```

例如：`Meiduo__backend`

---

## 2️⃣ 範例 `docker-compose.yml`

```yaml
name: Meiduo

services:
  redis:
    image: redis:5
    container_name: redis
    restart: always
    ports:
      - "6379:6379"
    volumes:
      - redis-data:/data
    networks:
      - b2cmall_network

  mysql-slave:
    image: mysql:8.0.44
    container_name: mysql-slave
    restart: always
    env_file:
      - .env.slave                 
    ports:
      - "3307:3306"
    volumes:
      - ./slave.cnf:/etc/mysql/conf.d/slave.cnf
      - ./mysql-init:/docker-entrypoint-initdb.d
      - mysql-slave-data:/var/lib/mysql
    networks:
      - b2cmall_network

  elasticsearch:
    image: my-elasticsearch-with-ik:1.0
    container_name: elasticsearch
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false
      - ES_JAVA_OPTS=-Xms512m -Xmx512m
    ports:
      - "9200:9200"
    volumes:
      - esdata:/usr/share/elasticsearch/data
    networks:
      - b2cmall_network

  celery-worker:
    build:
      context: ..  
      dockerfile: deploy/Dockerfile.celery
    container_name: celery-worker
    restart: always
    depends_on:
      - redis
    volumes:
      - html_volume:/app/generated_html
    networks:
      - b2cmall_network

  backend:
    build:
      context: ..
      dockerfile: deploy/Dockerfile.backend   
    container_name: backend
    env_file:
      - ../.env  
    volumes:
      - static_volume:/app/static
    depends_on:
      - mysql-slave
      - elasticsearch
    expose:
      - "8000"
    environment:
      - DEBUG=False
    networks:
      - b2cmall_network

  cron:
    build:
      context: ..
      dockerfile: deploy/Dockerfile.cron
    container_name: cron
    env_file:
      - ../.env
    volumes:
      - html_volume:/app/generated_html
    depends_on:
      - mysql-slave
      - redis   
    networks:
      - b2cmall_network

  nginx:
    build:
      context: ../../front_end_pc
      dockerfile: deploy/Dockerfile.nginx
    container_name: nginx
    ports:
      - "80:80"
    volumes:
      - static_volume:/app/static   
      - html_volume:/app/generated_html
    depends_on:
      - backend
    networks:
      - b2cmall_network

volumes:
  redis-data:
  mysql-slave-data:
  esdata:
  static_volume: {}  
  html_volume: {}    

networks:
  b2cmall_network:
    driver: bridge
```

---

<br>

## 🐳 常用 Docker Compose 屬性

### ▶ build

```yaml
build:
  context: ..
  dockerfile: deploy/Dockerfile.backend
```

* `context`：Docker build 可見範圍，決定 COPY 的來源路徑。
* `dockerfile`：指定 Dockerfile 位置。
* 常用於自建映像，如 Django 後端、Celery、Cron。

---

### ▶ env_file

```yaml
env_file:
  - ../.env
```

* 外部環境變數檔案，隱藏敏感資訊。
* 路徑相對於 `docker-compose.yml`。
* 可與 `environment` 同時使用，`environment` 會覆蓋同名變數。

---

### ▶ environment

```yaml
environment:
  - DEBUG=False
```

* 直接在 Compose 裡設定環境變數。
* 容器啟動時自動加入。
* 常用選項：

| 容器            | 常用環境變數                         | 說明                               |
| ------------- | ------------------------------ | -------------------------------- |
| MySQL         | MYSQL_ROOT_PASSWORD            | Root 密碼                          |
|               | MYSQL_DATABASE                 | 預先建立資料庫                          |
|               | MYSQL_USER / MYSQL_PASSWORD    | 一般使用者帳密                          |
|               | TZ                             | 時區                               |
| Django / 後端   | DEBUG                          | True/False                       |
|               | DJANGO_SETTINGS_MODULE         | 指定 settings 模組                   |
|               | SECRET_KEY                     | Django 密鑰                        |
|               | DATABASE_URL                   | DB 連線字串                          |
| Elasticsearch | discovery.type                 | single-node                      |
|               | xpack.security.enabled         | 是否啟用安全認證                         |
|               | ES_JAVA_OPTS                   | JVM 記憶體設定                        |
| Redis         | REDIS_PASSWORD                 | 密碼                               |
|               | TZ                             | 時區                               |
| Celery / Cron | BROKER_URL / CELERY_BROKER_URL | 指定 Broker，如 redis://redis:6379/0 |
|               | RESULT_BACKEND                 | 結果存儲，如 redis://redis:6379/1      |
|               | TZ                             | 時區                               |

---

### ▶ volumes

Docker Compose 支援兩種主要使用方式：

#### 1️⃣ 本地掛載 (Bind Mount)

```yaml
volumes:
  - ./mysql-init:/docker-entrypoint-initdb.d
  - ./slave.cnf:/etc/mysql/conf.d/slave.cnf
```

* 將宿主機檔案/目錄掛載到容器。
* 用於同步專案檔案、初始化 SQL、配置檔。

#### 2️⃣ 命名 Volume (Named Volume)

```yaml
volumes:
  static_volume: {}
  html_volume: {}
```

* Docker 自行管理儲存路徑。
* 持久化資料，容器刪除不影響。
* 多容器可共享。

#### 🔹 範例-持久化資料

```yaml
services:
  mysql-slave:
    volumes:
      - mysql-slave-data:/var/lib/mysql
  elasticsearch:
    volumes:
      - esdata:/usr/share/elasticsearch/data
```

#### 🔹 範例-多服務共享

```yaml
services:
  backend:
    volumes:
      - static_volume:/app/static
  nginx:
    volumes:
      - static_volume:/app/static
      - html_volume:/app/generated_html
```

---

### ▶ depends_on

* 控制容器啟動順序。
* **注意**：不保證依賴的服務已完全 ready。
* 適合搭配健康檢查 (`healthcheck`) 或等待腳本。

---

### ▶ 路徑規則整理

| 屬性               | 說明                              |
| ---------------- | ------------------------------- |
| build.context    | Docker build 可見範圍，對應 COPY 的來源路徑 |
| build.dockerfile | Dockerfile 實際檔案位置               |
| env_file         | 相對於 compose.yml 的路徑             |
| volumes          | 左側為宿主或命名 volume，右側為容器內掛載點       |
| depends_on       | 確保容器啟動順序，但不保證服務就緒               |

---

## 🐳 常用 Docker / Compose 命令

### 基本操作

* **啟動並建立容器（包含 build）**：

```bash
docker compose up -d --build
```

> 使用情境：
>
> * Dockerfile 或專案有更新時
> * 需要重新 build 映像後啟動容器

* **啟動已存在容器（不重建映像）**：

```bash
docker compose up -d
```

> 使用情境：
>
> * 映像已經 build 完畢
> * 只想快速啟動服務，不需要重新建置

* 停止並刪除容器及網路（保留 volume）：

```bash
docker compose down
```

* 停止並刪除容器、網路、volume：

```bash
docker compose down -v
```

* 查看容器日誌：

```bash
docker compose logs -f <service_name>
```

* 進入容器 shell：

```bash
docker compose exec -it <容器名> /sh/bash
```

* 列出正在運行的容器：

```bash
docker compose ps
```

* 查看 volume 列表：

```bash
docker volume ls
```

* 刪除未使用 volume：

```bash
docker volume prune
```

### Docker 命令補充

* 查看所有容器（包含停止的）：

```bash
docker ps -a
```

* 刪除單個容器：

```bash
docker rm <container_id>
```

* 刪除單個 image：

```bash
docker rmi <image_id>
```

* 查看容器資源使用狀況：

```bash
docker stats
```

* 查看容器環境變數與設定（包含 yml 設定的變數）：

```bash
docker inspect <container_id>
```

> 說明：
>
> * `docker inspect` 會顯示容器的完整 JSON 設定，包括 Compose 的 environment、env_file 變數、掛載 volumes、網路設定等。
> * 如果想單純看環境變數，可使用：

```bash
docker exec <container_id> printenv
```

### Compose 指定 yml 或 env 檔案

* 指定自訂 Compose 檔案：

```bash
docker compose -f custom-docker-compose.yml up -d
```

* 指定 env 檔案（覆蓋預設）：

```bash
docker compose --env-file .env up -d
```

> 這樣可以針對不同環境使用不同設定檔和環境變數，而不修改原本的 `docker-compose.yml`。

<br> 

# 十一、依序建立各服務容器

本文說明在本地環境中，依正式部署流程順序建立各服務容器，包含 hosts 設定、MySQL 主從同步，以及其他服務的啟動。

---

## 1️⃣ 修改主機 hosts，模擬正式部署網域

透過修改 hosts，讓本機可以使用正式網域進行測試（常見於 Nginx + 前後端分離架構）。

### hosts 檔案位置

* 🪟 **Windows**

  ```text
  C:\Windows\System32\drivers\etc\hosts
  ```

  > 需使用「系統管理員身分」開啟編輯器

* 🍎 **macOS**

  ```bash
  sudo nano /etc/hosts
  ```

* 🐧 **Linux**

  ```bash
  sudo vim /etc/hosts
  ```

### hosts 範例設定

```text
127.0.0.1   api.meiduo.site
127.0.0.1   www.meiduo.site
```

📌 說明：

* `api.meiduo.site`：後端 API 網域
* `www.meiduo.site`：前端網站網域
* 指向 `127.0.0.1`，代表請求會由本機（通常是 Nginx）處理

---

## 2️⃣ 先建立 MySQL 從機（mysql-slave）

為了讓後端服務啟動時能正常連接資料庫，需先啟動 MySQL 從機容器。

```bash
docker compose up -d --build mysql-slave
```

📌 為什麼要先啟動 MySQL？

* MySQL 啟動與主從同步設定需要時間
* 避免 backend 容器啟動時資料庫尚未就緒而失敗

---

## 3️⃣ 設定 MySQL 主從同步

進入 **MySQL 從機容器**，執行以下 SQL 指令：

```sql
CHANGE MASTER TO
  MASTER_HOST='主機IP',
  MASTER_USER='slave-user',        -- 主機上建立的同步帳號
  MASTER_PASSWORD='自訂密碼',
  MASTER_LOG_FILE='mysql-bin.000003', -- 主機 SHOW MASTER STATUS 的 File
  MASTER_LOG_POS=1951;                -- 主機 SHOW MASTER STATUS 的 Position

START SLAVE;
SHOW SLAVE STATUS\G;
```

### 驗證同步狀態

確認以下欄位皆為 `Yes`：

* `Slave_IO_Running: Yes`
* `Slave_SQL_Running: Yes`

代表 MySQL 主從同步設定成功。

---

## 4️⃣ 建立其餘服務容器

在資料庫與主從同步確認完成後，再啟動其他服務容器：

```bash
docker compose up -d --build \
  redis \
  cron \
  nginx \
  backend \
  elasticsearch \
  celery-worker
```

### 建議啟動順序

1. MySQL（master / slave）
2. Redis
3. Backend / Celery
4. Elasticsearch
5. Nginx

---

## ⚠️ 補充提醒

* `hosts` 設定 **只影響主機本身**，不會影響 Docker 容器內
* 容器之間的連線請使用：

  * Docker Compose 的 `service name`
  * 或在需要時設定 `extra_hosts`

---

✅ 至此，整個本地模擬正式部署的容器啟動流程完成。
