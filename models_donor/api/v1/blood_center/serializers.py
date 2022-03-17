from rest_framework import serializers
from rest_framework.validators import UniqueValidator
from rest_framework_jwt.settings import api_settings

from blood_center.models import Center


class CenterSerializer(serializers.ModelSerializer):
    class Meta:
        model = Center
        fields = (
            "name",
            "address",
            "city",
            "latitude",
            "longitude",
        )
