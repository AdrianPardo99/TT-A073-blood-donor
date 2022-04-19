from rest_framework import permissions

from application_user.models import User, Organization


class IsSuperuserOrTargetUser(permissions.BasePermission):
    def has_permission(self, request, view):
        # ALLOWED_ACTIONS = ['create','retrieve','list']
        # allow user to list all users if logged in or user is superuser
        # return (view.action in ALLOWED_ACTIONS) or request.user.is_superuser
        if hasattr(request.user, "blocked_at"):
            return not request.user.blocked_at
        return False

    def has_object_permission(self, request, view, obj):
        # Allow logged in user to retrieve or change his own details
        if isinstance(obj, User):
            is_valid_obj = obj == request.user
        else:  # Validate if obj.user is request.user, used with Order, Address and UserPaymentMethod models
            is_valid_obj = obj.user == request.user
        return request.user.is_superuser or is_valid_obj


class IsSuperuser(permissions.BasePermission):
    def has_permission(self, request, view):
        ALLOWED_READ_ACTIONS = ["retrieve", "list", "change_password"]
        ALLOWED_ACTIONS = [
            "create",
            "retrieve",
            "list",
            "update",
            "partial_update",
            "destroy",
        ]
        if isinstance(request.user, User):
            if request.user.is_superuser:
                return True
        return False

    def has_object_permission(self, request, view, obj):
        is_valid_obj = None
        if isinstance(obj, User):
            is_valid_obj = obj.organization == request.user.organization
        elif isinstance(obj, Organization):
            is_valid_obj = (obj == request.user.organization) or (
                request.user.organization.has_relation_with(obj)
            )
        else:
            is_valid_obj = obj.user.organization == request.user.organization
        return request.user.is_superuser or is_valid_obj
