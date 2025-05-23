var vm = new Vue({
    el: '#app',
    // 修改Vue變量的讀取語法，避免和django模板語法沖突
    delimiters: ['[[', ']]'],
    data: {
        host,
        username: sessionStorage.username || localStorage.username,
        user_id: sessionStorage.user_id || localStorage.user_id,
        token: sessionStorage.token || localStorage.token,
        cart_total_count: 0, // 購物車總數量
        cart: [], // 購物車數據,
        f1_tab: 1, // 1F 標簽頁控制
        f2_tab: 1, // 2F 標簽頁控制
        f3_tab: 1, // 3F 標簽頁控制
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

        }
    }
});