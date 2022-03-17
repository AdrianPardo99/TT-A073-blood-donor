from django.db import models
from core.models import BaseModel
from django.utils.translation import pgettext_lazy

from . import BloodABOSystem, BloodUnitType

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


class CenterCapacity(BaseModel):
    center = models.ForeignKey(
        Center,
        on_delete=models.PROTECT,
        verbose_name=pgettext_lazy("Center Capacity field", "capacity"),
        related_name="blood_units",
    )
    blood_type = models.CharField(
        pgettext_lazy("Center Capacity field", "blood type"),
        max_length=3,
        choices=BloodABOSystem.CHOICES,
        default=BloodABOSystem.O_MINUS,
    )
    blood_unit_type = models.CharField(
        pgettext_lazy("Center Capacity field", "blood unit type"),
        max_length=15,
        choices=BloodUnitType.CHOICES,
        default=BloodUnitType.BLOOD_CELLS,
    )
    min_qty = models.PositiveIntegerField(
        pgettext_lazy("Center Capacity field", "minimum quantity")
    )
    max_qty = models.PositiveIntegerField(
        pgettext_lazy("Center Capacity field", "maximum quantity")
    )
