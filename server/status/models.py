from django.db import models
from django.contrib.auth.models import User

# Create your models here.

class Change(models.Model):
    id=models.AutoField(primary_key=True)
    user=models.ForeignKey(User, on_delete=models.CASCADE, null=True)
    level=models.FloatField(null=True)
    timestamp=models.DateTimeField(auto_now=True)

    def __str__(self):
        return str(self.level)

class State(models.Model):
    id=models.AutoField(primary_key=True)
    user=models.ForeignKey(User, on_delete=models.CASCADE, null=True)
    level=models.FloatField(null=True)
    timestamp=models.DateTimeField(auto_now=True)

    def __str__(self):
        return str(self.level)