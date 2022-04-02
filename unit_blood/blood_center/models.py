from django.db import models
from core.models import BaseModel
from django.utils.translation import pgettext_lazy

from . import BloodABOSystem, BloodUnitType, DeadlineType, TransferStatus

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
        decimal_places=16,
    )
    longitude = models.DecimalField(
        pgettext_lazy("Center field", "longitude"),
        max_digits=18,
        decimal_places=16,
    )


class CenterCapacity(BaseModel):
    center = models.ForeignKey(
        Center,
        on_delete=models.PROTECT,
        verbose_name=pgettext_lazy("Center Capacity field", "center"),
        related_name="capabilities",
    )
    type = models.CharField(
        pgettext_lazy("Center Capacity field", "blood unit type"),
        max_length=55,
        choices=BloodUnitType.CHOICES,
        default=BloodUnitType.ST,
    )
    min_qty = models.PositiveIntegerField(
        pgettext_lazy("Center Capacity field", "minimum quantity")
    )
    max_qty = models.PositiveIntegerField(
        pgettext_lazy("Center Capacity field", "maximum quantity")
    )


class Unit(BaseModel):
    center = models.ForeignKey(
        Center,
        on_delete=models.PROTECT,
        verbose_name=pgettext_lazy("Unit field", "center"),
        related_name="units",
    )
    type = models.CharField(
        pgettext_lazy("Unit field", "type"),
        max_length=55,
        choices=BloodUnitType.CHOICES,
        default=BloodUnitType.ST,
    )
    blood_type = models.CharField(
        pgettext_lazy("Unit field", "blood type"),
        max_length=4,
        choices=BloodABOSystem.CHOICES,
        default=BloodABOSystem.O_PLUS,
    )
    expired_at = models.DateTimeField(
        pgettext_lazy("Unit field", "expired at"),
    )
    # This field tell us if the unit has already used or not yet
    is_available = models.BooleanField(
        pgettext_lazy("Unit field", "is available"),
        default=True,
    )
    is_expired = models.BooleanField(
        pgettext_lazy("Unit field", "is expired"),
        default=False,
    )
    can_transfer = models.BooleanField(
        pgettext_lazy("Unit field", "can transfer"),
        default=True,
    )


class CenterTransfer(BaseModel):
    origin = models.ForeignKey(
        Center,
        verbose_name=pgettext_lazy("Center transfer field", "origin"),
        related_name="+",
        on_delete=models.PROTECT,
    )
    destination = models.ForeignKey(
        Center,
        verbose_name=pgettext_lazy("Center transfer field", "destination"),
        related_name="+",
        on_delete=models.PROTECT,
    )
    status = models.CharField(
        pgettext_lazy("Center transfer field", "status"),
        max_length=25,
        choices=TransferStatus.CHOICES,
        default=TransferStatus.CREATED,
    )
    deadline = models.DateTimeField(
        pgettext_lazy("Center transfer field", "deadline"),
    )
    type_deadline = models.CharField(
        pgettext_lazy("Center transfer field", "type deadline"),
        max_length=25,
        choices=DeadlineType.CHOICES,
        default=DeadlineType.LOW,
    )
    name = models.CharField(
        pgettext_lazy("Center transfer field", "name"),
        max_length=450,
    )
    comment = models.CharField(
        pgettext_lazy("Center transfer field", "comment"),
        max_length=1500,
        blank=True,
        null=True,
    )


class CenterTransferUnit(BaseModel):
    transfer = models.ForeignKey(
        CenterTransfer,
        verbose_name=pgettext_lazy("Center transfer unit field", "transfer"),
        related_name="units",
        on_delete=models.PROTECT,
    )
    unit = models.ForeignKey(
        Unit,
        verbose_name=pgettext_lazy("Center transfer unit field", "unit"),
        related_name="transfers",
        on_delete=models.PROTECT,
    )
