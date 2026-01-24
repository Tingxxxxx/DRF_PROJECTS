from django.contrib.auth.tokens import default_token_generator
from django.utils.http import urlsafe_base64_encode
from django.utils.encoding import force_bytes
from django.conf import settings
import string, random

# 激活連結版本一: 使用django 內建的token生成器
def generate_activation_link(user):
    """
    生成用戶信箱激活連結

    說明：
    - 使用 Django 內建的 default_token_generator 為指定 user 產生一次性驗證 token。
    - urlsafe_base64_encode：將 user.pk 編碼（需要先轉成 bytes 類型）。
    - force_bytes: 將整數轉換成 bytes 類型。
    - 最終會回傳一個連結，例如：
        http://localhost:5500/front_end_pc/success_verify_email.html/NA-abc123token

    ⚠️ Token 有效期限：
    - Django 預設的 token（由 default_token_generator 產生）有效期限為 **3 天（72 小時）**。
    - 驗證時使用 `.check_token(user, token)` 方法，會根據 user 當前狀態 + 時間戳自動判斷有效性。

    ✅ 優點：
    - 系統在驗證時會動態重新生成並比對，無需資料庫儲存。
    - 有內建過期邏輯，安全性高。
    - 若 user 狀態變更，token 自動失效。

    🚫 如果你改用自訂隨機碼或驗證碼（例如簡訊碼），就需要儲存在資料庫或 Redis 中。

    返回：
        str: 激活連結（含 uid 和 token）
    """
    uid = urlsafe_base64_encode(force_bytes(user.pk))  # 將 user ID 編碼成 URL-safe Base64 格式
    token = default_token_generator.make_token(user)   # 為 user 產生驗證 token
    link = f"{settings.FRONTEND_URL}success_verify_email.html?code={uid}-{token}"  # 拼接前端跳轉網址
    return link


from django.core.cache import caches
# 激活連結版本二: 隨機產生驗證碼+redis控制過期時間
def generate_activation_link_2(user):
    uid = urlsafe_base64_encode(force_bytes(user.id)) # 
    code = "".join(random.choices(string.ascii_letters+string.digits, k=10))
    caches['verify'].set(f"activate:{code}", user.id, timeout=60*24)  # key = activate:ABcdE12345  value=user.id

    link = f'{settings.FRONTEND_URL}success_verify_email.html?token={uid}-{code}'
    return link

