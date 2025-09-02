var vm = new Vue({
    el: '#app',
    delimiters: ['[[', ']]'], // 修改 Vue 模板符號，避免與 Django 的模板符號衝突
    data: {
        host: host,
        goodsBaseUrl:'/front_end_pc/goods/',
        username: sessionStorage.username || localStorage.username, // 儲存使用者名稱
        user_id: sessionStorage.user_id || localStorage.user_id, // 儲存使用者 ID
        token: sessionStorage.access || localStorage.access, // 儲存使用者登入 token
        cat: '', // 當前商品類別 ID
        page: 1, // 當前頁碼
        page_size: 5, // 每頁商品數量
        ordering: '-create_time', // 商品排序方式（預設為建立時間倒序）
        count: 0,  // 商品總數量
        skus: [], // 當前頁面要顯示的商品資料
        cat1: {url: '', category:{name:'', id:''}},  // 第1級類別資訊
        cat2: {name:''},  // 第2級類別資訊
        cat3: {name:''},  // 第3級類別資訊
        cart_total_count: 0, // 購物車商品總數
        cart: [], // 購物車商品資料
        hots: [], // 熱銷商品資料

        // =============================
        // 搜尋框專用資料（以下屬性專門用於搜尋欄）
        // =============================
        query: '',
        suggestions: [],
        highlight_index: -1,
        show_suggestions: false,
        },

    computed: {
        // 計算總頁數
        total_page: function(){
            return Math.ceil(this.count / this.page_size);
        },
        // 下一頁頁碼
        next: function(){
            if (this.page >= this.total_page) {
                return 0;
            } else {
                return this.page + 1;
            }
        },
        // 上一頁頁碼
        previous: function(){
            if (this.page <= 0) {
                return 0;
            } else {
                return this.page - 1;
            }
        },
        // 動態生成要顯示的頁碼列表
        page_nums: function(){
            var nums = [];
            if (this.total_page <= 5) {
                for (var i = 1; i <= this.total_page; i++) {
                    nums.push(i);
                }
            } else if (this.page <= 3) {
                nums = [1, 2, 3, 4, 5];
            } else if (this.total_page - this.page <= 2) {
                for (var i = this.total_page; i > this.total_page - 5; i--) {
                    nums.push(i);
                }
            } else {
                for (var i = this.page - 2; i < this.page + 3; i++) {
                    nums.push(i);
                }
            }
            return nums;
        }
    },
    mounted: function(){
        // 頁面載入時從網址參數中獲取商品類別 ID
        this.cat = this.get_query_string('cat');

        // 以下功能可以根據需求開啟
        this.get_skus(); // 獲取商品列表
        this.get_categories(); // 
        
        this.get_cart(); // 獲取購物車資料
        this.get_hot_goods(); // 獲取熱銷商品
        
        // 點擊外部事件，用於關閉搜尋建議清單
        document.addEventListener('click', this.handleClickOutside);
    },
    methods: {
        // 使用者登出，清除儲存資訊並跳轉至登入頁面
        logout(){
            sessionStorage.clear();
            localStorage.clear();
            location.href = './login.html';
        },
        // 從網址中取得指定名稱的參數值
        get_query_string: function(name){
            var reg = new RegExp('(^|&)' + name + '=([^&]*)(&|$)', 'i');
            var r = window.location.search.substr(1).match(reg);
            if (r != null) {
                return decodeURI(r[2]);
            }
            return null;
        },
        // 向伺服器請求商品列表資料
        get_skus: function(){
            axios.get(this.host + 'categories/' + this.cat + '/skus/', {
                    params: {
                        page: this.page,
                        page_size: this.page_size,
                        ordering: this.ordering
                    },
                    responseType: 'json'
                })
                .then(response => {
                    this.count = response.data.count; // 更新總商品數
                    this.skus = response.data.results; // 更新商品列表
                    // 為每個商品添加商品詳情頁面的 URL
                    // for (var i = 0; i < this.skus.length; i++) {
                    //     this.skus[i].url = '/goods/' + this.skus[i].id + ".html";
                    // }
                })
                .catch(error => {
                    console.log(error.response.data);
                })
        },
        // 點擊分頁頁碼時觸發
        on_page: function(num){
            if (num != this.page) {
                this.page = num;
                this.get_skus();
            }
        },
        // 點擊排序方式時觸發
        on_sort: function(ordering){
            if (ordering != this.ordering) {
                this.page = 1;
                this.ordering = ordering;
                this.get_skus();
            }
        },
        // 獲取類別的麵包屑資訊（例如：男裝 > 上衣 > T恤）
        get_categories: function () {
            axios.get(this.host + 'categories/' + this.cat + '/', {
                responseType:'json'
            })
            .then(response => {
                this.cat1 = response.data.cat1;
                this.cat2 = response.data.cat2;
                this.cat3 = response.data.cat3;
            })
            .catch(error => {
                console.log(error.response.data)
            });
        },
        // 獲取購物車資訊
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
        },
        // 獲取熱銷商品資料
        get_hot_goods: function(){
            axios.get(this.host + 'categories/' + this.cat + '/skus/hot', {
                    responseType: 'json'
                })
                .then(response => {
                    this.hots = response.data.results;
                })
                .catch(error => {
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
