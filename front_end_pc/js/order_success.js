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
    },
    computed: {
        operate: function(){
            if (this.pay_method == 1){
                return '繼續購物';
            } else {
                return '前往付款';
            }
        }
    },
    mounted: function(){
        this.order_id = this.get_query_string('order_id');
        this.amount = this.get_query_string('amount');
        this.pay_method = this.get_query_string('pay');
    },
    methods: {
        // 登出
        logout: function(){
            sessionStorage.clear();
            localStorage.clear();
            location.href = '/login.html';
        },
        // 取得 URL 查詢參數
        get_query_string: function(name){
            var reg = new RegExp('(^|&)' + name + '=([^&]*)(&|$)', 'i');
            var r = window.location.search.substr(1).match(reg);
            if (r != null) {
                return decodeURI(r[2]);
            }
            return null;
        },
        next_operate: function(){
            if (this.pay_method == 1) {
                location.href = './index.html';
            } else {
                // 發起付款

            }
        }
    }
});
