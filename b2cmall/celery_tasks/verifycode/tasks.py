# 編寫異步任務的代碼，檔名tasks.py 是固定的，不可修改

from celery_tasks.main import celery_app
from django.core.mail import send_mail
from django.conf import settings


@celery_app.task # @celery_app.task綁定實例 裝飾器註冊任務函數
def send_email_task(recipient_email, verification_code):
    """異步發送郵件，並記錄錯誤"""
    subject="您的驗證碼"
    message=f"您好！您的驗證碼是：{verification_code}，請在 5 分鐘內使用。"
    from_email = settings.DEFAULT_FROM_EMAIL
    try:
        send_mail(subject, message, from_email, [recipient_email])
    except Exception as e:
        raise e # 郵件發送失敗則拋出異常，會在視圖中捕獲

    