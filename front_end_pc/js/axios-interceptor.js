// 請求攔截器：自動附加 access token

axios.interceptors.request.use(function (config) {
    // 嘗試從 sessionStorage 或 localStorage 取得 access token
    const token = sessionStorage.access || localStorage.access;  // 先從 sessionStorage 取得，若沒有再從 localStorage 取得

    // 如果 token 存在，則將其附加到請求的 Authorization 標頭中
    if (token) {
        config.headers.Authorization = 'Bearer ' + token;
    }
    // 返回修改後的 config 以繼續發送請求
    return config;
}, function (error) {
    // 如果請求中有錯誤，則返回拒絕的 Promise
    return Promise.reject(error);
});

// 回應攔截器：若 access token 過期，嘗試用 refresh token 更新
axios.interceptors.response.use(function (response) {
    // 如果請求成功，直接返回回應的資料
    return response;
}, async function (error) {
    console.log("Response Error:", error);  // Debugging step

    const originalRequest = error.config;  // 取得原始請求配置

    // 處理 401 錯誤（未授權）
    if (error.response && error.response.status === 401 && !originalRequest._retry) {
        originalRequest._retry = true;  // 設置 _retry 標誌以避免重試無窮迴圈

        try {
            // 嘗試從 sessionStorage 或 localStorage 取得 refresh token
            const refresh = sessionStorage.refresh || localStorage.refresh; 

            // 使用 refresh token 請求新的 access token
            const response = await axios.post( host + 'users/token/refresh/', {
                refresh: refresh  // 發送 refresh token 用於請求新的 access token
            });

            // 更新 sessionStorage 和 localStorage 中的 access token
            sessionStorage.access = response.data.access || sessionStorage.access; // 儲存新的 access token 至 sessionStorage

            // 更新原始請求中的 Authorization 標頭，使用新的 access token
            originalRequest.headers.Authorization = 'Bearer ' + response.data.access;

            // 重發原始請求，並附上新的 token
            return axios(originalRequest);

        } catch (refreshError) {
            // 如果刷新 token 失敗，跳轉到登錄頁面，並將當前頁面的路徑作為參數傳遞
            window.location.href = './login.html?next=' + encodeURIComponent(location.pathname);
            return Promise.reject(refreshError);  // 返回拒絕的 Promise
        }
    }

    // 處理 403 錯誤（禁止訪問）
    if (error.response && error.response.status === 403) {
        // 如果是 403 錯誤，顯示權限不足的提示
        alert("您沒有訪問此資源的權限！");
        // 可以選擇跳轉到錯誤頁面或執行其他操作
        window.location.href = "./error_page.html";  // 跳轉到錯誤頁面或其他提示頁
    }

    // 如果錯誤不是 401 或 403，則直接返回錯誤
    return Promise.reject(error);
});
