var vm = new Vue({
    el: '#app', // 綁定的 DOM 元素
    data: {
        host, // API 主機位址
        username: sessionStorage.username || localStorage.username, // 取得使用者名稱
        user_id, // 使用者 ID
        skus: [], // 商品資訊清單
        freight: 0, // 運費
        total_count: 0, // 商品總數量
        total_amount: 0, // 商品總金額
        payment_amount: 0, // 實際需付款金額（商品金額 + 運費）
        order_submitting: false, // 是否正在提交訂單
        pay_method: 1, // 支付方式，1 代表預設（例如：貨到付款）
        nowsite: 0, // 當前選擇的地址 ID
        addresses: [] // 用戶地址列表
    },
    mounted: function(){
        // ======= 取得使用者地址列表 =======
        axios.get(this.host + 'users/addresses/', {
                // 已有攔截器處理 token，不需額外加 headers
                responseType: 'json'
            })
            .then(response => {
                this.addresses = response.data.addresses; // 儲存地址清單
                this.nowsite = response.data.default_address_id; // 設定預設地址
            })
            .catch(error => {
                console.log(error.response.data); // 錯誤處理
            });

        // ======= 取得結算頁面商品資訊 =======
        axios.get(this.host + 'orders/settlement/', {
                responseType: 'json'
            })
            .then(response => {
                this.skus = response.data.skus; // 商品列表
                this.freight = response.data.freight; // 運費
                this.total_count = 0;
                this.total_amount = 0;

                // 計算每筆商品的小計及總數量與總金額
                for (var i = 0; i < this.skus.length; i++) {
                    var amount = parseFloat(this.skus[i].price) * this.skus[i].count;
                    this.skus[i].amount = amount.toFixed(2); // 商品小計
                    this.total_count += this.skus[i].count; // 累加數量
                    this.total_amount += amount; // 累加金額
                }

                // 最終付款金額（商品金額 + 運費）
                this.payment_amount = parseFloat(this.freight) + this.total_amount;
                this.payment_amount = this.payment_amount.toFixed(2); // 保留兩位小數
                this.total_amount = this.total_amount.toFixed(2); // 商品金額保留兩位小數
            })
            .catch(error => {
                // 若未登入，跳轉至登入頁面
                if (error.response.status == 401){
                    location.href = './login.html?next=./cart.html';
                } else {
                    console.log(error.response.data);
                }
            });
    },
    methods: {
        // ======= 使用者登出操作 =======
        logout: function(){
            sessionStorage.clear(); // 清除 session 資料
            localStorage.clear();  // 清除 local 資料
            location.href = './login.html'; // 返回登入頁面
        },

        // ======= 提交訂單 =======
        on_order_submit: function(){
            if (this.order_submitting == false){
                this.order_submitting = true; // 避免重複提交
                axios.post(this.host + 'orders/', {
                        address: this.nowsite, // 使用者選擇的地址 ID
                        pay_method: this.pay_method // 使用者選擇的付款方式
                    }, {
                        responseType: 'json'
                    })
                    .then(response => {
                        // 訂單成功後跳轉到成功頁，帶入參數
                        location.href = './order_success.html?order_id=' + response.data.order_id
                            + '&amount=' + this.payment_amount
                            + '&pay=' + this.pay_method;
                    })
                    .catch(error => {
                        this.order_submitting = false; // 提交失敗，解除鎖定
                        alert(error.response.data[0]); // 顯示錯誤訊息
                    });
            }
        }
    }
});
