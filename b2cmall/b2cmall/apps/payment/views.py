
import json
import logging
from datetime import datetime

from django.db import DatabaseError
from django.http import HttpResponse
from django.conf import settings
from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated

from .serializers import ECPayPaymentNotifySerializer
from .models import ECPayTransaction
from .libs.ecpay.sdk.ecpay_payment_sdk import ECPayPaymentSdk
from .utils import check_order_valid, build_ecpay_order_form

logger = logging.getLogger('django')

# Create your views here.
"""
購物車付款串接 ECPAY 流程:

[1] 前端送出付款請求 (order_id) ➜
[2] 進入 /api/payment/ecpay/request/ 進行驗證 ➜
[3] 回傳 redirect_url 給前端 ➜
[4] 前端跳轉至 /api/payment/ecpay/redirect/?order_id=xxxx ➜
[5] 後端產生綠界 HTML 表單並 auto-submit ➜
[6] 綠界付款畫面 ➜
[7] 付款完成後，ECPay Server ➜ POST NotifyURL ➜ /api/payment/ecpay/notify/ ➜ 更新訂單狀態
[8] 用戶從綠界按「返回商店」 ➜ ClientBackURL ➜ 前端付款完成頁面
"""

class ECPayPaymentRequestView(APIView):
    """驗證訂單後，回傳引導使用者前往建立綠界付款表單的後端連結。"""

    permission_classes = [IsAuthenticated]

    def post(self, request):
        order_id = request.data.get('order_id')  # 從請求體獲得
        user = request.user

        logger.info(f'用戶:{user.username}，訂單編號:{order_id}，請求付款')
        logger.info(f'訂單編號:{order_id}，訂單資訊驗證中...')

        # 驗證訂單是否存在 & 狀態是否符合付款條件
        order, error_response = check_order_valid(
            user, order_id, check_paymethod=True, check_status=True
        )

        if error_response:
            logger.error(f'用戶:{user.username}，訂單編號:{order_id}，訂單驗證失敗')
            return error_response

        logger.info(f'訂單編號:{order_id}，訂單驗證通過，生成跳轉連結')

        host = settings.BACKEND_HOST
        redirect_url = host + f"/payment/ecpay/redirect/?order_id={order_id}"  # 跳轉到下一步建立綠界付款資訊的 URL
        return Response({'redirect_url': redirect_url})


class ECPayPaymentRedirectView(APIView):
    """創建綠界付款訂單 - 回傳一段 HTML 表單，給前端跳轉到綠界付款頁"""

    permission_classes = [IsAuthenticated]

    def get(self, request):
        order_id = request.GET.get('order_id')
        user = request.user

        # 驗證訂單是否存在 & 狀態是否符合付款條件
        order, error_response = check_order_valid(
            user, order_id, check_paymethod=True, check_status=True
        )

        if error_response:
            logger.error(f'用戶:{user.username}，訂單編號:{order_id}，訂單驗證失敗')
            return error_response

        # 建立綠界訂單表單 HTML
        logger.info(f'用戶:{user.username}，訂單編號:{order_id}，創建付款綠界訂單，跳轉 ECPAY 付款頁面')
        html, merchant_trade_no, trade_amt = build_ecpay_order_form(order)

        try:
            # 新增此筆綠界訂單到資料庫
            if not ECPayTransaction.objects.filter(merchant_trade_no=merchant_trade_no,order=order).exists():

                if trade_amt != int(order.total_amount): # order的金額是decimal類型，綠界則一定是整數
                    return Response({'error':'訂單付款金額錯誤'},status=status.HTTP_400_BAD_REQUEST)
                
                logger.info(f'初始化訂單編號:{order_id}，綠界付款訂單到資料庫')

                ECPayTransaction.objects.create(
                    order = order,
                    merchant_trade_no= merchant_trade_no,
                    trade_amt = trade_amt,
                )

            else:
                logger.warning(f'訂單編號:{order_id} 對應的 merchant_trade_no:{merchant_trade_no} 已存在，不重複建立')


        except DatabaseError:
            logger.exception(f'訂單編號:{order_id}, merchant_trade_no:{merchant_trade_no}，建立綠界付款訂單失敗')
            return Response({'error': '伺服器資料庫錯誤'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        
        except Exception:
            logger.exception(f'訂單編號:{order_id}, merchant_trade_no:{merchant_trade_no}，建立綠界付款訂單失敗')
            return Response({'error': '伺服器錯誤'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
 
        return HttpResponse(html, content_type='text/html')  # 將 HTML 表單直接回傳給前端


class ECPayPaymentNotifyView(APIView):
    permission_classes = []  # 綠界不會帶 token，通常設公開或用 IP 白名單保護

    def post(self, request):

        # 獲取綠界回傳的付款結果
        post_data = request.data # 綠界回傳欄位資料類型都是str
        merchant_id = post_data.get('MerchantID')
        merchant_trade_no = post_data.get('MerchantTradeNo')
        logger.info(f'編號:{merchant_trade_no}，獲取綠界付款結果......')

        # for k,v in post_data.items():  
        #     logger.info(f'{k}:{v}，資料類型:{type(v).__name__}')
        
        # 初始化 綠界SDK
        ecpay = ECPayPaymentSdk(
            MerchantID=merchant_id,
            HashKey=settings.ECPAY['HashKey'],
            HashIV=settings.ECPAY['HashIV']
        )

        # 根據回傳結果重新計算checkvalue簽章
        check_mac_value = post_data.get('CheckMacValue', '')
        calculated_mac_value = ecpay.generate_check_value(post_data)

        # 比對簽章
        if check_mac_value != calculated_mac_value:
            logger.error(f'''
                簽章驗證失敗:
                原始 CheckMacValue: {check_mac_value}
                計算後 CheckMacValue: {calculated_mac_value}
                商店訂單號: {merchant_trade_no}
                原始資料: {json.dumps(post_data, ensure_ascii=False)}
            ''')
            return HttpResponse('0|Fail', status=400)
        
        logger.info(f"簽章驗證通過，更新資料庫中綠界訂單資訊")

        # 通過則修改綠界付款訂單狀態
        ecpay_order = ECPayTransaction.objects.filter(merchant_trade_no=merchant_trade_no).first()

        if ecpay_order:
            serializer = ECPayPaymentNotifySerializer(data=request.data, instance=ecpay_order, partial=True)
            serializer.is_valid(raise_exception=True)
            serializer.save() # 較驗通過後存到資料庫

        else:
            logger.warning(f'找不到符合的 ECPayTransaction 訂單: {merchant_trade_no}')
            return HttpResponse("0|OrderNotFound", status=404)

        return HttpResponse("1|OK")
