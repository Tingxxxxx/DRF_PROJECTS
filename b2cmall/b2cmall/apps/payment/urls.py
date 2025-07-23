from django.urls import path, include
from .views import ECPayPaymentRequestView, ECPayPaymentRedirectView,ECPayPaymentNotifyView


urlpatterns = [
    # SKU商品列表清單
    path('ecpay/request/', ECPayPaymentRequestView.as_view(), name='ecpay_request'),
    path('ecpay/redirect/', ECPayPaymentRedirectView.as_view(), name='ecpay_redirect'),
    path('ecpay/notify/', ECPayPaymentNotifyView.as_view(), name='ecpay_notify'),
    
]
