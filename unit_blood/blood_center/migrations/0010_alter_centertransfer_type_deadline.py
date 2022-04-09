# Generated by Django 3.2 on 2022-04-09 14:19

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('blood_center', '0009_centertransfer_qty'),
    ]

    operations = [
        migrations.AlterField(
            model_name='centertransfer',
            name='type_deadline',
            field=models.CharField(choices=[('1', 'Low'), ('2', 'Medium'), ('3', 'High'), ('4', 'High priority'), ('5', 'Max')], default='1', max_length=25, verbose_name='type deadline'),
        ),
    ]
