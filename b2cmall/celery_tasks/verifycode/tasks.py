# 編寫異步任務的代碼，檔名tasks.py 是固定的，不可修改

from celery_tasks.main import celery_app
from django.core.mail import send_mail
from django.conf import settings
import logging

logger = logging.getLogger('django')

@celery_app.task # @celery_app.task綁定實例 裝飾器註冊任務函數
def send_email_task(recipient_email, verification_code):
    """註冊時發送六位數隨機驗證碼"""
    subject="您的驗證碼"
    message=f"您好！您的驗證碼是：{verification_code}，請在 5 分鐘內使用。"
    from_email = settings.DEFAULT_FROM_EMAIL
    try:
        send_mail(subject, message, from_email, [recipient_email])
    except Exception as e:
        logger.error('發送驗證郵件時出錯', exc_info=True) # exc_info 完整錯誤訊息


@celery_app.task # 註冊任務函數
def send_verification_email(to_email, verify_url):
    """
    個人中心發送激活信件到指定信箱。
    
    :param to_email: 收件人電子信箱
    :param verify_url: 驗證連結
    :return: None
    """
    from_email = settings.DEFAULT_FROM_EMAIL
    subject = "我的購物網站｜信箱驗證通知"
    html_message = (
        f"<p>親愛的用戶您好：</p>"
        f"<p>感謝您使用本商城服務。</p>"
        f"<p>您的註冊信箱是：{to_email}。</p>"
        f"<p>請點擊以下連結完成信箱認證：</p>"
        f"<p><a href='{verify_url}'>{verify_url}</a></p>"
        f"<p>如果您未曾申請，請忽略此郵件。</p>"
    )
    try:
        send_mail(subject,
            "",  # 純文字內容（可以留空）
            from_email,
            [to_email],
            html_message=html_message,
    )
    except Exception as e:
        logger.error('發送驗證郵件時出錯', exc_info=True) # exc_info 完整錯誤訊息
