from django.contrib import admin
from . import models

# Register your models here.
admin.site.register(models.Center)
admin.site.register(models.CenterCapacity)
admin.site.register(models.Unit)
admin.site.register(models.CenterTransfer)
admin.site.register(models.CenterTransferUnit)
