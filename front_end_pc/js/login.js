var vm = new Vue({
    el: '#app',  // Vue 實例綁定在 HTML 中的 id 為 'app' 的元素上
    data: {
        host: host,  // 引用 host.js 中的 host 變數，通常用於設定 API 伺服器的基礎 URL
        error_username: false,  // 用來標示使用者名稱欄位是否有錯誤
        error_pwd: false,  // 用來標示密碼欄位是否有錯誤
        error_pwd_message: '請填寫密碼',  // 當密碼欄位有錯誤時，顯示的錯誤訊息
        username: '',  // 用來儲存使用者名稱
        password: '',  // 用來儲存密碼
        remember: false  // 用來決定是否記住使用者的登入狀態
    },
    methods: {
        // 獲取網址中的查詢參數
        get_query_string: function(name) {
            var urlParams = new URLSearchParams(window.location.search);  // 獲取 URL 查詢字串
            return urlParams.get(name);  // 根據名稱獲取對應的查詢參數的值
        },

        // 檢查使用者名稱欄位是否為空
        check_username: function() {
            if (!this.username) {
                this.error_username = true;  // 如果使用者名稱為空，設置錯誤標記
            } else {
                this.error_username = false;  // 如果使用者名稱非空，清除錯誤標記
            }
        },

        // 檢查密碼欄位是否為空
        check_pwd: function() {
            if (!this.password) {
                this.error_pwd_message = '請填寫密碼';  // 如果密碼為空，顯示錯誤訊息
                this.error_pwd = true;  // 設置密碼錯誤標記
            } else {
                this.error_pwd = false;  // 如果密碼非空，清除錯誤標記
            }
        },

        // 表單提交方法，檢查使用者名稱與密碼，並發送登入請求
        on_submit: function() {
            this.check_username();  // 檢查使用者名稱是否有效
            this.check_pwd();  // 檢查密碼是否有效

            // 如果使用者名稱和密碼都合法，進行 API 請求
            if (this.error_username == false && this.error_pwd == false) {
                // 發送 POST 請求給後端 API，並傳遞使用者名稱和密碼
                axios.post(this.host + 'users/token/', {
                        username: this.username,  // 使用者名稱
                        password: this.password   // 密碼
                    }, {
                        responseType: 'json',  // 設置回應類型為 JSON
                        withCredentials: true  // 允許跨域請求攜帶憑證（如 cookies）
                    })
                    .then(response => {
                        // 處理登入成功後的回應
                        if (this.remember) {
                            // 如果選擇記住登入，將 token 和用戶信息保存在 localStorage
                            sessionStorage.clear();  // 清除 sessionStorage
                            localStorage.access = response.data.access;
                            localStorage.refresh = response.data.refresh;
                            localStorage.user_id = response.data.user_id;  // 保存用戶 ID
                            localStorage.username = response.data.username;  // 保存用戶名稱
                        } else {
                            // 如果不記住登入，將 token 和用戶信息保存在 sessionStorage
                            localStorage.clear();  // 清除 localStorage
                            localStorage.access = response.data.access;   // 保存後端響應的 access token
                            localStorage.refresh = response.data.refresh; // 保存後端響應的 refresh token
                            sessionStorage.user_id = response.data.user_id;  // 保存用戶 ID
                            sessionStorage.username = response.data.username;  // 保存用戶名稱
                        }

                        // 登入成功後跳轉到原來的頁面（如果有提供 `next` 參數）
                        var return_url = this.get_query_string('next');  // 獲取網址中的 `next` 參數
                        if (!return_url) {
                            return_url = 'index.html';  // 如果沒有提供 `next`，則默認跳轉到首頁
                        }
                        location.href = return_url;  // 跳轉到指定頁面
                    })
                    .catch(error => {
                        // 錯誤處理，如果 API 返回錯誤
                        if (error.response.status == 400) {
                            this.error_pwd_message = '用戶名或密碼錯誤';  // 顯示錯誤訊息
                        } else {
                            this.error_pwd_message = '伺服器錯誤';  // 顯示伺服器錯誤訊息
                        }
                        this.error_pwd = true;  // 設置密碼欄位錯誤標記
                    })
            }
        },

        // 第三方登入方法（尚未實現）
        qq_login: function() {
            // 在這裡可以實現登入的邏輯
        }
    }
})
