# Generated by Django 3.2 on 2022-04-24 19:41

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('blood_center', '0012_auto_20220410_2216'),
    ]

    operations = [
        migrations.AlterField(
            model_name='center',
            name='type',
            field=models.CharField(choices=[('imss', 'IMSS'), ('issste', 'ISSSTE'), ('cnts', 'CNTS (Centro Nacional de la Transfusión Sanguínea)'), ('cets', 'CETS (Centro Estatal de la Transfusión Sanguínea)'), ('ccinshae', 'CCINSHAE (Comisión Coordinadora de Institutos Nacionales de Salud y Hospitales de Alta Especialidad)'), ('dif', 'DIF'), ('pemex', 'PEMEX'), ('sedena', 'SEDENA'), ('semar', 'SEMAR'), ('privados', 'PRIVADOS'), ('universitarios', 'UNIVERSITARIOS'), ('cruz_roja', 'CRUZ ROJA')], default='imss', max_length=150, verbose_name='type'),
        ),
        migrations.AlterField(
            model_name='historicalcenter',
            name='type',
            field=models.CharField(choices=[('imss', 'IMSS'), ('issste', 'ISSSTE'), ('cnts', 'CNTS (Centro Nacional de la Transfusión Sanguínea)'), ('cets', 'CETS (Centro Estatal de la Transfusión Sanguínea)'), ('ccinshae', 'CCINSHAE (Comisión Coordinadora de Institutos Nacionales de Salud y Hospitales de Alta Especialidad)'), ('dif', 'DIF'), ('pemex', 'PEMEX'), ('sedena', 'SEDENA'), ('semar', 'SEMAR'), ('privados', 'PRIVADOS'), ('universitarios', 'UNIVERSITARIOS'), ('cruz_roja', 'CRUZ ROJA')], default='imss', max_length=150, verbose_name='type'),
        ),
        migrations.AlterField(
            model_name='historicalunit',
            name='expired_at',
            field=models.DateField(verbose_name='expired at'),
        ),
        migrations.AlterField(
            model_name='unit',
            name='expired_at',
            field=models.DateField(verbose_name='expired at'),
        ),
    ]