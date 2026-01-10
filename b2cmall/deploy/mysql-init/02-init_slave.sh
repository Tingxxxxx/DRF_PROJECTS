#!/bin/bash
set -e  # 遇到任何錯誤立即停止執行，避免中途出錯還繼續執行

# ============================================================
# 腳本用途：
# 1. 適用於 MySQL 從機容器的初始化（只在容器第一次啟動且資料目錄為空時執行）
# 2. 自動建立 Django 專用查詢用戶
# 3. 從機用戶只賦予 SELECT 權限，不給修改、刪除或新增權限
# 4. 若容器已初始化過，再修改此腳本不會自動生效，需要先清除 volume 再重建容器
# 5. 使用 .sh 腳本取代單純 .sql，方便讀取環境變數，避免密碼寫死
# ============================================================

# 使用 root 帳號登入 MySQL
# -u root                : 以 root 用戶登入
# -p"$MYSQL_ROOT_PASSWORD": 密碼從環境變數讀取
mysql -u root -p"$MYSQL_ROOT_PASSWORD" <<-EOSQL


# 創建 Django 專用用戶
CREATE USER '${SLAVE_APP_USER}'@'%' IDENTIFIED BY '${SLAVE_APP_PASSWORD}';


# 授權該用戶對 drf_mall 資料庫的所有表只有 SELECT（查詢）權限
GRANT SELECT ON drf_mall.* TO '${SLAVE_APP_USER}'@'%';

# 刷新 MySQL 權限，使上述用戶和授權立即生效
FLUSH PRIVILEGES;

EOSQL
