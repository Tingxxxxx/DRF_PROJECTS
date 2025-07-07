// 解析 URL 參數
function getQueryParam(param) {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get(param);
  }
  
  const email = getQueryParam("email"); // 社交帳號的信箱
  const uid = getQueryParam("uid");  // 社交帳號唯一識別碼
  const provider = getQueryParam("provider"); // 社交平台
  
  if (!email || !uid || !provider) {
    alert("系統無法取得必要資訊，請返回重新操作。");
    // 可選：自動跳回登入頁面
    location.href = 'login.html';
  } else {
    new Vue({
        el: "#app",
        data: {
            host,
            email_disabled: true,  // 禁用 email 欄位
            username: "",
            email: email, // 從 URL 參數獲得的 email，不能修改
            mobile: "",
            uid: uid,
            provider: provider,
            allow: false,
          
            error_username: false,
            error_username_message: "",
            error_name: false,
            error_name_message: "",
          
            error_phone: false,
            error_phone_message: "",
          
            error_email: false,  // 添加 error_email
            error_email_message: "",  // 添加 error_email_message
          
            error_allow: false,
        },
        created() {
            this.email = getQueryParam("email");
            this.uid = getQueryParam("uid");
            this.provider = getQueryParam("provider");
    
            if (!this.email || !this.uid || !this.provider) {
                alert("系統無法取得必要資訊，請返回重新操作。");
                location.href = "login.html";
            } else {
                this.email_disabled = true;  // 假設根據需求禁用 email 欄位
            }
        },
        methods: {
            check_username() {
                const len = this.username.length;
                if (len < 5 || len > 20) {
                    this.error_name = true;
                    this.error_name_message = "帳號長度需為 5~20 字符";
                } else {
                    this.error_name = false;
                    axios.get(this.host + "users/username/" + this.username + "/")
                        .then(response => {
                            if (response.data.count > 0) {
                                this.error_name = true;
                                this.error_name_message = "該帳號已存在";
                            } else {
                                this.error_name = false;
                            }
                        })
                        .catch(error => {
                            console.log(error.response.data);
                        });
                }
            },
            check_phone() {
                const re = /^09\d{8}$/;
                if (re.test(this.mobile)) {
                    this.error_phone = false;
                    axios.get(this.host + "users/mobile/" + this.mobile + "/")
                        .then(response => {
                            if (response.data.count > 0) {
                                this.error_phone = true;
                                this.error_phone_message = "該手機號碼已註冊";
                            } else {
                                this.error_phone = false;
                            }
                        })
                        .catch(error => {
                            console.log(error.response.data);
                        });
                } else {
                    this.error_phone = true;
                    this.error_phone_message = "手機格式錯誤（需為 09 開頭，共 10 碼）";
                }
            },
            check_email() {
                // 因為 email 是禁用狀態，不用檢查
                this.error_email = false;
            },
            check_allow() {
                this.error_allow = !this.allow;
            },
            on_submit(event) {
                event.preventDefault();
                this.check_username();
                this.check_phone();
                this.check_email();  // 在提交時檢查電子郵件
                this.check_allow();
                if (!this.error_name && !this.error_phone && !this.error_email && !this.error_allow) {
                axios.post(this.host + "oauth/quick-register/" + this.provider + "/", {
                    username: this.username,
                    email: this.email,
                    mobile: this.mobile,
                    uid: this.uid,
                    allow: this.allow
                    }, {
                    responseType: 'json',
                    withCredentials: true // ✅ 允許攜帶 cookie，因為未登入用戶的購物車資料存於 cookie 中，若不加此行後端將無法取得，後續就無法合併購物車
                    }).then(response => {
                        sessionStorage.clear();
                        localStorage.clear();
                        localStorage.access = response.data.access;
                        localStorage.refresh = response.data.refresh;
                        localStorage.username = response.data.username;
                        localStorage.user_id = response.data.id;
                        location.href = "index.html";
                    })
                    .catch(error => {
                        if (error.response.status === 400 && error.response.data) {
                            const err = error.response.data;
                            if ("non_field_errors" in err) {
                                alert("錯誤訊息: " + err.non_field_errors[0]);
                            } else {
                                alert("資料有誤");
                            }
                        } else {
                            console.log(error);
                        }
                    });
                }
            }
        }
    });
      
  }
  