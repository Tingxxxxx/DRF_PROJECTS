var vm = new Vue({
    el: '#app', // Vue 實例掛載的 DOM 元素，表示該 Vue 實例綁定在 HTML 中 id 為 app 的元素上
    data: {
        host, // 後端的 URL 變量（通常在 host.js 文件中定義，應該包含 API 根 URL）

        // 錯誤提示相關標誌，控制各種輸入框的錯誤狀態
        error_name: false, // 用戶名格式錯誤標誌
        error_password: false, // 密碼格式錯誤標誌
        error_check_password: false, // 確認密碼錯誤標誌
        error_phone: false, // 手機號碼格式錯誤標誌
        error_allow: false, // 是否同意條款錯誤標誌
        error_email: false, // Email 格式錯誤標誌
        error_email_code: false, // Email 驗證碼錯誤標誌
        sending_flag: false, // 防止多次請求的標誌，防止重複點擊按鈕發送請求

        // 表單字段，用於綁定輸入框數據
        username: '', // 用戶名
        password: '', // 密碼
        password2: '', // 確認密碼
        mobile: '', // 手機號碼
        email: '', // Email 地址
        email_code: '', // Email 驗證碼
        allow: false, // 是否同意條款，checkbox 選項

        // UI 提示文本，用於顯示 Email 驗證碼按鈕的提示文字
        email_code_tip: '獲取驗證信', // Email 驗證碼按鈕初始文字
        error_email_code_tip: '' ,// Email 驗證碼錯誤提示信息
        error_name_message: '', // 用戶名重復提示信息
        error_phone_message: '' // 手機重複提示信息

    },
    methods: {
        // 檢查用戶名是否符合長度要求（5~20 字符）
        check_username: function () {
            var len = this.username.length;
            if (len < 5 || len > 20) {
                this.error_name = true; // 長度不符合要求，顯示錯誤提示
            } else {
                this.error_name = false; // 長度符合要求，隱藏錯誤提示
            }
            // 檢查用戶名是否重複註冊
            if (this.error_name == false) {
                axios.get(this.host + 'users/username/' + this.username + '/', {
                responseType: 'json'
                })
                .then(response => {
                if (response.data.count > 0) {   // 如果count 大於 0 代表有重複
                this.error_name_message = '該帳號已存在';
                this.error_name = true;
                } else {
                this.error_name = false;
                }
                })
                .catch(error => {
                console.log(error.response.data);
                })
            }
        },
        
        // 檢查密碼是否符合長度要求（8~20 字符）
        check_pwd: function () {
            var len = this.password.length;
            if (len < 8 || len > 20) {
                this.error_password = true; // 密碼長度不符合要求，顯示錯誤提示
            } else {
                this.error_password = false; // 密碼長度符合要求，隱藏錯誤提示
            }
        },
        
        // 檢查確認密碼是否與輸入的密碼一致
        check_cpwd: function () {
            if (this.password !== this.password2) {
                this.error_check_password = true; // 密碼不一致，顯示錯誤提示
            } else {
                this.error_check_password = false; // 密碼一致，隱藏錯誤提示
            }
        },
        
        // 檢查手機號碼格式（台灣手機號碼格式：09 開頭，後面 8 位數字）
        check_phone: function () {
            var re = /^09\d{8}$/; // 正則表達式匹配台灣手機號碼格式
            if (re.test(this.mobile)) {
                this.error_phone = false; // 格式正確，隱藏錯誤提示
            } else {
                this.error_phone = true; // 格式錯誤，顯示錯誤提示
            }
            if (this.error_phone == false) {
                axios.get(this.host + 'users/mobile/'+ this.mobile + '/', {
                responseType: 'json'
                })
                .then(response => {
                if (response.data.count > 0) {   // 如果count 大於 0 代表有重複
                this.error_phone_message = '該手機號碼已註冊';
                this.error_phone = true;
                } else {
                this.error_phone = false;
                }
                })
                .catch(error => {
                console.log(error.response.data);
                })
                }
        },
        
        // 檢查 Email 格式是否正確
        check_email: function () {
            var emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/; // 正則表達式檢查 Email 格式
            if (!emailPattern.test(this.email)) {
                this.error_email = true; // 格式錯誤，顯示錯誤提示
            } else {
                this.error_email = false; // 格式正確，隱藏錯誤提示
            }
        },
        
        // 檢查 Email 驗證碼是否已輸入
        check_email_code: function () {
            if (!this.email_code) {
                this.error_email_code = true; // 未輸入驗證碼，顯示錯誤提示
            } else {
                this.error_email_code = false; // 已輸入驗證碼，隱藏錯誤提示
            }
        },
        
        // 檢查是否勾選了「同意條款」
        check_allow: function () {
            if (!this.allow) {
                this.error_allow = true; // 未勾選同意條款，顯示錯誤提示
            } else {
                this.error_allow = false; // 已勾選同意條款，隱藏錯誤提示
            }
        },
        
        // 發送 Email 驗證碼
        send_email_code: function () {
            // 防止用戶重複點擊按鈕發送請求
            if (this.sending_flag) {
                return;
            }
            this.sending_flag = true;

            // 檢查 Email 格式是否正確
            this.check_email();
            if (this.error_email) {
                this.sending_flag = false; // 格式錯誤，停止發送請求
                return;
            }

            // 發送請求到後端 API 請求發送 Email 驗證碼
            axios.get(this.host + '/verifications/code/', {
                params: {
                    email: this.email // 傳送 Email 參數到後端
                }
            })
            .then(response => {
                // 成功發送後啟動倒計時
                console.log(response);
                var num = 60; // 設定倒計時秒數
                var timer = setInterval(() => {
                    if (num === 1) {
                        clearInterval(timer); // 倒計時結束，清除計時器
                        this.email_code_tip = '獲取驗證信'; // 重設按鈕文字
                        this.sending_flag = false; // 恢復發送按鈕狀態
                    } else {
                        num -= 1;
                        this.email_code_tip = num + '秒'; // 顯示剩餘秒數
                    }
                }, 1000);
            })
            .catch(error => {
                // 處理錯誤請求
                if (error.response && error.response.status === 400) {
                    alert(error.response.data.error || '驗證信發送失敗'); // 顯示錯誤提示
                } else {
                    console.error(error.response.data || '未知錯誤'); // 控制台打印錯誤信息
                }
                this.sending_flag = false; // 恢復發送按鈕狀態
            });
        },
        
        // 提交表單
        on_submit: function (event) {
            event.preventDefault();  // ⛔️ 阻止表單預設提交行為
            // 依次檢查各個輸入字段
            this.check_username();
            this.check_pwd();
            this.check_cpwd();
            this.check_phone();
            this.check_email();
            this.check_email_code();
            this.check_allow();

            // 如果所有檢查均通過，則提交表單
            if (
                !this.error_name &&
                !this.error_password &&
                !this.error_check_password &&
                !this.error_phone &&
                !this.error_email &&
                !this.error_email_code &&
                !this.error_allow
            ) {
                // 提交表單數據到後端
                axios.post(this.host + '/users/', {
                    username: this.username,
                    password: this.password,
                    password2: this.password2,
                    email: this.email,
                    mobile: this.mobile,
                    email_code: this.email_code,
                    allow: this.allow.toString() // 轉換為字串（true/false）
                },{
                    responseType: 'json' // 指定回應的格式
                })
                .then(response => {
                    // 後端註冊視圖會返回token，存到前端儲存空間中
                    sessionStorage.clear();
                        localStorage.clear();
                        localStorage.access = response.data.access;
                        localStorage.refresh = response.data.refresh;
                        localStorage.username = response.data.username;
                        localStorage.user_id = response.data.id;
                        location.href = 'index.html';
                })
                .catch(error => {
                    if (error.response.status == 400) {
                         // 確保是 400 錯誤，並且 response 存在
                        console.log(error.response.data); // 控制台查看錯誤數據

                        if ('non_field_errors' in error.response.data) {
                            this.error_email_code_tip = error.response.data.non_field_errors[0];
                            alert('錯誤訊息: ' + error.response.data.non_field_errors[0]);
                        } else {
                            this.error_email_code_tip = '資料有誤'; // 顯示錯誤提示
                        }
                        this.error_sms_code = true; // 顯示錯誤標誌
                    } else {
                        console.log(error.response.data); // 控制台打印錯誤
                    }
                });
            }
        }
    }
});
