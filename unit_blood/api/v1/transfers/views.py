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
    CenterTransferSerializer,
    CenterTransferListSerializer,
    CenterTransferDetailSerializer,
    CenterTransferUnitDetailListSerializer,
)

from ..units.serializers import UnitDetailSerializer
from ..incidents.serializers import (
    CenterTransferUnitIncidentSerializer,
    CenterTransferUnitIncicentDetailSerializer,
)

from blood_center.models import CenterTransfer, Center, Unit
from blood_center import TransferStatus


class CenterTransferViewSet(
    mixins.CreateModelMixin,
    mixins.RetrieveModelMixin,
    mixins.ListModelMixin,
    MultiSerializerViewSetMixin,
    viewsets.GenericViewSet,
):
    pagination_class = DefaultLimitOffsetPagination
    serializer_action_classes = {
        "list": CenterTransferListSerializer,
        "retrieve": CenterTransferDetailSerializer,
    }

    def create(self, request, center_pk, *args, **kwargs):
        center = get_object_or_404(Center, pk=center_pk)
        serializer = CenterTransferSerializer(
            data=request.data, context={"request": request, "center": center}
        )
        if serializer.is_valid():
            transfer = serializer.save()
            output_serializer = CenterTransferDetailSerializer(
                transfer, context={"request": request}, many=True
            )
            return Response(output_serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def list(self, request, center_pk, *args, **kwargs):
        center = get_object_or_404(Center, pk=center_pk)
        transfers = CenterTransfer.objects.filter(destination=center)
        serializer = self.get_serializer(
            transfers,
            many=True,
        )
        return self.get_paginated_response(self.paginate_queryset(serializer.data))

    def retrieve(self, request, center_pk, transfer_pk, *args, **kwargs):
        center = get_object_or_404(Center, pk=center_pk)
        transfer = CenterTransfer.objects.filter(pk=transfer_pk, destination=center)
        if not transfer.exists():
            get_object_or_404(CenterTransfer, pk=0)
        serializer = self.get_serializer(transfer, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    @action(detail=True, methods=["DELETE"])
    def cancel(self, request, center_pk, transfer_pk, *args, **kwargs):
        center = get_object_or_404(Center, pk=center_pk)
        transfer = CenterTransfer.objects.filter(
            pk=transfer_pk,
            destination=center,
        )
        if not transfer.exists():
            get_object_or_404(CenterTransfer, pk=0)
        transfer = transfer.first()
        cancelled, msg = transfer.cancel()
        return Response(
            {"message": msg, "cancelled": cancelled}, status=status.HTTP_200_OK
        )

    @action(detail=True, methods=["PUT"])
    def next_status(self, request, center_pk, transfer_pk, *args, **kwargs):
        center = get_object_or_404(Center, pk=center_pk)
        transfer = CenterTransfer.objects.filter(pk=transfer_pk, destination=center)
        if not transfer.exists():
            get_object_or_404(CenterTransfer, pk=0)
        transfer = transfer.first()
        change, msg, trans_status = transfer.transfer_next_status(center)
        if not trans_status:
            trans_status = transfer.status
        return Response(
            {"message": msg, trans_status: change, "current_status": trans_status},
            status=status.HTTP_200_OK,
        )


center_transfer_list = CenterTransferViewSet.as_view(
    {
        "get": "list",
        "post": "create",
    }
)
center_transfer_retrieve = CenterTransferViewSet.as_view(
    {
        "get": "retrieve",
        "delete": "cancel",
        "put": "next_status",
    }
)


class CenterTransferUnitViewSet(
    mixins.RetrieveModelMixin,
    mixins.ListModelMixin,
    MultiSerializerViewSetMixin,
    viewsets.GenericViewSet,
):
    pagination_class = DefaultLimitOffsetPagination
    serializer_action_classes = {
        "list": CenterTransferUnitDetailListSerializer,
        "retrieve": UnitDetailSerializer,
        "incident": CenterTransferUnitIncidentSerializer,
    }

    def list(self, request, center_pk, transfer_pk, *args, **kwargs):
        transfer = get_object_or_404(CenterTransfer, pk=transfer_pk)
        center = get_object_or_404(Center, pk=center_pk)
        if transfer.destination != center:
            return Response(
                {"error": "Not in same center"}, status=status.HTTP_400_BAD_REQUEST
            )
        units = transfer.units.all()
        serializer = self.get_serializer(
            units,
            many=True,
        )
        return self.get_paginated_response(self.paginate_queryset(serializer.data))

    def retrieve(self, request, center_pk, transfer_pk, unit_pk, *args, **kwargs):
        transfer = get_object_or_404(CenterTransfer, pk=transfer_pk)
        center = get_object_or_404(Center, pk=center_pk)
        if transfer.destination != center:
            return Response(
                {"error": "Not in same center"}, status=status.HTTP_400_BAD_REQUEST
            )
        unit = get_object_or_404(transfer.units, pk=unit_pk)
        serializer = self.get_serializer(unit.unit)
        return Response(serializer.data, status=status.HTTP_200_OK)

    @action(detail=True, methods=["POST"])
    def incident(self, request, center_pk, transfer_pk, unit_pk, *args, **kwargs):
        transfer = get_object_or_404(CenterTransfer, pk=transfer_pk)
        center = get_object_or_404(Center, pk=center_pk)
        if transfer.destination != center:
            return Response(
                {"error": "Not in same center"}, status=status.HTTP_400_BAD_REQUEST
            )
        unit = get_object_or_404(transfer.units, pk=unit_pk)
        serializer = self.get_serializer(
            data=request.data, context={"request": request, "transfer_unit": unit}
        )
        if serializer.is_valid():
            incident = serializer.save()
            output_serializer = CenterTransferUnitIncicentDetailSerializer(
                incident, context={"request": request}
            )
            return Response(output_serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


center_transfer_unit_list = CenterTransferUnitViewSet.as_view(
    {
        "get": "list",
    }
)
center_transfer_unit_retrieve = CenterTransferUnitViewSet.as_view(
    {
        "get": "retrieve",
        "post": "incident",
    }
)
