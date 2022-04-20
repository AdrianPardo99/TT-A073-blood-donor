from django.shortcuts import get_object_or_404

from rest_framework import mixins, status, viewsets
from rest_framework.decorators import (
    permission_classes,
    action,
)
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.pagination import PageNumberPagination

from api.mixins import MultiSerializerViewSetMixin
from ..pagination import DefaultLimitOffsetPagination

from .serializers import (
    UnitSerializer,
    UnitDetailSerializer,
    UnitListSerializer,
)

from blood_center.models import Unit, Center
from blood_center import BloodUnitType, BloodABOSystem, DonorGender


class UnitViewSet(
    mixins.CreateModelMixin,
    mixins.RetrieveModelMixin,
    mixins.ListModelMixin,
    MultiSerializerViewSetMixin,
    viewsets.GenericViewSet,
):
    pagination_class = DefaultLimitOffsetPagination
    serializer_action_classes = {
        "list": UnitListSerializer,
        "retrieve": UnitDetailSerializer,
    }
    lookup_url_kwarg = "unit_pk"

    def create(self, request, center_pk, *args, **kwargs):
        center = get_object_or_404(Center, pk=center_pk)
        serializer = UnitSerializer(
            data=request.data, context={"request": request, "center": center}
        )
        if serializer.is_valid():
            unit = serializer.save()
            output_serializer = UnitDetailSerializer(unit, context={"request": request})
            return Response(output_serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def list(self, request, center_pk, *args, **kwargs):
        center = get_object_or_404(Center, pk=center_pk)
        units = center.units.all()
        serializer = self.get_serializer(
            units,
            many=True,
        )
        return self.get_paginated_response(self.paginate_queryset(serializer.data))

    def retrieve(self, request, center_pk, unit_pk, *args, **kwargs):
        center = get_object_or_404(Center, pk=center_pk)
        unit = get_object_or_404(center.units, pk=unit_pk)
        serializer = self.get_serializer(unit)
        return Response(serializer.data, status=status.HTTP_200_OK)


unit_list = UnitViewSet.as_view(
    {
        "get": "list",
        "post": "create",
    }
)
unit_retrieve = UnitViewSet.as_view(
    {
        "get": "retrieve",
    }
)
