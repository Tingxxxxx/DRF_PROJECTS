var vm = new Vue({
    el: '#app',
    // 修改 Vue 的變數語法，避免與 Django 模板語法衝突
    delimiters: ['[[', ']]'],
    data: {
        host,
        goodsBaseUrl:'/goods/',
        username: sessionStorage.username || localStorage.username,
        user_id: sessionStorage.user_id || localStorage.user_id,
        access: sessionStorage.access || localStorage.access, 
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
        },
        // =============================
        // 搜尋框專用資料（以下屬性專門用於搜尋欄）
        // =============================
        query: '',
        suggestions: [],
        highlight_index: -1,
        show_suggestions: false,
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
            }, {
                headers: {
                    'Authorization': 'Bearer ' + this.access 
                },
            })
            }
            
        this.get_cart();        // 獲取購物車資料
        this.get_hot_goods();   // 獲取熱銷商品
        // this.get_comments();    // 獲取評論資料
        
        // 點擊外部事件，用於關閉搜尋建議清單
        document.addEventListener('click', this.handleClickOutside);
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
                    headers: {
                        'Authorization': 'Bearer ' + this.access 
                    },
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
                    headers: {
                        'Authorization': 'Bearer ' + this.access 
                    },
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

        window.location.href = `../search.html?q=${encodeURIComponent(this.query.trim())}`;
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
        }
    }
});
