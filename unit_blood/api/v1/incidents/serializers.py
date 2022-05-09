from rest_framework import serializers

from django.utils.translation import pgettext_lazy

from blood_center.models import CenterTransferUnitIncident
from ..transfers.serializers import CenterTransferUnitDetailListSerializer


class CenterTransferUnitIncidentSerializer(serializers.ModelSerializer):
    class Meta:
        model = CenterTransferUnitIncident
        fields = [
            "incident",
        ]

    def create(self, validated_data):
        request = self.context.get("request")
        transfer_unit = self.context.get("transfer_unit")
        incident_reason = validated_data.get("incident")
        defaults = {
            "unit": transfer_unit,
            "incident": incident_reason,
        }
        incident = CenterTransferUnitIncident.objects.filter(unit=transfer_unit)
        if incident.exists():
            incident.update(**defaults)
            return incident.first()
        return CenterTransferUnitIncident.objects.create(**defaults)


class CenterTransferUnitIncicentDetailSerializer(serializers.ModelSerializer):
    unit = CenterTransferUnitDetailListSerializer()

    class Meta:
        model = CenterTransferUnitIncident
        fields = [
            "id",
            "unit",
            "incident",
        ]
