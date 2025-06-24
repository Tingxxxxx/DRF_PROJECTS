// 建立 Vue 實例
var vm = new Vue({
    el: '#app',  // 掛載到 id 為 app 的元素
    data: {
        host,  // API 主機地址（需提前定義）
        // 從 sessionStorage 或 localStorage 取得使用者資訊
        username: sessionStorage.username || localStorage.username,
        user_id: sessionStorage.user_id || localStorage.user_id,
        // token: sessionStorage.access || localStorage.access, //有用攔截器了
        cart: [],  // 購物車商品清單
        total_selected_count: 0,  // 所有勾選商品的總數量
        origin_input: 0  // 手動輸入數量時記錄原本的數值
    },
    computed: {
        // 計算購物車中所有商品的總數量，同時計算每項商品的小計（amount）
        total_count: function(){
            var total = 0;
            for(var i=0; i<this.cart.length; i++){
                total += parseInt(this.cart[i].count);  // 累加商品數量
                this.cart[i].amount = (parseFloat(this.cart[i].price) * parseFloat(this.cart[i].count)).toFixed(2);  // 計算小計金額
            }
            return total;
        },
        // 計算所有已勾選商品的總金額
        total_selected_amount: function(){
            var total = 0;
            this.total_selected_count = 0;
            for(var i=0; i<this.cart.length; i++){
                if(this.cart[i].selected) {
                    total += (parseFloat(this.cart[i].price) * parseFloat(this.cart[i].count));
                    this.total_selected_count += parseInt(this.cart[i].count);  // 計算勾選商品數量
                }
            }
            return total.toFixed(2);  // 四捨五入至小數點第2位
        },
        // 判斷是否「全選」
        selected_all: function(){
            var selected = true;
            for(var i=0; i<this.cart.length; i++){
                if(!this.cart[i].selected){  // 有任一商品沒被勾選，則不是全選
                    selected = false;
                    break;
                }
            }
            return selected;
        }
    },
    mounted: function(){
        // 頁面加載完成後，向後端請求購物車資料
        // cart.html中已引入攔截器，故下面請求都不加 Authorization headers
        axios.get(this.host + 'cart/', {
            responseType: 'json',
            withCredentials: true  // 帶上 cookie 等憑證資訊
        })
        .then(response => {
            this.cart = response.data;
            // 為每一筆商品計算小計金額
            for(var i=0; i<this.cart.length; i++){
                this.cart[i].amount = (parseFloat(this.cart[i].price) * this.cart[i].count).toFixed(2);
            }
        })
        .catch(error => {
            console.log(error.response.data);  // 輸出錯誤訊息
        })
    },
    methods: {
        // 登出：清除登入資訊並跳轉到登入頁面
        logout: function(){
            sessionStorage.clear();
            localStorage.clear();
            location.href = './login.html';
        },
        // 商品數量減一（最少為1）
        on_minus: function(index){
            if (this.cart[index].count > 1) {
                var count = this.cart[index].count - 1;
                this.update_count(index, count);  // 呼叫更新方法
            }
        },
        // 商品數量加一
        on_add: function(index){
            var count = this.cart[index].count + 1;
            this.update_count(index, count);
        },
        // 勾選或取消「全選」
        on_selected_all: function(){
            var selected = !this.selected_all;  // 若原本是全選，則變為全不選
            axios.put(this.host + 'cart/selection/', {
                selected
            }, {
                responseType: 'json',
                withCredentials: true
            })
            .then(response => {
                // 所有商品勾選狀態更新
                for (var i=0; i<this.cart.length; i++){
                    this.cart[i].selected = selected;
                }
            })
            .catch(error => {
                console.log(error.response.data);
            })
        },
        // 刪除購物車中某項商品
        on_delete: function(index){
            axios.delete(this.host + 'cart/', {
                data: {
                    sku_id: this.cart[index].id  // 指定商品 ID
                },
                responseType: 'json',
                withCredentials: true
            })
            .then(response => {
                this.cart.splice(index, 1);  // 從前端刪除此項商品
            })
            .catch(error => {
                console.log(error.response.data);
            })
        },
        // 當手動輸入商品數量並按下 Enter 時觸發
        on_input: function(index){
            var val = parseInt(this.cart[index].count);
            if (isNaN(val) || val <= 0) {
                // 若輸入無效，恢復原本數值
                this.cart[index].count = this.origin_input;
            } else {
                // 向後端送出更新請求
                axios.put(this.host + 'cart/', {
                    sku_id: this.cart[index].id,
                    count: val,
                    selected: this.cart[index].selected
                }, {
                    responseType: 'json',
                    withCredentials: true
                })
                .then(response => {
                    this.cart[index].count = response.data.count;  // 更新成功後同步新數值
                })
                .catch(error => {
                    // 顯示錯誤訊息並還原原本數值
                    if ('non_field_errors' in error.response.data) {
                        alert(error.response.data.non_field_errors[0]);
                    } else {
                        alert('修改購物車失敗');
                    }
                    console.log(error.response.data);
                    this.cart[index].count = this.origin_input;
                })
            }
        },
        // 將商品數量更新到後端
        update_count: function(index, count){
            axios.put(this.host + 'cart/', {
                sku_id: this.cart[index].id,
                count,
                selected: this.cart[index].selected
            }, {
                responseType: 'json',
                withCredentials: true
            })
            .then(response => {
                this.cart[index].count = response.data.count;
            })
            .catch(error => {
                if ('non_field_errors' in error.response.data) {
                    alert(error.response.data.non_field_errors[0]);
                } else {
                    alert('修改購物車失敗');
                }
                console.log(error.response.data);
            })
        },
        // 勾選或取消勾選某一項商品
        update_selected: function(index) {
            axios.put(this.host + 'cart/', {
                sku_id: this.cart[index].id,
                count: this.cart[index].count,
                selected: this.cart[index].selected
            }, {
                responseType: 'json',
                withCredentials: true
            })
            .then(response => {
                this.cart[index].selected = response.data.selected;
            })
            .catch(error => {
                if ('non_field_errors' in error.response.data) {
                    alert(error.response.data.non_field_errors[0]);
                } else {
                    alert('修改購物車失敗');
                }
                console.log(error.response.data);
            })
        }
    }
});
