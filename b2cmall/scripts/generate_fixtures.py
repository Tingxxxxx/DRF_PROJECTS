import json
from collections import defaultdict

# 讀取scripts資料夾中的 原始json檔 並生成一個 region_fixtures.json


def generate_region_fixtures(json_path, output_path="region_fixtures.json", app_name="areas"):
    """
    生成區域資料的 fixture 檔案，包含城市、區域、郵遞區號等資訊。

    參數：
    json_path (str): 輸入的原始 JSON 檔案路徑，包含城市、區域、郵遞區號等資料。
    output_path (str): 輸出的 fixture 檔案路徑，預設為 "region_fixtures.json"。
    app_name (str): Django 應用程式名稱，預設為 "areas"。

    回傳：
    無
    """
    
    fixtures = []              # 儲存生成的 fixtures 資料
    pk_counter = 1             # 用來遞增產生主鍵（primary key）
    pk_map = {}                # 儲存每個城市和區域的主鍵對應資料
    seen_city = set()          # 儲存已處理過的城市
    seen_district = set()      # 儲存已處理過的區域

    # 讀取原始 JSON 資料
    with open(json_path, 'r', encoding='utf-8') as f:
        raw_data = json.load(f)

    rows = raw_data['rows']     # 取得 rows 裡的資料

    # Step 1：處理城市資料，避免重複
    for entry in rows:
        city = entry['city']
        city_key = f"{city}_city"

        # 檢查該城市是否已經處理過
        if city_key not in pk_map:
            pk_map[city_key] = pk_counter  # 分配主鍵
            fixtures.append({
                "model": f"{app_name}.region",  # Django 模型名稱
                "pk": pk_counter,              # 主鍵
                "fields": {
                    "name": city,             # 城市名稱
                    "level": "city",          # 層級：城市
                    "parent": None            # 無父節點
                }
            })
            pk_counter += 1  # 主鍵遞增

    # Step 2：處理區域資料，避免重複
    for entry in rows:
        city = entry['city']
        area = entry['area']
        district_key = f"{city}_{area}_district"

        # 檢查該區域是否已經處理過
        if district_key not in pk_map:
            pk_map[district_key] = pk_counter  # 分配主鍵
            fixtures.append({
                "model": f"{app_name}.region",  # Django 模型名稱
                "pk": pk_counter,              # 主鍵
                "fields": {
                    "name": area,             # 區域名稱
                    "level": "district",      # 層級：區域
                    "parent": pk_map[f"{city}_city"]  # 城市的主鍵作為父節點
                }
            })
            pk_counter += 1  # 主鍵遞增

    # Step 3：處理郵遞區號資料
    for entry in rows:
        city = entry['city']
        area = entry['area']
        zipcode = str(entry['zipcode'])  # 確保郵遞區號是字串格式

        fixtures.append({
            "model": f"{app_name}.region",  # Django 模型名稱
            "pk": pk_counter,              # 主鍵
            "fields": {
                "name": zipcode,           # 郵遞區號
                "level": "postal_code",    # 層級：郵遞區號
                "parent": pk_map[f"{city}_{area}_district"]  # 區域的主鍵作為父節點
            }
        })
        pk_counter += 1  # 主鍵遞增

    # 將生成的 fixture 資料寫入輸出 JSON 檔案
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(fixtures, f, ensure_ascii=False, indent=4)

    print(f"✅ Fixtures 已產生：{output_path}")

# 執行腳本主體
if __name__ == "__main__":
    generate_region_fixtures("taiwan_service_area.json")
