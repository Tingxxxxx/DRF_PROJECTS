# 開發環境的settings.py

"""
Django settings for b2cmall project.

Generated by 'django-admin startproject' using Django 4.2.2.

For more information on this file, see
https://docs.djangoproject.com/en/4.2/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/4.2/ref/settings/
"""

from pathlib import Path
import sys

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/4.2/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = 'django-insecure-z2eryher551tw-+f$@^zu(++1zd23ism+d58btf%aq$edbzd(+'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

ALLOWED_HOSTS = ['127.0.0.1', 'localhost']

# CORS 跨域請求白名單
CORS_ALLOWED_ORIGINS = [
    "http://127.0.0.1:5500",  
    "http://localhost:5500",  
]


# 自訂義解析模組的路徑
sys.path.append(str(BASE_DIR / "apps")) # D:\\drf_mall\\b2cmall\\b2cmall\\apps'

# Application definition
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'rest_framework',  # 開發RESTfull API 加上此行
    'rest_framework.authtoken', # DRF自帶的TOKEN認證,
    'b2cmall.apps.users', # 用戶相關
    'b2cmall.apps.verifications', # 驗證碼
    'corsheaders' # 解決cors問題
]

AUTH_USER_MODEL = 'users.User'

MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'b2cmall.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'b2cmall.wsgi.application'


# Database
# https://docs.djangoproject.com/en/4.2/ref/settings/#databases

# 連線到MySql
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'HOST': '127.0.0.1',  # 本機資料庫
        'PORT': 3306,  
        'USER': 'hellen',  
        'PASSWORD': 'hellen',  
        'NAME': 'drf_mall'  
    }
}

# 配置快取
CACHES = {
    # 'default' 配置，主要用來配置 Django 的快取系統
    'default': {
        # 使用 django-redis 作為快取的後端
        'BACKEND': 'django_redis.cache.RedisCache',
        
        # Redis 伺服器的地址，127.0.0.1 是本地地址，6379 是 Redis 的默認端口
        'LOCATION': 'redis://127.0.0.1:6379/0',  # 這裡指定了使用 Redis 數據庫的第 0 索引
        
        # 配置額外選項，這裡指定了使用 django-redis 的預設客戶端
        'OPTIONS': {
            'CLIENT_CLASS': 'django_redis.client.DefaultClient',  # 使用預設的客戶端類別
        }
    },

    # "session" 配置，用於會話儲存
    "session": {
        # 同樣使用 django-redis 作為會話儲存的後端
        "BACKEND": "django_redis.cache.RedisCache",
        
        # Redis 伺服器的地址，這裡還是使用本地 Redis 伺服器
        "LOCATION": "redis://127.0.0.1:6379/1",  # 默認使用 Redis 的第 1 數據庫
        
        # 配置選項，同樣指定使用預設的 Redis 客戶端
        "OPTIONS": {
            "CLIENT_CLASS": "django_redis.client.DefaultClient",  # 使用預設的客戶端類別
        }
    }
}

# 配置 Django 使用快取來儲存會話數據
SESSION_ENGINE = "django.contrib.sessions.backends.cache"  # 告訴 Django 使用快取系統作為會話存儲後端

# 配置會話的快取別名，指向前面配置中的 'session' 快取設置
SESSION_CACHE_ALIAS = "session"  # 這裡指向名為 "session" 的 Redis 配置，用來儲存會話數據



# 創建 logs 文件夾（如果尚不存在）
log_folder = BASE_DIR / "logs"
log_folder.mkdir(parents=True, exist_ok=True)

# log日誌輸出
LOGGING = {
    # 日誌設置的版本，默認為 1
    'version': 1,

    # 是否禁用已存在的日志器
    'disable_existing_loggers': False,  # 設置為 False，表示不禁用現有的日誌記錄器，這樣可以保證 Django 預設的日誌設置不會被覆蓋

    # 設置日誌顯示格式
    'formatters': {
        # 定義 verbose 格式，會顯示日誌級別、時間戳、模塊名稱、行號及消息
        'verbose': {
            'format': '%(levelname)s %(asctime)s %(module)s %(lineno)d %(message)s'
        },
        
        # 定義簡單的格式，只顯示日誌級別、模塊名稱、行號及消息
        'simple': {
            'format': '%(levelname)s %(module)s %(lineno)d %(message)s'
        },
    },

    # 設置日誌過濾器
    'filters': {
        # 設置過濾器，只有在 debug 模式下才會輸出日誌
        'require_debug_true': {
            '()': 'django.utils.log.RequireDebugTrue',  # 使用 Django 預設的過濾器，確保只在 Debug 模式下輸出日誌
        },
    },

    # 設置日誌處理器
    'handlers': {
        # 向終端輸出日誌
        'console': {
            'level': 'INFO',  # 設定最低日誌級別為 INFO
            'filters': ['require_debug_true'],  # 只有在 Debug 模式下才會輸出日誌，部署後就不會輸出到終端
            'class': 'logging.StreamHandler',  # 使用 StreamHandler 類將日誌輸出到終端
            'formatter': 'simple',  # 使用 simple 格式
        },

        # 向文件中輸出日誌
        'file': {
            'level': 'INFO',  # 設定最低日誌級別為 INFO
            'class': 'logging.handlers.RotatingFileHandler',  # 使用 RotatingFileHandler 類來處理文件輸出，支持循環日誌
            'filename': BASE_DIR / "logs" / "b2cmall.log",  # 使用 Path 合併路徑, 設置日誌文件的存儲位置
            'maxBytes': 300 * 1024 * 1024,  # 設置單個日誌文件的最大大小為 300MB
            'backupCount': 10,  # 設置保留的日誌文件數量為 10，舊的日誌文件會被覆蓋
            'formatter': 'verbose',  # 使用 verbose 格式
        },
    },

    # 設置日誌記錄器
    'loggers': {
        # 設置 django 日誌記錄器
        'django': {
            'handlers': ['console', 'file'],  # 配置該日誌器同時使用控制台和文件處理器
            'propagate': True,  # 允許日誌信息向上傳播（即將日誌信息傳遞給父日誌器）
            'level': 'INFO',  # 設置該日誌器的最低日誌級別為 INFO
        },
    }
}


# DRF 相關配置
REST_FRAMEWORK = {
    # 自訂異常處理
    'EXCEPTION_HANDLER': 'b2cmall.utils.exceptions.exception_handler',

    # ✅ 設定 API 頁面分頁（可選）
    'DEFAULT_PAGINATION_CLASS': 'rest_framework.pagination.PageNumberPagination',  # 使用分頁模式
    'PAGE_SIZE': 50,  # 每頁顯示 50 筆資料

    # ✅ 設定 API 返回的時間格式
    'DATETIME_FORMAT': "%Y-%m-%d %H:%M:%S",  # 例如：2025-03-03 14:30:00

    # ✅ 設定 API 回應的 Renderer（渲染器），決定 API 如何回應數據
    'DEFAULT_RENDERER_CLASSES': [
        'rest_framework.renderers.JSONRenderer',         # 讓 API 預設回傳 JSON 格式
        'rest_framework.renderers.BrowsableAPIRenderer'  # 讓 API 具有可視化的瀏覽器 API 介面（開發測試方便）
    ],

    # ✅ 設定 API 解析請求數據的方式 -->解析restqust.data的方式
    'DEFAULT_PARSER_CLASSES': [
        'rest_framework.parsers.JSONParser',  # 允許解析 JSON 請求
        'rest_framework.parsers.FormParser',  # 允許解析 `application/x-www-form-urlencoded` 表單請求
        'rest_framework.parsers.MultiPartParser',  # 允許解析 `multipart/form-data`（文件上傳）
    ],

    # ✅ 設定 API 權限管理（誰可以訪問 API）
    'DEFAULT_PERMISSION_CLASSES': [
        'rest_framework.permissions.IsAuthenticated',  # 只有已驗證的使用者才能訪問
        # 若要允許所有使用者訪問，可改成：
        # 'rest_framework.permissions.AllowAny',
    ],

    # ✅ 設定 API 認證方式（身份驗證）
    'DEFAULT_AUTHENTICATION_CLASSES': [
        'rest_framework.authentication.BasicAuthentication',  # 使用者帳號+密碼（Basic Auth），可省略
        'rest_framework.authentication.SessionAuthentication',  # 會話認證（與 Django 內建登入機制相容）
        'rest_framework.authentication.TokenAuthentication',  # Token 認證（需在APP安裝 `rest_framework.authtoken`）
    ],
}




# Password validation
# https://docs.djangoproject.com/en/4.2/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]


# Internationalization
# https://docs.djangoproject.com/en/4.2/topics/i18n/

LANGUAGE_CODE = 'zh-hant' # 修改，顯示繁體中文

TIME_ZONE = 'Asia/Taipei' # 修改，台北時間

USE_I18N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/4.2/howto/static-files/

STATIC_URL = 'static/'

# Default primary key field type
# https://docs.djangoproject.com/en/4.2/ref/settings/#default-auto-field

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'


# 配置Django 後端 email設置
EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_HOST = 'smtp.gmail.com'  # Gmail 的 SMTP 伺服器
EMAIL_PORT = 587  # TLS 通訊埠號
EMAIL_USE_TLS = True  # 啟用 TLS 加密
EMAIL_HOST_USER = 'hellendjango@gmail.com'  # 您的 Gmail 帳號
EMAIL_HOST_PASSWORD = 'jwja uwvh qbyk ylgn'  # 應用程式密碼，保留空格

