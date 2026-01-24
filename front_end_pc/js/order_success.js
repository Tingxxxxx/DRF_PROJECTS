var vm = new Vue({
    el: '#app',
    data: {
        host,
        username: sessionStorage.username || localStorage.username,
        user_id: sessionStorage.user_id || localStorage.user_id,
        token: sessionStorage.access || localStorage.access,
        order_id: '',
        amount: 0,
        pay_method: '',
        loading: false  // 防止連點
    },
    computed: {
        operate: function () {
            return this.pay_method == 1 ? '繼續購物' : '前往付款';
        }
    },
    mounted: function () {
        this.order_id = this.get_query_string('order_id');
        this.amount = this.get_query_string('amount');
        this.pay_method = this.get_query_string('pay');
    },
    methods: {
        // 登出
        logout: function () {
            sessionStorage.clear();
            localStorage.clear();
            location.href = '/login.html';
        },
        // 取得 URL 查詢參數
        get_query_string: function (name) {
            var reg = new RegExp('(^|&)' + name + '=([^&]*)(&|$)', 'i');
            var r = window.location.search.slice(1).match(reg);
            if (r != null) {
                return decodeURI(r[2]);
            }
            return null;
        },
        // 下一步操作
        next_operate: function () {
            if (this.loading) return;

            if (this.pay_method == 1) {
                // 如果是貨到付款,則點擊後跳轉首頁
                location.href = './index.html';
            } else {
                this.loading = true;
                // 線上支付,發送付款請求
                axios.post(this.host + 'payment/ecpay/request/', {
                    order_id: this.order_id
                },{
                    // headers: {
                    //     'Authorization': 'Bearer ' + this.token  //有在html中引入攔截器了
                    // },
                })
                .then(response => {
                    // 從回應取出 redirect_url，(DRF後端 取得ECPAY付款表單的API)
                    const redirectUrl = response.data.redirect_url;
                    if (redirectUrl) {
                        // 訪問後端API獲取綠界HTML表單
                        axios.get(redirectUrl, {
                                responseType: 'text',
                                headers: {
                                'Authorization': 'Bearer ' + this.token
                            }
                            }).then(response => {
                                document.open();               // 清空原頁內容
                                document.write(response.data); // 寫入 HTML 表單
                                document.close();              // 自動觸發 submit
                            }).catch(err => {
                                console.error('無法取得付款頁面:', err);
                                alert('發生錯誤，請稍後再試');
                            });
                        } else {
                            alert('未取得付款頁面連結');
                        }
                    })
                .catch((error) => {
                    console.error('❌ 請求錯誤:', error.response?.data || error.message);
                    alert('付款請求失敗，請稍後再試');
                })
                .finally(() => {
                    this.loading = false;
                });
            }
        }
    }
});
