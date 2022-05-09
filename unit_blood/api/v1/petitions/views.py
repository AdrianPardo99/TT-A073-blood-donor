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

from ..transfers.serializers import (
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

origin_status = [
    TransferStatus.CREATED,
    TransferStatus.CONFIRMED,
    TransferStatus.PREPARED,
    TransferStatus.SENDING,
    TransferStatus.IN_TRANSIT,
]


class PetitionViewSet(
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

    def list(self, request, center_pk, *args, **kwargs):
        center = get_object_or_404(Center, pk=center_pk)
        transfers = CenterTransfer.objects.filter(
            origin=center, status__in=origin_status
        )

        serializer = self.get_serializer(
            transfers,
            many=True,
        )
        return self.get_paginated_response(self.paginate_queryset(serializer.data))

    def retrieve(self, request, center_pk, transfer_pk, *args, **kwargs):
        center = get_object_or_404(Center, pk=center_pk)
        transfer = CenterTransfer.objects.filter(
            pk=transfer_pk, origin=center, status__in=origin_status
        )
        if not transfer.exists():
            get_object_or_404(CenterTransfer, pk=0)
        serializer = self.get_serializer(transfer, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    @action(detail=True, methods=["DELETE"])
    def cancel(self, request, center_pk, transfer_pk, *args, **kwargs):
        center = get_object_or_404(Center, pk=center_pk)
        transfer = CenterTransfer.objects.filter(
            pk=transfer_pk,
            origin=center,
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
        transfer = CenterTransfer.objects.filter(
            pk=transfer_pk, origin=center, status__in=origin_status
        )
        if not transfer.exists():
            get_object_or_404(CenterTransfer, pk=0)
        transfer = transfer.first()
        change, msg, trans_status = transfer.petition_next_status(center)
        if not trans_status:
            trans_status = transfer.status
        return Response(
            {"message": msg, trans_status: change}, status=status.HTTP_200_OK
        )


petition_list = PetitionViewSet.as_view(
    {
        "get": "list",
    }
)
petition_retrieve = PetitionViewSet.as_view(
    {
        "get": "retrieve",
        "delete": "cancel",
        "put": "next_status",
    }
)


class PetitionUnitViewSet(
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
        if transfer.origin != center:
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
        if transfer.origin != center:
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
        if transfer.origin != center:
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


petition_unit_list = PetitionUnitViewSet.as_view(
    {
        "get": "list",
    }
)
petition_unit_retrieve = PetitionUnitViewSet.as_view(
    {
        "get": "retrieve",
        "post": "incident",
    }
)
