// 解析 URL 參數
function getQueryParam(param) {
  const urlParams = new URLSearchParams(window.location.search);
  return urlParams.get(param);
}

const email = getQueryParam("email"); // 社交帳號的信箱
const uid = getQueryParam("uid");  // 社交帳號唯一識別碼
const provider = getQueryParam("provider") // 社交平台

if (!email || !uid || !provider) {
  alert("系統無法取得必要資訊，請返回重新操作。");
  // 可選：自動跳回登入頁面
  location.href = 'login.html';
} else {
  // 若 provider 和 email 和 uid 都存在，初始化頁面資料
  const vm = new Vue({
    el: "#app",
    data: {
      host,
      username: "",
      password: "",
      email: email,
      uid: uid,
      email_disabled: true,
      error_username: false,
      error_username_message: "",
      error_password: false,
      error_email: false,
      error_email_message: ""
    },
    methods: {
      check_username() {
        this.error_username = this.username.length < 5 || this.username.length > 20;
        if (this.error_username) {
          this.error_username_message = "使用者名稱長度必須在 5~20 個字之間";
        }
      },
      check_pwd() {
        this.error_password = this.password.length < 8 || this.password.length > 20;
      },
      check_email() {
        // 因為 email 是禁用狀態，不用檢查
        this.error_email = false;
      },
      on_submit() {
        this.check_username();
        this.check_pwd();
        this.check_email();

        if (!this.error_username && !this.error_password && !this.error_email) {
          // 提交資料至後端 API
          axios.post(this.host + "oauth/bind-" + provider + "/", {
            username: this.username,
            password: this.password,
            email: this.email,
            uid: this.uid
          }).then(response => {
            // 成功綁定，導向首頁或顯示訊息
            alert("綁定成功！");
            location.href = "index.html";
          }).catch(error => {
            alert("綁定失敗，請確認帳號資訊或稍後再試。");
          });
        }
      }
    }
  });
}
