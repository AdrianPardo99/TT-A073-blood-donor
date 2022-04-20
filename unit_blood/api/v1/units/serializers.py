from rest_framework import serializers

from blood_center.models import Unit
from blood_center import BloodUnitType, BloodABOSystem, DonorGender


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
