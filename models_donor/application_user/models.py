import uuid


from django.contrib.auth.models import (
    AbstractBaseUser,
    BaseUserManager,
    PermissionsMixin,
    Group,
)
from django.db import models
from django.forms.models import model_to_dict
from django.utils import timezone
from django.utils.timezone import localtime
from django.conf import settings
from django.utils.translation import pgettext_lazy

from blood_center.models import Center


class UserManager(BaseUserManager):
    def create_user(
        self,
        email,
        password=None,
        first_name=None,
        last_name=None,
        is_staff=False,
        is_active=True,
        groups=None,
        **extra_fields
    ):
        "Creates a User with a given first_name, last_name, email and password"
        email = UserManager.normalize_email(email.lower())
        user = self.model(
            email=email,
            is_active=is_active,
            first_name=first_name,
            is_staff=is_staff,
            **extra_fields
        )
        if last_name:
            user.last_name = last_name
        if password:
            user.set_password(password)
        if groups:
            user.groups = groups
        user.save()
        return user

    def create_superuser(
        self,
        email,
        password=None,
        first_name=None,
        last_name=None,
        groups=None,
        **extra_fields
    ):
        return self.create_user(
            email,
            password,
            first_name,
            last_name,
            groups,
            is_staff=True,
            is_superuser=True,
            **extra_fields
        )


class User(PermissionsMixin, AbstractBaseUser):  # index.Indexed):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    email = models.EmailField(pgettext_lazy("User field", "email"), unique=True)
    first_name = models.CharField(
        pgettext_lazy("User field", "first name"),
        max_length=256,
    )
    last_name = models.CharField(
        pgettext_lazy("User field", "last name"),
        max_length=256,
        blank=True,
    )
    is_staff = models.BooleanField(
        pgettext_lazy("User field", "staff status"),
        default=False,
    )
    is_active = models.BooleanField(
        pgettext_lazy("User field", "active"),
        default=True,
    )
    date_joined = models.DateTimeField(
        pgettext_lazy("User field", "date joined"),
        default=timezone.now,
        editable=False,
    )
    groups = models.ManyToManyField(
        Group,
        verbose_name=pgettext_lazy("User field", "groups"),
        related_name="users",
        blank=True,
    )

    language_code = models.CharField(
        max_length=10,
        default=settings.LANGUAGE_CODE,
    )
    blocked_at = models.DateTimeField(
        blank=True,
        null=True,
    )
    center = models.ForeignKey(
        Center,
        on_delete=models.PROTECT,
        verbose_name=pgettext_lazy("User field", "organization"),
        related_name="users",
        blank=True,
        null=True,
    )
    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = ["first_name"]

    objects = UserManager()

    # search_fields = [index.SearchField('email')]

    class Meta:
        verbose_name = pgettext_lazy("User model", "user")
        verbose_name_plural = pgettext_lazy("User model", "users")
        db_table = "user"

    def get_full_name(self):
        return "%s %s" % (self.first_name, self.last_name)

    def get_short_name(self):
        return self.first_name

    def get_very_first_name(self):
        return self.first_name.split(" ")[0]

    def has_unknown_email(self):
        return self.email and "unknown" in self.email

    def block(self):
        self.blocked_at = timezone.now()
        self.save()

    def unblock(self):
        self.blocked_at = None
        self.save()
