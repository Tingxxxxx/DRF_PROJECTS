from django.apps import AppConfig


class GoodsConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'goods'

    def ready(self):
        # 在 App 啟動時導入 signals 模組，讓 signal handler 註冊生效
        import goods.signals