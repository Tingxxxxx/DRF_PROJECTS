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
        origin_input: 0,  // 手動輸入數量時記錄原本的數值
        
        // =============================
        // 搜尋框專用資料（以下屬性專門用於搜尋欄）
        // =============================
        query: '',
        suggestions: [],
        highlight_index: -1,
        show_suggestions: false,
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

        // 點擊外部事件，用於關閉搜尋建議清單
        document.addEventListener('click', this.handleClickOutside);
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
        },

        // =============================
        // 搜尋框相關方法（以下方法專門用於搜尋欄）
        // =============================

        // 輸入文字時觸發
        on_input() {
        if (!this.query) {
            this.load_history();
        } else {
            this.fetch_suggestions();
        }
        this.show_suggestions = true;
        },

        // 載入搜尋歷史（最多5筆）
        load_history() {
        const key = 'search_history';
        let searchHistory = JSON.parse(localStorage.getItem(key) || '[]');
        this.suggestions = searchHistory.slice(0, 5);
        this.highlight_index = -1;
        },

        // 取得搜尋建議
        fetch_suggestions() {
        axios.get(this.host + 'skus/suggestions/', {
            params: { q: this.query }
        })
        .then(res => {
            this.suggestions = res.data.suggest || [];
            this.highlight_index = -1;
        })
        .catch(err => {
            console.error(err);
            this.suggestions = [];
        });
        },

        // 鍵盤向下移動選項
        move_down() {
        if (this.highlight_index < this.suggestions.length - 1) {
            this.highlight_index++;
            this.scroll_to_highlight();
        }
        },

        // 鍵盤向上移動選項
        move_up() {
        if (this.highlight_index > 0) {
            this.highlight_index--;
            this.scroll_to_highlight();
        }
        },

        // 選擇目前高亮的搜尋建議
        select_item() {
        if (this.highlight_index >= 0 && this.highlight_index < this.suggestions.length) {
            this.query = this.suggestions[this.highlight_index];
        }
        this.on_search();
        this.show_suggestions = false;
        },

        // 點擊建議選項
        select_suggestion(item) {
        this.query = item;
        this.on_search();
        this.show_suggestions = false;
        },

        // 滾動列表讓高亮項目可見
        scroll_to_highlight() {
        this.$nextTick(() => {
            const ul = this.$el.querySelector('.search_suggest');
            const items = ul.querySelectorAll('li');
            if (this.highlight_index >= 0 && items.length > this.highlight_index) {
            const item = items[this.highlight_index];
            const itemTop = item.offsetTop;
            const itemBottom = itemTop + item.offsetHeight;
            const ulScrollTop = ul.scrollTop;
            const ulHeight = ul.clientHeight;

            if (itemTop < ulScrollTop) {
                ul.scrollTop = itemTop;
            } else if (itemBottom > ulScrollTop + ulHeight) {
                ul.scrollTop = itemBottom - ulHeight;
            }
            }
        });
        },

        // 執行搜尋，並存入歷史紀錄（最多10筆）
        on_search() {
        if (!this.query.trim()) return;

        const key = 'search_history';
        let history = JSON.parse(localStorage.getItem(key) || '[]');
        history = history.filter(item => item !== this.query);
        history.unshift(this.query);
        if (history.length > 10) history = history.slice(0, 10);
        localStorage.setItem(key, JSON.stringify(history));

        window.location.href = `search.html?q=${encodeURIComponent(this.query.trim())}`;
        },

        // 點擊頁面其他地方時，隱藏建議列表
        handleClickOutside(event) {
        const searchWrap = this.$el.querySelector('.search_wrap');
        if (searchWrap && !searchWrap.contains(event.target)) {
            this.show_suggestions = false;
        }
        },

        // 文字過長截斷加省略號
        truncate(text, length = 30) {
        if (text.length > length) {
            return text.slice(0, length) + '...';
        }
        return text;
        },
    }
});
