from django.db import models
from django.core.validators import MinValueValidator
from django.utils.translation import pgettext_lazy

from simple_history.models import HistoricalRecords

from core.models import BaseModel
from core.utils import update_user_and_change_reason_history

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

    history = HistoricalRecords(table_name="center_history")

    class Meta:
        verbose_name = pgettext_lazy("Center model", "Center")
        verbose_name_plural = pgettext_lazy("Center model", "Centers")
        db_table = "center"

    def __str__(self) -> str:
        return "(%s) - %s (%s)" % (self.id, self.name, self.get_type_display())

    def obtain_distinct_centers(self):
        return Center.objects.all().exclude(pk=self.pk)

    def can_create_capacity(self, type):
        return self.capabilities.filter(type=type).exists()

    def can_create_unit(self, type):
        return not self.capabilities.filter(type=type).exists()

    def can_create_another_unit(self, type):
        return self.capabilities.get(type=type).max_qty > (
            self.units.filter(type=type, is_available=True, is_expired=False).count()
            + 1
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

    history = HistoricalRecords(table_name="center_capacity_history")

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
    expired_at = models.DateField(
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

    history = HistoricalRecords(table_name="unit_history")

    class Meta:
        verbose_name = pgettext_lazy("Unit model", "Unit")
        verbose_name_plural = pgettext_lazy("Unit model", "Units")
        db_table = "unit"

    def __str__(self) -> str:
        return "%s - %s (Expired at: %s) %s" % (
            self.get_type_display(),
            self.get_blood_type_display(),
            self.expired_at,
            self.center,
        )

    def expire_unit(self, user, reason):
        self.is_expired = True
        self.is_available = False
        self.can_transfer = False
        self.save()
        update_user_and_change_reason_history(self, user, reason)


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

    history = HistoricalRecords(table_name="center_transfer_history")

    class Meta:
        verbose_name = pgettext_lazy("Center Transfer model", "Center Transfer")
        verbose_name_plural = pgettext_lazy(
            "Center Transfer model", "Centers Transfers"
        )
        db_table = "center_transfer"

    def __str__(self) -> str:
        return "(%s) - %s - %s" % (self.id, self.origin, self.destination)

    def can_cancel(self):
        return self.status in [
            TransferStatus.CREATED,
            TransferStatus.CONFIRMED,
            TransferStatus.PREPARED,
        ]

    def cancel(self):
        if not self.can_cancel():
            return False, pgettext_lazy(
                "Center transfer message", "Cannot cancel transfer"
            )
        for unit in self.units.all():
            unit.deallocate()
        self.status = TransferStatus.CANCELLED
        self.save()
        return True, pgettext_lazy(
            "Center transfer message", "Transfer cancelled successfully"
        )

    def can_confirm(self, center):
        return self.status in [TransferStatus.CREATED] and self.origin in [center]

    def confirm(self, center):
        if not self.can_confirm(center):
            return False, pgettext_lazy(
                "Center transfer message", "Cannot confirm transfer"
            )
        self.status = TransferStatus.CONFIRMED
        self.save()
        return True, pgettext_lazy(
            "Center transfer message", "Transfer confirmed successfully"
        )

    def can_prepare(self, center):
        return self.status in [TransferStatus.CONFIRMED] and self.origin in [center]

    def prepare(self, center):
        if not self.can_prepare(center):
            return False, pgettext_lazy(
                "Center transfer message", "Cannot prepare transfer"
            )
        self.status = TransferStatus.PREPARED
        self.save()
        return True, pgettext_lazy(
            "Center transfer message", "Transfer prepared successfully"
        )

    def can_send(self, center):
        return self.status in [TransferStatus.PREPARED] and self.origin in [center]

    def send(self, center):
        if not self.can_send(center):
            return False, pgettext_lazy(
                "Center transfer message", "Cannot send transfer"
            )
        self.status = TransferStatus.SENDING
        self.save()
        return True, pgettext_lazy(
            "Center transfer message", "Transfer sending successfully"
        )

    def can_transit(self, center):
        return self.status in [TransferStatus.SENDING] and self.origin in [center]

    def transit(self, center):
        if not self.can_transit(center):
            return False, pgettext_lazy(
                "Center transfer message", "Cannot change to in transit transfer"
            )
        self.status = TransferStatus.IN_TRANSIT
        self.save()
        return True, pgettext_lazy("Center transfer message", "Transfer in transit")

    def can_arrive(self, center):
        return self.status in [TransferStatus.IN_TRANSIT] and self.destination in [
            center
        ]

    def arrive(self, center):
        if not self.can_arrive(center):
            return False, pgettext_lazy(
                "Center transfer message", "Cannot arrive transfer"
            )
        self.status = TransferStatus.ARRIVED
        self.save()
        return True, pgettext_lazy(
            "Center transfer message", "Transfer arrive successfully"
        )

    def can_verify(self, center):
        return self.status in [TransferStatus.ARRIVED] and self.destination in [center]

    def verify(self, center):
        if not self.can_verify(center):
            return False, pgettext_lazy(
                "Center transfer message", "Cannot verifying transfer"
            )
        self.status = TransferStatus.VERIFYING
        self.save()
        return True, pgettext_lazy(
            "Center transfer message", "Transfer verifying successfully"
        )

    def can_finish(self, center):
        return self.status in [TransferStatus.VERIFYING] and self.destination in [
            center
        ]

    def finish(self, center):
        if not self.can_finish(center):
            return False, pgettext_lazy(
                "Center transfer message", "Cannot finish transfer"
            )
        destination = self.destination
        for unit in self.units.all():
            unit.change_center(destination)
        self.status = TransferStatus.FINISHED
        self.save()
        return True, pgettext_lazy(
            "Center transfer message", "Transfer finished and units are in center"
        )

    def petition_next_status(self, center):
        changed = False
        msg = None
        status = None
        if self.status in [TransferStatus.CREATED]:
            changed, msg = self.confirm(center)
            status = TransferStatus.CONFIRMED
        elif self.status in [TransferStatus.CONFIRMED]:
            changed, msg = self.prepare(center)
            status = TransferStatus.PREPARED
        elif self.status in [TransferStatus.PREPARED]:
            changed, msg = self.send(center)
            status = TransferStatus.SENDING
        elif self.status in [TransferStatus.SENDING]:
            changed, msg = self.transit(center)
            status = TransferStatus.IN_TRANSIT
        return changed, msg, status

    def transfer_next_status(self, center):
        changed = False
        msg = None
        status = None
        if self.status in [TransferStatus.IN_TRANSIT]:
            changed, msg = self.arrive(center)
            status = TransferStatus.ARRIVED
        elif self.status in [TransferStatus.ARRIVED]:
            changed, msg = self.verify(center)
            status = TransferStatus.VERIFYING
        elif self.status in [TransferStatus.VERIFYING]:
            changed, msg = self.finish(center)
            status = TransferStatus.FINISHED
        return changed, msg, status


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
        related_name="+",
        on_delete=models.PROTECT,
    )

    history = HistoricalRecords(table_name="center_transfer_unit_history")

    class Meta:
        unique_together = ("transfer", "unit")
        verbose_name = pgettext_lazy(
            "Center Transfer Unit model", "Center Transfer Unit"
        )
        verbose_name_plural = pgettext_lazy(
            "Center Transfer Unit model", "Center Transfer Units"
        )
        db_table = "center_transfer_unit"

    def reserve_uni(self):
        unit = self.unit
        unit.is_available = False
        unit.save()

    def deallocate(self):
        unit = self.unit
        unit.is_available = True
        unit.save()

    def change_center(self, center):
        unit = self.unit
        unit.is_available = True
        unit.can_transfer = False
        unit.center = center
        unit.save()
