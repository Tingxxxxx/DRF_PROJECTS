new Vue({
  el: "#app",  // 指定 Vue 要掛載的 HTML 元素（用 id 選擇器）
  data: {
    host,  // 後端 API 的根 URL，會用來發送 HTTP 請求
    user_id: sessionStorage.user_id || localStorage.user_id,  // 優先從 sessionStorage 取得 user_id，若沒有則從 localStorage 取得
    token: sessionStorage.access || localStorage.access,  // 優先從 sessionStorage 取得 access token，否則從 localStorage 取得
    username: "",  // 使用者名稱
    mobile: "",  // 使用者手機號碼
    email: "",  // 使用者電子郵件
    email_active: false,  // 郵箱是否已驗證，預設為 false
    set_email: false,  // 是否已設定郵箱，預設為 false
    send_email_btn_disabled: false,  // 發送驗證郵件按鈕是否禁用，預設為 false
    send_email_tip: "重新發送驗證郵件",  // 發送驗證郵件按鈕上顯示的提示文字
    email_error: false,  // 郵箱格式錯誤提示，預設為 false
    toastMessage: "",  // 用於顯示 Toast 訊息的內容
    toastVisible: false,  // 控制 Toast 是否顯示
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
          this.email_active = response.data.email_active;
        })
        .catch((error) => {
          // 攔截器已處理 401/403，這裡只簡單印出錯誤
          console.error(error);
        });
    } else {
      // 若未登入，導向登入頁並指定登入成功後返回此頁
      location.href = "./login.html?next=./user_center_info.html";
    }
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
  },
});
