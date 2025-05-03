
// 建立不受攔截器影響的 axios 實例
const rawAxios = axios.create();

// 自訂函數：取得 token
function getToken(key) {
    return sessionStorage.getItem(key) || localStorage.getItem(key);
}

// 自訂函數：設定 token
function setToken(key, value) {
    sessionStorage.setItem(key, value);
}

// 自訂函數：清除 token
function clearTokens() {
    sessionStorage.removeItem('access');
    sessionStorage.removeItem('refresh');
    localStorage.removeItem('access');
    localStorage.removeItem('refresh');
}

// 請求攔截器：自動附加 access token
axios.interceptors.request.use(
    function (config) {
        const accessToken = getToken('access');

        if (accessToken) {
            config.headers.Authorization = 'Bearer ' + accessToken;
        }

        return config;
    },
    function (error) {
        return Promise.reject(error);
    }
);

// 回應攔截器：處理 401 與 403
axios.interceptors.response.use(
    function (response) {
        return response;
    },
    async function (error) {
        console.log('Response Error:', error);

        const originalRequest = error.config;

        // 處理 401：未授權
        if (error.response && error.response.status === 401 && !originalRequest._retry) {
            originalRequest._retry = true;

            const refreshToken = getToken('refresh');

            if (!refreshToken) {
                clearTokens();
                window.location.href = './login.html?next=' + encodeURIComponent(location.pathname);
                return Promise.reject(error);
            }

            try {
                // ⚠️ 改為使用 rawAxios（避免再次進入攔截器）
                const response = await rawAxios.post(host + 'users/token/refresh/', {
                    refresh: refreshToken
                });

                const newAccessToken = response.data.access;

                // 更新新的 token
                setToken('access', newAccessToken);

                // 更新原始請求的 header
                originalRequest.headers.Authorization = 'Bearer ' + newAccessToken;

                // 重新發送原始請求
                return axios(originalRequest);

            } catch (refreshError) {
                clearTokens();
                window.location.href = './login.html?next=' + encodeURIComponent(location.pathname);
                return Promise.reject(refreshError);
            }
        }

        // 處理 403：禁止訪問
        if (error.response && error.response.status === 403) {
            alert('您沒有訪問此資源的權限！');
            window.location.href = './error_page.html';
        }

        return Promise.reject(error);
    }
);
