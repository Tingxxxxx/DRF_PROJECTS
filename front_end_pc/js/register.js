
var vm = new Vue({
    el: '#app', // Vue 實例掛載的 DOM 元素
    data: {
        host, // 後端的url 變量(host.js)
        // 錯誤提示相關標誌
        error_name: false, // 用戶名格式錯誤標誌
        error_password: false, // 密碼格式錯誤標誌
        error_check_password: false, // 確認密碼錯誤標誌
        error_phone: false, // 手機號碼格式錯誤標誌
        error_allow: false, // 是否同意條款錯誤標誌
        error_email: false, // Email 格式錯誤標誌
        error_email_code: false, // Email 驗證碼錯誤標誌
        sending_flag: false, // 防止多次請求的標誌

        // 表單字段（用於綁定輸入框數據）
        username: '', // 用戶名
        password: '', // 密碼
        password2: '', // 確認密碼
        mobile: '', // 手機號碼
        email: '', // Email 地址
        email_code: '', // Email 驗證碼
        allow: false, // 是否同意條款

        // UI 提示文本
        email_code_tip: '獲取驗證信', // Email 驗證碼按鈕初始文字
        error_email_code_tip: '' // Email 驗證碼錯誤提示信息
    },
    methods: {
        // 檢查用戶名是否符合長度要求（5~20 字符）
        check_username: function () {
            var len = this.username.length;
            if (len < 5 || len > 20) {
                this.error_name = true;
            } else {
                this.error_name = false;
            }
        },
        
        // 檢查密碼是否符合長度要求（8~20 字符）
        check_pwd: function () {
            var len = this.password.length;
            if (len < 8 || len > 20) {
                this.error_password = true;
            } else {
                this.error_password = false;
            }
        },
        
        // 檢查確認密碼是否與輸入的密碼一致
        check_cpwd: function () {
            if (this.password !== this.password2) {
                this.error_check_password = true;
            } else {
                this.error_check_password = false;
            }
        },
        
        // 檢查手機號碼格式（台灣手機號碼格式：09 開頭，後面 8 位數字）
        check_phone: function () {
            var re = /^09\d{8}$/; // 正則表達式匹配台灣手機號碼格式
            if (re.test(this.mobile)) {
                this.error_phone = false;
            } else {
                this.error_phone = true;
            }
        },
        
        // 檢查 Email 格式是否正確
        check_email: function () {
            var emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
            if (!emailPattern.test(this.email)) {
                this.error_email = true;
            } else {
                this.error_email = false;
            }
        },
        
        // 檢查 Email 驗證碼是否已輸入
        check_email_code: function () {
            if (!this.email_code) {
                this.error_email_code = true;
            } else {
                this.error_email_code = false;
            }
        },
        
        // 檢查是否勾選了「同意條款」
        check_allow: function () {
            if (!this.allow) {
                this.error_allow = true;
            } else {
                this.error_allow = false;
            }
        },
        
        // 發送 Email 驗證碼
        send_email_code: function () {
            // 防止用戶重複點擊按鈕發送請求
            if (this.sending_flag) {
                return;
            }
            this.sending_flag = true;

            // 檢查 Email 格式
            this.check_email();
            if (this.error_email) {
                this.sending_flag = false;
                return;
            }

            // 發送請求到後端 API
            axios.get(this.host +'/verifications/code/', {
                params: {
                    email: this.email // 傳送 Email 參數
                }
            })
            .then(response => {
                // 成功發送後啟動倒計時
                console.log(response);
                var num = 60; // 設定倒計時秒數
                var timer = setInterval(() => {
                    if (num === 1) {
                        clearInterval(timer);
                        this.email_code_tip = '獲取驗證信';
                        this.sending_flag = false;
                    } else {
                        num -= 1;
                        this.email_code_tip = num + '秒';
                    }
                }, 1000);
            })
            .catch(error => {
                // 處理錯誤請求
                if (error.response && error.response.status === 400) {
                    alert(error.response.data.error || '驗證信發送失敗');
                } else {
                    console.error(error.response.data || '未知錯誤');
                }
                this.sending_flag = false;
            });
        },
        
        // 提交表單
        on_submit: function () {
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
                alert('表單提交成功！'); // 實際應用時可在此發送表單數據到後端
            }
        }
    }
});