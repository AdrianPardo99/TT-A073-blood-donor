from django.db import models
from core.models import BaseModel
from django.utils.translation import pgettext_lazy

# Tabla centro
class Center(BaseModel):
    name = models.CharField(
        pgettext_lazy("Center field", "name"),
        max_length=200,
    )
    address = models.CharField(
        pgettext_lazy("Center field", "address"),
        max_length=300,
    )
    city = models.CharField(pgettext_lazy("Center field", "city"), max_length=100)
    latitude = models.DecimalField(
        pgettext_lazy("Center field", "latitude"),
        max_digits=18,
        decimal_places=12,
    )
    longitude = models.DecimalField(
        pgettext_lazy("Center field", "longitude"),
        max_digits=18,
        decimal_places=12,
    )
