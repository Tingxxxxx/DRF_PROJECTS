var vm = new Vue({
	el: '#app',
	data: {
		error_name: false,
		error_password: false,
		error_check_password: false,
		error_phone: false,
		error_allow: false,
		error_email: false, //新增
		error_email_code: false, //新增
		sending_flag: false,

		username: '',
		password: '',
		password2: '',
		mobile: '', 
		email:'',
		email_code: '',
		allow: false
	},
	methods: {
		check_username: function (){
			var len = this.username.length;
			if(len<5||len>20) {
				this.error_name = true;
			} else {
				this.error_name = false;
			}
		},
		check_pwd: function (){
			var len = this.password.length;
			if(len<8||len>20){
				this.error_password = true;
			} else {
				this.error_password = false;
			}		
		},
		check_cpwd: function (){
			if(this.password!=this.password2) {
				this.error_check_password = true;
			} else {
				this.error_check_password = false;
			}		
		},
		check_phone: function (){
			var re = /^09\d{8}$/;
			if(re.test(this.mobile)) {
				this.error_phone = false;
			} else {
				this.error_phone = true;
			}
		},
		// 新增 email 格式檢查
		check_email: function() {
			var emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
			if (!emailPattern.test(this.email)) {
				this.error_email = true; // 新增錯誤提示
			} else {
				this.error_email = false;
			}
		},
		check_email_code: function() {
			if (!this.email_code) {
				this.error_email_code = true;  // 設置錯誤狀態為 true
			} else {
				this.error_email_code = false;  // 如果有填寫，設置錯誤狀態為 false
			}
		},
		check_allow: function(){
			if(!this.allow) {
				this.error_allow = true;
			} else {
				this.error_allow = false;
			}
		},
		// 注册
		on_submit: function(){
			this.check_username();
			this.check_pwd();
			this.check_cpwd();
			this.check_phone();
			this.check_email_code();
			this.check_allow();
		}
	}
});
