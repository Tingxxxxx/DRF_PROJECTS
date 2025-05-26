from django.contrib import admin
from .models import *
from celery_tasks.html.tasks import generate_static_list_search_html
# Register your models here.

class Generate_list_html(admin.ModelAdmin):
    
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


# 註冊模型
admin.site.register(GoodsCategory, Generate_list_html)
admin.site.register(GoodsChannel, Generate_list_html)
admin.site.register(Goods)
admin.site.register(Brand)
admin.site.register(GoodsSpecification)
admin.site.register(SpecificationOption)
admin.site.register(SKU)
admin.site.register(SKUSpecification)
admin.site.register(SKUImage)