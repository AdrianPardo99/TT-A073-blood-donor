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
    CenterSerializer,
    CenterDetailSerializer,
    CenterListSerializer,
    CenterCapacitySerializer,
    CenterCapacityDetailSerializer,
    CenterCapacityListSerializer,
)

from blood_center.models import Center
from blood_center import InstitutionType


class CenterViewSet(
    mixins.CreateModelMixin,
    mixins.RetrieveModelMixin,
    mixins.ListModelMixin,
    MultiSerializerViewSetMixin,
    viewsets.GenericViewSet,
):
    pagination_class = DefaultLimitOffsetPagination
    serializer_action_classes = {
        "list": CenterListSerializer,
        "retrieve": CenterDetailSerializer,
        "list_distinct_center": CenterListSerializer,
    }
    lookup_url_kwarg = "center_pk"

    def create(self, request, *args, **kwargs):
        """
        Create a center
        """
        user = request.user
        if not user.is_superuser:
            return Response(
                {"error": "Can't create center you don't have permission"},
                status=status.HTTP_403_FORBIDDEN,
            )
        serializer = CenterSerializer(data=request.data, context={"request": request})
        if serializer.is_valid():
            center = serializer.save()
            output_serializer = CenterDetailSerializer(
                center, context={"request": request}
            )
            return Response(output_serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def list(self, request, *args, **kwargs):
        """
        List all centers
        """
        return super(CenterViewSet, self).list(request, *args, **kwargs)

    def retrieve(self, request, *args, **kwargs):
        return super(CenterViewSet, self).retrieve(request, *args, **kwargs)

    @action(detail=True, methods=["GET"])
    def list_distinct_center(self, request, center_pk, *args, **kwargs):
        center = get_object_or_404(Center, pk=center_pk)
        serializer = self.get_serializer(center.obtain_distinct_centers(), many=True)
        return self.get_paginated_response(self.paginate_queryset(serializer.data))

    @action(detail=True, methods=["GET"])
    def list_type_center(self, request, *args, **kwargs):
        response = {
            "type": InstitutionType.CHOICES,
        }
        return Response(response, status.HTTP_200_OK)

    def get_queryset(self):
        qs = Center.objects.all()
        return qs


center_list = CenterViewSet.as_view(
    {
        "get": "list",
        "post": "create",
    }
)
center_detail = CenterViewSet.as_view(
    {
        "get": "retrieve",
    }
)
center_distinct = CenterViewSet.as_view(
    {
        "get": "list_distinct_center",
    }
)
center_type_list = CenterViewSet.as_view(
    {
        "get": "list_type_center",
    }
)


class CenterCapacityViewSet(
    mixins.CreateModelMixin,
    mixins.RetrieveModelMixin,
    mixins.ListModelMixin,
    MultiSerializerViewSetMixin,
    viewsets.GenericViewSet,
):
    pagination_class = DefaultLimitOffsetPagination
    serializer_action_classes = {
        "list": CenterCapacityListSerializer,
        "retrieve": CenterCapacityDetailSerializer,
    }
    lookup_url_kwarg = "capacity_pk"

    def create(self, request, center_pk, *args, **kwargs):
        center = get_object_or_404(Center, pk=center_pk)
        serializer = CenterCapacitySerializer(
            data=request.data, context={"request": request, "center": center}
        )
        if serializer.is_valid():
            center_capacity = serializer.save()
            output_serializer = CenterCapacityDetailSerializer(
                center_capacity, context={"request": request}
            )
            return Response(output_serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def list(self, request, center_pk, *args, **kwargs):
        center = get_object_or_404(Center, pk=center_pk)
        capabilities = center.capabilities.all()
        serializer = self.get_serializer(
            capabilities,
            many=True,
        )
        return self.get_paginated_response(self.paginate_queryset(serializer.data))

    def retrieve(self, request, center_pk, capacity_pk, *args, **kwargs):
        center = get_object_or_404(Center, pk=center_pk)
        capacity = get_object_or_404(center.capabilities, pk=capacity_pk)
        serializer = self.get_serializer(capacity)
        return Response(serializer.data, status=status.HTTP_200_OK)


center_capacity_list = CenterCapacityViewSet.as_view(
    {
        "get": "list",
        "post": "create",
    }
)
center_capacity_retrieve = CenterCapacityViewSet.as_view(
    {
        "get": "retrieve",
    }
)
