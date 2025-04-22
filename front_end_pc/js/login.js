var vm = new Vue({
    el: '#app',
    data: {
        host: host,
        error_username: false,
        error_pwd: false,
        error_pwd_message: '請填寫密碼',
        username: '',
        password: '',
        remember: false
    },
    methods: {
        get_query_string: function (name) {
            var urlParams = new URLSearchParams(window.location.search);
            return urlParams.get(name);
        },

        check_username: function () {
            if (!this.username) {
                this.error_username = true;
            } else {
                this.error_username = false;
            }
        },

        check_pwd: function () {
            if (!this.password) {
                this.error_pwd_message = '請填寫密碼';
                this.error_pwd = true;
            } else {
                this.error_pwd = false;
            }
        },

        on_submit: function () {
            this.check_username();
            this.check_pwd();

            if (this.error_username === false && this.error_pwd === false) {
                axios.post(this.host + 'users/token/', {
                        username: this.username,
                        password: this.password
                    }, {
                        responseType: 'json',
                        withCredentials: true
                    })
                    .then(response => {
                        this.save_login_data(response.data);
                        var return_url = this.get_query_string('next') || 'index.html';
                        location.href = return_url;
                    })
                    .catch(error => {
                        if (error.response && error.response.status === 400) {
                            this.error_pwd_message = '用戶名或密碼錯誤';
                        } else {
                            this.error_pwd_message = '伺服器錯誤';
                        }
                        this.error_pwd = true;
                    });
            }
        },

        save_login_data: function (data) {
            if (this.remember) {
                sessionStorage.clear();
                localStorage.access = data.access;
                localStorage.refresh = data.refresh;
                localStorage.user_id = data.user_id;
                localStorage.username = data.username;
            } else {
                localStorage.clear();
                localStorage.access = data.access;
                localStorage.refresh = data.refresh;
                sessionStorage.user_id = data.user_id;
                sessionStorage.username = data.username;
            }
        },

        // Google 第三方登入處理
        google_login_callback: function (credentialResponse) {
            const id_token = credentialResponse.credential;
            console.log("取得的 id_token：", credentialResponse.credential);

            // 傳送 Google ID token 給後端
            axios.post(this.host + 'oauth/google-login/', {
                id_token: id_token
            }, {
                responseType: 'json'
            }).then(response => {
                const status = response.data.status;
                const email = response.data.email;
                const uid = response.data.uid;
                const provider = response.data.provider;

                if(status === 'success'){
                    this.save_login_data(response.data);
                    var return_url = this.get_query_string('next') || 'index.html';
                    location.href = return_url;
                } else if (status === 'need-bind'){
                    // 導向綁定頁(已有對應信箱的本站帳號)
                    alert('該信箱已經註冊過，請登入帳號完成綁定')
                    // 跳轉並攜帶參數 bind.html?email=test@example.com&uid=12345?provider=xxxxx
                    location.href = `bind.html?email=${encodeURIComponent(email)}&uid=${encodeURIComponent(uid)}&provider=${encodeURIComponent(provider)}`;

                    } else if (status === 'quick-rigister'){
                        // 沒有綁定社交帳號，也無對應信箱的本站帳號
                        location.href = `quick-rigister.html?email=${encodeURIComponent(email)}&uid=${encodeURIComponent(uid)}&provider=${encodeURIComponent(provider)}`;
                        alert('該信箱用戶尚未註冊，請註冊帳號以完成綁定')
                    }
                    else{
                        alert(response.data.message || '未知錯誤，請稍後再試');
                    }
            }).catch(error => {
                console.error("Google 登入失敗：", error);
                alert('Google 登入失敗，請稍後再試。');
            });
        }
    }
});

// 註冊全域回呼函式供 Google SDK 使用
window.handleCredentialResponse = function (response) {
    vm.google_login_callback(response);
}
