var vm = new Vue({
  el: '#app',

  data: {
    host: host,
    goodsBaseUrl:'/goods/',
    username: sessionStorage.username || localStorage.username,  // 使用者名稱（從 session 或 localStorage 取）
    user_id: sessionStorage.user_id || localStorage.user_id,    // 使用者 ID
    orders: [],               // 訂單清單
    currentPage: 1,           // 當前頁碼
    pageSize: 2,              // 每頁筆數
    totalCount: 0,            // 訂單總筆數
    pageGroupSize: 10,        // 每組頁碼的顯示數量
    loadingOrderId: null,     // 防止同一筆訂單重複付款的旗標
    // =============================
    // 搜尋框專用資料（以下屬性專門用於搜尋欄）
    // =============================
    query: '',
    suggestions: [],
    highlight_index: -1,
    show_suggestions: false
  },

  computed: {
    // 計算總頁數（向上取整）
    totalPages() {
      return Math.ceil(this.totalCount / this.pageSize);
    },

    // 計算當前頁碼所屬的頁碼群組（例如第1~10頁為一組）
    currentPageGroup() {
      return Math.floor((this.currentPage - 1) / this.pageGroupSize);
    },

    // 取得當前群組要顯示的所有頁碼清單
    pageGroupPages() {
      const start = this.currentPageGroup * this.pageGroupSize + 1;
      const end = Math.min(start + this.pageGroupSize - 1, this.totalPages);
      const pages = [];
      for (let i = start; i <= end; i++) {
        pages.push(i);
      }
      return pages;
    },

    // 是否有上一個頁碼群組可切換
    hasPrevPageGroup() {
      return this.currentPageGroup > 0;
    },

    // 是否有下一個頁碼群組可切換
    hasNextPageGroup() {
      return (this.currentPageGroup + 1) * this.pageGroupSize < this.totalPages;
    }
  },

  created() {
    // Vue 實例初始化後立即載入訂單資料
    this.fetchOrders();
  },
  mounted: function(){
   // 點擊外部事件，用於關閉搜尋建議清單
    document.addEventListener('click', this.handleClickOutside); 
  },
  methods: {
    // 取得訂單列表資料
    fetchOrders() {
      axios.get(`${this.host}orders/status/me/?page=${this.currentPage}&page_size=${this.pageSize}`)
        .then(response => {
          this.orders = response.data.results;      // 訂單列表
          this.totalCount = response.data.count;    // 總筆數
        })
        .catch(error => {
          console.error('訂單請求失敗:', error);
        });
    },

    // 切換頁碼
    changePage(page) {
      if (page < 1 || page > this.totalPages) return;
      this.currentPage = page;
      this.fetchOrders();  // 重新取得該頁資料
    },

    // 切換上一組或下一組頁碼群（direction: -1或+1）
    changePageGroup(direction) {
      const newGroup = this.currentPageGroup + direction;
      const newPage = newGroup * this.pageGroupSize + 1;
      if (newPage < 1 || newPage > this.totalPages) return;
      this.changePage(newPage);
    },

    // 商品名稱過長時截斷顯示，加上 "..."
    truncateName(name, length = 25) {
      if (!name) return '';
      return name.length <= length ? name : name.slice(0, length) + '...';
    },

    // 價格只顯示整數（去除小數）
    formatIntPrice(price) {
      return Math.floor(price);
    },

    // 處理單筆訂單付款動作（避免重複點擊）
    handlePay(order) {
      if (this.loadingOrderId === order.order_id) return; // 已在處理中則跳出
      this.loadingOrderId = order.order_id; // 標記正在處理的訂單

      // 呼叫後端 API 取得綠界付款頁
      axios.post(`${this.host}payment/ecpay/request/`, {
        order_id: order.order_id
      })
        .then(response => {
          const redirectUrl = response.data.redirect_url;

          if (redirectUrl) {
            // 再請求取得綠界表單內容，寫入頁面進行付款
            axios.get(redirectUrl, { responseType: 'text' })
              .then(response => {
                document.open();
                document.write(response.data); // 將 ECPay 表單 HTML 寫入頁面
                document.close();
              })
              .catch(err => {
                console.error('無法取得付款頁面:', err);
                alert('發生錯誤，請稍後再試');
              });
          } else {
            alert('未取得付款頁面連結');
          }
        })
        .catch(error => {
          console.error('❌ 請求錯誤:', error.response?.data || error.message);
          alert('付款請求失敗，請稍後再試');
        })
        .finally(() => {
          this.loadingOrderId = null;  // 結束處理，解除鎖定
        });
    },

    // 登出操作：清除使用者資訊並跳轉回登入頁
    logout() {
      sessionStorage.clear();
      localStorage.clear();
      location.href = './login.html';
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
