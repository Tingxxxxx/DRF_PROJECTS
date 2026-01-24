var vm = new Vue({
  el: '#app',
  // 修改 Vue 變量語法，避免與 Django 模板語法衝突
  delimiters: ['[[', ']]'],
  data: {
    host,
    goodsBaseUrl: '/goods/',
    username: sessionStorage.username || localStorage.username,
    user_id: sessionStorage.user_id || localStorage.user_id,
    token: sessionStorage.access || localStorage.access,
    cart_total_count: 0,  // 購物車商品總數
    cart: [],             // 購物車商品資料
    f1_tab: 1,  // 1F 標籤頁控制
    f2_tab: 1,  // 2F 標籤頁控制
    f3_tab: 1,  // 3F 標籤頁控制

    // =============================
    // 搜尋框專用資料（以下屬性專門用於搜尋欄）
    // =============================
    query: '',
    suggestions: [],
    highlight_index: -1,
    show_suggestions: false,
  },
  mounted: function() {
    this.get_cart();
    // 點擊外部事件，用於關閉搜尋建議清單
    document.addEventListener('click', this.handleClickOutside);
  },
  methods: {
    // 使用者登出
    logout: function() {
      sessionStorage.clear();
      localStorage.clear();
      location.href = '/login.html';
    },

    // 從 API 取得購物車商品資料
    get_cart: function() {
      axios.get(this.host + 'cart/', {
        headers: { 'Authorization': 'Bearer ' + this.token },
        responseType: 'json',
        withCredentials: true
      })
      .then(response => {
        this.cart = response.data;
        this.cart_total_count = 0;

        // 商品名稱過長時截斷並加省略號
        for (var i = 0; i < this.cart.length; i++) {
          if (this.cart[i].name.length > 25) {
            this.cart[i].name = this.cart[i].name.substring(0, 25) + '...';
          }
          this.cart_total_count += this.cart[i].count;  // 計算總商品數
        }
      })
      .catch(error => {
        console.log(error.response.data);
      });
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
