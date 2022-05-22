from rest_framework import serializers

from django.utils.translation import pgettext_lazy

from blood_center.models import Unit
from blood_center import BloodUnitType, BloodABOSystem, DonorGender

from ..blood_center.serializers import CenterCapacityListSerializer


class UnitExpiredSerializer(serializers.Serializer):
    reason = serializers.CharField(required=True)


class UnitSerializer(serializers.ModelSerializer):
    type = serializers.ChoiceField(choices=BloodUnitType.CHOICES)
    blood_type = serializers.ChoiceField(choices=BloodABOSystem.CHOICES)
    donor_gender = serializers.ChoiceField(choices=DonorGender.CHOICES)

    class Meta:
        model = Unit
        fields = (
            "type",
            "blood_type",
            "expired_at",
            "can_transfer",
            "is_altruist_unit",
            "donor_gender",
            "donor_age",
        )

    def create(self, validated_data):
        center = self.context.get("center")
        request = self.context.get("request")
        user = request.user
        if center.can_create_unit(validated_data.get("type")):
            capabilities = CenterCapacityListSerializer(
                center.capabilities.all(), many=True
            )
            raise serializers.ValidationError(
                {
                    "error": pgettext_lazy(
                        "Validation error",
                        "Capacity doesn't exists, so you cannot add this unit",
                    ),
                    "available_capacity": capabilities.data,
                }
            )

        if not center.can_create_another_unit(validated_data.get("type")):
            raise serializers.ValidationError(
                {
                    "error": pgettext_lazy(
                        "Validation error",
                        "Capacity has an exceded if we register this unit, please transfer this or another unit",
                    ),
                }
            )

        defaults = {
            "type": validated_data.get("type"),
            "blood_type": validated_data.get("blood_type"),
            "expired_at": validated_data.get("expired_at"),
            "can_transfer": validated_data.get("can_transfer"),
            "is_altruist_unit": validated_data.get("is_altruist_unit"),
            "donor_gender": validated_data.get("donor_gender"),
            "donor_age": validated_data.get("donor_age"),
            "center": center,
        }
        unit = Unit.objects.create(**defaults)
        return unit


class UnitDetailSerializer(serializers.ModelSerializer):
    type = serializers.CharField(source="get_type_display")
    blood_type = serializers.CharField(source="get_blood_type_display")
    donor_gender = serializers.CharField(source="get_donor_gender_display")

    class Meta:
        model = Unit
        fields = (
            "id",
            "type",
            "blood_type",
            "expired_at",
            "can_transfer",
            "is_altruist_unit",
            "donor_gender",
            "donor_age",
        )


class UnitListSerializer(serializers.ModelSerializer):
    type = serializers.CharField(source="get_type_display")
    blood_type = serializers.CharField(source="get_blood_type_display")
    donor_gender = serializers.CharField(source="get_donor_gender_display")

    class Meta:
        model = Unit
        fields = (
            "id",
            "type",
            "blood_type",
            "expired_at",
            "can_transfer",
            "is_altruist_unit",
            "donor_gender",
            "donor_age",
        )


class UnitPlasmaListSerializer(serializers.ModelSerializer):
    blood_type = serializers.CharField(source="get_blood_type_display")
    compatible = serializers.BooleanField(default=False)
    weight = serializers.IntegerField(default=0)
    profit = serializers.IntegerField(default=0)

    class Meta:
        model = Unit
        fields = [
            "id",
            "blood_type",
            "compatible",
            "weight",
            "profit",
        ]


class UnitErythrocyteListSerializer(serializers.ModelSerializer):
    weight = serializers.IntegerField(default=0)
    profit = serializers.IntegerField(default=0)

    class Meta:
        model = Unit
        fields = [
            "id",
            "weight",
            "profit",
        ]
