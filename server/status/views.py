from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from django.core import serializers
from rest_framework.authtoken.models import Token
from django.contrib.auth.models import User
import json
from .models import Change, State


# Create your views here.
def change_status(request):
    change=Change()
    state=State()
    if request.method=='POST':
        body=json.loads(request.body.decode('utf-8'))
        change.level=body['level']
        token=body['Authorization']
        user = User.objects.get(auth_token=token)
        if user is None:
            return HttpResponse(401)
        change.user=user
        try:
            change.save()
            if(body['isChanging']==False):
                state.level=body['level']
                state.user=user
                state.save()
            return HttpResponse(status=201)
        except:
            return HttpResponse(status=500)

def get_status(request):
    state=State()
    response_data={}
    if(request.method=='POST'):
        body=json.loads(request.body.decode('utf-8'))
        if 'Authorization' in body:
            token=body['Authorization']
            user = User.objects.get(auth_token=token)
            if user is None:
                return HttpResponse(401)
            try:
                level = State.objects.values('level').filter(user=user).order_by('-timestamp')[0]['level']
                response_data['level']=level
            except:
                response_data['level']=5
        return JsonResponse(response_data, status=201)