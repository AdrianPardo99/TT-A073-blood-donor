# Generated by Django 3.2 on 2022-03-17 04:38

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('blood_center', '0002_centercapacity'),
    ]

    operations = [
        migrations.AlterField(
            model_name='centercapacity',
            name='center',
            field=models.ForeignKey(on_delete=django.db.models.deletion.PROTECT, related_name='blood_units', to='blood_center.center', verbose_name='capacity'),
        ),
    ]
