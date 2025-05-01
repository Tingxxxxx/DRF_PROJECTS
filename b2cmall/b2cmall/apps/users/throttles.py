# throttles.py
from rest_framework.throttling import UserRateThrottle

class EmailRateThrottle(UserRateThrottle):
    """
    自訂的限流類別，用於限制使用者發送驗證信的頻率。
    繼承自 DRF 的 UserRateThrottle，根據使用者進行限流。

    scope:
        - 用來對應 settings.py 中的 REST_FRAMEWORK['DEFAULT_THROTTLE_RATES'] 設定。
        - 在此命名為 'email'，代表這是針對 email 發送操作的限流設定。

    使用方式:
        1. 在 settings.py 中加入:
            REST_FRAMEWORK = {
                'DEFAULT_THROTTLE_RATES': {
                    'email': '3/hour',  # 每位用戶每小時最多只能發送 3 封驗證信
                }
            }

        2. 在 View 中搭配 get_throttles 方法動態指定:
            def get_throttles(self):
                if self.request.method == 'PATCH':
                    return [EmailThrottleRate()]
                return []
    """
    scope = 'email'
