# Generated by Django 3.2 on 2022-04-02 18:27

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('blood_center', '0005_auto_20220328_1459'),
    ]

    operations = [
        migrations.AddField(
            model_name='unit',
            name='is_altruist_unit',
            field=models.BooleanField(default=False, verbose_name='is altruist unit'),
        ),
    ]
