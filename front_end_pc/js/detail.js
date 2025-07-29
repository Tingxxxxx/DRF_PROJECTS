var vm = new Vue({
    el: '#app',
    // 修改 Vue 的變數語法，避免與 Django 模板語法衝突
    delimiters: ['[[', ']]'],
    data: {
        host,
        goodsBaseUrl:'/front_end_pc/goods/',
        username: sessionStorage.username || localStorage.username,
        user_id: sessionStorage.user_id || localStorage.user_id,
        // access: sessionStorage.access || localStorage.access, //有用攔截器了
        toastMessage: "",  // 用於顯示 Toast 訊息的內容
        toastVisible: false,  // 控制 Toast 是否顯示
        tab_content: {
            detail: true,    // 商品詳情
            pack: false,     // 包裝資訊
            comment: false,  // 商品評論
            service: false   // 售後服務
        },
        sku_id: '',           // 商品 SKU ID
        sku_count: 1,         // 商品數量
        sku_price: price,     // 單價
        cart_total_count: 0,  // 購物車中商品總數量
        cart: [],             // 購物車資料
        hots: [],             // 熱銷商品資料
        cat: cat,             // 商品分類 ID
        comments: [],         // 評論資料
        score_classes: {      // 評分對應的 CSS 類名
            1: 'stars_one',
            2: 'stars_two',
            3: 'stars_three',
            4: 'stars_four',
            5: 'stars_five',
        }
    },
    computed: {
        // 計算總金額（價格 * 數量），保留小數點後兩位
        sku_amount: function(){
            return (this.sku_price * this.sku_count).toFixed(2);
        }
    },
    mounted: function(){
        // 新增使用者的瀏覽紀錄
        this.get_sku_id();

        if (this.user_id) {
            // 只有登入用戶才添加瀏覽紀錄，商品詳情html中有引入攔截器了故這裡不用寫
            axios.post(this.host + 'users/browse_histories/', { 
                sku_id: this.sku_id
            })
        }

        this.get_cart();        // 獲取購物車資料
        this.get_hot_goods();   // 獲取熱銷商品
        // this.get_comments();    // 獲取評論資料
    },
    methods: {
        // 使用者登出
        logout: function(){
            sessionStorage.clear();
            localStorage.clear();
            location.href = '/login.html';
        },
        // 控制頁籤切換顯示內容
        on_tab_content: function(name){
            this.tab_content = {
                detail: false,
                pack: false,
                comment: false,
                service: false
            };
            this.tab_content[name] = true;
        },
        // 從網址中提取 SKU ID
        get_sku_id: function(){
            var re = /\/goods\/(\d+)\.html$/;
            this.sku_id = document.location.pathname.match(re)[1];
        },
        // 減少購買數量
        on_minus: function(){
            if (this.sku_count > 1) {
                this.sku_count--;
            }
        },
        // 加入商品到購物車
        add_cart: function(){
            axios.post(this.host+'cart/', {
                    sku_id: parseInt(this.sku_id),
                    count: this.sku_count
                }, {
                    // headers: {
                    //     'Authorization': 'Bearer ' + this.access  //有在html中引入攔截器了
                    // },
                    responseType: 'json',
                    withCredentials: true // 前端在此跨域請求中要攜帶cookie，故需要在axios中設定 withCredentials: true
                })
                .then(response => {
                    this.showToast('已加入到購物車');
                    // alert('已加入到購物車');
                    this.cart_total_count += response.data.count;
                })
                .catch(error => {
                    if ('non_field_errors' in error.response.data) {
                        alert(error.response.data.non_field_errors[0]);
                    } else {
                        this.showToast('購物車添加失敗');
                        // alert('購物車添加失敗');
                    }
                    console.log(error.response.data);
                })
        },
        // 獲取購物車資訊
        get_cart: function(){
            axios.get(this.host + 'cart/', {
                    responseType: 'json',
                    withCredentials: true
                })
                .then(response => {
                    this.cart = response.data;
                    this.cart_total_count = 0;
                    for (var i = 0; i < this.cart.length; i++) {
                        // 商品名稱超過 25 個字元則進行截斷
                        if (this.cart[i].name.length > 25) {
                            this.cart[i].name = this.cart[i].name.substring(0, 25) + '...';
                        }
                        this.cart_total_count += this.cart[i].count; // 累計總商品數量
                    }
                })
                .catch(error => {
                    console.log(error.response.data);
                })
        },
        // 獲取熱銷商品資料
        get_hot_goods: function(){
            axios.get(this.host + 'categories/' + this.cat + '/skus/hot', {
                    responseType: 'json'
                })
                .then(response => {
                    this.hots = response.data.results;
                    for (var i = 0; i < this.hots.length; i++) {
                        this.hots[i].url = this.goodsBaseUrl + this.hots[i].id + '.html';
                    }
                })
                .catch(error => {
                    console.log(error.response.data);
                })
        },
        // 獲取商品評論資料（待實作）
        get_comments: function(){
            
        },
        // 添加購物車 彈窗提示訊息
        showToast: function (message) {
        // 顯示 Toast 訊息
        this.toastMessage = message;
        this.toastVisible = true;

        // 設定 1.5 秒後自動隱藏 Toast
        setTimeout(() => {
        this.toastVisible = false;
            }, 1500);
        }
    }
});
