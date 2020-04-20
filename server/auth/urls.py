from django.urls import path

from . import views

urlpatterns = [
    path('login/', views.login, name='Login'),
    path('', views.auth, name='Authentication'),
]