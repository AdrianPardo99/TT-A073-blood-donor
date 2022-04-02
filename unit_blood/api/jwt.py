import uuid
import datetime

from calendar import timegm
from django.utils.timezone import now
from rest_framework_jwt.compat import get_username
from rest_framework_jwt.compat import get_username_field
from rest_framework_jwt.settings import api_settings

from api.v1.account.serializers import UserSerializer


def jwt_response_payload_handler(token, user=None, request=None):
    return {
        "token": token,
        "user": UserSerializer(user, context={"request": request}).data,
    }


def jwt_payload_handler(user=None):
    if user:
        username_field = get_username_field()
        username = get_username(user)
        payload = {
            "user_id": user.pk,
            "username": username,
            "exp": now() + api_settings.JWT_EXPIRATION_DELTA,
        }
        if hasattr(user, "email"):
            payload["email"] = user.email
        if isinstance(user.pk, uuid.UUID):
            payload["user_id"] = str(user.pk)

        payload[username_field] = username

    # Include original issued at time for a brand new token,
    # to allow token refresh
    if api_settings.JWT_ALLOW_REFRESH:
        payload["orig_iat"] = timegm(now().utctimetuple())
    return payload
