new Vue({
    el: "#app",  // 指定 Vue 要掛載的 HTML 元素（用 id 選擇器）
    data: {
      host,  // 後端 API 的根 URL，會用來發送 HTTP 請求
      user_id: sessionStorage.user_id || localStorage.user_id,  // 優先從 sessionStorage 取得 user_id，若沒有則從 localStorage 取得
      token: sessionStorage.access || localStorage.access,  // 優先從 sessionStorage 取得 access token，否則從 localStorage 取得
      username: "",  // 使用者名稱
      oldPassword: "",
      newPassword: "",
      newPassword2: "",
      error_password: false,
      error_check_password: false,
      toastMessage: "",  // 用於顯示 Toast 訊息的內容
      toastVisible: false,  // 控制 Toast 是否顯示


        // =============================
        // 搜尋框專用資料（以下屬性專門用於搜尋欄）
        // =============================
        query: '',
        suggestions: [],
        highlight_index: -1,
        show_suggestions: false
        },
    mounted() {
        // Vue 實例掛載完成後執行的邏輯
      
        // 重新確認 user_id 和 token（有可能頁面刷新了重新抓取）
        this.user_id = sessionStorage.user_id || localStorage.user_id;
        this.token = sessionStorage.access || localStorage.access;

        if (this.user_id && this.token) {
        // 若已登入（有 user_id 和 token），發送請求獲取使用者資訊
        axios
          .get(this.host + "users/me/")  // 發送 GET 請求至後端 API 取得當前使用者資訊
          .then((response) => {
            // 回應成功，填充使用者資料
            this.username = response.data.username;
          })
          .catch((error) => {
            // 攔截器已處理 401/403，這裡只簡單印出錯誤
            console.error(error);
          });
            } else {
            // 若未登入，導向登入頁並指定登入成功後返回此頁
            location.href = "./login.html?next=./user_center_pass.html";
        }

        // 點擊外部事件，用於關閉搜尋建議清單
        document.addEventListener('click', this.handleClickOutside);
      
    },
    methods: {

        // 檢查密碼是否符合長度要求（8~20 字符）
        check_pwd: function () {
        var len = this.newPassword.length;
        if (len < 8 || len > 20) {
            this.error_password = true; // 密碼長度不符合要求，顯示錯誤提示
        } else {
            this.error_password = false; // 密碼長度符合要求，隱藏錯誤提示
        }
        },
        
        // 檢查確認密碼是否與輸入的密碼一致
        check_cpwd: function () {
        if (this.newPassword !== this.newPassword2) {
            this.error_check_password = true; // 密碼不一致，顯示錯誤提示
        } else {
            this.error_check_password = false; // 密碼一致，隱藏錯誤提示
        }
        },

        //提交密碼
        submitChange() {
          if (this.error_password) {
              this.showToast("新密碼長度不正確！");
              return;
          }
          if (this.error_check_password) {
              this.showToast("確認密碼不一致！");
              return;
          }

          axios.post(this.host + 'users/change_password/', {
              old_password: this.oldPassword,
              new_password: this.newPassword
          }, {
              headers: { Authorization: `Bearer ${this.token}` }
          })
          .then(res => {
              this.showToast(res.data.detail || "密碼修改成功！");
              this.oldPassword = "";
              this.newPassword = "";
              this.newPassword2 = "";
          })
          .catch(err => {
              // 統一抓 detail
              let msg = err.response?.data?.detail[0] || "修改失敗";
              this.showToast(msg);
          });
        },


        logout: function () {
            // 登出邏輯：清除所有存儲並導向登入頁
            sessionStorage.clear();  // 清除 sessionStorage
            localStorage.clear();  // 清除 localStorage
            location.href = "/login.html";  // 導向登入頁
        },

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

    },
});
