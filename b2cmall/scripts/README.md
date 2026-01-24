# 區域資料 Fixture 產生工具

此腳本用於自動產生 Django 專案中用來初始化「台灣縣市／區／郵遞區號」資料的 fixture 檔案 `region_fixtures.json`，可匯入到 Django 資料庫中使用。

---

## 📁 檔案結構

scripts/
├── generate_region_fixtures.py # 本腳本
├── taiwan_service_area.json # 原始輸入資料
└── region_fixtures.json # 執行後輸出的 fixture 檔


---

## 🛠 使用方式

1. **準備原始資料**  
   請確認 `taiwan_service_area.json` 的格式如下：

   ```json
   {
     "rows": [
       {
         "city": "臺北市",
         "area": "中正區",
         "zipcode": 100
       },
       {
         "city": "臺北市",
         "area": "大同區",
         "zipcode": 103
       }
       ...
     ]
   }

2. **執行腳本以產生 fixture**
- 在終端機中進入腳本所在資料夾並執行：`python generate_region_fixtures.py`
- 執行成功後會在同目錄下產生 region_fixtures.json。



## 🧩 Django 匯入方式
1. 確認你的 areas 應用（例如：b2cmall.apps.areas）已在 INSTALLED_APPS 中註冊。

2. 將產出的 region_fixtures.json 放到 Django 可以讀取的 fixtures 目錄下（或任意位置）。

3. 使用 Django 指令載入資料：`python manage.py loaddata region_fixtures.json`


## 🔧 參數可調整說明
可修改 generate_region_fixtures.py 中的這些參數：
- json_path：原始資料 JSON 檔案路徑
- output_path：產出的 fixture 檔案名稱
- app_name：Django App 名稱（預設為 areas）



## mysql資料庫備份命令

mysqldump -u 使用者名稱 -p 資料庫名稱 > 輸出檔案.sql

mysqldump -u 使用者名稱 -p 資料庫名稱 表1 表2 ... > 輸出檔案.sql
