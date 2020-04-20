from django.contrib import admin
from .models import Change, State

# Register your models here.
class ChangeAdmin(admin.ModelAdmin):
    list_display=[field.name for field in Change._meta.get_fields()]
class StateAdmin(admin.ModelAdmin):
    list_display=[field.name for field in State._meta.get_fields()]
admin.site.register(Change, ChangeAdmin)
admin.site.register(State, StateAdmin)