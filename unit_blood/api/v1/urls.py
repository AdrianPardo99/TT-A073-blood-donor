from django.conf.urls import include, re_path

from rest_framework_jwt.views import (
    obtain_jwt_token,
    refresh_jwt_token,
    verify_jwt_token,
)

from .blood_center import views as blood_center_views
from .units import views as unit_views
from .transfers import views as transfers_views
from .petitions import views as petitions_views

urlpatterns = [
    # Auth related
    re_path(r"^auth/login/$", obtain_jwt_token),
    re_path(r"^auth/verify/$", verify_jwt_token),
    re_path(r"^auth/refresh/$", refresh_jwt_token),
    re_path(r"^type-centers/$", blood_center_views.center_type_list),
    re_path(r"^centers/$", blood_center_views.center_list),
    re_path(
        r"^centers/(?P<center_pk>.+)/petitions/(?P<transfer_pk>.+)/units/(?P<unit_pk>.+)/$",
        petitions_views.petition_unit_retrieve,
    ),
    re_path(
        r"^centers/(?P<center_pk>.+)/petitions/(?P<transfer_pk>.+)/units/$",
        petitions_views.petition_unit_list,
    ),
    re_path(
        r"^centers/(?P<center_pk>.+)/petitions/(?P<transfer_pk>.+)/cancel/$",  # [DELETE]
        petitions_views.petition_unit_list,
    ),
    re_path(
        r"^centers/(?P<center_pk>.+)/petitions/(?P<transfer_pk>.+)/$",
        petitions_views.petition_retrieve,
    ),
    re_path(r"^centers/(?P<center_pk>.+)/petitions/$", petitions_views.petition_list),
    re_path(
        r"^centers/(?P<center_pk>.+)/transfers/$", transfers_views.center_transfer_list
    ),
    re_path(
        r"^centers/(?P<center_pk>.+)/transfers/(?P<transfer_pk>.+)/units/$",
        transfers_views.center_transfer_unit_list,
    ),
    re_path(
        r"^centers/(?P<center_pk>.+)/transfers/(?P<transfer_pk>.+)/units/(?P<unit_pk>.+)/$",
        transfers_views.center_transfer_unit_retrieve,
    ),
    re_path(
        r"^centers/(?P<center_pk>.+)/transfers/(?P<transfer_pk>.+)/$",
        transfers_views.center_transfer_retrieve,
    ),
    re_path(r"^centers/(?P<center_pk>.+)/units/$", unit_views.unit_list),
    re_path(
        r"^centers/(?P<center_pk>.+)/units/(?P<unit_pk>.+)/$", unit_views.unit_retrieve
    ),
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
