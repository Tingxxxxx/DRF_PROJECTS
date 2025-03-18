"""
因 DRF 不會自動處理資料庫相關的異常，因此我們需要自定義一個異常處理器來捕捉並處理這些錯誤

1. 捕捉 DatabaseError（資料庫錯誤）和 RedisError（Redis 服務錯誤）。
2. 記錄詳細的錯誤訊息
3. 返回一個統一的錯誤響應，告訴用戶發生了伺服器錯誤，並且保持一致的錯誤消息格式。


"""

# utils/exceptions.py
from rest_framework.views import exception_handler as drf_exception_handler
import logging
from django.db import DatabaseError
from redis.exceptions import RedisError
from rest_framework.response import Response
from rest_framework import status

# 取得在設定檔中定義的 logger，用來記錄日誌
logger = logging.getLogger('django')

def exception_handler(exc, context):
    """
    自訂異常處理
    :param exc: 異常
    :param context: 拋出異常的上下文 (是一個字典，包含requset與view物件)
    :return: Response 回應物件
    """
    # 呼叫 DRF 框架原生的異常處理方法
    response = drf_exception_handler(exc, context)

    # 如果 response 為 None，表示此異常沒有被 DRF 處理
    if response is None:
        view = context.get('view', None)
        # 判斷是資料庫異常或 Redis 異常
        if isinstance(exc, DatabaseError):
            # 資料庫異常
            logger.error(f"DatabaseError 發生在視圖 {view}: {exc}")
            response = Response({'message': '伺服器內部錯誤'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        elif isinstance(exc, RedisError):
            # Redis 異常
            logger.error(f"RedisError 發生在視圖 {view}: {exc}")
            response = Response({'message': '伺服器內部錯誤'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    return response
