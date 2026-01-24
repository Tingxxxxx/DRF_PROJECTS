

class MasterSlaveDBRouter(object):
    """資料庫主從讀寫分離路由"""

    def db_for_read(self, model, **hints):
        """指定讀取操作要使用的資料庫"""
        return "slave"   # 所有查詢操作都走從庫

    def db_for_write(self, model, **hints):
        """指定寫入操作要使用的資料庫"""
        return "default"  # 所有新增、修改、刪除操作都走主庫

    def allow_relation(self, obj1, obj2, **hints):
        """是否允許跨資料庫的關聯操作"""
        return True   # 永遠允許（主從之間關聯也可）
