# Generated by Django 3.0.5 on 2020-04-15 20:14

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('status', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='status',
            name='status',
            field=models.IntegerField(),
        ),
    ]
