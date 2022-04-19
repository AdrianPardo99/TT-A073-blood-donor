from django.conf.urls import include, re_path

from rest_framework_jwt.views import (
    obtain_jwt_token,
    refresh_jwt_token,
    verify_jwt_token,
)

from .blood_center import views as blood_center_views

urlpatterns = [
    # Auth related
    re_path(r"^auth/login/$", obtain_jwt_token),
    re_path(r"^auth/verify/$", verify_jwt_token),
    re_path(r"^auth/refresh/$", refresh_jwt_token),
    re_path(r"^type-centers/$", blood_center_views.center_type_list),
    re_path(r"^centers/$", blood_center_views.center_list),
    re_path(
        r"^centers/(?P<center_pk>.+)/distinct/$", blood_center_views.center_distinct
    ),
    re_path(
        r"^centers/(?P<center_pk>.+)/capabilities/$",
        blood_center_views.center_capacity_list,
    ),
    re_path(
        r"^centers/(?P<center_pk>.+)/capabilities/(?P<capacity_pk>.+)/$",
        blood_center_views.center_capacity_retrieve,
    ),
    re_path(r"^centers/(?P<center_pk>.+)/$", blood_center_views.center_detail),
    # re_path(r"^centers/(?P<center_pk>.+)/units$", blood_center_views.center_detail),
]
