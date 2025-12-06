import pickle, base64
import logging
from django_redis import get_redis_connection

logger = logging.getLogger('django')

def merge_cart_cookie_to_redis(request, user, response):
    """
    將 cookie 購物車商品合併到登入用戶的 Redis 購物車中。

    合併原則：
    - 若商品在 Redis 中已存在，以 cookie 中的數量為準（覆蓋）
    - 勾選狀態策略：只要 cookie 中有勾選，就保留勾選，不會移除 Redis 原本已有的勾選狀態
    """
    # 1️⃣ 從 cookie 中取得購物車資料（Base64 字串）
    cart_str = request.COOKIES.get('cart')
    logger.info('從cookie中獲取購物車資料')

    if cart_str is None:
        logger.info('當前cookie中沒有購物車資料 ')
        # 若 cookie 中沒有購物車資料，則不需合併，直接結束
        return

    # 2️⃣ 將 cookie 資料還原成 Python 字典（結構如：{sku_id: {'count':1, 'selected': true}})
    try:
        cart_dict = pickle.loads(base64.b64decode(cart_str.encode()))

    except Exception:
        # 若解碼或反序列化失敗，可能是格式錯誤或資料遭破壞，直接結束
        return

    # 3️⃣ 組合 當前用戶redis的key
    cart_key = f'{user.id}:cart'         # 儲存每個商品的數量（sku_id -> count）
    selected_key = f'{user.id}:selected' # 儲存已勾選的商品 sku_id 清單（set 結構）

    # 4️⃣ 建立 Redis 連線與 pipeline
    redis_conn = get_redis_connection('cart')
    pipe = redis_conn.pipeline()

    # 5️⃣ 遍歷 cookie 中的每個商品，寫入 Redis
    for sku_id, item in cart_dict.items():
        count = item.get('count')         # 取得商品數量
        selected = item.get('selected')   # 取得勾選狀態

        # 將商品數量存入 Redis 的 hash 中，會覆蓋原本的數值
        pipe.hset(cart_key, sku_id, count)

        # 若商品在 cookie 中有勾選，就將其加入 Redis 的勾選 set 中
        # 👉 若原本 Redis 中已勾選，這邊會保持勾選；若沒勾選，則新增
        if selected:
            pipe.sadd(selected_key, sku_id)

    # 6️⃣ 一次執行所有 Redis 寫入操作
    pipe.execute()
    logger.info(f"合併 cookie 購物車數據到使用者:{user.username}中")

    # 7️⃣ 合併完成後，刪除 cookie 中的購物車資料，避免重複合併
    del_cookie_depend_on_domain(request, response) # 127.0.0.1或meiduo.site


def set_cookie_depend_on_domain(request, cart_str, response, CART_COOKIE_EXPIRES):
    """
    根據請求的 Host，自動設置購物車 Cookie 的 domain 和 secure 屬性。

    功能說明：
    - 本機開發環境（127.0.0.1 或 localhost）：
        - domain=None
        - secure=False（HTTP 可用）
    - 模擬部署/正式站（前端:www.meiduo.site / 後端:api.meiduo.site）：
        - domain=".meiduo.site"
        - secure=secure_flag，可改為 True 以支援 HTTPS
    """
    host = request.get_host()  # 取得請求 Host

    # 本機測試用:前端/後端/前端axios統一要用127.0.1.1域名
    if host.startswith("127.0.0.1") or host.startswith("localhost"): 
        cookie_domain = None       
        secure_flag = False       
    
    # 模擬部屬用     
    else:
        cookie_domain = ".meiduo.site"
        secure_flag = False  # 正式上線後再打開           

    response.set_cookie(
        'cart', cart_str,
        max_age=CART_COOKIE_EXPIRES,
        domain=cookie_domain,
        samesite=None,
        secure=secure_flag
)


def del_cookie_depend_on_domain(request, response):
    """
    根據請求的 Host，自動設置購物車 Cookie 的 domain 屬性。

    功能說明：
    - 本機開發環境（127.0.0.1 或 localhost）：
        - domain=None
    - 模擬部署/正式站（前端:www.meiduo.site / 後端:api.meiduo.site）：
        - domain=".meiduo.site"
    """
    host = request.get_host()  # 取得請求 Host

    # 本機測試用:前端/後端/前端axios統一要用127.0.1.1域名
    if host.startswith("127.0.0.1") or host.startswith("localhost"): 
        cookie_domain = None       
                
    # 模擬部屬用
    else:
        cookie_domain = ".meiduo.site"

    response.delete_cookie(
        'cart',
        domain=cookie_domain,
        samesite=None,
    )
