import logging
import random
from datetime import datetime

from django.core.signing import BadSignature, SignatureExpired
from django.core import signing
from django.conf import settings
from rest_framework.exceptions import ValidationError
from rest_framework.response import Response
from rest_framework import status

from .libs.ecpay.sdk.ecpay_payment_sdk import ECPayPaymentSdk
from orders.models import OrderInfo

logger = logging.getLogger('django')

# 常量區
TOKEN_EXPIRATION_SECONDS = 10 * 60

def check_order_valid(user, order_id, check_paymethod=True, check_status=True):
    """
    驗證訂單有效性

    參數：
    - user: 訂單所屬使用者
    - order_id: 訂單編號
    - check_paymethod: 是否檢查付款方式為線上付款（預設True）
    - check_status: 是否檢查訂單狀態為未付款（預設True）

    回傳：
    - 成功： (order, None)
    - 失敗： (None, 錯誤Response)

    功能：
    確認訂單存在且符合付款條件，避免非法付款操作。
    """
    if not order_id:
        return None, Response({'error': '缺少訂單編號'}, status=status.HTTP_400_BAD_REQUEST)

    try:
        order = OrderInfo.objects.get(order_id=order_id, user=user)
    except OrderInfo.DoesNotExist:
        return None, Response({'error': '訂單不存在'}, status=status.HTTP_400_BAD_REQUEST)

    if check_paymethod and order.pay_method != OrderInfo.PAY_METHOD_ENUM['ONLINE']:
        return None, Response({'error': '付款方式錯誤'}, status=status.HTTP_400_BAD_REQUEST)

    if check_status and order.status != OrderInfo.ORDER_STATUS_ENUM['UNPAID']:
        return None, Response({'error': '訂單狀態錯誤'}, status=status.HTTP_400_BAD_REQUEST)

    return order, None


def sign_trade_no_to_token(merchant_trade_no):
    """用於簽名、加密 merchant_trade_no"""
    token = signing.dumps({'merchant_trade_no': merchant_trade_no}) # 簽名 + 序列化
    return token


def usign_token_to_trade_no(token):
    """將 token 解簽回 merchant_trade_no，失敗則拋出例外(在視圖自動被DRF捕捉處理)"""
    try:
        data_dict = signing.loads(token, max_age=TOKEN_EXPIRATION_SECONDS)
        return data_dict['merchant_trade_no']
    
    except SignatureExpired:
        logger.warning("Token 已過期")
        raise ValidationError({'error': 'Token 已過期'})

    except BadSignature:
        logger.warning("Token 簽章無效或被竄改")
        raise ValidationError({'error': 'Token 無效'})


def build_ecpay_order_form(order):
    """
    根據訂單資訊，產生綠界付款的 HTML 表單
    """

    # 初始化綠界 SDK
    ecpay = ECPayPaymentSdk(
        MerchantID=settings.ECPAY['MerchantID'],
        HashKey=settings.ECPAY['HashKey'],
        HashIV=settings.ECPAY['HashIV']
    )

    # 整理商品資料
    ordergoods = order.order_goods.select_related('sku').all()  # 用 select_related JOIN OrderGoods 跟 SKU
    item_names = [og.sku.name for og in ordergoods]              # 取得所有商品名稱
    names = '#'.join(item_names)                                 # 用 # 串接成字串，如 '商品1#商品2#商品3'
    total_amount = int(order.total_amount)  # 綠界只接收int，而資料庫為decimal 

    # 加密merchant_trade_no拼接到ClientBackURL，方便綠界付款完後在前端直接查詢訂單狀態
    merchant_trade_no = datetime.now().strftime("NO%Y%m%d%H%M%S") + str(random.randint(10,99))
    token = sign_trade_no_to_token(merchant_trade_no)
    

    # 綠界訂單參數
    order_params = {
        'MerchantTradeNo': merchant_trade_no , # NO20250723173015
        # 必填：特店訂單編號，需唯一

        'MerchantTradeDate': datetime.now().strftime("%Y/%m/%d %H:%M:%S"),
        # 必填：交易建立時間（格式固定 yyyy/MM/dd HH:mm:ss）

        'PaymentType': 'aio',
        # 必填：固定填 aio 表示一般付款

        'TotalAmount': total_amount,
        # 必填：整數，綠界不接受小數

        'TradeDesc': '我的商城網路購物',
        # 必填：交易描述，會出現在綠界付款頁面

        'ItemName': names,
        # 必填：商品名稱（多筆用 # 分隔）

        'ReturnURL': settings.ECPAY['RETURN_URL'],
        # 必填：綠界付款完成後，伺服器會收到 POST 通知，需實作對應 API

        'ChoosePayment': 'ALL',
        # 選填：ALL 讓使用者自由選付款方式

        'IgnorePayment': 'ApplePay#WeiXin#TWQR#BNPL',
        # 選填：排除不想開放的付款方式

        'ClientBackURL': settings.ECPAY['CLIENT_BACK_URL'].format(merchant_trade_no=token), # http://....?token={merchant_trade_no}'
        # 選填：付款完成後，使用者點「返回商店」時會跳回這個網址（通常是訂單成功頁）

        'EncryptType': 1
        # 必填：固定填入 1（使用 SHA256 加密）
    }

    # 產生加密簽章與完整參數（含 CheckMacValue）
    order_info = ecpay.create_order(order_params)

    # 建立 HTML 表單（form） ➜ 導向綠界付款網址並自動 submit
    html = ecpay.gen_html_post_form(
        action="https://payment-stage.ecpay.com.tw/Cashier/AioCheckOut/V5",  # 測試環境
        # 若正式上線，改為：https://payment.ecpay.com.tw/Cashier/AioCheckOut/V5
        parameters=order_info
    )

    return html, order_params.get('MerchantTradeNo'), order_params.get('TotalAmount')

    
