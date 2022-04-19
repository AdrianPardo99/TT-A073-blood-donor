from django.db import models
from django.core.validators import MinValueValidator
from django.utils.translation import pgettext_lazy

from simple_history.models import HistoricalRecords

from core.models import BaseModel

from . import (
    BloodABOSystem,
    BloodUnitType,
    DeadlineType,
    TransferStatus,
    InstitutionType,
    DonorGender,
)

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
    type = models.CharField(
        pgettext_lazy("Center field", "type"),
        max_length=150,
        choices=InstitutionType.CHOICES,
        default=InstitutionType.IMSS,
    )

    history = HistoricalRecords()

    class Meta:
        verbose_name = pgettext_lazy("Center model", "Center")
        verbose_name_plural = pgettext_lazy("Center model", "Centers")
        db_table = "center"

    def __str__(self) -> str:
        return "(%s) - %s (%s)" % (self.id, self.name, self.type)

    def obtain_distinct_centers(self):
        return Center.objects.all().exclude(pk=self.pk)


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

    history = HistoricalRecords()

    class Meta:
        verbose_name = pgettext_lazy("Center Capacity model", "Center Capacity")
        verbose_name_plural = pgettext_lazy("Center Capacity model", "Centers Capacity")
        db_table = "center_capacity"

    def __str__(self) -> str:
        return "%s (%s, %s)" % (self.type, self.min_qty, self.max_qty)


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
    is_altruist_unit = models.BooleanField(
        pgettext_lazy("Unit field", "is altruist unit"),
        default=False,
    )
    donor_gender = models.CharField(
        pgettext_lazy("Unit field", "donor gender"),
        max_length=10,
        choices=DonorGender.CHOICES,
        default=DonorGender.MALE,
    )
    donor_age = models.PositiveIntegerField(
        pgettext_lazy("Unit field", "donor age"),
        default=18,
        validators=[MinValueValidator(18)],
    )

    history = HistoricalRecords()

    class Meta:
        verbose_name = pgettext_lazy("Unit model", "Unit")
        verbose_name_plural = pgettext_lazy("Unit model", "Units")
        db_table = "unit"

    def __str__(self) -> str:
        return "%s - %s (%s)" % (self.type, self.blood_type, self.expired_at)


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
    receptor_blood_type = models.CharField(
        pgettext_lazy("Center transfer field", "receptor blood type"),
        max_length=4,
        choices=BloodABOSystem.CHOICES,
        default=BloodABOSystem.O_PLUS,
    )
    unit_type = models.CharField(
        pgettext_lazy("Center transfer field", "unit type"),
        max_length=55,
        choices=BloodUnitType.CHOICES,
        default=BloodUnitType.ST,
    )
    qty = models.PositiveIntegerField(
        pgettext_lazy("Center Capacity field", "quantity"),
        default=1,
    )

    history = HistoricalRecords()

    class Meta:
        verbose_name = pgettext_lazy("Center Transfer model", "Center Transfer")
        verbose_name_plural = pgettext_lazy(
            "Center Transfer model", "Centers Transfers"
        )
        db_table = "center_transfer"

    def __str__(self) -> str:
        return "(%s) - %s - %s" % (self.id, self.origin, self.destination)


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

    history = HistoricalRecords()

    class Meta:
        unique_together = ("transfer", "unit")
        verbose_name = pgettext_lazy(
            "Center Transfer Unit model", "Center Transfer Unit"
        )
        verbose_name_plural = pgettext_lazy(
            "Center Transfer Unit model", "Center Transfer Units"
        )
        db_table = "center_transfer_unit"
