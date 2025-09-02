var vm = new Vue({
  el: '#app',
  delimiters: ['[[', ']]'],
  data: {
    host: host,            
    username: sessionStorage.username || localStorage.username,
    user_id: sessionStorage.user_id || localStorage.user_id,     
    token: sessionStorage.access || localStorage.access,       
    goodsBaseUrl: '/front_end_pc/goods/',  // 商品詳情頁基礎 URL
    query: '',                     // 搜尋框輸入字串
    skus: [],                     // 搜尋結果商品清單（陣列）
    suggestions: [],              // 搜尋建議字串列表
    highlight_index: -1,          // 搜尋建議列表中高亮選中項目索引
    show_suggestions: false,      // 是否顯示搜尋建議下拉選單
    page: 1,                     // 當前分頁頁碼
    page_size: 5,                // 每頁顯示商品數量
    count: 0,                    // 搜尋結果總數（用於計算總頁數）
    cart_total_count: 0,         // 購物車內商品總數量
    cart: [],                    // 購物車商品列表
  },
  computed: {
    // 總頁數
    total_page() {
      return Math.ceil(this.count / this.page_size);
    },
    // 下一頁號碼，無下一頁則為 0
    next() {
      return this.page < this.total_page ? this.page + 1 : 0;
    },
    // 上一頁號碼，無上一頁則為 0
    previous() {
      return this.page > 1 ? this.page - 1 : 0;
    },
    // 分頁按鈕陣列，最多五頁動態顯示
    page_nums() {
      let nums = [];
      if (this.total_page <= 5) {
        for (let i = 1; i <= this.total_page; i++) nums.push(i);
      } else if (this.page <= 3) {
        nums = [1, 2, 3, 4, 5];
      } else if (this.total_page - this.page <= 2) {
        for (let i = this.total_page - 4; i <= this.total_page; i++) nums.push(i);
      } else {
        for (let i = this.page - 2; i <= this.page + 2; i++) nums.push(i);
      }
      return nums;
    }
  },
  mounted() {
    // 頁面載入時從 URL 取得搜尋字串與頁數，還原搜尋狀態
    this.query = this.get_query_string('q') || '';
    this.page = Number(this.get_query_string('page')) || 1;

    if (this.query) {
      this.get_search_result();
    }
    this.get_cart();

    // 點擊頁面空白處關閉建議下拉
    document.addEventListener('click', this.handleClickOutside);
  },
  beforeDestroy() {
    // 移除事件監聽器
    document.removeEventListener('click', this.handleClickOutside);
  },
  methods: {

    /* ----------- 使用者相關 ----------- */

    // 登出並跳轉登入頁
    logout() {
      sessionStorage.clear();
      localStorage.clear();
      location.href = './login.html';
    },


    /* ----------- URL 參數處理 ----------- */

    // 從 URL 查詢字串中取得指定參數值
    get_query_string(name) {
      var reg = new RegExp('(^|&)' + name + '=([^&]*)(&|$)', 'i');
      var r = window.location.search.substr(1).match(reg);
      if (r != null) return decodeURIComponent(r[2]);
      return null;
    },


    /* ----------- 搜尋建議與輸入框控制 ----------- */

    // 輸入框變動時觸發，根據是否有輸入字串決定顯示搜尋歷史或請求建議
    on_input() {
      if (!this.query) {
        this.load_history();
      } else {
        this.fetch_suggestions();
      }
      this.show_suggestions = true;
    },

    // 載入本地搜尋歷史前五筆
    load_history() {
      const key = 'search_history';
      let searchHistory = JSON.parse(localStorage.getItem(key) || '[]');
      this.suggestions = searchHistory.slice(0, 5);
      this.highlight_index = -1;
    },

    // 向後端請求搜尋建議
    fetch_suggestions() {
      axios.get(this.host + 'skus/suggestions/', {
        params: { q: this.query }
      })
      .then(response => {
        this.suggestions = response.data.suggest || [];
        this.highlight_index = -1;
      })
      .catch(error => {
        console.error('補全錯誤', error);
        this.suggestions = [];
      });
    },

    // 使用鍵盤向下鍵選擇建議列表
    move_down() {
      if (this.highlight_index < this.suggestions.length - 1) {
        this.highlight_index++;
        this.scroll_to_highlight();
      }
    },

    // 使用鍵盤向上鍵選擇建議列表
    move_up() {
      if (this.highlight_index > 0) {
        this.highlight_index--;
        this.scroll_to_highlight();
      }
    },

    // 使用鍵盤 Enter 鍵選擇建議項目並搜尋
    select_item() {
      if (this.highlight_index >= 0 && this.highlight_index < this.suggestions.length) {
        this.query = this.suggestions[this.highlight_index];
        this.on_search();
        this.show_suggestions = false;
      }
    },

    // 使用滑鼠點擊建議項目搜尋
    select_suggestion(item) {
      this.query = item;
      this.on_search();
      this.show_suggestions = false;
    },

    // 確保建議列表中的高亮項目可見，滾動視窗到對應位置
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

    // 文本過長截斷並加省略號
    truncate(text, length = 30) {
      if (text.length > length) {
        return text.slice(0, length) + '...';
      }
      return text;
    },


    /* ----------- 搜尋與分頁 ----------- */

    // 執行搜尋，更新搜尋歷史與 URL，並取得搜尋結果
    on_search() {
      const key = 'search_history';
      let searchHistory = JSON.parse(localStorage.getItem(key) || '[]');
      searchHistory = searchHistory.filter(item => item !== this.query);
      searchHistory.unshift(this.query);
      if (searchHistory.length > 10) searchHistory = searchHistory.slice(0, 10);
      localStorage.setItem(key, JSON.stringify(searchHistory));

      this.page = 1;
      const newUrl = `${location.pathname}?q=${encodeURIComponent(this.query)}&page=1`;
      window.history.pushState(null, '', newUrl);

      this.get_search_result();
      this.show_suggestions = false;
    },

    // 從後端取得搜尋結果資料
    get_search_result() {
      axios.get(this.host + 'skus/search/', {
        params: {
          search: this.query,
          page: this.page,
          page_size: this.page_size
        },
        responseType: 'json'
      })
      .then(response => {
        this.count = response.data.count;
        this.skus = response.data.results;
      })
      .catch(error => {
        console.log(error.response.data);
      });
    },

    // 點擊分頁時觸發換頁，更新 URL 並重新取得搜尋結果
    on_page(num) {
      if (num != this.page) {
        this.page = num;
        const newUrl = `${location.pathname}?q=${encodeURIComponent(this.query)}&page=${num}`;
        window.history.pushState(null, '', newUrl);

        this.get_search_result();
      }
    },


    /* ----------- 購物車 ----------- */

    // 取得購物車資訊並計算商品總數，名稱過長截斷
    get_cart() {
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
        for (let i = 0; i < this.cart.length; i++) {
          if (this.cart[i].name.length > 25) {
            this.cart[i].name = this.cart[i].name.substring(0, 25) + '...';
          }
          this.cart_total_count += this.cart[i].count;
        }
      })
      .catch(error => {
        console.log(error.response.data);
      });
    },


    /* ----------- 事件處理 ----------- */

    // 點擊頁面空白處關閉搜尋建議下拉選單
    handleClickOutside(event) {
      const searchWrap = this.$el.querySelector('.search_wrap');
      if (searchWrap && !searchWrap.contains(event.target)) {
        this.show_suggestions = false;
      }
    },

  }
});
