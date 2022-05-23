from rest_framework import serializers
from rest_framework.validators import UniqueValidator
from rest_framework_jwt.settings import api_settings

from django.utils.translation import pgettext_lazy

from blood_center.models import Center, CenterCapacity
from blood_center import InstitutionType, BloodUnitType


class CenterCapacitySerializer(serializers.ModelSerializer):
    type = serializers.ChoiceField(choices=BloodUnitType.CHOICES)

    class Meta:
        model = CenterCapacity
        fields = (
            "type",
            "min_qty",
            "max_qty",
        )

    def create(self, validated_data):
        center = self.context.get("center")
        request = self.context.get("request")
        user = request.user
        if center.can_create_capacity(validated_data.get("type")):
            capabilities = CenterCapacityListSerializer(
                center.capabilities.all(), many=True
            )
            raise serializers.ValidationError(
                {
                    "error": pgettext_lazy(
                        "Validation error", "Capacity already exists"
                    ),
                    "available_capacity": capabilities.data,
                }
            )
        defaults = {
            "type": validated_data.get("type"),
            "min_qty": validated_data.get("min_qty"),
            "max_qty": validated_data.get("max_qty"),
            "center": center,
        }
        center_capacity = CenterCapacity.objects.create(**defaults)
        return center_capacity


class CenterCapacityDetailSerializer(serializers.ModelSerializer):
    type = serializers.CharField(source="get_type_display")

    class Meta:
        model = CenterCapacity
        fields = (
            "id",
            "type",
            "min_qty",
            "max_qty",
        )


class CenterCapacityUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = CenterCapacity
        fields = (
            "min_qty",
            "max_qty",
        )


class CenterCapacityListSerializer(serializers.ModelSerializer):
    type = serializers.CharField(source="get_type_display")

    class Meta:
        model = CenterCapacity
        fields = (
            "id",
            "type",
            "min_qty",
            "max_qty",
        )


class CenterSerializer(serializers.ModelSerializer):
    type = serializers.ChoiceField(choices=InstitutionType.CHOICES)

    class Meta:
        model = Center
        fields = (
            "name",
            "address",
            "city",
            "type",
            "latitude",
            "longitude",
        )


class CenterListSerializer(serializers.ModelSerializer):
    type = serializers.CharField(source="get_type_display")

    class Meta:
        model = Center
        fields = (
            "id",
            "name",
            "address",
            "city",
            "type",
            "latitude",
            "longitude",
        )


class CenterDetailSerializer(serializers.ModelSerializer):
    type = serializers.CharField(source="get_type_display")

    class Meta:
        model = Center
        fields = (
            "id",
            "name",
            "address",
            "city",
            "type",
            "latitude",
            "longitude",
        )
