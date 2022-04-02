# Generated by Django 3.2 on 2022-03-17 04:50

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('blood_center', '0003_alter_centercapacity_center'),
        ('application_user', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='user',
            name='center',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.PROTECT, related_name='users', to='blood_center.center', verbose_name='organization'),
        ),
    ]
