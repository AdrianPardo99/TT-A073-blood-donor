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
)

from blood_center.models import CenterTransfer, Center


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
        if not transfers.exists():
            get_object_or_404(CenterTransfer, pk=0)
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


center_transfer_list = CenterTransferViewSet.as_view(
    {
        "get": "list",
        "post": "create",
    }
)
center_transfer_retrieve = CenterTransferViewSet.as_view(
    {
        "get": "retrieve",
    }
)