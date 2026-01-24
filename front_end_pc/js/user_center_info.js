new Vue({
    el: "#app",  // 指定 Vue 要掛載的 HTML 元素（用 id 選擇器）
    data: {
      host,  // 後端 API 的根 URL，會用來發送 HTTP 請求
      user_id: sessionStorage.user_id || localStorage.user_id,  // 優先從 sessionStorage 取得 user_id，若沒有則從 localStorage 取得
      token: sessionStorage.access || localStorage.access,  // 優先從 sessionStorage 取得 access token，否則從 localStorage 取得
      username: "",  // 使用者名稱
      histories: [],  // 用戶最近瀏覽紀錄
      mobile: "",  // 使用者手機號碼
      email: "",  // 使用者電子郵件
      email_is_active: false,  // 郵箱是否已驗證，預設為 false
      set_email: false,  // 是否已設定郵箱，預設為 false
      send_email_btn_disabled: false,  // 發送驗證郵件按鈕是否禁用，預設為 false
      send_email_tip: "重新發送驗證郵件",  // 發送驗證郵件按鈕上顯示的提示文字
      email_error: false,  // 郵箱格式錯誤提示，預設為 false
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
            this.mobile = response.data.mobile;
            this.email = response.data.email;
            this.email_is_active = response.data.email_is_active;

            // 如果是登入用戶，則顯示最近瀏覽紀錄
            axios.get(this.host + 'users/browse_histories/', {
                  responseType: 'json'
                })
                .then(response => {
                  this.histories = response.data;
                  for(var i=0; i<this.histories.length; i++){
                  this.histories[i].url = '/goods/' + this.histories[i].id + '.html';
                }
              })
            
          })
          .catch((error) => {
            // 攔截器已處理 401/403，這裡只簡單印出錯誤
            console.error(error);
          });
      } else {
        // 若未登入，導向登入頁並指定登入成功後返回此頁
        location.href = "./login.html?next=./user_center_info.html";
      }

      // 點擊外部事件，用於關閉搜尋建議清單
      document.addEventListener('click', this.handleClickOutside);

      
    },
    methods: {
      logout: function () {
        // 登出邏輯：清除所有存儲並導向登入頁
        sessionStorage.clear();  // 清除 sessionStorage
        localStorage.clear();  // 清除 localStorage
        location.href = "./login.html";  // 導向登入頁
      },
      save_email: function(){
        var re = /^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;  
        if(re.test(this.email)) {
        this.email_error = false;
        } else {
        this.email_error = true;
        return;
        }
        axios.patch(this.host + 'users/me/',  // 路由同一個 但改發PATCH請求，只更新指定欄位
        { email: this.email },
        {
          responseType: 'json'
        })
        .then(response => {
        this.set_email = false;
        this.send_email_btn_disabled = true;
        this.send_email_tip = '已發送信箱激活連結至您的信箱'

        //這裡加上呼叫 showToast
        this.showToast('請查收郵箱中的認證連結，並完成您的郵箱驗證！')
        // 延遲 5 秒後刷新頁面（5000 毫秒）
        setTimeout(() => {
          window.location.reload();
        }, 2000);

              })
        .catch(error => {
          // 檢查是否是 429 錯誤 (限流錯誤)
          if (error.response && error.response.status === 429) {
              this.showToast('請求過於頻繁，請稍後再試。');
          } else {
              // 處理其他錯誤(401、403則是攔截器自動處理了)
              console.error(error);
          }
      });
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
