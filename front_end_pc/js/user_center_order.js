var vm = new Vue({
  el: '#app',

  data: {
    host: host,
    goodsBaseUrl:'/front_end_pc/goods/',
    username: sessionStorage.username || localStorage.username,  // 使用者名稱（從 session 或 localStorage 取）
    user_id: sessionStorage.user_id || localStorage.user_id,    // 使用者 ID
    orders: [],               // 訂單清單
    currentPage: 1,           // 當前頁碼
    pageSize: 2,              // 每頁筆數
    totalCount: 0,            // 訂單總筆數
    pageGroupSize: 10,        // 每組頁碼的顯示數量
    loadingOrderId: null      // 防止同一筆訂單重複付款的旗標
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
    }
  }
});
