from django.contrib import admin
from django.utils.html import format_html
from .models import *
from celery_tasks.html.tasks import generate_static_list_search_html
# Register your models here.

class Generate_list_html_Admin(admin.ModelAdmin):
    
    def save_model(self, request, obj, form, change):
        """
        Given a model instance save it to the database.
        """
        obj.save()
        generate_static_list_search_html.delay()


    def delete_model(self, request, obj):
        """
        Given a model instance delete it from the database.
        """
        obj.delete()
        generate_static_list_search_html.delay()


class SKUImageAdmin(admin.ModelAdmin):
    """admin後台自訂縮圖顯示"""
    list_display = ('sku', 'image_tag')

    def image_tag(self, obj):
        if obj.image:
            # 後台點縮圖就能打開完整 S3 圖片
            return format_html(
                '<a href="{}" target="_blank"><img src="{}" width="100" /></a>',
                obj.image.url, obj.image.url
            )
        return ""
    image_tag.short_description = '圖片'

# 註冊模型
admin.site.register(GoodsCategory, Generate_list_html_Admin)
admin.site.register(GoodsChannel, Generate_list_html_Admin)
admin.site.register(Goods)
admin.site.register(Brand)
admin.site.register(GoodsSpecification)
admin.site.register(SpecificationOption)
admin.site.register(SKU)
admin.site.register(SKUSpecification)
admin.site.register(SKUImage, SKUImageAdmin)
