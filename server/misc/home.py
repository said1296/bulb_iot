from django.http import HttpResponse, JsonResponse
from django.middleware.csrf import get_token
from django.contrib.auth.models import User
from django.contrib.auth import authenticate
from rest_framework.authtoken.models import Token
import json
# Create your views here.

def home(request):
    return HttpResponse(200)