var vm = new Vue({
    el: '#app', // 將 Vue 實例掛載到 id 為 #app 的 DOM 元素
    data: { // 定義 Vue 實例的數據
        host: host, // 主機位址變數（需外部定義）
        user_id: sessionStorage.user_id || localStorage.user_id, // 優先使用 sessionStorage 中的 user_id，否則使用 localStorage
        token: sessionStorage.access || localStorage.access, // 同上，用於授權的 access token
        username: sessionStorage.username || localStorage.username, // 同上，使用者名稱
        is_show_edit: false, // 是否顯示編輯地址的表單（true 表示顯示）
        cities: [], // 城市列表
        districts: [], // 儲存所選城市下的區域列表
        postal_codes:[],// //所選區域下的郵遞區號
        addresses: [], // 使用者的地址列表
        limit: '', // 地址上限數量（由後端返回）
        default_address_id: '', // 預設地址的 ID
        form_address: { // 表單中的地址資料
            receiver: '', // 收件人姓名
            city_id: '', // 城市 ID
            district_id: '', // 區域 ID
            postal_code_id:'', // 郵遞區號 ID
            place: '', // 詳細地址
            mobile: '', // 手機號碼
            tel: '', // 固話（可選）
            email: '', // 電子信箱
        },
        error_receiver: false, // 收件人欄位錯誤提示開關
        error_place: false, // 地址欄位錯誤提示開關
        error_mobile: false, // 手機號碼錯誤提示開關
        error_email: false, // 電子信箱錯誤提示開關
        editing_address_index: '', // 編輯中的地址索引（空字串表示新增）
        is_set_title: [], // 每個地址是否顯示編輯標題欄（布林陣列）
        input_title: '' // 使用者輸入的地址標題
    },
    mounted: function(){
        // 載入城市列表
        axios.get(this.host + 'areas/?level=city', {
                responseType: 'json'
            })
            .then(response => {
                // alert('查詢城市 請求發送成功areas/?level=city')
                this.cities = response.data.results;
                console.log(this.cities)
            })
            .catch(error => {
                console.log(error.response.data);
            });

        // 获取用户地址列表
        // axios.get(this.host + '/addresses/', {
        //         headers: {
        //             'Authorization': 'JWT ' + this.token
        //         },
        //         responseType: 'json'
        //     })
        //     .then(response => {
        //         this.addresses = response.data.addresses;
        //         this.limit = response.data.limit;
        //         this.default_address_id = response.data.default_address_id;
        //     })
        //     .catch(error => {
        //         status = error.response.status;
        //         if (status == 401 || status == 403) {
        //             location.href = 'login.html?next=/user_center_site.html';
        //         } else {
        //             alert(error.response.data.detail);
        //         }
        //     })
    },
    watch: {
        'form_address.city_id': function(){
            if (this.form_address.city_id) {
                // 當選擇城市後載入對應的行政區
                axios.get(this.host + 'areas/?parent='+ this.form_address.city_id + '&level=district', {
                        responseType: 'json'
                    })
                    .then(response => {
                        // alert('查詢行政區 請求發送成功 )
                        this.districts = response.data.results;
                    })
                    .catch(error => {
                        console.log(error.response.data);
                        this.districts = [];
                    });
            }
        },
        'form_address.district_id': function(){
            if (this.form_address.district_id){
                // 選擇行政區後載入對應的郵遞區號
                axios.get(this.host + 'areas/?parent='+ this.form_address.district_id + '&level=postal_code', {
                        responseType: 'json'
                    })
                    .then(response => {
                        // alert('查詢郵遞區號 請求發送成功 )
                        this.postal_codes = response.data.results;
                        if (this.postal_codes.length > 0) {
                            this.form_address.postal_code_id = this.postal_codes[0].name;
                        } else {
                            this.form_address.postal_code_id = '';
                        }
                    })                    
                    .catch(error => {
                        console.log(error.response.data);
                        this.postal_codes = [];
                        
                    });
            }
        }
    },
    methods: {
        // 登出
        logout: function(){
            sessionStorage.clear();
            localStorage.clear();
            location.href = './login.html';
        },
        // 清除所有錯誤提示
        clear_all_errors: function(){
            this.error_receiver = false;
            this.error_mobile = false;
            this.error_place = false;
            this.error_email = false;
        },
        // 顯示新增地址表單
        show_add: function(){
            this.clear_all_errors();
            this.editing_address_index = '';
            this.form_address.receiver = '';
            this.form_address.city_id = '';
            this.form_address.district_id = '';
            this.form_address.postal_code_id = '';
            this.form_address.place = '';
            this.form_address.mobile = '';
            this.form_address.tel = '';
            this.form_address.email = '';
            this.is_show_edit = true;
        },
        // 顯示編輯地址表單
        show_edit: function(index){
            this.clear_all_errors();
            this.editing_address_index = index;
            // 只獲取數據，防止修改form_address影響到addresses數據
            this.form_address = JSON.parse(JSON.stringify(this.addresses[index]));
            this.is_show_edit = true;
        },
        // 檢查收件人姓名
        check_receiver: function(){
            if (!this.form_address.receiver) {
                this.error_receiver = true;
            } else {
                this.error_receiver = false;
            }
        },
        // 檢查詳細地址
        check_place: function(){
            if (!this.form_address.place) {
                this.error_place = true;
            } else {
                this.error_place = false;
            }
        },
         // 檢查手機號碼格式
        check_mobile: function(){
            var re = /^09\d{8}$/;
            if(re.test(this.form_address.mobile)) {
                this.error_mobile = false;
            } else {
                this.error_mobile = true;
            }
        },
        // 檢查電子信箱格式
        check_email: function(){
            if (this.form_address.email) {
                var re = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
                if(re.test(this.form_address.email)) {
                    this.error_email = false;
                } else {
                    this.error_email = true;
                }
            }
        },
        // 儲存地址（新增或修改）
        save_address: function(){
            if (this.error_receiver || this.error_place || this.error_mobile || this.error_email || !this.form_address.city_id || !this.form_address.district_id || !this.form_address.postal_code_id ) {
                alert('信息填写有误！');
            } else {
                this.form_address.title = this.form_address.receiver;
                if (this.editing_address_index === '') {
                    // 新增地址
                    axios.post(this.host + '/addresses/', this.form_address, {
                        headers: {
                            'Authorization': 'Bearer ' + this.token
                        },
                        responseType: 'json'
                    })
                    .then(response => {
                        // 将新地址添加大数组头部
                        this.addresses.splice(0, 0, response.data);
                        this.is_show_edit = false;
                    })
                    .catch(error => {
                        console.log(error.response.data);
                    })
                } else {

                    // 修改地址
                    axios.put(this.host + '/addresses/' + this.addresses[this.editing_address_index].id + '/', this.form_address, {
                        headers: {
                            'Authorization': 'Bearer ' + this.token
                        },
                        responseType: 'json'
                    })
                    .then(response => {
                        this.addresses[this.editing_address_index] = response.data;
                        this.is_show_edit = false;
                    })
                    .catch(error => {
                        alert(error.response.data.detail || error.response.data.message);
                    })
                }
            }
        },
        // 删除地址
        del_address: function(index){
            axios.delete(this.host + '/addresses/' + this.addresses[index].id + '/', {
                    headers: {
                        'Authorization': 'Bearer ' + this.token
                    },
                    responseType: 'json'
                })
                .then(response => {
                    // 从数组中移除地址
                    this.addresses.splice(index, 1);
                })
                .catch(error => {
                    console.log(error.response.data);
                })
        },
        /// 設定為默認地址
        set_default: function(index){
            axios.put(this.host + '/addresses/' + this.addresses[index].id + '/status/', {}, {
                    headers: {
                        'Authorization': 'Bearer ' + this.token
                    },
                    responseType: 'json'
                })
                .then(response => {
                    this.default_address_id = this.addresses[index].id;
                })
                .catch(error => {
                    console.log(error.response.data);
                })
        },
        // 顯示標題輸入欄位
        show_edit_title: function(index){
            this.input_title = this.addresses[index].title;
            for(var i=0; i<index; i++) {
                this.is_set_title.push(false);
            }
            this.is_set_title.push(true);
        } ,
        // 儲存地址標題
        save_title: function(index){
            if (!this.input_title) {
                alert("请填写标题后再保存！");
            } else {
                axios.put(this.host + '/addresses/' + this.addresses[index].id + '/title/', {
                        title: this.input_title
                    }, {
                        headers: {
                            'Authorization': 'Bearer ' + token
                        },
                        responseType: 'json'
                    })
                    .then(response => {
                        this.addresses[index].title = this.input_title;
                        this.is_set_title = [];
                    })
                    .catch(error => {
                        console.log(error.response.data);
                    })
            }
        },
        // 取消保存地址
        cancel_title: function(index){
            this.is_set_title = [];
        }
    }
});