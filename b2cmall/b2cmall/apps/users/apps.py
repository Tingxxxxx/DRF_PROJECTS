from django.apps import AppConfig


class UsersConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'b2cmall.apps.users' # 因有修改默認位置，所以這裡要修改成包含父級目錄的完整路徑

