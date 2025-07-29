var vm = new Vue({
    el: '#app',
    // 修改Vue變量的讀取語法，避免和django模板語法沖突
    delimiters: ['[[', ']]'],
    data: {
        host,
        goodsBaseUrl:'/front_end_pc/goods/',
        username: sessionStorage.username || localStorage.username,
        user_id: sessionStorage.user_id || localStorage.user_id,
        token: sessionStorage.access || localStorage.access,
        cart_total_count: 0, // 購物車總數量
        cart: [], // 購物車數據,
        f1_tab: 1, // 1F 標簽頁控制
        f2_tab: 1, // 2F 標簽頁控制
        f3_tab: 1, // 3F 標簽頁控制
        cart_total_count: 0, // 購物車商品總數
        cart: [], // 購物車商品資料
    },
    mounted: function(){
        this.get_cart();
    },
    methods: {
        // 退出
        logout: function(){
            sessionStorage.clear();
            localStorage.clear();
            location.href = '/login.html';
        },
        // 獲取購物車數據
        get_cart: function(){
            axios.get(this.host + 'cart/', {
                    headers: {
                        'Authorization': 'Bearer ' + this.token
                    },
                    responseType: 'json',
                    withCredentials: true
                })
                .then(response => {
                    this.cart = response.data;
                    this.cart_total_count = 0;
                    for (var i = 0; i < this.cart.length; i++) {
                        // 商品名稱超過 25 字元則截斷顯示
                        if (this.cart[i].name.length > 25) {
                            this.cart[i].name = this.cart[i].name.substring(0, 25) + '...';
                        }
                        this.cart_total_count += this.cart[i].count; // 計算總商品數
                    }
                })
                .catch(error => {
                    console.log(error.response.data);
                })
        }
    }
});