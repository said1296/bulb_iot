# Generated by Django 3.0.5 on 2020-04-15 20:30

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('status', '0003_auto_20200415_2021'),
    ]

    operations = [
        migrations.AlterField(
            model_name='changes',
            name='id',
            field=models.AutoField(primary_key=True, serialize=False),
        ),
        migrations.AlterField(
            model_name='changes',
            name='timestamp',
            field=models.DateTimeField(auto_now=True),
        ),
    ]
