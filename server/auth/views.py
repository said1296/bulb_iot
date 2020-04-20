from django.http import HttpResponse, JsonResponse
from django.middleware.csrf import get_token
from django.contrib.auth.models import User
from django.contrib.auth import authenticate
from rest_framework.authtoken.models import Token
import json
# Create your views here.

def login(request):
    if(request.method=='POST'):
        body=json.loads(request.body.decode('utf-8'))
        username=body['username']
        password=body['password']
        user = authenticate(username=username, password=password)
        if user is not None:
            token, _ =  Token.objects.get_or_create(user=user)
            return JsonResponse({'error': '', 'authToken': str(token)})
        else:
            return JsonResponse({'error': "User not found"})

def auth(request):
    if(request.method=='GET'):
        return HttpResponse(200)   #TO REQUEST COOKIES
    if(request.method=='POST'):
        body=json.loads(request.body.decode('utf-8'))
        token=body['Authorization']
        return JsonResponse({'isAuth': Token.objects.filter(key=token).exists()})