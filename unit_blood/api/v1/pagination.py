from rest_framework.pagination import LimitOffsetPagination


class DefaultLimitOffsetPagination(LimitOffsetPagination):
    default_limit = 1000000000000
    max_limit = 1000000000000
