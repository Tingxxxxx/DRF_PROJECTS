# Taiwan Region Fixtures

此資料夾包含台灣縣市與郵遞區號的 fixtures 檔案，用於 Django 專案初始化地區資料。

## 檔案列表
- `region_fixtures.json`：用於導入地區資料的 fixture 檔

## 使用方式
1. 確保 `b2cmall.apps.areas` 已註冊於 `INSTALLED_APPS`
2. 執行指令匯入資料：

   ```bash
   python manage.py loaddata b2cmall/apps/areas/fixtures/region_fixtures.json
