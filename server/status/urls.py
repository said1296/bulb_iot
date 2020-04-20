from django.urls import path

from . import views

urlpatterns = [
    path('', views.change_status, name='Toggle'),
    path('get/', views.get_status),
]