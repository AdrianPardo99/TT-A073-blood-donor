from django.conf.urls import include, re_path

from rest_framework_jwt.views import (
    obtain_jwt_token,
    refresh_jwt_token,
    verify_jwt_token,
)


urlpatterns = [
    # Auth related
    re_path(r"^auth/login/$", obtain_jwt_token),
    re_path(r"^auth/verify/$", verify_jwt_token),
    re_path(r"^auth/refresh/$", refresh_jwt_token),
]
